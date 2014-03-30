//
//  MD5Methd.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-13.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "NetWorkUtility.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NetWorkUtility

+ (NSString*)md5HexDigest:(NSString*)input {
    
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    
    //转大写
    return [ret uppercaseString];
}

+ (NSString *)AssembleString:(NSString *)str
{
    NSString *assembleString = [str stringByAppendingString:SECRETCODE];
    return assembleString;
}

+ (NSString *)generateSign:(NSString *)keyValueStr
{
    NSString * assembleString = [NetWorkUtility AssembleString:keyValueStr];
    NSString * sign = [NetWorkUtility md5HexDigest:assembleString];
    return sign;
}

+(NSString *)StringDecode:(NSString *)input
{
    NSString *DecodeStr = [[input stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return DecodeStr;
}

+(NSString *)StringEncode:(NSString *)input
{
    NSString *enCodeStr = [input stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return enCodeStr;
}

+(NSString *)StringEncodeTwo:(NSString *)input
{
    NSString *enCodeStr = [[input stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return enCodeStr;
}

@end
