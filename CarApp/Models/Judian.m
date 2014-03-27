//
//  Judian.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-27.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "Judian.h"

@implementation Judian

-(Judian *)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.ID = [[dic valueForKey:@"id"]intValue];
        self.name = [AppUtility getStrByNil:[dic valueForKey:@"name"]];
        self.cityregion = [AppUtility getStrByNil:[dic valueForKey:@"cityregion"]];
        self.address = [AppUtility getStrByNil:[dic valueForKey:@"address"]];
        self.description = [AppUtility getStrByNil:[dic valueForKey:@"description"]];
        self.img = [AppUtility getStrByNil:[dic valueForKey:@"img"]];
        self.distance = [[dic valueForKey:@"distance"]doubleValue];
        self.longitude = [[dic valueForKey:@"longitude"]doubleValue];
        self.latitude = [[dic valueForKey:@"latitude"]doubleValue];
    }
    return self;
}

+(NSArray *)arrayWithArrayDic:(NSArray *)array
{
    NSMutableArray * mutableArray = [[[NSMutableArray alloc]init]autorelease];
    for (NSDictionary * dic in array) {
        Judian *judian = [[Judian alloc]initWithDic:dic];
        [mutableArray addObject:judian];
        [judian release];
    }
    return mutableArray;
}

@end
