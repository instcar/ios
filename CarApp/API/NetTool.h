//
//  NetTool.h
//  Temp_Pro
//
//  Created by MacPro-Mr.Lu on 14-3-27.
//  Copyright (c) 2014年 Mr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
#import "JSONKit.h"
#import "Respone.h"
#import "MBProgressHUD+Add.h"

@interface NetTool : NSObject


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
 *	捕获网络异常
 *
 *	@param	error	网络异常错误
 */
+ (void)handleAsiHttpNetworkError:(NSError *)error;

/**
 ?apiver=10200&category=weibo_jokes
 @param ?param1= && param2=
 */
+ (void)httpGetRequest:(NSString *)url  WithSuccess:(void (^)(Respone *respone))success failure:(void (^)(NSError *error))failure;

/**
 {"key":"va", "key":val}
 @param  字典 param1=2,param2=1
 */
+ (void)httpPostRequest:(NSString *)url WithFormdata:(NSMutableDictionary *)formdata WithSuccess:(void (^)(Respone *respone))success failure:(void (^)(NSError *error))failure;

/**
 上传文件接口:以Data格式上传
 @param {"data":[data1,data2],"formate":"png","key":"photo","name":"photo"}
 */
+ (void)httpPostFileDataRequest:(NSString *)url WithFileFormdata:(NSMutableDictionary *)data withFormdaya:(NSMutableDictionary *)formData WithSuccess:(void (^)(Respone *respone))success failure:(void (^)(NSError *error))failure;

/**
 上传文件接口:以文件名的形式
 @param {"data":[nameaddr1,nameaddr2],"formate":"png","key":"photo","name":"photo"}
 */
+ (void)httpPostFileAddrRequest:(NSString *)url WithFileFormdata:(NSMutableDictionary *)data withFormdaya:(NSMutableDictionary *)formData WithSuccess:(void (^)(Respone *respone))success failure:(void (^)(NSError *error))failure;
@end
