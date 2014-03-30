//
//  NetTool.m
//  Temp_Pro
//
//  Created by MacPro-Mr.Lu on 14-3-27.
//  Copyright (c) 2014年 Mr. All rights reserved.
//

#import "NetTool.h"


@implementation NetTool

+ (void)httpGetRequest:(NSString *)url WithSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    NSURL *rurl = [NSURL URLWithString:url];
    __unsafe_unretained __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:rurl];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setRequestMethod:@"GET"];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSDictionary *jsonDic = [responseString objectFromJSONString];
        success(jsonDic);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

+ (void)httpPostRequest:(NSString *)url WithFormdata:(NSMutableDictionary *)formdata WithSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    NSURL *rurl = [NSURL URLWithString:url];
    __unsafe_unretained __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:rurl];
    for (NSString *key in [formdata allKeys])
    {
        [request setPostValue:[formdata valueForKey:key] forKey:key];
    }
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSDictionary *jsonDic = [responseString objectFromJSONString];
        success(jsonDic);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

+ (void)httpPostFileDataRequest:(NSString *)url WithFileFormdata:(NSMutableDictionary *)data withFormdaya:(NSMutableDictionary *)formData WithSuccess:(int (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    NSURL *rurl = [NSURL URLWithString:url];
    
    __unsafe_unretained __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:rurl];
    
    NSString *type = [data valueForKey:@"formate"];
    NSString *key = [data valueForKey:@"key"];
    NSArray *fileData = (NSArray *)[data objectForKey:@"data"];
    NSString *name = [data valueForKey:@"name"];
    
    for (int i = 0 ; i < [fileData count]; i++) {
        NSData *pdata = (NSData *)[fileData objectAtIndex:i];
        [request addData:pdata withFileName:name andContentType:type forKey:key];
    }
    
    for (NSString *key in [formData allKeys])
    {
        [request setPostValue:[formData valueForKey:key] forKey:key];
    }
    
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSDictionary *jsonDic = [responseString objectFromJSONString];
        success(jsonDic);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];

}

+ (void)httpPostFileAddrRequest:(NSString *)url WithFileFormdata:(NSMutableDictionary *)data withFormdaya:(NSMutableDictionary *)formData WithSuccess:(int (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    NSURL *rurl = [NSURL URLWithString:url];
    
    __unsafe_unretained __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:rurl];
    
    NSString *type = [data valueForKey:@"formate"];
    NSString *key = [data valueForKey:@"key"];
    NSArray *fileData = (NSArray *)[data objectForKey:@"data"];
    NSString *name = [data valueForKey:@"name"];
    
    for (int i = 0 ; i < [fileData count]; i++) {
        NSString *pdata = (NSString *)[fileData objectAtIndex:i];
        [request addFile:pdata withFileName:name andContentType:type forKey:key];
    }
    
    for (NSString *key in [formData allKeys])
    {
        [request setPostValue:[formData valueForKey:key] forKey:key];
    }
    
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSDictionary *jsonDic = [responseString objectFromJSONString];
        success(jsonDic);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        failure(error);
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
    
}


@end
