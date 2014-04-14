//
//  APIClient.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-5.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "APIClient.h"

@implementation APIClient

+(void)networkCheckPhone:(NSString *)phoneNum success:(void (^)(Respone *respone))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:phoneNum,@"phone", nil];
    [NetTool httpPostRequest:API_POST_CheckUserPhone WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)networkCheckUserName:(NSString *)username success:(void (^)(Respone *respone))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:username,@"username", nil];
    [NetTool httpPostRequest:API_POST_CheckUserName WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)networkGetauthcodeWithPhone:(NSString *)phoneNum success:(void (^)(Respone *respone))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:phoneNum,@"phone", nil];
    [NetTool httpPostRequest:API_POST_GetAuthCode WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)networkUserRegistWithPhone:(NSString *)phone password:(NSString *)password authcode:(NSString *)authcode smsid:(NSString *)smsid success:(void (^)(Respone *respone))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:phone,@"phone", password,@"password",smsid,@"smsid",authcode,@"authcode",nil];
    [NetTool httpPostRequest:API_POST_Register WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)networkUserLoginWithPhone:(NSString *)phone password:(NSString *)password success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:phone,@"phone", password,@"password",nil];
    [NetTool httpPostRequest:API_POST_Login WithFormdata:formData WithSuccess:^(Respone *resultDic)
    {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)networkGetUserInfoWithuid:(long)uid success:(void (^)(Respone *respone))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:uid],@"uid",nil];
    [NetTool httpPostRequest:API_POST_GetUserDetail WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)networkGetLineListByJudianId:(long)judianID page:(int)page rows:(int)rows all:(int)all success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:judianID],@"pointid",[NSNumber numberWithInt:page],@"page",[NSNumber numberWithInt:rows],@"rows",[NSNumber numberWithInt:all],@"all",nil];
    [NetTool httpPostRequest:API_POST_GetListLienByJudianID WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)networkGetLineListByTag:(NSString *)tag page:(int)page rows:(int)rows all:(int)all success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:tag,@"wd",[NSNumber numberWithInt:page],@"page",[NSNumber numberWithInt:rows],@"rows",[NSNumber numberWithInt:all],@"all",nil];
    [NetTool httpPostRequest:API_POST_GetListLienByTag WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)networkUpLoadImageFileByType:(int)type user_id:(long)user_id dataFile :(NSArray *)fileArray success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
//    {"data":[nameaddr1,nameaddr2],"formate":"png","key":"photo","name":"photo"}
    NSMutableDictionary *fileDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:fileArray,@"data",@"png",@"formate",@"file_",@"key",@"file_",@"name", nil];
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:user_id],@"user_id",[NSNumber numberWithInt:type],@"type",nil];
    [NetTool httpPostFileAddrRequest:API_POST_UpLoadImageFile WithFileFormdata:fileDic withFormdaya:formData WithSuccess:^void(Respone *respone) {
        success(respone);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
