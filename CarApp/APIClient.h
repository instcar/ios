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

+(void)networkCheckPhone:(NSString *)phoneNum success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

+(void)networkCheckUserName:(NSString *)username success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

+(void)networkGetauthcodeWithPhone:(NSString *)phoneNum success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

+(void)networkUserRegistWithPhone:(NSString *)phone password:(NSString *)password authcode:(NSString *)authcode smsid:(NSString *)smsid success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

+(void)networkUserLoginWithPhone:(NSString *)phone password:(NSString *)password success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//根据用户id获取用户详细信息
+(void)networkGetUserInfoWithuid:(long)uid success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//根据聚点ID获取线路的分页数据
+(void)networkGetLineListByJudianId:(long)judianID page:(int)page rows:(int)rows all:(int)all success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;

//根据关键字获取线路的分页数据
+(void)networkGetLineListByTag:(NSString *)tag page:(int)page rows:(int)rows all:(int)all success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;
@end
