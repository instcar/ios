//
//  Room.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-29.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Room : NSObject

//"description": "20一个",//附加信息
//"headpic": "http://test/head/2.jpg",//房主头像
//"id": 2,//房间ID
//"lineid": 1,//线路ID
//"publishtime": "2013-11-27 23:41:21",//房间发布时间
//"seatnum": 3,//座位数
//"startingtime": "2013-11-28 09:30:00",//出发时间
//"status": 1,//房间状态
//"userid": 2,//房主用户ID
//"username": "测试用户2"//房主昵称

@property (assign, nonatomic) long ID;
@property (assign, nonatomic) long lineid;
@property (assign, nonatomic) long userid;
@property (assign, nonatomic) int seatnum;
@property (assign, nonatomic) int status;
@property (assign, nonatomic) int leftseatnum;

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *headpic;
@property (retain, nonatomic) NSDate *startingtime;
@property (retain, nonatomic) NSDate *publishtime;
@property (copy, nonatomic) NSString *description;
@property (copy, nonatomic) NSString *startaddr;
@property (copy, nonatomic) NSString *stopaddr;
@property (copy, nonatomic) NSString *wayaddr;
@property (copy, nonatomic) NSString *linename;


-(Room *)initWithDic:(NSDictionary *)dic;
+(NSArray *)arrayWithArrayDic:(NSArray *)array;

@end
