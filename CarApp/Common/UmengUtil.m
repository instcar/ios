//
//  UmengUtil.m
//  PRJ_HQHD_BTN
//
//  Created by MacPro-Mr.Lu on 14-2-19.
//  Copyright (c) 2014年 MacPro-Mr.Lu. All rights reserved.
//

#import "UmengUtil.h"
#import "JSONKit.h"
#import "Utility_DeviceIdentification.h"
#import "SSKeychain.h"

@implementation UmengUtil

+(NSString *)getUmengOpenUDID
{
    //利用keychain来保存的OpenUDID,保证删除应用之后OpenUDID一致
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *deviceID = [SSKeychain passwordForService:identifier account:@"user"];
    if ([deviceID isEqualToString:@""] || deviceID == nil) {
        if(cls && [cls respondsToSelector:deviceIDSelector]){
            deviceID = [cls performSelector:deviceIDSelector];
        }
        [SSKeychain setPassword: [NSString stringWithFormat:@"%@", deviceID]
                     forService:identifier account:@"user"];
    }
    return deviceID;
}

+(void)setAnalyticsAppkey
{
    //统计
    [MobClick startWithAppkey:kUmengAppKey reportPolicy:SENDDAILY channelId:@"appstore"];
    [MobClick setAppVersion:kAppVersion];
    [MobClick setLogEnabled:NO];
    
    [MobClick checkUpdate];//检测更新
    
}

//+(void)setSocialAppkey
//{
//    //设置微信AppId，url地址传nil，将默认使用友盟的网址
//    [UMSocialConfig setWXAppId:@"wxd9a39c7122aa6516" url:nil];
//}
/**
 * 点击事件统计
 *
 * @param  inArgments	参数不能为空
 * @param  inArgments length == 1  调用 MobClick event
 * @param  inArgments length >= 2  调用 MobClick event:attributes:
 */
+(void)umengEvent:(NSMutableArray *)inArgments
{
    if ([inArgments count]<=0) {
        return;
    }
    if ([inArgments count] == 1) {
        NSString *eventStr = [inArgments objectAtIndex:0];
        [MobClick event:eventStr];
    }
    if ([inArgments count] >= 2) {
        NSString *eventStr = [inArgments objectAtIndex:0];
        NSString *dicStr = [inArgments objectAtIndex:1];
        NSDictionary *dic = (NSDictionary *)[dicStr objectFromJSONString];
        if ([[dic allKeys]count]>1) {
            [MobClick event:eventStr attributes:dic];
        }
        else
        {
            if([[dic allKeys]count] == 1)
            {
                NSString *key = [[dic allKeys] objectAtIndex:0];
                NSString *value = [dic valueForKey:key];
                [MobClick event:eventStr label:value];
            }
        }
        
    }
}

/**
 * 页面时长开始
 *
 * @param  inArgments	参数不能为空
 * @param  inArgments length == 1  调用 MobClick beginEvent
 * @param  inArgments length >= 2  调用 MobClick beginEvent:primarykey:attributes:
 */
+(void)beginUmengEvent:(NSMutableArray *)inArgments
{
    if ([inArgments count]<=0) {
        return;
    }
    if ([inArgments count] == 1) {
        NSString *eventStr = [inArgments objectAtIndex:0];
        [MobClick beginEvent:eventStr];
    }
    if ([inArgments count] >= 2) {
        NSString *eventStr = [inArgments objectAtIndex:0];
        NSString *dicStr = [inArgments objectAtIndex:1];
        NSDictionary *dic = (NSDictionary *)[dicStr objectFromJSONString];
        [MobClick beginEvent:eventStr primarykey:eventStr attributes:dic];
    }
}

/**
 * 页面时长结束
 *
 * @param  inArgments	参数不能为空
 * @param  inArgments length == 1  调用 MobClick endEvent
 * @param  inArgments length >= 2  调用 MobClick endEvent:primarykey:
 */
+(void)endUmengEvent:(NSMutableArray *)inArgments
{
    if ([inArgments count]<=0) {
        return;
    }
    if ([inArgments count] == 1) {
        NSString *eventStr = [inArgments objectAtIndex:0];
        [MobClick endEvent:eventStr];
    }
    if ([inArgments count] >= 2) {
        NSString *eventStr = [inArgments objectAtIndex:0];
        [MobClick endEvent:eventStr primarykey:eventStr];
    }
}

@end
