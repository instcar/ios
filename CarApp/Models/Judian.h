//
//  Judian.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-27.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Judian : NSObject<NSCopying>
///*
// "id": 1,//聚点ID
// "cityregion": "厦门市思明区",//聚点城市区域
// "name": "聚点-卧龙",//聚点名称
// "address": "测试地址",//聚点地址
// "description": "测试描述",//聚点描述
// "longitude": 118.143154,//聚点的经度
// "latitude": 24.483156,//聚点的纬度
// "img": null//聚点的图片
// */
@property (assign, nonatomic) int ID;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) double lat;
@property (assign, nonatomic) double lng;
@property (copy, nonatomic) NSString *geohash;
@property (copy, nonatomic) NSString *district;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSDate *addtime;
@property (copy, nonatomic) NSDate *modtime;


/*
@property (assign, nonatomic) double distance;
@property (copy, nonatomic) NSString *cityregion;

@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *description;

@property (copy, nonatomic) NSString *img;*/

-(Judian *)initWithDic:(NSDictionary *)dic;
+(NSMutableArray *)arrayWithArrayDic:(NSArray *)array;
@end
