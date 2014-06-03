//
//  LinePoint.h
//  CarApp
//
//  Created by Mac_ZL on 14-6-1.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Judian;
@interface LinePoint : NSObject<NSCopying>

@property (assign, nonatomic) int ID;
@property (assign, nonatomic) int line_id;
@property (assign, nonatomic) int point_id;
@property (assign, nonatomic) int pre_point_id;
@property (assign, nonatomic) int post_point_id;
@property (assign, nonatomic) int distance;
@property (copy, nonatomic) NSDate *starttime;
@property (assign, nonatomic) float price;
@property (copy, nonatomic) NSDate *addtime;
@property (copy, nonatomic) NSDate *modtime;
@property (strong, nonatomic) Judian *geo;

-(LinePoint *)initWithDic:(NSDictionary *)dic;
+(NSArray *)arrayWithArrayDic:(NSArray *)array;
@end
