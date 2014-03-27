//
//  Message.h
//  WPWProject
//
//  Created by Mr.Lu on 13-7-1.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CommonMessage : NSObject

@property (assign, nonatomic) long ID;
@property (assign, nonatomic) long uid;   //自己id
@property (assign, nonatomic) long fid;   //用户id
@property (assign, nonatomic) long roomid; //房间id roomid 为-1 表示单人聊天
@property (copy, nonatomic) NSString * content; //信息内容
@property (retain, nonatomic) NSDate * date; //日期时间
@property (assign, nonatomic) int type; // 1 为接受 2为发送

//@property (assign, nonatomic) CLLocationCoordinate2D loginLocate; //登入的地理位置
//@property (assign, nonatomic) long touid; //发给谁
//@property (assign, nonatomic) int state; // 1 为未读 2 为已读



@end
