//
//  NetWorkManager.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-2.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "NetWorkManager.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "ASIProgressDelegate.h"
#import "JSONKit.h"
#import "NetWorkUtility.h"
#import "UIImage+Compress.h"
#import "ASIDownloadCache.h"


static NetWorkManager *networkManager = nil;

@implementation NetWorkManager

+ (NetWorkManager *)shareInstance
{
	@synchronized(self) {
		if (networkManager == nil) {
			networkManager = [[NetWorkManager alloc]init];
            [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES]; //显示网络指示器
		}
	}
	return networkManager;
}

+ (void)checkNetworkChange
{
	// 监测网络状态变化监控
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
	[AppDelegate shareDelegate].reachability = [Reachability reachabilityForInternetConnection];
	// 监测网络状态变化监控启动
	[[AppDelegate shareDelegate].reachability startNotifier];
}

#pragma mark -- 回调网络状态方法
+ (void)reachabilityChanged:(id)sender
{
	// 检测网络是否存在
	Reachability	*r = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"NetWorkChanged" object:nil userInfo:nil];
	switch ([r currentReachabilityStatus]) {
		case NotReachable:
			{
				[SVProgressHUD showErrorWithStatus:@"网络断开"];
				break;
			}

		case ReachableViaWWAN:
			{
				[SVProgressHUD showSuccessWithStatus:@"3G网络开启"];
				break;
			}

		case ReachableViaWiFi:
			{
				[SVProgressHUD showSuccessWithStatus:@"wifi网络开启"];
				break;
			}
	}
}

+ (void)handleAsiHttpNetworkError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
//    [UIAlertView showAlertViewWithTitle:@"错误" message:[error localizedDescription] cancelTitle:@"确定"];
}

+ (void)networkQueueWork:(NSArray *)requestArray withDelegate:(id)delegate asiHttpSuccess:(SEL)asiSuccess asiHttpFailure:(SEL)asiFailure queueSuccess:(SEL)queueSuccess
{
    ASINetworkQueue *networkQueue = [[ASINetworkQueue alloc] init];
    [networkQueue setMaxConcurrentOperationCount:1];
    // 重置队列
    [networkQueue reset];
    // 创建ASI队列
    [networkQueue setDelegate:delegate];
    [networkQueue setRequestDidFinishSelector:asiSuccess];
    [networkQueue setRequestDidFailSelector:asiFailure];
    [networkQueue setQueueDidFinishSelector:queueSuccess];
    
    for (int i=1; i<=[requestArray count]; i++) {
        ASIFormDataRequest *request = (ASIFormDataRequest *)[requestArray objectAtIndex:i-1];
        request.tag = i;
        [networkQueue addOperation:request];
    }  
    
    [networkQueue go];
}

+ (BOOL)netWorkIsUseful
{
    return [ASIHTTPRequest isNetworkInUse];
}

+(void)networkCheckPhone:(NSString *)phoneNum success:(void (^)(int,NSObject *,NSString *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:phoneNum,@"phone", nil];
    [NetTool httpPostRequest:API_POST_CheckUserPhone WithFormdata:formData WithSuccess:^(NSDictionary *resultDic) {
        int status = [[resultDic valueForKey:@"status"]intValue];
        NSObject *data = [resultDic objectForKey:@"data"];
        NSString *msg = [resultDic valueForKey:@"msg"];
        success(status,data,msg);

    } failure:^(NSError *error) {
        failure(error);
    }];
}

+(ASIFormDataRequest *)networkGetauthcodeWithPhone:(NSString *)phoneNum type:(int)type mode:(kNetworkrequestMode)mode success:(void (^)(BOOL , NSString *,NSString *, NSString *))success failure:(void (^)(NSError *))failure
{
    
//    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:phoneNum,@"phone", nil];
//    [NetTool httpPostRequest:API_POST_CheckUserPhone WithFormdata:formData WithSuccess:^(NSDictionary *resultDic) {
//        int status = [[resultDic valueForKey:@"status"]intValue];
//        NSObject *data = [resultDic objectForKey:@"data"];
//        NSString *msg = [resultDic valueForKey:@"msg"];
//        success(status,data,msg);
//        
//    } failure:^(NSError *error) {
//        failure(error);
//    }];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/user/getauthcode", kServerHost]];

    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&phone=%@&type=%d",APPKEY,phoneNum,type];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:phoneNum forKey:@"phone"];
    [request addPostValue:[NSNumber numberWithInt:type] forKey:@"type"];
    [request addPostValue:sign forKey:@"sign"];
    [request setRequestMethod:@"POST"];
    if (mode == kNetworkrequestModeQueue) {
        return request;
    }
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        NSString *authcode = @"";
        NSString *sequence = @"";
        if (flag) {
            authcode = [dic valueForKey:@"authcode"];
            sequence = [dic valueForKey:@"sequence"];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
            [SVProgressHUD showErrorWithStatus:msg];
        }
        success(flag,authcode,sequence,msg);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
    
    return nil;

}

+(void)networkCheckUserName:(NSString *)username success:(void (^)(int, NSObject *, NSString *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:username,@"username", nil];
    [NetTool httpPostRequest:API_POST_CheckUserName WithFormdata:formData WithSuccess:^(NSDictionary *resultDic) {
        int status = [[resultDic valueForKey:@"status"]intValue];
        NSObject *data = [resultDic objectForKey:@"data"];
        NSString *msg = [resultDic valueForKey:@"msg"];
        success(status,data,msg);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

+(void)networkUserRegistName:(NSString *)username password:(NSString *)password phone:(NSString *)phone sex:(NSString *)sex age:(int)age phonetype:(NSString *)phonetype phoneuuid:(NSString *)phoneuuid success:(void (^)(BOOL, NSDictionary *userDic, NSString *))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/user/regist", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&age=%d&password=%@&phone=%@&phonetype=%@&phoneuuid=%@&sex=%@&username=%@",APPKEY,age,password,phone,[NetWorkUtility StringEncodeTwo:phonetype],phoneuuid,[NetWorkUtility StringEncodeTwo:sex],[NetWorkUtility StringEncodeTwo:username]];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    //中文字符两次转码
    username = [NetWorkUtility StringEncode:username];
    phonetype = [NetWorkUtility StringEncode:phonetype];
    sex = [NetWorkUtility StringEncode:sex];
    
    [SVProgressHUD show];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithInt:age] forKey:@"age"];
    [request addPostValue:username forKey:@"username"];
    [request addPostValue:password forKey:@"password"];
    [request addPostValue:phone forKey:@"phone"];
    [request addPostValue:phonetype forKey:@"phonetype"];
    [request addPostValue:phoneuuid forKey:@"phoneuuid"];
    [request addPostValue:sex forKey:@"sex"];
    [request addPostValue:sign forKey:@"sign"];
    
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        
//        {"flag":1,
//            "userid":1,
//            "username":"易行人1"
//            “phone”:”15280553669”
//        }
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {
    
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,dic,msg);
        [SVProgressHUD dismiss];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];

}

+(ASIFormDataRequest *)networkEditHeadpic:(UIImage *)photo uid:(long)uid mode:(kNetworkrequestMode)mode success:(void (^)(BOOL, NSString *, NSString *))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/user/editheadpic", kServerHost]];
    
    //图片的压缩处理 设置尺寸为 100*100
    photo = [photo imageByScalingAndCroppingForSize:CGSizeMake(200, 200)];
    
    NSData * photoData = UIImagePNGRepresentation(photo);
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&uid=%ld",APPKEY,uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addData:photoData withFileName:@"headPic.png" andContentType:@"png" forKey:@"photo"];
    [request addPostValue:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [request addPostValue:sign forKey:@"sign"];
    [request setRequestMethod:@"POST"];
    
    if (mode == kNetworkrequestModeQueue) {
        return request;
    }
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString * headPicUrlStr = @"";
        NSString *msg = @"";
        if (flag) {
            headPicUrlStr = [dic valueForKey:@"headpic"];
        }
        else
        {
            msg = [AppUtility getStrByNil:[dic valueForKey:@"msg"]];
        }
        success(flag,headPicUrlStr,msg);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
    return nil;
}

+(void)networkEditpasswordeWithuid:(long)uid password:(NSString *)passWord success:(void (^)(BOOL, NSString *))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/user/editpassword", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&password=%@&uid=%ld",APPKEY,passWord,uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:passWord forKey:@"password"];
    [request addPostValue:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [request addPostValue:sign forKey:@"sign"];
    
    [request setRequestMethod:@"POST"];
    [SVProgressHUD show];
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {
            [SVProgressHUD dismiss];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"密码修改失败:%@",msg]];
        }
        success(flag,msg);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];

}

+(void)networkResetpasswordeWithphone:(NSString *)phone password:(NSString *)passWord success:(void (^)(BOOL))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/user/resetpassword", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&password=%@&phone=%@",APPKEY,passWord,phone];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:passWord forKey:@"password"];
    [request addPostValue:phone forKey:@"phone"];
    [request addPostValue:sign forKey:@"sign"];
    
    [request setRequestMethod:@"POST"];
    [SVProgressHUD show];
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        if (flag) {
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"重设密码失败"];
        }
        success(flag);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
    
}


+(void)networkUserLoginWithname:(NSString *)username password:(NSString *)password phone :(NSString *)phone type:(int)type success:(void (^)(BOOL, NSDictionary *, NSString *))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/user/login", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&password=%@&phone=%@&type=%d&username=%@",APPKEY,password,phone,type,[NetWorkUtility StringEncodeTwo:username]];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    //中文字符两次转码
    username = [NetWorkUtility StringEncode:username];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:username forKey:@"username"];
    [request addPostValue:password forKey:@"password"];
    [request addPostValue:phone forKey:@"phone"];
    [request addPostValue:[NSNumber numberWithInt:type] forKey:@"type"];
    [request addPostValue:sign forKey:@"sign"];
    [request setRequestMethod:@"POST"];
    
    [SVProgressHUD show];
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {
            [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
            [SVProgressHUD showErrorWithStatus:msg];
        }
        success(flag,dic,msg);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

+(void)networkUserLocateGetlastWithuid:(NSString *)uids success:(void (^)(BOOL, NSArray *, NSString *))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/user/login", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&uids=%@",APPKEY,uids];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];

    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:uids forKey:@"uids"];
    [request addPostValue:sign forKey:@"sign"];
    
    [request setRequestMethod:@"POST"];
    
    [SVProgressHUD show];
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSArray *locatelist = nil;
        NSString *msg = @"";
        if (flag) {
            locatelist = (NSArray *)[dic objectForKey:@"locatelist"];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,locatelist,msg);
        [SVProgressHUD dismiss];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

+(void)networkUserLocateAddWithuid:(long)uid address:(NSString *)address longitude:(double)longitude latitude:(double)latitude success:(void (^)(BOOL, NSDictionary *, NSString *))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/locate/add", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&address=%@&longitude=%lf&latitude=%lf&uid=%ld",APPKEY,address,longitude,latitude,uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    address = [NetWorkUtility StringEncode:address];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [request addPostValue:address forKey:@"address"];
    [request addPostValue:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
    [request addPostValue:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
    [request addPostValue:sign forKey:@"sign"];
    
    [request setRequestMethod:@"POST"];
    
//    [SVProgressHUD show];
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {
            
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,dic,msg);
//        [SVProgressHUD dismiss];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

+(void)networkGetUserAddressWithLongitude:(double)longitude latitude:(double)latitude success:(void (^)(BOOL, NSDictionary *))success failure:(void (^)(NSError *))failure
{
    double lat = [[User shareInstance] lat];
    double lon = [[User shareInstance] lon];
    NSURL * requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.map.baidu.com/geocoder?output=json&location=%lf,%lf&key=%@",lat,lon,kBaiDuWebAPIKey]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestUrl];
    
    [request setRequestMethod:@"POST"];
    
    //    [SVProgressHUD show];
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"status"]isEqualToString:@"OK"]?YES:NO;
        NSDictionary *result = nil;
        if (flag) {
            result = (NSDictionary *)[dic objectForKey:@"result"];
        }
        else
        {

        }
        success(flag,result);
        //        [SVProgressHUD dismiss];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
    
}

#pragma mark -- 用户详细信息
+(void)networkGetUserInfoWithuid:(long)uid success:(void (^)(BOOL, NSDictionary *, NSString *))success failure:(void (^)(NSError *))failure
{
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&uid=%ld",APPKEY,uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    [NetTool httpGetRequest:api_getUserInfo(uid,sign) WithSuccess:^(NSDictionary *resultDic) {
        BOOL flag = [[resultDic valueForKey:@"flag"]boolValue];
        NSDictionary *userInfo = nil;
        NSString *msg = @"";
        if (flag) {
            userInfo = [resultDic objectForKey:@"user"];
        }
        else
        {
            msg = [resultDic valueForKey:@"msg"];
        }
        success(flag,userInfo,msg);
    } failure:^(NSError *error) {
        [self handleAsiHttpNetworkError:error];
    }];
}

+(void)networkGetUserInfoWithuidArray:(NSArray *)uidArray success:(void (^)(BOOL, NSArray *, NSString *))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/user/detail", kServerHost]];
    
    NSString *uidArrayStr = @"";
    
    for(int i = 0; i < [uidArray count]; i++)
    {
        if (i==0) {
            uidArrayStr = [uidArrayStr stringByAppendingFormat:@"%ld",[[uidArray objectAtIndex:i]longValue]];
        }
        else
        {
            uidArrayStr = [uidArrayStr stringByAppendingFormat:@",%ld",[[uidArray objectAtIndex:i]longValue]];
        }
    }
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&uid=%@",APPKEY,uidArrayStr];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:uidArrayStr forKey:@"uid"];
    [request addPostValue:sign forKey:@"sign"];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSArray *userInfoArray = nil;
        NSString *msg = @"";
        if (flag) {
            userInfoArray = [dic objectForKey:@"users"];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,userInfoArray,msg);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

+(void)networkGetUserInfoCenterWithuid:(long)uid success:(void (^)(BOOL, NSDictionary *, NSString *))success failure:(void (^)(NSError *))failure
{
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&uid=%ld",APPKEY,uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    [NetTool httpGetRequest:api_getUserCenterInfo(uid, sign) WithSuccess:^(NSDictionary *resultDic) {
        BOOL flag = [[resultDic valueForKey:@"flag"]boolValue];
        NSDictionary *userInfo = nil;
        NSString *msg = @"";
        if (flag) {
            userInfo = resultDic;
            [SVProgressHUD dismiss];
        }
        else
        {
            msg = [resultDic valueForKey:@"msg"];
            [SVProgressHUD showErrorWithStatus:msg];
        }
        success(flag,userInfo,msg);
    } failure:^(NSError *error) {
        [self handleAsiHttpNetworkError:error];
    }];
    
}

+(void)networkGetJokeListPage:(int)page rows:(int)rows success:(void (^)(BOOL, BOOL, NSArray *, NSString *))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/joke/list", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&page=%d&rows=%d",APPKEY,page,rows];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithInt:page] forKey:@"page"];
    [request addPostValue:[NSNumber numberWithInt:rows] forKey:@"rows"];
    [request addPostValue:sign forKey:@"sign"];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        // Use when fetching text data
//
        NSString *responseString = [request responseString];
//        DLog(@"joke responseString %@",responseString);

        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];

        NSArray *jokearray = nil;
        NSString *msg = @"";
        BOOL hasnexpage = NO;
        if (flag) {
            hasnexpage = [[dic valueForKey:@"hasnextpage"]boolValue];
            jokearray = [NSArray arrayWithArray:[dic valueForKey:@"jokes"]];
            
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag, hasnexpage, jokearray,msg);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

+(void)networkEditMailWithuid:(long)uid email:(NSString *)email success:(void (^)(BOOL flag))success failure:(void (^)(NSError * error))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/user/editemail", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&email=%@&uid=%ld",APPKEY,email,uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:email forKey:@"email"];
    [request addPostValue:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [request addPostValue:sign forKey:@"sign"];
    
    [request setRequestMethod:@"POST"];
    [SVProgressHUD show];
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {
            [SVProgressHUD dismiss];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"邮箱修改失败:%@",msg]];
        }
        success(flag);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

+(ASIFormDataRequest *)networkEditUserNameWithuid:(long)uid username:(NSString *)username mode:(kNetworkrequestMode)mode success:(void (^)(BOOL))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/user/editusername", kServerHost]];

    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&uid=%ld&username=%@",APPKEY,uid,[NetWorkUtility StringEncodeTwo:username]];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];

    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NetWorkUtility StringEncode:username] forKey:@"username"];
    [request addPostValue:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [request addPostValue:sign forKey:@"sign"];
    [request setRequestMethod:@"POST"];
    
    if (mode == kNetworkrequestModeQueue) {
        return request;
    }

    [SVProgressHUD show];
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {
            [SVProgressHUD dismiss];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"用户名修改失败:%@",msg]];
        }
        success(flag);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
    
    return nil;
}

+(ASIFormDataRequest *)networkEditSexWithuid:(long)uid sex:(NSString *)sex mode:(kNetworkrequestMode)mode success:(void (^)(BOOL))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/user/editsex", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&sex=%@&uid=%ld",APPKEY,[NetWorkUtility StringEncodeTwo:sex],uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NetWorkUtility StringEncode:sex] forKey:@"sex"];
    [request addPostValue:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [request addPostValue:sign forKey:@"sign"];
    [request setRequestMethod:@"POST"];
    
    if (mode == kNetworkrequestModeQueue) {
        return request;
    }
    
    [SVProgressHUD show];
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {
            [SVProgressHUD dismiss];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"性别修改失败:%@",msg]];
        }
        success(flag);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
    return nil;
}

+(ASIFormDataRequest *)networkEditAgeWithuid:(long)uid age:(int)age mode:(kNetworkrequestMode)mode success:(void (^)(BOOL))success failure:(void (^)(NSError *))failure
{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/user/editage", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&age=%d&uid=%ld",APPKEY,age,uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithInt:age] forKey:@"age"];
    [request addPostValue:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [request addPostValue:sign forKey:@"sign"];
    
    [request setRequestMethod:@"POST"];

    if (mode == kNetworkrequestModeQueue) {
        return request;
    }

    [SVProgressHUD show];
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {
            [SVProgressHUD dismiss];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"年龄修改失败:%@",msg]];
        }
        success(flag);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
    
    return nil;
}

+(ASIFormDataRequest *)networkEditcompanyaddressWithuid:(long)uid companyaddress:(NSString *)companyaddress mode:(kNetworkrequestMode)mode success:(void (^)(BOOL))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/user/editcompanyaddress", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&companyaddress=%@&uid=%ld",APPKEY,[NetWorkUtility StringEncodeTwo:companyaddress],uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NetWorkUtility StringEncode:companyaddress] forKey:@"companyaddress"];
    [request addPostValue:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [request addPostValue:sign forKey:@"sign"];
    
    [request setRequestMethod:@"POST"];
    
    if (mode == kNetworkrequestModeQueue) {
        return request;
    }
    
    [SVProgressHUD show];
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {
            [SVProgressHUD dismiss];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"邮箱修改失败:%@",msg]];
        }
        success(flag);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
    return nil;
}

+(ASIFormDataRequest *)networkEdithomeaddressWithuid:(long)uid homeaddress:(NSString *)homeaddress mode:(kNetworkrequestMode)mode success:(void (^)(BOOL))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/user/edithomeaddress", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&homeaddress=%@&uid=%ld",APPKEY,[NetWorkUtility StringEncodeTwo:homeaddress],uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NetWorkUtility StringEncode:homeaddress] forKey:@"homeaddress"];
    [request addPostValue:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [request addPostValue:sign forKey:@"sign"];
    [request setRequestMethod:@"POST"];

    
    if (mode == kNetworkrequestModeQueue) {
        return request;
    }
    [SVProgressHUD show];
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {
            [SVProgressHUD dismiss];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"邮箱修改失败:%@",msg]];
        }
        success(flag);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
    return nil;
}

#pragma mark--选择路线接口
+(void)networkGetJuDianListPage:(int)page rows:(int)rows success:(void (^)(BOOL, BOOL, NSArray *, NSString *))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/judian/list", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&page=%d&rows=%d",APPKEY,page,rows];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url usingCache:[ASIDownloadCache sharedCache] andCachePolicy:ASIFallbackToCacheIfLoadFailsCachePolicy|ASIAskServerIfModifiedWhenStaleCachePolicy|ASIAskServerIfModifiedCachePolicy];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithInt:rows] forKey:@"rows"];
    [request addPostValue:[NSNumber numberWithInt:page] forKey:@"page"];
    [request addPostValue:sign forKey:@"sign"];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        // Use when fetching text data
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        
        NSArray *judiansArray = nil;
        NSString *msg = @"";
        BOOL hasnexpage = NO;
        if (flag) {
            hasnexpage = [[dic valueForKey:@"hasnextpage"]boolValue];
            judiansArray = [Judian arrayWithArrayDic:[dic valueForKey:@"judians"]];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag, hasnexpage, judiansArray,msg);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

+(void)networkGetJuDianListPage:(int)page rows:(int)rows lng:(double)lng lat:(double)lat success:(void (^)(BOOL, BOOL, NSArray *, NSString *))success failure:(void (^)(NSError *))failure
{
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&lat=%lf&lng=%lf&page=%d&rows=%d",APPKEY,lat,lng,page,rows];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    [NetTool httpGetRequest:api_getJudianListWithLocate(lat, lng, page, rows, sign) WithSuccess:^(NSDictionary *resultDic) {
        BOOL flag = [[resultDic valueForKey:@"flag"]boolValue];
        
        NSArray * judiansArray = nil;
        NSString *msg = @"";
        BOOL hasnexpage = NO;
        if (flag) {
            hasnexpage = [[resultDic valueForKey:@"hasnextpage"]boolValue];
            judiansArray = [Judian arrayWithArrayDic:[resultDic valueForKey:@"judians"]];
        }
        else
        {
            msg = [resultDic valueForKey:@"msg"];
        }
        success(flag, hasnexpage, judiansArray,msg);
    } failure:^(NSError *error) {
         [self handleAsiHttpNetworkError:error];
    }];
}

+(void)networkGetLineListByJudianId:(long)judianID page:(int)page rows:(int)rows success:(void (^)(BOOL, BOOL, NSArray *, NSString *))success failure:(void (^)(NSError *))failure
{
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&judianid=%ld&page=%d&rows=%d",APPKEY,judianID,page,rows];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    [NetTool httpGetRequest:api_getLineListbyjudianid(judianID, page, rows, sign) WithSuccess:^(NSDictionary *resultDic) {
        BOOL flag = [[resultDic valueForKey:@"flag"]boolValue];
        
        NSArray *linearray = nil;
        NSString *msg = @"";
        BOOL hasnexpage = NO;
        if (flag) {
            hasnexpage = [[resultDic valueForKey:@"hasnextpage"]boolValue];
            linearray = [Line arrayWithArrayDic:[resultDic valueForKey:@"lines"]];
        }
        else
        {
            msg = [resultDic valueForKey:@"msg"];
        }
        success(flag, hasnexpage, linearray,msg);
    } failure:^(NSError *error) {
        [self handleAsiHttpNetworkError:error];
    }];
    
}

//获取线路的分页数据
+(void)networkGetLineListPage:(int)page rows:(int)rows success:(void (^)(BOOL flag, BOOL hasnextpage, NSArray *lineArray,NSString * msg))success failure:(void (^)(NSError * error))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/line/list", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&page=%d&rows=%d",APPKEY,page,rows];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithInt:rows] forKey:@"rows"];
    [request addPostValue:[NSNumber numberWithInt:page] forKey:@"page"];
    [request addPostValue:sign forKey:@"sign"];
    
    [request setRequestMethod:@"POST"];
//    [SVProgressHUD show];
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        
        NSArray *linearray = nil;
        NSString *msg = @"";
        BOOL hasnexpage = NO;
        if (flag) {
            hasnexpage = [[dic valueForKey:@"hasnextpage"]boolValue];
            linearray = [Line arrayWithArrayDic:[dic valueForKey:@"lines"]];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag, hasnexpage, linearray,msg);
//        [SVProgressHUD dismiss];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

//根据关键字获取线路的分页数据
+(void)networkGetLineListByTag:(NSString *)tag page:(int)page rows:(int)rows success:(void (^)(BOOL flag, BOOL hasnextpage, NSArray *lineArray,NSString * msg))success failure:(void (^)(NSError * error))failure
{
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&page=%d&rows=%d&tag=%@",APPKEY,page,rows,[NetWorkUtility StringEncodeTwo:tag]];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    NSString *tagx = [NetWorkUtility StringEncodeTwo:tag];//中文字符两次转码
    [NetTool httpGetRequest:api_getLineListbyTag(page, rows, tagx, sign) WithSuccess:^(NSDictionary *resultDic) {

        BOOL flag = [[resultDic valueForKey:@"flag"]boolValue];
        
        NSArray *linearray = nil;
        NSString *msg = @"";
        BOOL hasnexpage = NO;
        if (flag) {
            hasnexpage = [[resultDic valueForKey:@"hasnextpage"]boolValue];
            linearray = [Line arrayWithArrayDic:[resultDic valueForKey:@"lines"]];
            
        }
        else
        {
            msg = [resultDic valueForKey:@"msg"];
        }
        success(flag, hasnexpage, linearray,msg);
    } failure:^(NSError *error) {
        [self handleAsiHttpNetworkError:error];
    }];
    
}

//*****增加房间****//
+(void)networkCreateRoomWithID:(long)ID lineID:(long)lineID startingTime:(NSString *)startingTime seatnum:(int)seatnum description:(NSString *)description addtofav:(BOOL)addtofav success:(void (^)(BOOL flag,long roomID, NSString * msg))success failure:(void (^)(NSError * error))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/room/add", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&addtofav=%d&description=%@&lineid=%ld&startingtime=%@&seatnum=%d&uid=%ld",APPKEY,addtofav,description,lineID,startingTime,seatnum,ID];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithBool:addtofav] forKey:@"addtofav"];
    [request addPostValue:[NSNumber numberWithLong:ID] forKey:@"uid"];
    [request addPostValue:[NSNumber numberWithLong:lineID] forKey:@"lineid"];
    [request addPostValue:startingTime forKey:@"startingtime"];
    [request addPostValue:[NSNumber numberWithInt:seatnum] forKey:@"seatnum"];
    [request addPostValue:[NetWorkUtility StringEncode:description] forKey:@"description"];
    [request addPostValue:sign forKey:@"sign"];
    
    [request setRequestMethod:@"POST"];
    [SVProgressHUD show];
    [request setCompletionBlock:^{
        
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        long roomid = 0;
        NSString *msg = @"";
        if (flag) {
            roomid = [[dic valueForKey:@"roomid"]longValue];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,roomid,msg);
//        [SVProgressHUD dismiss];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

//销毁房间
+(void)networkCloseRoomWithID:(long)ID roomID:(long)roomID success:(void (^)(BOOL flag,NSString * msg))success failure:(void (^)(NSError * error))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/room/del", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&roomid=%ld&uid=%ld",APPKEY,roomID,ID];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithLong:ID] forKey:@"uid"];
    [request addPostValue:[NSNumber numberWithLong:roomID] forKey:@"roomid"];
    [request addPostValue:sign forKey:@"sign"];
    
    [request setRequestMethod:@"POST"];
    [SVProgressHUD show];
    [request setCompletionBlock:^{
        
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        
        NSString *msg = @"";
        if (!flag) {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,msg);
        [SVProgressHUD dismiss];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

//加入房间 == 准备
+(void)networkJoinRoomWithID:(long)ID roomID:(long)roomID success:(void (^)(BOOL flag,NSString * msg))success failure:(void (^)(NSError * error))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/room/join", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&roomid=%ld&uid=%ld",APPKEY,roomID,ID];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithLong:ID] forKey:@"uid"];
    [request addPostValue:[NSNumber numberWithLong:roomID] forKey:@"roomid"];
    [request addPostValue:sign forKey:@"sign"];
    
    [request setRequestMethod:@"POST"];
    [SVProgressHUD show];
    [request setCompletionBlock:^{
        
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        
        NSString *msg = @"";
        if (!flag) {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,msg);
        [SVProgressHUD dismiss];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

//退出房间 == 取消准备
+(void)networkExitRoomWithID:(long)ID roomID:(long)roomID success:(void (^)(BOOL flag,NSString * msg))success failure:(void (^)(NSError * error))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/room/exit", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&roomid=%ld&uid=%ld",APPKEY,roomID,ID];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithLong:ID] forKey:@"uid"];
    [request addPostValue:[NSNumber numberWithLong:roomID] forKey:@"roomid"];
    [request addPostValue:sign forKey:@"sign"];
    
    [request setRequestMethod:@"POST"];
    [SVProgressHUD show];
    [request setCompletionBlock:^{
        
        NSString *responseString = [request responseString];
        NSDictionary *dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        
        NSString *msg = @"";
        if (!flag) {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,msg);
        [SVProgressHUD dismiss];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];

}

//取到房间准备的所有用户
+(void)networkGetRoomUsersWithroomID:(long)roomID success:(void (^)(BOOL flag, NSArray *users,NSDictionary *owner,NSString * msg))success failure:(void (^)(NSError * error))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/room/users", kServerHost]];
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&roomid=%ld",APPKEY,roomID];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithLong:roomID] forKey:@"roomid"];
    [request addPostValue:sign forKey:@"sign"];
    
    [request setRequestMethod:@"POST"];
    [SVProgressHUD show];
    [request setCompletionBlock:^{
        
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSArray *users = nil;
        NSDictionary *owner = nil;
        NSString *msg = @"";
        BOOL hasnexpage = NO;
        if (flag) {
            hasnexpage = [[dic valueForKey:@"hasnextpage"]boolValue];
            users = (NSArray *)[dic valueForKey:@"users"];
            owner = (NSDictionary *)[dic valueForKey:@"owner"];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,users,owner,msg);
        [SVProgressHUD dismiss];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];

}

//根据用户获取房间数据
+(void)networkGetRoomsWithID:(long)ID page:(int)page rows:(int)rows success:(void (^)(BOOL flag, BOOL hasnextpage, NSArray *roomArray,NSString * msg))success failure:(void (^)(NSError * error))failure
{
    
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&page=%d&rows=%d&uid=%ld",APPKEY,page,rows,ID];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    [NetTool httpGetRequest:api_getRoomsWithuid(page, rows, ID, sign) WithSuccess:^(NSDictionary *resultDic) {
        BOOL flag = [[resultDic valueForKey:@"flag"]boolValue];
        NSArray *rooms = nil;
        NSString *msg = @"";
        BOOL hasnexpage = NO;
        if (flag) {
            hasnexpage = [[resultDic valueForKey:@"hasnextpage"]boolValue];
            rooms = (NSArray *)[Room arrayWithArrayDic:[resultDic valueForKey:@"rooms"]];
        }
        else
        {
            msg = [resultDic valueForKey:@"msg"];
        }
        success(flag,hasnexpage,rooms,msg);
    } failure:^(NSError *error) {
         [self handleAsiHttpNetworkError:error];
    }];
    
}
                                                                                                                    
//根据线路获取房间数据
+(void)networkGetRoomsWithuid:(long)uid lineID:(long)lineID page:(int)page rows:(int)rows success:(void (^)(BOOL flag, BOOL hasnextpage, NSArray *roomArray,NSString * msg))success failure:(void (^)(NSError * error))failure
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/room/listbyline", kServerHost]];
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&lineid=%ld&page=%d&rows=%d&uid=%ld",APPKEY,lineID,page,rows,uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithLong:lineID] forKey:@"lineid"];
    [request addPostValue:[NSNumber numberWithInt:page] forKey:@"page"];
    [request addPostValue:[NSNumber numberWithInt:rows] forKey:@"rows"];
    [request addPostValue:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [request addPostValue:sign forKey:@"sign"];

    [request setRequestMethod:@"POST"];
    [SVProgressHUD show];
    [request setCompletionBlock:^{
        
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSArray *rooms = nil;
        NSString *msg = @"";
        BOOL hasnexpage = NO;
        if (flag) {
            hasnexpage = [[dic valueForKey:@"hasnextpage"]boolValue];
            rooms = (NSArray *) [Room arrayWithArrayDic:[dic valueForKey:@"rooms"]];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,hasnexpage,rooms,msg);
        [SVProgressHUD dismiss];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

+(void)networkGetRoomInfoWithRoomID:(long)roomID success:(void (^)(BOOL, NSDictionary *, NSString *))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/room/infobyid", kServerHost]];
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&roomid=%ld",APPKEY,roomID];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithLong:roomID] forKey:@"roomid"];
    [request addPostValue:sign forKey:@"sign"];
    
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {
            
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,dic,msg);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

+(void)networkCommemtWithRoomID:(long)roomID uid:(long)uid touid:(long)touid content:(NSString *)content commentLever:(int)lever userstatus:(int)userstatus yeyxstar:(int)yeyxstar jzwmstar:(int)jzwmstar rxttstar:(int)rxttstar ownertatus:(int)ownertatus  success:(void (^)(BOOL flag, NSString * msg))success failure:(void (^)(NSError * error))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/comment/add", kServerHost]];
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&content=%@&commentlever=%d&jzwmstar=%d&ownertatus=%d&roomid=%ld&rxttstar=%d&touid=%ld&uid=%ld&userstatus=%d&yeyxstar=%d",APPKEY,content,lever,jzwmstar,ownertatus,roomID,rxttstar,touid,uid,userstatus,yeyxstar];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithLong:roomID] forKey:@"roomid"];
    [request addPostValue:[NSNumber numberWithLong:touid] forKey:@"touid"];
    [request addPostValue:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [request addPostValue:content forKey:@"content"];
    [request addPostValue:[NSNumber numberWithInt:lever] forKey:@"commentlever"];
    [request addPostValue:[NSNumber numberWithInt:userstatus] forKey:@"userstatus"];
    [request addPostValue:[NSNumber numberWithInt:yeyxstar] forKey:@"yeyxstar"];
    [request addPostValue:[NSNumber numberWithInt:jzwmstar] forKey:@"jzwmstar"];
    [request addPostValue:[NSNumber numberWithInt:rxttstar] forKey:@"rxttstar"];
    [request addPostValue:[NSNumber numberWithInt:ownertatus] forKey:@"ownertatus"];
    [request addPostValue:sign forKey:@"sign"];
    
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {

        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,msg);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

+(void)networkGetCommentsWithuid:(long)uid page:(int)page rows:(int)rows success:(void (^)(BOOL, BOOL, NSArray *, NSString *))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/comment/listbyuid", kServerHost]];
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&page=%d&rows=%d&uid=%ld",APPKEY,page,rows,uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [request addPostValue:[NSNumber numberWithInt:page] forKey:@"page"];
    [request addPostValue:[NSNumber numberWithInt:rows] forKey:@"rows"];
    [request addPostValue:sign forKey:@"sign"];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSArray *comments = nil;
        NSString *msg = @"";
        BOOL hasnexpage = NO;
        if (flag) {
            hasnexpage = [[dic valueForKey:@"hasnextpage"]boolValue];
            comments = [dic valueForKey:@"comments"];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,hasnexpage,comments,msg);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

+(void)networkGetRoomCommentWithuid:(long)uid roomid:(long)roomid success:(void (^)(BOOL, NSArray *, NSDictionary *, NSString *))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/comment/roomconment", kServerHost]];
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&roomid=%ld&uid=%ld",APPKEY,roomid,uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [request addPostValue:[NSNumber numberWithLong:roomid] forKey:@"roomid"];
    [request addPostValue:sign forKey:@"sign"];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSArray *userArray = nil;
        NSDictionary *roomDic = nil;
        NSString *msg = @"";
        if (flag) {
            userArray = [dic valueForKey:@"users"];
            roomDic = [dic valueForKey:@"room"];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,userArray,roomDic,msg);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

//房主确认拼车
+(void)networkRoomMasterEnsureuid:(long)uid roomid:(long)roomid success:(void (^)(BOOL flag, NSString * msg))success failure:(void (^)(NSError * error))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/room/confirm", kServerHost]];
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&roomid=%ld&uid=%ld",APPKEY,roomid,uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [request addPostValue:[NSNumber numberWithLong:roomid] forKey:@"roomid"];
    [request addPostValue:sign forKey:@"sign"];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,msg);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

//房主修改出发时间
+(void)networkRoomMasterEditStartTime:(long)uid roomid:(long)roomid startingTime:(NSString *)startingTime success:(void (^)(BOOL flag, NSString * msg))success failure:(void (^)(NSError * error))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/room/changestarttime", kServerHost]];
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&roomid=%ld&startingtime=%@&uid=%ld",APPKEY,roomid,startingTime,uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [request addPostValue:[NSNumber numberWithLong:roomid] forKey:@"roomid"];
    [request addPostValue:startingTime forKey:@"startingtime"];
    [request addPostValue:sign forKey:@"sign"];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,msg);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

//房主修改出附加信息
+(void)networkRoomMasterEditDes:(long)uid roomid:(long)roomid description:(NSString *)description success:(void (^)(BOOL flag, NSString * msg))success failure:(void (^)(NSError * error))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/room/changedescription", kServerHost]];
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&description=%@&roomid=%ld&uid=%ld",APPKEY,description,roomid,uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [request addPostValue:[NSNumber numberWithLong:roomid] forKey:@"roomid"];
    [request addPostValue:description forKey:@"description"];
    [request addPostValue:sign forKey:@"sign"];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,msg);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

//房主修改坐位数
+(void)networkRoomMasterEditSeat:(long)uid roomid:(long)roomid seatnum:(int)seatnum success:(void (^)(BOOL flag, NSString * msg))success failure:(void (^)(NSError * error))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/room/changeseatnum", kServerHost]];
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&roomid=%ld&seatnum=%d&uid=%ld",APPKEY,roomid,seatnum,uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [request addPostValue:[NSNumber numberWithLong:roomid] forKey:@"roomid"];
    [request addPostValue:[NSNumber numberWithInt:seatnum] forKey:@"seatnum"];
    [request addPostValue:sign forKey:@"sign"];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,msg);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

#pragma mark -- 推送方法
+(void)networkJpushSendNotification:(NSString *)uidalias title:(NSString *)title content:(NSString *)content success:(void (^)(BOOL, NSString *))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/push/send/notification", kServerHost]];
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&content=%@&title=%@&uidalias=%@",APPKEY,[NetWorkUtility StringEncode:content],[NetWorkUtility StringEncode:title],uidalias];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    DLog(@"%@?%@&sign=%@",url,keyValueString,sign);
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:uidalias forKey:@"uidalias"];
    [request addPostValue:[NetWorkUtility StringEncode:title] forKey:@"title"];
    [request addPostValue:[NetWorkUtility StringEncode:content] forKey:@"content"];
    [request addPostValue:sign forKey:@"sign"];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,msg);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

+(void)networkJpushSendMessage:(NSString *)uidalias title:(NSString *)title content:(NSString *)content success:(void (^)(BOOL, NSString *))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/push/send/message", kServerHost]];
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&content=%@&title=%@&uidalias=%@",APPKEY,[NetWorkUtility StringEncode:content],[NetWorkUtility StringEncode:title],uidalias];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    DLog(@"%@?%@&sign=%@",url,keyValueString,sign);
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:uidalias forKey:@"uidalias"];
    [request addPostValue:[NetWorkUtility StringEncode:title] forKey:@"title"];
    [request addPostValue:[NetWorkUtility StringEncode:content] forKey:@"content"];
    [request addPostValue:sign forKey:@"sign"];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
        }
        success(flag,msg);
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    
    [request startAsynchronous];
}

#pragma mark - 取广告信息
+(void)networkGetADListWithPage:(int)page rows:(int)rows success:(void (^)(BOOL flag, NSArray *adArray, NSString *msg))success failure:(void (^)(NSError * error))failure
{
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&page=%d&rows=%d",APPKEY,page,rows];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    [NetTool httpGetRequest:api_Setting_Ad(page, rows, sign) WithSuccess:^(NSDictionary *resultDic) {
        BOOL flag = [[resultDic valueForKey:@"flag"]boolValue];
        NSArray *adsArray = nil;
        NSString *msg = @"";
        if (flag) {
            adsArray = (NSArray *)[resultDic objectForKey:@"ads"];
        }
        else
        {
            msg = [resultDic valueForKey:@"msg"];
        }
        success(flag,adsArray,msg);
    } failure:^(NSError *error) {
        [self handleAsiHttpNetworkError:error];
    }];
}

#pragma mark - 获取常用路线
+(void)networkGetUserfavlineListWithUid:(long)uid page:(int)page rows:(int)rows success:(void (^)(BOOL, BOOL , NSArray *, NSString *))success failure:(void (^)(NSError *))failure
{
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&page=%d&rows=%d&uid=%ld",APPKEY,page,rows,uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    
    [NetTool httpGetRequest:api_getUserfavlineList(page, rows, uid, sign) WithSuccess:^(NSDictionary *resultDic) {
        BOOL flag = [[resultDic valueForKey:@"flag"]boolValue];
        NSArray *adsArray = nil;
        NSString *msg = @"";
        BOOL hasnexpage = NO;
        if (flag) {
            hasnexpage = [[resultDic valueForKey:@"hasnextpage"]boolValue];
            adsArray = (NSArray *)[resultDic objectForKey:@"userfavlines"];
        }
        else
        {
            msg = [resultDic valueForKey:@"msg"];
        }
        success(flag,hasnexpage,adsArray,msg);

    } failure:^(NSError *error) {
        [self handleAsiHttpNetworkError:error];
    }];
}

+(void)networkAddUserfavlineWithUid:(long)uid lineID:(int)lineid success:(void (^)(BOOL, NSString *))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@yx/api/userfavline/add", kServerHost]];
    NSString  *keyValueString = [NSString stringWithFormat:@"appkey=%@&lineid=%d&uid=%ld",APPKEY,lineid,uid];
    NSString  *sign = [NSString stringWithFormat:@"%@",[NetWorkUtility generateSign:keyValueString]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:APPKEY forKey:@"appkey"];
    [request addPostValue:[NSNumber numberWithInt:lineid] forKey:@"lineid"];
    [request addPostValue:[NSNumber numberWithLong:uid] forKey:@"uid"];
    [request addPostValue:sign forKey:@"sign"];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSDictionary * dic = [responseString objectFromJSONString];
        BOOL flag = [[dic valueForKey:@"flag"]boolValue];
        NSString *msg = @"";
        if (flag) {
            [SVProgressHUD showSuccessWithStatus:@"添加常用路线成功"];
        }
        else
        {
            msg = [dic valueForKey:@"msg"];
            [SVProgressHUD showErrorWithStatus:@"msg"];
        }
        success(flag,msg);
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [self handleAsiHttpNetworkError:error];
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}
@end

