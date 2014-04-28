//
//  People.h
//  WPWProject
//
//  Created by Mr.Lu on 13-7-1.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import <Foundation/Foundation.h>

//{
//    "status": 200,
//    "data": {
//        "id": "1",
//        "phone": "18612648090",
//        "name": "顾伟刚",
//        "sex": "2",
//        "age": "0",
//        "password": "wl00GOpFZXaVrsZcZvJ3lwt+K2jmScwXXdUeaJce2qm80tW/0xXFGKd0elIETkPpnpzV2oJVAvYP6iYFMylY5g==",
//        "email": "",
//        "headpic": "http://instcar-user-pic-1.oss-cn-qingdao.aliyuncs.com/java.png",
//        "status": "0",
//        "addtime": "2014-04-13 16:57:17",
//        "modtime": "2014-04-14 23:22:26",
//        "detail": {
//            "id": "1",
//            "user_id": "1",
//            "id_number": "",
//            "info": "{\"id_cards\":[\"http:\\/\\/instcar-user-pic-1.oss-cn-qingdao.aliyuncs.com\\/java.png\"]}",
//            "signature": "我叫顾伟刚，哈哈",
//            "home_addr": "",
//            "show_home_addr": "0",
//            "comp_addr": "",
//            "show_comp_addr": "0",
//            "addtime": "2014-04-13 20:58:17",
//            "modtime": "2014-04-14 23:22:26"
//        }
//    },
//    "msg": ""
//}


@interface  PeopleDetail: NSObject

@property (copy, nonatomic) NSString *id_number;        //省份证id
@property (copy, nonatomic) NSString *signature;        //签名
@property (copy, nonatomic) NSString *home_addr;        //家庭地址
@property (assign, nonatomic) BOOL show_home_addr;      //是否保密
@property (copy, nonatomic) NSString *comp_addr;        //公司地址
@property (assign, nonatomic) BOOL show_comp_addr;      //是否保密
@property (retain, nonatomic) NSDictionary *info;       //省份证图片地址

//初始话对象
- (PeopleDetail *)initFromDic:(NSDictionary *)dic;

//@property (assign, nonatomic) int ID;
//@property (assign, nonatomic) int user_id;
//@property (retain, nonatomic) NSDate *addtime;          //添加时间
//@property (retain, nonatomic) NSDate *modtime;          //修改时间

@end

@interface  People: NSObject

@property (assign, nonatomic)long ID;               //用户id
@property (copy, nonatomic) NSString *name;         //用户名字
@property (assign, nonatomic) int status;           //实名认证状态
@property (copy, nonatomic)NSString *sex;           //性别
@property (assign, nonatomic)int age;               //年龄
@property (copy, nonatomic) NSString *password;     //密码
@property (copy, nonatomic)NSString *headpic;       //用户头像
@property (copy, nonatomic)NSString *phone;         //手机号
@property (copy, nonatomic)NSString *email;         //邮箱
@property (retain, nonatomic)PeopleDetail *detail;  //用户详细信息

//@property (retain, nonatomic)NSDate *addTime;       //注册时间
//@property (retain, nonatomic)NSDate *modTime;       //修改时间

//@property (copy, nonatomic)NSString *realName; //用户名字
//@property (copy, nonatomic)NSString *des;//描述
//@property (assign, nonatomic)int favlinenum;//线路数量
//
//@property (assign, nonatomic)int cityID;
//@property (assign, nonatomic)int areaID;
//@property (copy, nonatomic)NSString *birthday;//生日
//@property (copy, nonatomic)NSString *phonetype;//手机类型
//@property (copy, nonatomic)NSString *devicetoken;//推送地址
//@property (copy, nonatomic)NSString *phonemac;//手机mac地址
//@property (copy, nonatomic)NSString *phoneuuid;//手机识别号
//@property (copy, nonatomic)NSString *registarea;
//@property (copy, nonatomic)NSString *registtime;
//@property (copy, nonatomic)NSString *lastarea; //用户定地区
//@property (copy, nonatomic)NSString *lastcoord; //用户定位点  （1，1）
//@property (copy, nonatomic)NSString *lastloginTime;
//
//@property (assign, nonatomic)int jifen;//积分
//@property (assign, nonatomic)int credit;//信誉
//@property (assign, nonatomic)int goodcount;
//@property (assign, nonatomic)int midcount;
//@property (assign, nonatomic)int badcount;

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
