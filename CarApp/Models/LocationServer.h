//
//  LocationServer.h
//  WPWProject
//
//  Created by Mr.Lu on 13-7-10.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**定位服务采用百度ip定位和自带的定位功能**/
@interface LocationServer : NSObject<CLLocationManagerDelegate,UIAlertViewDelegate>
@property (assign, nonatomic)CLLocationCoordinate2D locate; //定位点
@property (strong, nonatomic)CLLocationManager *locationManager; //定位管理器

/**
 *	实例化网络模块单例
 *
 *	@return	网络模块单例
 */
+ (LocationServer *)shareInstance;

-(void)startLocation; //开始定位
//+(NSString *)locateIP; //ip定位 (未使用)

@end
