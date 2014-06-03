//
//  LinePoint.m
//  CarApp
//
//  Created by Mac_ZL on 14-6-1.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "LinePoint.h"
#import "Judian.h"
@implementation LinePoint
-(LinePoint *)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.ID = [[dic valueForKey:@"id"] intValue];
        self.line_id = [[dic valueForKey:@"line_id"] intValue];
        self.point_id = [[dic valueForKey:@"point_id"] intValue];
        self.pre_point_id = [[dic valueForKey:@"pre_point_id"] intValue];
        self.post_point_id = [[dic valueForKey:@"post_point_id"] intValue];
        self.distance = [[dic valueForKey:@"distance"] intValue];
        self.starttime = [dic valueForKey:@"starttime"];
        self.price = [[dic valueForKey:@"distance"] floatValue];
        self.addtime = [dic valueForKey:@"addtime"];
        self.modtime = [dic valueForKey:@"modtime"];
        self.geo = [[Judian alloc] initWithDic:[dic valueForKey:@"geo"]];
    }
    return self;
}

+(NSArray *)arrayWithArrayDic:(NSArray *)array
{
    NSMutableArray * mutableArray = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in array) {
        LinePoint *point = [[LinePoint alloc]initWithDic:dic];
        [mutableArray addObject:point];
    }
    return mutableArray;
}
- (id)copyWithZone:(NSZone *)zone
{
    LinePoint *result = [[[self class] allocWithZone:zone] init];
    
    result.geo = [self.geo copy];
    
    return result;
}
@end
