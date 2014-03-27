//
//  People.h
//  WPWProject
//
//  Created by Mr.Lu on 13-7-1.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import <Foundation/Foundation.h>

//"id": 1,
//"username": "测试用户1",
//"realname": null,
//"headpic": "http://test/head/1.jpg",
//"phone": "187777777777",
//"sex": "男",
//"email": null,
//"des": null,
//"birthday": "1983-09-22",
//"age": 24,
//"companyaddress": null,
//"homeaddress": null,
//"phonetype": null,
//"devicetoken": null,
//"phonemac": null,
//"phoneuuid": null,
//"registarea": null,
//"registtime": null,
//"cityID": 1,
//"areaID": 1,
//"lastlogintime": null,
//"lastarea": null,
//"lastcoord": null,
//"jifen": 0,
//"status": 1,
//"credit": null


@interface People : NSObject

@property (assign, nonatomic)long ID; //用户id
@property (assign, nonatomic)int age;//年龄
@property (assign, nonatomic)int cityID;
@property (assign, nonatomic)int areaID;
@property (assign, nonatomic)int status;//状态
@property (assign, nonatomic)int jifen;//积分
@property (assign, nonatomic)int credit;//信誉
@property (assign, nonatomic)int favlinenum;
@property (assign, nonatomic)int goodcount;
@property (assign, nonatomic)int midcount;
@property (assign, nonatomic)int badcount;

@property (copy, nonatomic)NSString *userName; //用户名字
@property (copy, nonatomic)NSString *realName; //用户名字
@property (copy, nonatomic)NSString *headpic;//用户头像
@property (copy, nonatomic)NSString *phone;//手机号
@property (copy, nonatomic)NSString *sex; //性别
@property (copy, nonatomic)NSString *email;//邮箱
@property (copy, nonatomic)NSString *des;//描述
@property (copy, nonatomic)NSString *birthday;//生日
@property (copy, nonatomic)NSString *companyaddress;//公司地址
@property (copy, nonatomic)NSString *homeaddress;//公司地址
@property (copy, nonatomic)NSString *phonetype;//手机类型
@property (copy, nonatomic)NSString *devicetoken;//推送地址
@property (copy, nonatomic)NSString *phonemac;//手机mac地址
@property (copy, nonatomic)NSString *phoneuuid;//手机识别号
@property (copy, nonatomic)NSString *registarea;
@property (copy, nonatomic)NSString *registtime;
@property (copy, nonatomic)NSString *lastarea; //用户定地区
@property (copy, nonatomic)NSString *lastcoord; //用户定位点  （1，1）
@property (retain, nonatomic)NSString *lastloginTime;


//初始化对象
-(People *)initFromDic:(NSDictionary *)dic;

+(NSArray *)arrayWithArrayDic:(NSArray *)array;

//从网络请求里面得到数据
//+(void)peopleFormServerRequestWithHaveId:(int)haveId withWantID:(int)wantID withFilmData:(Film *)filmData success:(void (^)(NSArray * peoples,id json))block failure:(void(^)(void))failureblock;

////从网络请求好友里面得到数据
//+(void)FriendFormServerRequestWithMoreId:(int)moreId success:(void (^)(NSArray *peoples, id json))block failure:(void (^)(void))failureblock;
//
////从网络请求删选择的好友数据
//+(void)ScreenFriendFormServerRequestWithMoreId:(int)moreId searchKeyWord:(NSString *)keyWord success:(void (^)(NSArray *peoples, id json))block failure:(void (^)(void))failureblock;


@end
