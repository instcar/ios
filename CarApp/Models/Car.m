//
//  Car.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-28.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "Car.h"
#import "NSDictionary+IsExitKey.h"
#import "JSONKit.h"

@implementation Car

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.ID = [[dic valueForKey:@"id"]intValue];
        self.user_id = [[dic valueForKey:@"user_id"]longLongValue];
        self.license = [dic utilityValueForKey:@"license"];
        self.car_id = [[dic valueForKey:@"car_id"]intValue];
        self.info = [[dic utilityValueForKey:@"info"] objectFromJSONString];
        self.status = [[dic valueForKey:@"status"]intValue];
        self.name = [dic utilityValueForKey:@"name"];
        self.picture = [dic utilityValueForKey:@"picture"];
    }
    return self;
}

+ (NSArray *)initWithArray:(NSArray *)array
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        Car *car = [[Car alloc]initWithDic:dic];
        [resultArray addObject:car];
    }
    return resultArray;
}

@end
