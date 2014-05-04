//
//  CarType.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-5-1.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CarType.h"

@implementation CarType

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.ID = [[dic valueForKey:@"id"]intValue];
        self.picture = [dic valueForKey:@"picture"];
        self.name = [dic valueForKey:@"name"];
        self.brand = [dic valueForKey:@"brand"];
        self.parent_brand = [dic valueForKey:@"parent_brand"];
        self.series = [dic valueForKey:@"series"];
    }
    return self;
}
+ (NSArray *)initWithArray:(NSArray *)array;
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for(int i = 0; i < [array count]; i++)
    {
        NSDictionary * dic = [array objectAtIndex:i];
        CarType * car = [[CarType alloc]initWithDic:dic];
        [resultArray addObject:car];
    }
    return resultArray;
}

@end
