//
//  people.m
//  SQList Data Controller
//
//  Created by ibokan on 13-2-25.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "MessageManager.h"
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "DataBase.h"
#import "XmppManager.h"

@implementation MessageManager

+(id)checkKindOfMessage:(CommonMessage *)message
{
    
    //判断是否为图片请求
    if ([message.content hasPrefix:kImageRequest])
    {
        ImageMessage * imessage = [[[ImageMessage alloc]init]autorelease];
        return [imessage confromFromMessage:message];
    }
    
    //判断是否为基本文本请求
    if ([message.content hasPrefix:kTextRequest]) {
        BaseTextMessage * btMessage = [[[BaseTextMessage alloc]init]autorelease];
        return [btMessage confromFromMessage:message];
    }
    
    //系统消息
    if ([message.content hasPrefix:kSystemRequest]) {
        SystemTextMessage  * btMessage = [[[SystemTextMessage alloc]init]autorelease];
        return [btMessage confromFromMessage:message];
    }
//    //判断是否位基本位置请求
//    if ([message.content hasPrefix:kLocationRequest]) {
//        LocationMessage * lMessage = [[[LocationMessage alloc]init]autorelease];
//        return [lMessage confromFromMessage:message];
//    }
    
    return message;
}

+(void)managerMessage:(CommonMessage *)message
{
    //保存历史聊天记录
    [self insertCommonMessage:message];
    
    id mes = [self checkKindOfMessage:message];
    
    if ([mes isKindOfClass:[ImageMessage class]])
    {
        [ImageMessage imageManager:mes];
//        [self insertCommonMessage:message];//记录数据库
    }
    
    if ([mes isKindOfClass:[BaseTextMessage class]])
    {
        [BaseTextMessage baseTextManager:mes];
//        [self insertCommonMessage:message];//记录数据库
    }
    
//    if ([mes isKindOfClass:[LocationMessage class]])
//    {
//        [SendLocationManager locationManager:mes];
//        [self insertCommonMessage:message];//记录数据库
//    }
    
    //注册通知有新消息
    [[NSNotificationCenter defaultCenter]postNotificationName:@"NewMessage" object:self userInfo:nil];
}

//创建表
+(void)creatTable
{
    FMDatabase * db = [DataBase getDataBase];
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![db open])
    {
        DLog(@"数据库打开失败");
        return;
    }
    
    //为数据库设置缓存，提高查询效率
    [db setShouldCacheStatements:YES];
    
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![db tableExists:@"ChatHistory"])
    {
        [db executeUpdate:@"CREATE TABLE ChatHistory(ID INTEGER PRIMARY KEY AUTOINCREMENT,MyID INTEGER,RoomID INTEGER, FriendID INTEGER,Msg TEXT,Date DATE,Type INTEGER)"];
        DLog(@"数据库创建完成");
    }
}

//插入聊天消息
+(void)insertCommonMessage:(CommonMessage *)message
{
    FMDatabase * db = [DataBase getDataBase];

	if (![db open])
    {
        DLog(@"数据库打开失败");
        return;
	}
    
	[db setShouldCacheStatements:YES];
    
	if(![db tableExists:@"ChatHistory"])
	{
        [self creatTable];
	}

    @try {
        [db executeUpdate:@"INSERT INTO ChatHistory (MyID,RoomID,FriendID,Msg,Date,Type) VALUES (?,?,?,?,?,?)",[NSNumber numberWithLong:message.uid],[NSNumber numberWithLong:message.roomid],[NSNumber numberWithLong:message.fid],message.content,message.date,[NSNumber numberWithInt:message.type]];
    }
    @catch (NSException *exception) {

        DLog(@"%@",exception.description);
    }
    @finally
    {
//            DLog(@"%@",[NSString stringWithFormat:@"INSERT INTO ChatHistory (FriendID,Msg,Date,Type,State,MyID) VALUES (%@,%@,%@,%@,%@,%@)",message.uid,message.content,message.date,[NSNumber numberWithInt:type],[NSNumber numberWithInt:1],myuid]);
    }
}

#pragma mark -- 房间
//删除用户聊天记录
+(void)deleteRoomByID:(long)roomID
{
    FMDatabase * db = [DataBase getDataBase];

    if (![db open])
    {
        DLog(@"数据库打开失败");
        return;
    }

    [db setShouldCacheStatements:YES];

    //判断表中是否有指定的数据， 如果没有则无删除的必要，直接return
    if(![db tableExists:@"ChatHistory"])
    {
        return;
    }
    
    long myuid = [User shareInstance].userId;

    @try {
        //删除操作
        [db executeUpdate:@"delete from ChatHistory where RoomID = ? AND MyID = ?",[NSNumber numberWithLong:roomID],[NSNumber numberWithInt:myuid]];
    }
    @catch (NSException *exception) {
        
        DLog(@"%@",exception.description);
    }
    @finally {
//        DLog(@"%@",[NSString stringWithFormat:@"delete from ChatHistory where FriendID = %@ AND MyID = %@",ID,myuid]);
    }
    
    
    [db close];
}

+(NSDictionary *)getCommonMessageWithRoomID:(int)RoomID withPerNum:(int)perNum withOrder:(int)order
{

    FMDatabase * db = [DataBase getDataBase];
    if (![db open])
    {
        DLog(@"数据库打开失败");
        return nil;
    }

    [db setShouldCacheStatements:YES];

    if(![db tableExists:@"ChatHistory"])
    {
         return nil;
    }
    
    long myuid = [User shareInstance].userId;
    
    //定义一个可变数组，用来存放查询的结果，返回给调用者
    NSMutableArray *messageArray = [[NSMutableArray alloc] initWithArray:0];
    
    if (order == -1) {
        order = 999999;
    }
    NSDictionary * messageHisDic = nil;
    @try {
       //定义一个结果集，存放查询的数据
    FMResultSet *rs = [db executeQuery:@"select * from ChatHistory where RoomID = ? and MyID = ? and id < ? order by id DESC limit ?,?",[NSNumber numberWithInt:RoomID],[NSNumber numberWithInt:myuid],[NSNumber numberWithInt:order],[NSNumber numberWithInt:0],[NSNumber numberWithInt:perNum]];
    
    int lastId = 0;
    BOOL canLoadMore = YES;
    //判断结果集中是否有数据，如果有则取出数据
    
    while ([rs next])
    {
        CommonMessage * amessage = [[CommonMessage alloc] init];
        amessage.content = [rs stringForColumn:@"Msg"];
        amessage.date = [rs dateForColumn:@"Date"];
        amessage.type = [rs intForColumn:@"Type"];
        lastId = [rs intForColumn:@"ID"];
    
        amessage.fid = [rs intForColumn:@"FriendID"];
        amessage.uid = [rs intForColumn:@"MyID"];
        amessage.roomid = [rs intForColumn:@"RoomID"];

        //将查询到的数据放入数组中。 
        [messageArray addObject:[MessageManager checkKindOfMessage:amessage]];
    }
    if ([messageArray count] < perNum) {
        canLoadMore = NO;
    }
    
    messageHisDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",lastId],@"lastId",messageArray, @"message",[NSNumber numberWithBool:canLoadMore],@"canLoadMore",nil];
    }
    @catch (NSException *exception) {
        DLog(@"%@",exception.description);
    }
    @finally {
//        DLog(@"%@",[NSString stringWithFormat:@"select * from ChatHistory where FriendID = %@ and MyID = %@ and id < %@ order by id DESC limit %@,%@",friendID,myuid,[NSNumber numberWithInt:order],[NSNumber numberWithInt:0],[NSNumber numberWithInt:perNum]]);
    }

    return messageHisDic;
}

+(BOOL)deleteChathistroy
{
    FMDatabase * db = [DataBase getDataBase];
    if (![db open])
    {
        DLog(@"数据库打开失败");
        return NO;
    }
    
    [db setShouldCacheStatements:YES];
    
    if(![db tableExists:@"ChatHistory"])
    {
        return YES;
    }
    
    BOOL ret;
    
    @try {
        //删除操作
        NSString * sql = @"delete from ChatHistory";
        ret = [db executeUpdate:sql];
    }
    @catch (NSException *exception) {
        
        DLog(@"%@",exception.description);
    }
    @finally {
        //        DLog(@"delete from ChatHistory");
    }
    return ret;
}

+(void)sendGroupMessage:(CommonMessage *)message
{
    //保存聊天记录
    [self insertCommonMessage:message];
    
    //消息编号
    NSString *siID = [XMPPStream generateUUID];
    
    XMPPMessage *xmessage = [XMPPMessage messageWithType:@"groupchat" to:[XMPPJID jidWithString: [AppUtility groupNameFromRoomID:message.roomid]] elementID:siID];
    
    NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    //发送到xmpp时对内容进行加密，客户端接受的时候进行解密
    [xmessage addBody:[message.content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [xmessage addChild:receipt];
    [[XmppManager sharedInstance].xmppStream sendElement:xmessage];
}

#pragma mark -- 用户
+(void)deleteUserByID:(long)userID
{
    //删除用户的记录 当roomid 为 -1时为单人聊天
    FMDatabase * db = [DataBase getDataBase];
    
    if (![db open])
    {
        DLog(@"数据库打开失败");
        return;
    }
    
    [db setShouldCacheStatements:YES];
    
    //判断表中是否有指定的数据， 如果没有则无删除的必要，直接return
    if(![db tableExists:@"ChatHistory"])
    {
        return;
    }
    
    long myuid = [User shareInstance].userId;
    
    @try {
        //删除操作
        [db executeUpdate:@"delete from ChatHistory where RoomID = ? AND MyID = ? AND FriendID = ?",[NSNumber numberWithLong:-1],[NSNumber numberWithInt:myuid],[NSNumber numberWithLong:userID]];
    }
    @catch (NSException *exception) {
        
        DLog(@"%@",exception.description);
    }
    @finally {
        //        DLog(@"%@",[NSString stringWithFormat:@"delete from ChatHistory where FriendID = %@ AND MyID = %@",ID,myuid]);
    }
    
    
    [db close];

}

+(NSDictionary *)getCommonMessageWithUserID:(int)UserID withPerNum:(int)perNum withOrder:(int)order
{
    FMDatabase * db = [DataBase getDataBase];
    if (![db open])
    {
        DLog(@"数据库打开失败");
        return nil;
    }
    
    [db setShouldCacheStatements:YES];
    
    if(![db tableExists:@"ChatHistory"])
    {
        return nil;
    }
    
    long myuid = [User shareInstance].userId;
    
    //定义一个可变数组，用来存放查询的结果，返回给调用者
    NSMutableArray *messageArray = [[NSMutableArray alloc] initWithArray:0];
    
    if (order == -1) {
        order = 999999;
    }
    NSDictionary * messageHisDic = nil;
    @try {
        //定义一个结果集，存放查询的数据
        FMResultSet *rs = [db executeQuery:@"select * from ChatHistory where RoomID = ? and MyID = ? and FriendID = ? and id < ? order by id DESC limit ?,?",[NSNumber numberWithInt:-1],[NSNumber numberWithInt:myuid],[NSNumber numberWithInt:UserID],[NSNumber numberWithInt:order],[NSNumber numberWithInt:0],[NSNumber numberWithInt:perNum]];
        
        int lastId = 0;
        BOOL canLoadMore = YES;
        //判断结果集中是否有数据，如果有则取出数据
        
        while ([rs next])
        {
            CommonMessage * amessage = [[CommonMessage alloc] init];
            amessage.content = [rs stringForColumn:@"Msg"];
            amessage.date = [rs dateForColumn:@"Date"];
            amessage.type = [rs intForColumn:@"Type"];
            lastId = [rs intForColumn:@"ID"];
            
            amessage.fid = [rs intForColumn:@"FriendID"];
            amessage.uid = [rs intForColumn:@"MyID"];
            amessage.roomid = [rs intForColumn:@"RoomID"];
            
            //将查询到的数据放入数组中。
            [messageArray addObject:[MessageManager checkKindOfMessage:amessage]];
        }
        if ([messageArray count] < perNum) {
            canLoadMore = NO;
        }
        
        messageHisDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",lastId],@"lastId",messageArray, @"message",[NSNumber numberWithBool:canLoadMore],@"canLoadMore",nil];
    }
    @catch (NSException *exception) {
        DLog(@"%@",exception.description);
    }
    @finally {
        //        DLog(@"%@",[NSString stringWithFormat:@"select * from ChatHistory where FriendID = %@ and MyID = %@ and id < %@ order by id DESC limit %@,%@",friendID,myuid,[NSNumber numberWithInt:order],[NSNumber numberWithInt:0],[NSNumber numberWithInt:perNum]]);
    }
    
    return messageHisDic;

}

+(void)sendSigleMessage:(CommonMessage *)message
{
    //保存聊天记录
    [self insertCommonMessage:message];

//    XMPPMessage *xmessage = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString: [AppUtility jidWithuid:message.fid]]];
//    //发送到xmpp时对内容进行加密，客户端接受的时候进行解密
//    [xmessage addBody:[message.content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    [[XmppManager sharedInstance].xmppStream sendElement:xmessage];
}
//+(void)sendMessage:(CommonMessage *)message
//{
//    [self insertCommonMessage:message];
//    NSXMLElement *mes = nil;
//    @try {
//        //XMPPFramework主要是通过KissXML来生成XML文件
//        //生成<body>文档
//        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
//        [body setStringValue:message.content];
//        //生成XML消息文档
//        mes = [NSXMLElement elementWithName:@"message"];
//        //消息类型
//        [mes addAttributeWithName:@"type" stringValue:@"chat"];
//        //发送给谁
//        NSString * toUser = [NSString formateToUserWithUid:message.touid];
//        [mes addAttributeWithName:@"to" stringValue:toUser];
//        //由谁发送
//        NSString * user = [NSString formateToUserWithUid:message.uid];
//        [mes addAttributeWithName:@"from" stringValue:user];
//        //组合
//        [mes addChild:body];
//    }
//    @catch (NSException *exception) {
//        DLog(@"%@",exception.description);
//    }
//    @finally {
//        //发送消息
//        DLog(@"%@",mes);
//    }
//    
//    [[XmppManager sharedInstance].xmppStream sendElement:mes];
//}

//更新好友请求
/*
 +(void)UpdateNewFriendRequest:(CommonMessage *)message withID:(int)ID
 {
 FMDatabase * db = [DataBase getDataBase];
 
 if (![db open])
 {
 DLog(@"数据库打开失败");
 return;
 }
 
 [db setShouldCacheStatements:YES];
 
 if(![db tableExists:@"ChatHistory"])
 {
 [self creatTable];
 }
 int myuid = [XYCommon appDelegate].myInfo.ID;
 [db executeUpdate:@"UPDATE ChatHistory SET FriendID = ?,Msg = ?,Date = ?,Type = ?,State = ?,MyID = ? WHERE ID = ?",[NSNumber numberWithInt:message.uid],message.content,message.date,[NSNumber numberWithInt:message.type],[NSNumber numberWithInt:message.state],[NSNumber numberWithInt:myuid],[NSNumber numberWithInt:ID]];
 
 }*/



/*
 +(void)deleteMessageByID:(int)ID
 {
 FMDatabase * db = [DataBase getDataBase];
 
 if (![db open])
 {
 DLog(@"数据库打开失败");
 return;
 }
 
 [db setShouldCacheStatements:YES];
 
 //判断表中是否有指定的数据， 如果没有则无删除的必要，直接return
 if(![db tableExists:@"ChatHistory"])
 {
 return;
 }
 
 @try {
 //删除操作
 [db executeUpdate:@"delete from ChatHistory where ID = ?",[NSNumber numberWithInt:ID]];
 }
 @catch (NSException *exception) {
 
 DLog(@"%@",exception.description);
 }
 @finally {
 //        DLog(@"%@",[NSString stringWithFormat:@"delete from ChatHistory where ID = %@",ID]);
 }
 
 
 [db close];
 }*/

/*
+(int)getUnreadMessage
{
 
    FMDatabase * db = [DataBase getDataBase];
    if (![db open])
    {
        DLog(@"数据库打开失败");
        return 0;
    }
    
    [db setShouldCacheStatements:YES];
    
    if(![db tableExists:@"ChatHistory"])
    {
        return 0;
    }
    int myuid = [XYCommon appDelegate].myInfo.ID;;
    
    int count = 0;
    @try {
        //定义一个结果集，存放查询的数据
        count = [db intForQuery:@"select count(*) from ChatHistory where State = ? and MyID = ? ",[NSNumber numberWithInt:1],[NSNumber numberWithInt:myuid]];
    }
    @catch (NSException *exception) {
        
        DLog(@"%@",exception.description);
    }
    @finally {
//        DLog(@"%@",[NSString stringWithFormat:@"select count(*) from ChatHistory where State = %@ and MyID = %@ ",[NSNumber numberWithInt:1],myuid]);
    }
    
    
    
    [db close];
    
    return count;
}
*/

/*
+(void)updateMessageStateWithFriendID:(int)friendID
{
    FMDatabase * db = [DataBase getDataBase];
    if (![db open])
    {
        DLog(@"数据库打开失败");
        return;
    }
    
    [db setShouldCacheStatements:YES];
    
    if(![db tableExists:@"ChatHistory"])
    {
        return;
    }
    int myuid = [XYCommon appDelegate].myInfo.ID;
    
    @try {
        [db executeUpdate:@"UPDATE ChatHistory SET State = ? WHERE FriendID = ? and MyID = ?",[NSNumber numberWithInt:2],[NSNumber numberWithInt:friendID],[NSNumber numberWithInt:myuid]];
    }
    @catch (NSException *exception) {
        
        DLog(@"%@",exception.description);
    }
    @finally {
//        DLog(@"%@",[NSString stringWithFormat:@"UPDATE ChatHistory SET State = %@ WHERE FriendID = %@ and MyID = %@",[NSNumber numberWithInt:2],friendID,myuid]);
    }
}
 */

/*
+(NSArray *)getMessageHistoryPeopleLastMessage
{
    FMDatabase * db = [DataBase getDataBase];
    if (![db open])
    {
        DLog(@"数据库打开失败");
        return nil;
    }
    
    [db setShouldCacheStatements:YES];
    
    if(![db tableExists:@"ChatHistory"])
    {
        return nil;
    }
    
    //定义一个可变数组，用来存放查询的结果，返回给调用者
    NSMutableArray *messageArray = [NSMutableArray array];
    int myuid = [XYCommon appDelegate].myInfo.ID;
    
    @try {
        //定义一个结果集，存放查询的数据
        FMResultSet *rs = [db executeQuery:@"select * from  ChatHistory where id in( SELECT max(ID) FROM ChatHistory t where MyID= ? GROUP BY t.FriendID )Order BY State ASC, Date DESC,Type ASC",[NSNumber numberWithInt:myuid]];
        
        while ([rs next])
        {
            CommonMessage * amessage = [[CommonMessage alloc] init];
            amessage.content = [rs stringForColumn:@"Msg"];
            amessage.date = [rs dateForColumn:@"Date"];
            amessage.state = [rs intForColumn:@"State"];
            amessage.type = [rs intForColumn:@"Type"];
            int type = [rs intForColumn:@"Type"];
            
            if (type == 1)
            {
                amessage.uid = [rs intForColumn:@"FriendID"];
                amessage.touid = [rs intForColumn:@"MyID"];
            }
            else
            {
                amessage.uid = [rs intForColumn:@"MyID"];
                amessage.touid = [rs intForColumn:@"FriendID"];
            }
            //将查询到的数据放入数组中。
            [messageArray addObject:[MessageManager checkKindOfMessage:amessage]];
        }
    }
    @catch (NSException *exception) {
        
        DLog(@"%@",exception.description);
    }
    @finally {
//        DLog(@"%@",[NSString stringWithFormat:@"select * from  ChatHistory where id in( SELECT max(ID) FROM ChatHistory t where MyID= %@ GROUP BY t.FriendID )Order BY Date DESC",myuid]);
    }
    
       return messageArray;
}*/

/*
//得到好友请求
+(NSArray *)getFriendrequestMessageMessage
{
    FMDatabase * db = [DataBase getDataBase];
    if (![db open])
    {
        DLog(@"数据库打开失败");
        return nil;
    }
    
    [db setShouldCacheStatements:YES];
    
    if(![db tableExists:@"ChatHistory"])
    {
        return nil;
    }
    
    //定义一个可变数组，用来存放查询的结果，返回给调用者
    NSMutableArray *messageArray = [NSMutableArray array];
    int myuid = [XYCommon appDelegate].myInfo.ID;
    
    @try {
        //定义一个结果集，存放查询的数据   查找接受的信息
        FMResultSet *rs = [db executeQuery:@"select * from  ChatHistory where  type = 1 and MyID = ? Order BY Date DESC",[NSNumber numberWithInt:myuid]];
        
        while ([rs next])
        {
            CommonMessage * amessage = [[CommonMessage alloc] init];
            amessage.content = [rs stringForColumn:@"Msg"];
            amessage.date = [rs dateForColumn:@"Date"];
            amessage.state = [rs intForColumn:@"State"];
            amessage.type = [rs intForColumn:@"Type"];
            amessage.ID = [rs intForColumn:@"ID"];
            int type = [rs intForColumn:@"Type"];
            
            if (type == 1)
            {
                amessage.uid = [rs intForColumn:@"FriendID"];
                amessage.touid = [rs intForColumn:@"MyID"];
            }
            else
            {
                amessage.uid = [rs intForColumn:@"MyID"];
                amessage.touid = [rs intForColumn:@"FriendID"];
            }
            
            if ([[MessageManager checkKindOfMessage:amessage] isKindOfClass:[FriendRequestMessage class]]) {
                FriendRequestMessage * friendRequestMessage = [MessageManager checkKindOfMessage:amessage];
                //如果是还有请求 否侧忽略
                if([friendRequestMessage.content isEqualToString:@"request"])
                {
                    //将查询到的数据放入数组中。
                    [messageArray addObject:[MessageManager checkKindOfMessage:amessage]];
                }
            }
        }
    }
    @catch (NSException *exception) {
        
        DLog(@"%@",exception.description);
    }
    @finally {
//       DLog(@"%@",[NSString stringWithFormat:@"select * from  ChatHistory where  type = 1 and MyID = %@ Order BY Date DESC",myuid]);
    }
    
    return messageArray;
}
*/

@end
