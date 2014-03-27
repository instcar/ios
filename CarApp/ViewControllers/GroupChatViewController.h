//
//  GroupChatViewController.h
//  CarApp
//
//  Created by leno on 13-10-13.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XmppManager.h"

@interface GroupChatViewController : UIViewController<ChatDelegate,UIAlertViewDelegate>
{

}

//@property (retain, nonatomic) NSDictionary * configurationDic;//聊天室的配置 创建房间的时候使用
@property (assign, nonatomic) long roomID;  //房间id
@property (assign, nonatomic) BOOL isRoomMaster; //是不是房主
@property (assign, nonatomic) int status; //房间状态
@property (assign, nonatomic) int userState; //1为为未准备 2为准备
@property (retain, nonatomic) NSXMLElement *roomConfiguration;
-(void)refreshRoomInfo;


@end
