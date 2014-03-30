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

@interface NetTool : NSObject

/**
 ?apiver=10200&category=weibo_jokes
 @param ?param1= && param2=
 */
+ (void)httpGetRequest:(NSString *)url  WithSuccess:(void (^)(NSDictionary *resultDic))success failure:(void (^)(NSError *error))failure;

/**
 {"key":"va", "key":val}
 @param  字典 param1=2,param2=1
 */
+ (void)httpPostRequest:(NSString *)url WithFormdata:(NSMutableDictionary *)formdata WithSuccess:(void (^)(NSDictionary *resultDic))success failure:(void (^)(NSError *error))failure;

/**
 上传文件接口:以Data格式上传
 @param {"data":[data1,data2],"formate":"png","key":"photo","name":"photo.png"}
 */
+ (void)httpPostFileDataRequest:(NSString *)url WithFileFormdata:(NSMutableDictionary *)data withFormdaya:(NSMutableDictionary *)formData WithSuccess:(int (^)(NSDictionary *resultDic))success failure:(void (^)(NSError *error))failure;

/**
 上传文件接口:以文件名的形式
 @param {"data":[nameaddr1,nameaddr2],"formate":"png","key":"photo","name":"photo.png"}
 */
+ (void)httpPostFileAddrRequest:(NSString *)url WithFileFormdata:(NSMutableDictionary *)data withFormdaya:(NSMutableDictionary *)formData WithSuccess:(int (^)(NSDictionary *resultDic))success failure:(void (^)(NSError *error))failure;
@end
