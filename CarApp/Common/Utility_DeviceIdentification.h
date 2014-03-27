//
//  Utility_DeviceIdentification.h
//  PRJ_HQHD_BTN
//
//  Created by MacPro-Mr.Lu on 14-2-20.
//  Copyright (c) 2014年 MacPro-Mr.Lu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSKeychain.h"

@interface Utility_DeviceIdentification : NSObject

/**
 *	mac 地址
 *  //IOS 7.0 之后无法使用 返回 02.00.00.00
 */
+(NSString *)macAddress;

/**
 *	设备UDID 
 *  //IOS 5.0 之后被禁止使用 无法上架
 */
+(NSString *)udid;

/**
 *	Vender标示
 *  //IOS 6.0 之后才被使用
 */
+(NSString *)vendor;

/**
 *	广告标示 
 *  //如果用户完全重置系统,会发生变化
 */
+(NSString *)advertisingIdentifier;

/**
 *	推送标示
 *  必须通过application的代理实现
 *  //取决于apple服务器返回
 */
+(NSString *)token;

/**
 * UUID
 */
+(NSString *)uuid;

/**
 * keyChain，我们需要导入Security.framework ，keychain的操作接口声明在头文件SecItem.h里。
 *
 */
+(NSString *)keyChain;

@end
