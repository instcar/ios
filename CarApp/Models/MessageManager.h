//
//  people.h
//  SQList Data Controller
//
//  Created by ibokan on 13-2-25.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonMessage.h"
#import "ImageMessage.h"
#import "BaseTextMessage.h"
#import "SystemTextMessage.h"

@interface MessageManager : NSObject<UIAlertViewDelegate>

@property (retain, nonatomic)CommonMessage * message;//信息
//公共聊天记录
+(id)checkKindOfMessage:(CommonMessage *)message; //检测message的类型

+(void)managerMessage:(CommonMessage *)message; //分配处理message信息

+(BOOL)deleteChathistroy; //删除全部聊天记录

+(void)insertCommonMessage:(CommonMessage *)message; //插入message到数据库

//房间聊天记录

+(void)deleteRoomByID:(long)roomID; //删除用户房间的记录

+(NSDictionary *)getCommonMessageWithRoomID:(int)RoomID withPerNum:(int)perNum withOrder:(int)order; //得到某聊天室的聊天信息 /以页显示

+(void)sendGroupMessage:(CommonMessage *)messaged;//发送群消息

//+(void)deleteMessageByID:(int)ID; //删除特定的信息

//+(int)getUnreadMessage; //得到未读信息数

//+(void)updateMessageStateWithFriendID:(int)friendID; //更新未读取消息状态为已读

//+(NSArray *)getMessageHistoryPeopleLastMessage; //得到某人信息所以未读信息的最后消息

//+(NSArray *)getFriendrequestMessageMessage;//得到好友请求的信息

//+(void)UpdateNewFriendRequest:(CommonMessage *)message withID:(int)ID; //更新好友请求状态

//用户聊天记录
+(void)deleteUserByID:(long)userID; //删除用户的记录

+(NSDictionary *)getCommonMessageWithUserID:(int)UserID withPerNum:(int)perNum withOrder:(int)order; //得到私人的聊天记录 /以页显示

+(void)sendSigleMessage:(CommonMessage *)message; //发送信息

@end
