//
//  CarD.m
//  GaoDeMap
//
//  Created by cty on 14-2-17.
//  Copyright (c) 2014年 cty. All rights reserved.
//

#import "CarD.h"

@implementation CarD

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.name = [dic valueForKey:@"name"];
        self.aliasname = [dic valueForKey:@"aliasname"];
        self.icon = [dic valueForKey:@"icon"];
    }
    return self;
}
+ (NSArray *)initWithArray:(NSArray *)array;
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for(int i = 0; i < [array count]; i++)
    {
        NSDictionary * dic = [array objectAtIndex:i];
        CarD * car = [[CarD alloc]initWithDic:dic];
        [resultArray addObject:car];
    }
    return resultArray;
}
@end
