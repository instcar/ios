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
@property (nonatomic,assign,getter = getUserId)long userId;
@property (nonatomic,copy,getter = getUserName)NSString *userName;
@property (nonatomic,copy,getter = getUserPwd)NSString *userPwd;
@property (nonatomic,copy,getter = getPhoneNum)NSString *phoneNum;
@property (nonatomic,copy,getter = getSession)NSString *session;
@property (nonatomic,retain,getter = getUserData)NSMutableDictionary *userData;//从服务端获取用户资料
@property (nonatomic,copy,getter = getAddress) NSString *address;//,所在地址
@property (nonatomic,assign,getter = getLon) double lon;//最新位置 经度
@property (nonatomic,assign,getter = getLat) double lat;//最新位置 纬度

//是否第一次使用，是否保存密码
@property (nonatomic,assign,getter = getIsFirstUse)BOOL isFirstUse;
@property (nonatomic,assign,getter = getIsSavePwd)BOOL isSavePwd;


@property (nonatomic,retain, getter = getCookies)NSArray *cookies; //请求的cookias
//设置属性
@property (nonatomic, assign, getter = getSoundEnable) BOOL soundEnable;  //声音是否可用
@property (nonatomic, assign, getter = getLocateEnable) BOOL LocateEnable; //定位是否可用
@property (nonatomic, assign, getter = getPushEnable) BOOL pushEnable; //消息推送是否可用
@property (nonatomic, assign, getter = getAutoPublish) BOOL autoPublish; //自动发布是否可用
@property (nonatomic, copy, getter = getVersion) NSString *version; //当前版本
@property (nonatomic, copy, getter = getOpenuuid) NSString *openuuid; //设备标示

//用户使用软件的保存数据
+ (User *)shareInstance;
- (void)clear;

@end
