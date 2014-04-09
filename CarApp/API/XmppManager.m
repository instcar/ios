//
//  XmppManager.m
//  PRJ_MrLu_GroupChat
//
//  Created by MacPro-Mr.Lu on 13-11-25.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import "XmppManager.h"
#import "MessageManager.h"
#import "CommonMessage.h"
#import "PeopleManager.h"

#define tag_subcribe_alertView 100

static XmppManager *sharedXmppManagerInstance = nil;
@interface XmppManager()

-(NSString *)jidWithuid:(long)uid;//格式化jid
@property (copy, nonatomic)void (^createGroupRoomResult)(bool state);
@property (copy, nonatomic)void (^configurationRoomResult)(bool state);
@end

@implementation XmppManager

+ (XmppManager *)sharedInstance
{
	@synchronized(self) {
		if (sharedXmppManagerInstance == nil) {
			sharedXmppManagerInstance = [[XmppManager alloc]init];
        }
	}
	return sharedXmppManagerInstance;
}

#pragma mark - xmpp
- (void)setupStream{
    _xmppStream = [[XMPPStream alloc]init];
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    _xmppReconnect = [[XMPPReconnect alloc]init];
    [_xmppReconnect setAutoReconnect:YES];
    [_xmppReconnect activate:self.xmppStream];
    [_xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    _xmppStream.enableBackgroundingOnSocket = NO;	// 由于后台功能问题 后台消息采用推送实现
    
    _xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc]init];
    _xmppRoster = [[XMPPRoster alloc]initWithRosterStorage:_xmppRosterStorage];
    [_xmppRoster activate:self.xmppStream];
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    _xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    _xmppMessageArchivingModule = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage];
    [_xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    [_xmppMessageArchivingModule activate:_xmppStream];
    [_xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self.xmppStream setHostName:kOpenFireHost];
	[self.xmppStream setHostPort:kOpenFirePort];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(networkChanged) name:@"NetWorkChanged"  object:nil];
    
}

//网络状态 连接xmpp
- (void)networkChanged
{
    if (![self.xmppStream isConnected] && [[AppDelegate shareDelegate].reachability currentReachabilityStatus] != kNotReachable) {
        [self connect];
    }
    
    if ([[AppDelegate shareDelegate].reachability currentReachabilityStatus] == kNotReachable && [self.xmppStream isConnected]) {
        [self disconnect];
    }
}

- (BOOL)connect{
    
    [APService setTags:nil alias:[NSString  stringWithFormat:@"instcar%ld",[User shareInstance].userId] callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:[AppDelegate shareDelegate]];
    
//    jid 格式为[NSString stringWithFormat:@"%@@%@/XMPPIOS",用户名,主机名]
    if ([_xmppStream isConnected] || ![User shareInstance].isSavePwd) {
        return YES;
    }
    
    NSString *jid = [self jidWithuid:[User shareInstance].userId];
    NSString *ps = kXmppAccountPassword;
//    [JDStatusBarNotification showWithStatus:@"连接中" styleName:@"style"];
    if (jid == nil || ps == nil) {
        return NO;
    }
    
    XMPPJID *myjid = [XMPPJID jidWithString:jid];
    NSError *error ;
    [_xmppStream setMyJID:myjid];
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        DLog(@"my connected error : %@",error.description);
        return NO;
    }
    return YES;
}

- (void)goOnline
{
	// 发送在线状态
	XMPPPresence *presence = [XMPPPresence presence];
	[_xmppStream sendElement:presence];
}

- (void)goOffline
{
	// 发送下线状态
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	[_xmppStream sendElement:presence];
}

/*断开连接的方法 */
- (void)disconnect
{
    if ([_xmppStream isConnected]) {
        [self goOffline];
        [_xmppStream disconnect];
    }
}

// 回收处理
- (void)teardownStream
{
	[_xmppStream removeDelegate:self];
	[_xmppReconnect deactivate];
	[_xmppStream disconnect];
	_xmppStream		= nil;
	_xmppReconnect	= nil;
}


-(NSString *)jidWithuid:(long)uid
{
    //格式化xmpp uid名字
    NSString *uidStr = [NSString stringWithFormat:@"%@%ld",kJidPrdfix,uid];
    NSString *jid = [NSString stringWithFormat:@"%@@%@/InstcarXmppIOS",uidStr,kopenFireMasterName];
    return jid;
}

-(void)createGroup:(NSString *)groupName result:(void(^)(bool state))resultState;
{
    groupName = [NSString stringWithFormat:@"%@%@",KRoomNamePrdFix,groupName];
//创建一个新的群聊房间,roomName是房间名 Nickname是房间里自己所用的昵称
    NSString * username= [self jidWithuid:[User shareInstance].userId];
//    NSString * username= [User shareInstance].userName;
    NSString * hostname = kopenFireMasterName;
    
    NSString * roomName = [NSString stringWithFormat:@"%@@conference.%@/%@",groupName,hostname,username];
//    NSString * roomName = [NSString stringWithFormat:@"%@@conference.%@",groupName,hostname];
    self.roomName = roomName;
    
    _xmppRoomStorage  = [XMPPRoomCoreDataStorage sharedInstance];
    
    XMPPJID *roomJID = [XMPPJID jidWithString:roomName];
    
    self.xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:_xmppRoomStorage jid:roomJID dispatchQueue:dispatch_get_main_queue()];
    
    [self.xmppRoom activate:_xmppStream];
    //设为默认设置
    [self.xmppRoom fetchConfigurationForm];
    [self.xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSXMLElement *historyElement=[NSXMLElement elementWithName:@"history"];
    
    //    [xmppRoom joinRoomUsingNickname:[[NSUserDefaults standardUserDefaults] valueForKey:kMyJID] history:historyElement password:@"111"];
    [self.xmppRoom joinRoomUsingNickname:username history:historyElement password:KRoomPass];
    
    self.createGroupRoomResult = [resultState copy];
}

//房主配置房间 配置属性在 xmppRoomManager
-(void)configuration:(DDXMLElement *)configuration result:(void(^)(bool state))resultState;
{
    if ([self.xmppRoom isJoined]) {
        [self.xmppRoom configureRoomUsingOptions:configuration];
        self.configurationRoomResult = [resultState copy];
    }
    else
    {
        [UIAlertView showAlertViewWithTitle:@"Error" message:@"当前没有加入到房间无法进行配置" cancelTitle:@"确定"];
    }
}

-(void)leaveRoom
{
    if (self.xmppRoom) {
        [self.xmppRoom leaveRoom];
    }
}

//房主权限
-(void)destoryRoom
{
    [self.xmppRoom destroyRoom];
}

#pragma mark - XMPPStreamDelegate

- (void)xmppStreamWillConnect:(XMPPStream *)sender
{
    DLog(@"xmppStreamWillConnect");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"XmppStreamWillConnnect" object:nil];
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    DLog(@"xmppStreamDidConnect");
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:kPS]) {
        NSError *error ;
        if (![self.xmppStream authenticateWithPassword:kXmppAccountPassword error:&error]) {
            DLog(@"error authenticate : %@",error.description);
        }
//    }
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    DLog(@"xmppStreamDidRegister");
    
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:kPS]) {
        NSError *error ;
        if (![self.xmppStream authenticateWithPassword:kXmppAccountPassword error:&error]) {
            DLog(@"error authenticate : %@",error.description);
        }
//    }
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    [self showAlertView:@"当前用户已经存在"];
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    DLog(@"xmppStreamDidAuthenticate");
    XMPPPresence *presence = [XMPPPresence presence];
	[[self xmppStream] sendElement:presence];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"XmppStreamConnected" object:nil];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    DLog(@"didNotAuthenticate:%@",error.description);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"XmppStreamDidNotConnected" object:nil];
}

- (NSString *)xmppStream:(XMPPStream *)sender alternativeResourceForConflictingResource:(NSString *)conflictingResource
{
//    DLog(@"alternativeResourceForConflictingResource: %@",conflictingResource);
    return @"XMPPIOS";
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
//    DLog(@"didReceiveIQ: %@",iq.description);
    
    return YES;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    
//    DLog(@"xmpp didReceiveMessage: %@",message.description);
//    if ([self.chatDelegate respondsToSelector:@selector(getNewMessage:Message:)]) {
//        [self.chatDelegate getNewMessage:self Message:message];
//    }
    
    //回执判断
    /*
    NSXMLElement *request = [message elementForName:@"request"];
    if (request)
    {
        if ([request.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
        {
            //组装消息回执
            XMPPMessage *msg = [XMPPMessage messageWithType:[message attributeStringValueForName:@"type"] to:message.from elementID:[message attributeStringValueForName:@"id"]];
            NSXMLElement *recieved = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
            [msg addChild:recieved];
            
            //发送回执
            [self.xmppStream sendElement:msg];
        }
    }
    else
    {
        NSXMLElement *received = [message elementForName:@"received"];
        if (received)
        {
            if ([received.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
            {
                //发送成功
                DLog(@"message send success!");
            }
        }
    }
    */
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    DLog(@"didReceivePresence: %@",presence.description);
    if (presence.status) {
        if ([self.chatDelegate respondsToSelector:@selector(friendStatusChange:Presence:)]) {
            [self.chatDelegate friendStatusChange:self Presence:presence];
        }
    }
}
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error
{
//    DLog(@"didReceiveError: %@",error.description);
}
- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq
{
//    DLog(@"didSendIQ:%@",iq.description);
}
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    DLog(@"didSendMessage:%@",message.description);
}
- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence
{
//    DLog(@"didSendPresence:%@",presence.description);
}
- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error
{
//    DLog(@"didFailToSendIQ:%@",error.description);
}
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    DLog(@"didFailToSendMessage:%@",error.description);
}
- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error
{
//    DLog(@"didFailToSendPresence:%@",error.description);
}

- (void)xmppStreamWasToldToDisconnect:(XMPPStream *)sender
{
    DLog(@"xmppStreamWasToldToDisconnect");
}

- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    DLog(@"xmppStreamConnectDidTimeout");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"XmppStreamDidNotConnected" object:nil];
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    DLog(@"xmppStreamDidDisconnect: %@",error.description);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"XmppStreamDidNotConnected" object:nil];
}

#pragma mark - XMPPRosterDelegate
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:presence.fromStr message:@"add" delegate:self cancelButtonTitle:@"cancle" otherButtonTitles:@"yes", nil];
    alertView.tag = tag_subcribe_alertView;
    [alertView show];
}

#pragma mark - XMPPReconnectDelegate
- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkReachabilityFlags)connectionFlags
{
    DLog(@"didDetectAccidentalDisconnect:%u",connectionFlags);
}

- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkReachabilityFlags)reachabilityFlags
{
    DLog(@"shouldAttemptAutoReconnect:%u",reachabilityFlags);
    return YES;
}

#pragma mark - xmppRoomDelegate

- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    DLog(@" xmppRoomDidCreate : %@",sender);
    [sender fetchConfigurationForm];
//    [sender configureRoomUsingOptions:nil];//确认配置
//    self.createGroupRoomResult(YES);
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm
{
     DLog(@"--------------获取房间的当前配置---------------\n%@",configForm);
}

- (void)xmppRoom:(XMPPRoom *)sender willSendConfiguration:(XMPPIQ *)roomConfigForm
{
     DLog(@"--------------发送房间配置---------------\n%@",roomConfigForm);
}

- (void)xmppRoom:(XMPPRoom *)sender didConfigure:(XMPPIQ *)iqResult
{
    DLog(@"--------------完成配置---------------\n%@",iqResult);
    [sender fetchConfigurationForm];
    self.configurationRoomResult(YES);
}

- (void)xmppRoom:(XMPPRoom *)sender didNotConfigure:(XMPPIQ *)iqResult
{
    DLog(@"didNotConfigure:%@",iqResult);
    
    int errorCode  = [[iqResult childErrorElement] attributeIntValueForName:@"code"];
    if (errorCode == 401) {
        [self showAlertView:@"401 错误，进入该房间需要房间密码"];
    }
    if (errorCode == 403) {
        [self showAlertView:@"403 错误，通知用户他或她被房间禁止了"];
    }
    if (errorCode == 404) {
        [self showAlertView:@"404 错误，通知用户房间不存在"];
    }
    if (errorCode == 405) {
        [self showAlertView:@"405 错误，通知用户限制创建房间"];
    }
    if (errorCode == 406) {
        [self showAlertView:@"406 错误，通知用户必须使用保留的房间昵称"];
    }
    if (errorCode == 407) {
        [self showAlertView:@"407 错误，通知用户他或她不在成员列表中"];
    }
    if (errorCode == 409) {
        [self showAlertView:@"409 错误，通知用户他或她的房间昵称正在使用或被别的用户注册了"];
    }
    if (errorCode == 503) {
        [self showAlertView:@"通知用户已经达到最大用户数"];
    }
    
    self.createGroupRoomResult(NO);
    self.configurationRoomResult(NO);
}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    [sender fetchConfigurationForm];
//    [self configuration:nil];
    [sender fetchMembersList];
//    [sender fetchBanList];
//    [sender fetchModeratorsList];
    self.createGroupRoomResult(YES);
}

- (void)xmppRoomDidLeave:(XMPPRoom *)sender
{
    DLog(@"XMPPRoom leave");
    
    //清除当前房间
    [sender deactivate];
    [sender removeDelegate:sender];
    sender = nil;
//    [SafetyRelease release:_xmppRoom];
}

- (void)xmppRoomDidDestroy:(XMPPRoom *)sender;
{
    
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    DLog(@"新成员加入");
    [sender fetchMembersList];
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    DLog(@"新成员离开");
    [sender fetchMembersList];
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidUpdate:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    DLog(@"成员更新");
}

/**
 * Invoked when a message is received.
 * The occupant parameter may be nil if the message came directly from the room, or from a non-occupant.
 **/
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID
{
    DLog(@"群天消息 from: %@ message: %@",occupantJID,message);
    
    // 判断是否是离线消息 是就直接跳出
	if ([message elementForName:@"delay"]) {
		// 离线消息日期采用iso8601时间格式，必须转换
        //		NSXMLElement			*delay				= [message elementForName:@"delay"];
        //		NSString				*dateString			= [[delay attributeForName:@"stamp"] stringValue];
        //		ISO8601DateFormatter	*isoDateFormater	= [[[ISO8601DateFormatter alloc]init]autorelease];
        //		commonMessage.date = [isoDateFormater dateFromString:dateString];
        return;
	}
    
	CommonMessage *commonMessage = [[CommonMessage alloc]init];
	commonMessage.content	= [[[message elementForName:@"body"] stringValue]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];							// 短信内容
	commonMessage.uid		= [User shareInstance].userId;	// 短信对方id
    commonMessage.fid       = [AppUtility useridFromRoomName:[[message attributeForName:@"from"] stringValue]];
	commonMessage.roomid	= [AppUtility roomidFromgroupName:[[message attributeForName:@"from"] stringValue]];		// 发给谁
    commonMessage.type      = 1;
    
    //xmpp 房间的系统消息,屏蔽
    if (commonMessage.fid == 0) {
        return;
    }
    
    //判断是否为自己的群消息 数据库写入自己的信息
    //保存用户信息
    if (commonMessage.fid == commonMessage.uid) {
        if (![PeopleManager peopleExitInTableWithFid:commonMessage.fid]) {
            [NetWorkManager networkGetUserInfoWithuid:commonMessage.fid success:^(BOOL flag, NSDictionary *userInfo, NSString *msg) {
                
                if (flag) {
                    People *people = [[People alloc]initFromDic:userInfo];
                    [PeopleManager insertPeopleShortInfo:people];
                }
                
            } failure:^(NSError *error) {
                
            }];
        }
        return;
    }
    
    if (![PeopleManager peopleExitInTableWithFid:commonMessage.fid]) {
        //保存用户信息
        if (commonMessage.fid != -1 && commonMessage.fid != commonMessage.uid) {
            [NetWorkManager networkGetUserInfoWithuid:commonMessage.fid success:^(BOOL flag, NSDictionary *userInfo, NSString *msg) {
                
                if (flag) {
                    People *people = [[People alloc]initFromDic:userInfo];
                    [PeopleManager insertPeopleShortInfo:people];
                }
                
            } failure:^(NSError *error) {
                
            }];
        }
    }
    
    [MessageManager managerMessage:commonMessage];

}
//获取禁止用户列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items
{
    DLog(@"FetchBanList:%@",items);
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchBanList:(XMPPIQ *)iqError
{
    DLog(@"didNotFetchBanList:error:%@",iqError);
}

//获取好友用户列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items
{
    DLog(@"FetchMembersList:%@",items);
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError
{
    DLog(@"didNotFetchMembersList:error:%@",iqError);
}

//获取主持人用户列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items
{
    DLog(@"FetchModeratorsList:%@",items);
}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchModeratorsList:(XMPPIQ *)iqError
{
    DLog(@"didNotFetchModeratorsList:error:%@",iqError);
}

- (void)xmppRoom:(XMPPRoom *)sender didEditPrivileges:(XMPPIQ *)iqResult
{
    
}
- (void)xmppRoom:(XMPPRoom *)sender didNotEditPrivileges:(XMPPIQ *)iqError
{
    
}

#pragma mark - my method
-(void)showAlertView:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alertView show];
}


#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == tag_subcribe_alertView && buttonIndex == 1) {
        XMPPJID *jid = [XMPPJID jidWithString:alertView.title];
        [[self xmppRoster] acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
//      [self.xmppRoster rejectPresenceSubscriptionRequestFrom:];
    }
}


@end