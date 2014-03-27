//
//  XmppManager.h
//  PRJ_MrLu_GroupChat
//
//  Created by MacPro-Mr.Lu on 13-11-25.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "XmppRoomManager.h"
#import "APService.h"

//服务器地址
#define kOpenFireHost @"115.28.231.132"
#define kopenFireMasterName @"ay140222164105110546z"
#define kOpenFirePort 5222													// openFire服务器地址
#define kXmppAccountPassword @"instcar123456"                               // openfire用户地址
#define kJidPrdfix @"instcar"                                               // openfire用户前缀

@class CommonMessage;
@protocol ChatDelegate;

@interface XmppManager : NSObject<XMPPStreamDelegate,XMPPRoomDelegate>
{
    XMPPStream *_xmppStream;
    XMPPRoster *_xmppRoster;
    XMPPRosterCoreDataStorage *_xmppRosterStorage;
    XMPPRoomCoreDataStorage *_xmppRoomStorage;
    XMPPReconnect *_xmppReconnect;
    XMPPMessageArchivingCoreDataStorage *_xmppMessageArchivingCoreDataStorage;
    XMPPMessageArchiving *_xmppMessageArchivingModule;
}

//---------------------------------------------------------------------
@property (retain, nonatomic) XMPPStream *xmppStream;
@property (retain, nonatomic) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (retain, nonatomic) XMPPRoster *xmppRoster;
@property (retain, nonatomic) XMPPReconnect *xmppReconnect;
@property (retain, nonatomic) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
@property (retain, nonatomic) XMPPMessageArchiving *xmppMessageArchivingModule;
@property (retain, nonatomic) NSXMLElement * roomConfiguration;//房间配置
@property (copy, nonatomic) NSString * roomName;
@property (retain, nonatomic) XMPPRoom * xmppRoom;
@property (assign, nonatomic) id<ChatDelegate> chatDelegate;

+(XmppManager *)sharedInstance;

//辅助属性
-(NSString *)jidWithuid:(long)uid;

- (void)setupStream;
- (BOOL)connect;

- (void)createGroup:(NSString*)groupName result:(void(^)(bool state))resultState;;//创建房间
//房主配置房间 配置属性在 xmppRoomManager
- (void)configuration:(NSXMLElement *)configuration result:(void(^)(bool state))resultState;;
- (void)leaveRoom; //没有准备的用户 离开房间直接退出房间///准备的用户将不退出房间，可以接受推送消息
- (void)destoryRoom; //销毁房间  //房主销毁房间

- (void)goOnline;
- (void)goOffline;
- (void)disconnect;

- (void)showAlertView:(NSString *)message;

// 回收处理
- (void)teardownStream;
@end

@protocol ChatDelegate <NSObject>

@optional
-(void)friendStatusChange:(XmppManager *)xmppManager Presence:(XMPPPresence *)presence;

-(void)getNewRoomMessage:(CommonMessage *)message;

-(void)getNewPersonMessage:(CommonMessage *)message;

@end