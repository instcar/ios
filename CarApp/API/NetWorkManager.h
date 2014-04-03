//
//  NetWorkManager.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-2.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Urls.h"
#import "NetTool.h"
#import "ASINetworkQueue.h"

#import "Line.h"
#import "Judian.h"
#import "Room.h"

typedef enum
{
    kNetworkrequestModeRequest,
    kNetworkrequestModeQueue,
}kNetworkrequestMode;

typedef enum
{
    kRequestModeRefresh,
    kRequestModeLoadmore,
}kRequestMode;

@interface NetWorkManager : NSObject

/**
 *	实例化网络模块单例
 *
 *	@return	网络模块单例
 */
+ (NetWorkManager *)shareInstance;

/**
 *	启动实时的网络状态监控
 */
+ (void)checkNetworkChange;

/**
 *	网络是否可用
 *
 *	@return	yes为 可用  no 为不可用
 */
+ (BOOL)netWorkIsUseful;

/**
 *	捕获asihttp的网络错误
 *
 *	@param	error	错误
 */
+ (void)handleAsiHttpNetworkError:(NSError *)error;


+ (void)networkQueueWork:(NSArray *)requestArray withDelegate:(id)delegate asiHttpSuccess:(SEL)asiSuccess asiHttpFailure:(SEL)asiFailure queueSuccess:(SEL)queueSuccess;
/**
 *	请求验证手机号是否被注册
 *
 *	@param	phoneNum	手机号码
 *  @success @param flag  成功失败的标识，1为成功，0为失败
 *           @param msg msg字段为错误描述
 *           @param useable：手机号是否可用，true可用 false不可用
 *  @failuse error  请求失败错误
 */
+(void)networkCheckPhone:(NSString *)phoneNum success:(void (^)(int status,NSObject *data,NSString *msg))success failure:(void (^)(NSError * error))failure;

/**
 *	请求取得验证码
 *
 *	@param	phoneNum	手机号码     type 1为注册验证码  2为更换手机号码的验证码
 *  @success flag yes 为可用 no 为不可用  sequenceNo 验证码对应编号 authcode 验证码
 *  @failuse error 为错误信息
 */
+(ASIFormDataRequest *)networkGetauthcodeWithPhone:(NSString *)phoneNum type:(int)type mode:(kNetworkrequestMode)mode success:(void (^)(BOOL flag, NSString * authcode,NSString * sequenceNo,NSString * msg))success failure:(void (^)(NSError * error))failure;


/**
 *  请求验证用户名字是否有效
 *
 *	@param	userName	用户名
 *  @success @param flag  成功失败的标识，1为成功，0为失败
 *           @param msg msg字段为错误描述
 *           @param useable：手机号是否可用，true可用 false不可用
 *  @failuse error  请求失败错误
 */
+(void)networkCheckUserName:(NSString *)username success:(void (^)(BOOL flag,BOOL userable,NSString *msg))success failure:(void (^)(NSError * error))failure;

/**
 *	注册用户
 *
 *	username	用户名	String
 *  password	密码	    String
 *  phone	    手机号	String
 *  sex	        性别	    String   男/女
 *  age	        年龄	    int
 *  phonetype	手机类别	String	是	IOS7.0.3
 *  phoneuuid	手机的UUID，后台推送需要	String	是

 *  @success flag yes 为可用 no 为不可用 
 *           userid：注册成功的用户ID
 *           username：注册成功的用户名
 *  @failuse error 为错误信息
 */
+(void)networkUserRegistName:(NSString *)username password:(NSString *)password phone:(NSString *)phone sex:(NSString *)sex  age:(int)age phonetype:(NSString *)phonetype phoneuuid:(NSString *)phoneuuid success:(void (^)(BOOL flag, NSDictionary *userDic,NSString * msg))success failure:(void (^)(NSError * error))failure;


/**
 *  编辑头像   只需传入图片即可（代码内处理压缩）
 *
 *	@param	photo	头像
 *  @success @param flag  成功失败的标识，1为成功，0为失败
 *           @param newHeadPicUrl 新的头像图片地址
 *           @param msg
 *  @failuse error  请求失败错误
 */
+(ASIFormDataRequest *)networkEditHeadpic:(UIImage *)photo uid:(long)uid mode:(kNetworkrequestMode)mode success:(void (^)(BOOL flag,NSString *newHeadPicUrl,NSString *msg))success failure:(void (^)(NSError * error))failure;


/**
 *  修改密码
 *
 *	@param	userid	用户id
 *          password 新密码
 *  @success @param flag  成功失败的标识，1为成功，0为失败
 *           @param msg msg字段为错误描述
 *  @failuse error  请求失败错误
 */
+(void)networkEditpasswordeWithuid:(long)uid password:(NSString *)passWord success:(void (^)(BOOL flag,NSString *msg))success failure:(void (^)(NSError * error))failure;


/**
 *  根据手机号重设密码
 *
 *	@param	phone	手机号
 *          password 新密码
 *  @success @param flag  成功失败的标识，1为成功，0为失败
 *
 *  @failuse error  请求失败错误
 */
+(void)networkResetpasswordeWithphone:(NSString *)phone password:(NSString *)passWord success:(void (^)(BOOL flag))success failure:(void (^)(NSError * error))failure;

/**
 *  用户登入
 *
 *	username	用户名	String  type=1时否
 *  password	密码	    String
 *  phone	    手机号	String  type=2时否
 *  type	  1 用户名方式  2 手机号方式 	int
 *
 *  @success flag yes 为可用 no 为不可用
 *           uid：注册成功的用户ID
 *           phone：用户的手机号
 *  @failuse error 为错误信息
 */
+(void)networkUserLoginWithname:(NSString *)username password:(NSString *)password phone:(NSString *)phone type:(int)type success:(void (^)(BOOL flag, NSDictionary *userDic,NSString * msg))success failure:(void (^)(NSError * error))failure;

/**
 *	用户IDS获取他的最新位置信息
 *
 *	@param	uids	100,100 (字符串,号分隔)
 */
+(void)networkUserLocateGetlastWithuid:(NSString *)uids success:(void (^)(BOOL flag, NSArray *locatelist,NSString * msg))success failure:(void (^)(NSError * error))failure;

/**
 *	上传用户的定位信息
 *
 *	@param	uid	用户ID
 *	@param	address	地址
 *	@param	longitude	经度
 *	@param	latitude	纬度
 */
+(void)networkUserLocateAddWithuid:(long)uid address:(NSString *)address longitude:(double)longitude latitude:(double)latitude success:(void (^)(BOOL flag, NSDictionary *result,NSString * msg))success failure:(void (^)(NSError * error))failure;
/**
 *	使用百度WebApi获取定位点位置信息
 *
 *	@param	longitude	经度
 *	@param	latitude	纬度
 */
+(void)networkGetUserAddressWithLongitude:(double)longitude latitude:(double)latitude success:(void (^)(BOOL flag, NSDictionary *addressInfo))success failure:(void (^)(NSError * error))failure;


//根据用户id获取用户详细信息
+(void)networkGetUserInfoWithuid:(long)uid success:(void (^)(BOOL flag, NSDictionary * userInfo,NSString * msg))success failure:(void (^)(NSError * error))failure;

//根据用户多个用户id获取用户详细信息列面
+(void)networkGetUserInfoWithuidArray:(NSArray *)uidArray success:(void (^)(BOOL flag, NSArray * userInfoArray,NSString * msg))success failure:(void (^)(NSError * error))failure;


+(void)networkGetUserInfoCenterWithuid:(long)uid success:(void (^)(BOOL flag, NSDictionary * userInfoDic,NSString * msg))success failure:(void (^)(NSError * error))failure;
/**
 *	获取笑话百科数据
 *
 *	@param	page	页码
 *	@param	rows	每页多少行
 */
+(void)networkGetJokeListPage:(int)page rows:(int)rows success:(void (^)(BOOL flag, BOOL hasnextpage, NSArray *jokeArray,NSString * msg))success failure:(void (^)(NSError * error))failure;

///****补全资料****/

+(void)networkEditMailWithuid:(long)uid email:(NSString *)email success:(void (^)(BOOL flag))success failure:(void (^)(NSError * error))failure;
                                                                                 
+(ASIFormDataRequest *)networkEditUserNameWithuid:(long)uid username:(NSString *)username mode:(kNetworkrequestMode)mode success:(void (^)(BOOL flag))success failure:(void (^)(NSError * error))failure;

+(ASIFormDataRequest *)networkEditSexWithuid:(long)uid sex:(NSString *)sex mode:(kNetworkrequestMode)mode success:(void (^)(BOOL flag))success failure:(void (^)(NSError * error))failure;

+(ASIFormDataRequest *)networkEditAgeWithuid:(long)uid age:(int)age mode:(kNetworkrequestMode)mode success:(void (^)(BOOL flag))success failure:(void (^)(NSError * error))failure;

+(ASIFormDataRequest *)networkEditcompanyaddressWithuid:(long)uid companyaddress:(NSString *)companyaddress mode:(kNetworkrequestMode)mode success:(void (^)(BOOL flag))success failure:(void (^)(NSError * error))failure;
                                                                                                            
+(ASIFormDataRequest *)networkEdithomeaddressWithuid:(long)uid homeaddress:(NSString *)homeaddress mode:(kNetworkrequestMode)mode success:(void (^)(BOOL flag))success failure:(void (^)(NSError * error))failure;


//****选择路线接口****//

//获取聚点分页数据
+(void)networkGetJuDianListPage:(int)page rows:(int)rows success:(void (^)(BOOL flag, BOOL hasnextpage, NSArray *judianArray,NSString * msg))success failure:(void (^)(NSError * error))failure;

//根据经纬度获取最近的聚点分页数据
+(void)networkGetJuDianListPage:(int)page rows:(int)rows lng:(double)lng lat:(double)lat success:(void (^)(BOOL flag, BOOL hasnextpage, NSArray *judianArray,NSString * msg))success failure:(void (^)(NSError * error))failure;

//根据聚点获取线路的分页数据
+(void)networkGetLineListByJudianId:(long)judianID page:(int)page rows:(int)rows success:(void (^)(BOOL flag, BOOL hasnextpage, NSArray *lineArray,NSString * msg))success failure:(void (^)(NSError * error))failure;

//获取线路的分页数据
+(void)networkGetLineListPage:(int)page rows:(int)rows success:(void (^)(BOOL flag, BOOL hasnextpage, NSArray *lineArray,NSString * msg))success failure:(void (^)(NSError * error))failure;

//根据关键字获取线路的分页数据
+(void)networkGetLineListByTag:(NSString *)tag page:(int)page rows:(int)rows success:(void (^)(BOOL flag, BOOL hasnextpage, NSArray *lineArray,NSString * msg))success failure:(void (^)(NSError * error))failure;

//*****房间接口****//
//增加房间
+(void)networkCreateRoomWithID:(long)ID lineID:(long)lineID startingTime:(NSString *)startingTime seatnum:(int)seatnum description:(NSString *)description addtofav:(BOOL)addtofav success:(void (^)(BOOL flag,long roomID, NSString * msg))success failure:(void (^)(NSError * error))failure;

//销毁房间
+(void)networkCloseRoomWithID:(long)ID roomID:(long)roomID success:(void (^)(BOOL flag,NSString * msg))success failure:(void (^)(NSError * error))failure;

//加入房间 == 准备
+(void)networkJoinRoomWithID:(long)ID roomID:(long)roomID success:(void (^)(BOOL flag,NSString * msg))success failure:(void (^)(NSError * error))failure;

//退出房间 == 取消准备
+(void)networkExitRoomWithID:(long)ID roomID:(long)roomID success:(void (^)(BOOL flag,NSString * msg))success failure:(void (^)(NSError * error))failure;

//取到房间准备的所有用户
+(void)networkGetRoomUsersWithroomID:(long)roomID success:(void (^)(BOOL flag, NSArray *users,NSDictionary *owner,NSString * msg))success failure:(void (^)(NSError * error))failure;

//根据用户获取房间数据
+(void)networkGetRoomsWithID:(long)ID page:(int)page rows:(int)rows success:(void (^)(BOOL flag, BOOL hasnextpage, NSArray *roomArray,NSString * msg))success failure:(void (^)(NSError * error))failure;

//根据线路获取房间数据
+(void)networkGetRoomsWithuid:(long)uid lineID:(long)lineID page:(int)page rows:(int)rows success:(void (^)(BOOL flag, BOOL hasnextpage, NSArray *roomArray,NSString * msg))success failure:(void (^)(NSError * error))failure;

//根据id取房间信息
+(void)networkGetRoomInfoWithRoomID:(long)roomID success:(void (^)(BOOL flag, NSDictionary *roomInfo,NSString * msg))success failure:(void (^)(NSError * error))failure;

//评论拼车结果
+(void)networkCommemtWithRoomID:(long)roomID uid:(long)uid touid:(long)touid content:(NSString *)content commentLever:(int)lever userstatus:(int)userstatus yeyxstar:(int)yeyxstar jzwmstar:(int)jzwmstar rxttstar:(int)rxttstar ownertatus:(int)ownertatus  success:(void (^)(BOOL flag, NSString * msg))success failure:(void (^)(NSError * error))failure;

//更具用户id获取他的评论列表
+(void)networkGetCommentsWithuid:(long)uid page:(int)page rows:(int)rows success:(void (^)(BOOL flag, BOOL hasnextpage, NSArray *commentsArray,NSString * msg))success failure:(void (^)(NSError * error))failure;

//车主获取房间评论状态http://115.28.40.43:8080/yx/api/comment/roomconment
+(void)networkGetRoomCommentWithuid:(long)uid roomid:(long)roomid success:(void (^)(BOOL flag, NSArray *userArray, NSDictionary *room,NSString * msg))success failure:(void (^)(NSError * error))failure;

//房主确认拼车
+(void)networkRoomMasterEnsureuid:(long)uid roomid:(long)roomid success:(void (^)(BOOL flag, NSString * msg))success failure:(void (^)(NSError * error))failure;

//房主修改出发时间
+(void)networkRoomMasterEditStartTime:(long)uid roomid:(long)roomid startingTime:(NSString *)startingTime success:(void (^)(BOOL flag, NSString * msg))success failure:(void (^)(NSError * error))failure;

//房主修改出附加信息
+(void)networkRoomMasterEditDes:(long)uid roomid:(long)roomid description:(NSString *)description success:(void (^)(BOOL flag, NSString * msg))success failure:(void (^)(NSError * error))failure;

//房主修改坐位数
+(void)networkRoomMasterEditSeat:(long)uid roomid:(long)roomid seatnum:(int)seatnum success:(void (^)(BOOL flag, NSString * msg))success failure:(void (^)(NSError * error))failure;

#pragma mark -- Jpush推送消息
//发送推送通知
+(void)networkJpushSendNotification:(NSString *)uidalias title:(NSString *)title content:(NSString *)content success:(void (^)(BOOL flag, NSString * msg))success failure:(void (^)(NSError * error))failure;

//发送推送消息 andriod可用 IOS 不可用
+(void)networkJpushSendMessage:(NSString *)uidalias title:(NSString *)title content:(NSString *)content success:(void (^)(BOOL flag, NSString * msg))success failure:(void (^)(NSError * error))failure;

#pragma mark - 取广告信息
+(void)networkGetADListWithPage:(int)page rows:(int)rows success:(void (^)(BOOL flag, NSArray *adsArray,NSString * msg))success failure:(void (^)(NSError * error))failure;

#pragma mark - 获取常用路线
+(void)networkGetUserfavlineListWithUid:(long)uid page:(int)page rows:(int)rows success:(void (^)(BOOL flag, BOOL hasnextpage, NSArray *favArray, NSString * msg))success failure:(void (^)(NSError * error))failure;

+(void)networkAddUserfavlineWithUid:(long)uid lineID:(int)lineid success:(void (^)(BOOL flag, NSString * msg))success failure:(void (^)(NSError * error))failure;
@end

