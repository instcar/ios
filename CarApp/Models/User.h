//
//  User.h
//  ToCall
//
//  Created by guo on 13-7-26.
//  Copyright (c) 2013年 guo. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface User : NSObject

//用户id，登录名，登录密码，(id存在代表登录，不存在代表登出),session
@property (nonatomic,assign)long userId;
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,copy)NSString *userPwd;
@property (nonatomic,copy)NSString *phoneNum;
@property (nonatomic,copy)NSString *session;
@property (nonatomic,retain)NSMutableDictionary *userData;//从服务端获取用户资料
@property (nonatomic,copy) NSString *address;//,所在地址
@property (nonatomic,assign) double lon;//最新位置 经度
@property (nonatomic,assign) double lat;//最新位置 纬度

//是否第一次使用，是否保存密码
@property (nonatomic,assign)BOOL isFirstUse;
@property (nonatomic,assign)BOOL isSavePwd;

//设置属性
@property (nonatomic, assign, getter = getSoundEnable) BOOL soundEnable;  //声音是否可用
@property (nonatomic, assign, getter = getLocateEnable) BOOL LocateEnable; //定位是否可用
@property (nonatomic, assign, getter = getPushEnable) BOOL pushEnable; //消息推送是否可用
@property (nonatomic, assign, getter = getAutoPublish) BOOL autoPublish; //自动发布是否可用
@property (nonatomic, copy, getter = getVersion) NSString *version; //当前版本
@property (nonatomic, copy, getter = getOpenuuid) NSString *openuuid; //设备标示

//用户使用软件的保存数据

//创建数据的储存.plist文件
+(void)userDataInit;

+(User *)shareInstance;

//装填
-(void)userWithPlist;

//保存到plist里
-(void)save;

-(void)clear;

@end
