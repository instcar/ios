//
//  Utility_DeviceIdentification.m
//  PRJ_HQHD_BTN
//
//  Created by MacPro-Mr.Lu on 14-2-20.
//  Copyright (c) 2014年 MacPro-Mr.Lu. All rights reserved.
//

#import "Utility_DeviceIdentification.h"
//mac
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import <AdSupport/ASIdentifierManager.h>
#import <Security/Security.h>

@implementation Utility_DeviceIdentification

+(NSString *)macAddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    NSString* noUID = @"";
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        return noUID;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        return noUID;
    }
    
    if ((buf = (char*)malloc(len)) == NULL) {
        return noUID;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        return noUID;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
    
}

+(NSString *)udid
{
    /*
     IOS 移除该对外方法调用
     */
//    return [[UIDevice currentDevice] uniqueIdentifier];
    return nil;
}

+(NSString *)vendor
{
    NSString *vendor = nil;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 6.0) {
        vendor = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    }
    return vendor;
}

+(NSString *)advertisingIdentifier
{
    //需要导入 #import AdSupport.framework <AdSupport/ASIdentifierManager.h>
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return adId;
}

+(NSString *)token
{
    if (![[UIApplication sharedApplication].delegate respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"没有实现获取Device方法" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
    }
    /*
     1.设置推送证书
     2.获取DeviceToken
     3.监听回调方法
     */
    return nil;
}

+(NSString*) uuid {
    
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 5.0 && [[[UIDevice currentDevice] systemVersion]floatValue] < 6.0) {
        //使用ARC
        CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
//        NSString * uuidString = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
        NSString *uuidString = nil;
        CFRelease(newUniqueId);
        return uuidString;
    }
    
    //IOS 6.0之后的方法
    return [[NSUUID UUID] UUIDString];
}

+(NSString *)keyChain
{
    NSString *uuid = nil;
    //554F8521-398e
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    uuid = [SSKeychain passwordForService:identifier account:@"user"];
    if ([uuid isEqualToString:@""] || uuid == nil) {
        uuid = [self uuid];
        [SSKeychain setPassword: [NSString stringWithFormat:@"%@", uuid]
                     forService:identifier account:@"user"];
    }
    return uuid;
}
@end
