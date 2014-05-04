//
//  APIClient.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-5.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Urls.h"
#import "NetTool.h"

@interface APIClient : NSObject

#pragma mark - 用户
//检测手机号
+(void)networkCheckPhone:(NSString *)phoneNum success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//检测用户名
+(void)networkCheckUserName:(NSString *)username success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//获取验证码
+(void)networkGetauthcodeWithPhone:(NSString *)phoneNum success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//用户注册
+(void)networkUserRegistWithPhone:(NSString *)phone password:(NSString *)password authcode:(NSString *)authcode smsid:(long)smsid success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//用户登入
+(void)networkUserLoginWithPhone:(NSString *)phone password:(NSString *)password success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//用户退出
+ (void)networkLoginoutWithSuccess:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//根据用户id获取用户详细信息
+(void)networkGetUserInfoWithuid:(long)uid success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//编辑用户信息
//请求参数：可出现某个或全部出现，但必须出现1个
/*
参数	类型	服务端验证规则	备注
name	string	长度验证[6-16]字
sex	int	in [0, 1, 2]
headpic	string	URL
email	string	邮箱格式
signature	string
home_addr	string	JSON
comp_addr	string	JSON
show_home_addr	int	in [0, 1]
show_comp_addr	int	in [0, 1]
 */
+(void)networkEditUserInfo:(NSMutableDictionary *)userInfoDic success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//用户增加车辆
+(void)networkAddCarWithid:(int)car_id license:(NSString *)license cars_1:(NSString *)cars_1 cars_2:(NSString *)cars_2 success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//用户获取车辆列表
+ (void)networkUserGetCarsWithcar_id:(int)car_id success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//用户实名认证
+ (void)networkUserRealNameRequestWithid_cards_1:(NSString *)cars_1 id_cards_2:(NSString *)cars_2 success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;
#pragma mark - 车辆
//根据别名获取车辆型号列表
+ (void)networkGetCarListWithAliasname:(NSString *)aliasname success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;


#pragma mark - 路线
//根据聚点ID获取线路的分页数据
+(void)networkGetLineListByJudianId:(long)judianID page:(int)page rows:(int)rows all:(int)all success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//根据关键字获取线路的分页数据
+(void)networkGetLineListByTag:(NSString *)tag page:(int)page rows:(int)rows all:(int)all success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//根据id获取线路详情
+(void)networkGetListLinebyid:(int)lineid all:(int)all success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//用户收藏路线
+(void)networkAddFavoriteLinebyid:(int)lineid success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//用户获取收藏路线列表
+(void)networkGetFavoriteLineListByPage:(int)page rows:(int)rows success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

/**
 管理员管理路线
 */
//新增路线
+(void)networkAdminAddLinewithName:(NSString *)name description:(NSString *)description price:(float)price success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//编辑路线
+(void)networkAdminEditLineWithLineid:(int)lineid name:(NSString *)name description:(NSString *)description price:(float )price success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//删除路线
+(void)networkAdminDelLineWithLineid:(int)lineid success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;


#pragma mark - 据点
//添加据点
+ (void)networkAdminAddPointWithName:(NSString *)name lat:(double)lat lng:(double)lng district:(NSString *)district city:(NSString *)city success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//编辑据点
+ (void)networkAdminEditPointWithPointId:(long)pointid Name:(NSString *)name lat:(double)lat lng:(double)lng district:(NSString *)district city:(NSString *)city success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//删除据点
+ (void)networkAdminDelPointWithPointId:(long)pointid success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//获取聚点分页数据
+ (void)networkGetPointListWithPage:(int)page rows:(int)rows success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//根据经纬度获取
+ (void)networkGetPointListWithLat:(double)lat lng:(double)lng page:(int)page rows:(int)rows success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

#pragma mark - 房间接口
//创建
+ (void)networkCreatRoomWithUser_phone:(NSString *)user_phone line_id:(int)line_id price:(int)price description:(NSString *)description start_time:(NSString *)start_time max_seat_num:(int)max_seat_num success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//关闭房间
+ (void) networkCloseRoomWithroom_id:(int)room_id success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//改变房间描述
+ (void) networkChangeRoomDescWithroom_id:(int)room_id desc:(NSString *)desc success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//改变房间最大座位数
+ (void) networkChangemaxseatnumWithroom_id:(int)room_id max_seat_num:(int)max_seat_num success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//修改房间出发时间
+ (void) networkChangestarttimeWithroom_id:(int)room_id start_time:(NSDate *)start_time success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//司机修改房间状态
+ (void) networkChangeroomstateWithroom_id:(int)room_id status:(int)status success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//乘客加入房间
+ (void) networkpassengerJoinroomWithroom_id:(int)room_id user_id:(int)user_id success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//乘客退出房间
+ (void) networkpassengerQuitroomWithroom_id:(int)room_id user_id:(int)user_id success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//查询某条路线的房间列表
+ (void) networkGetlineroomsWithline_id:(int)line_id success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//查询某房间的用户列表
+ (void) networkGetroomusersWithroom_id:(int)room_id success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//查询单个房间的信息


#pragma mark - 上传图片
//上传图片请求
//parm type: 1 :车相关 2 :用户相关
+(void)networkUpLoadImageFileByType:(int)type user_id:(long)user_id dataFile:(NSArray *)fileArray success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;


@end
