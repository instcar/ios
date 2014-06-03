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
        self.name = [dic valueForKey:@"name"];
        self.lat = [[dic valueForKey:@"lat"]doubleValue];
        self.lng = [[dic valueForKey:@"lng"]doubleValue];
        self.geohash = [dic valueForKey:@"geohash"];
        self.district = [dic valueForKey:@"district"];
        self.city = [dic valueForKey:@"city"];
        self.addtime = [dic valueForKey:@"addtime"];
        self.modtime = [dic valueForKey:@"modtime"];
        /*
        self.cityregion = [AppUtility getStrByNil:[dic valueForKey:@"cityregion"]];
        self.address = [AppUtility getStrByNil:[dic valueForKey:@"address"]];
        self.description = [AppUtility getStrByNil:[dic valueForKey:@"description"]];
        self.img = [AppUtility getStrByNil:[dic valueForKey:@"img"]];
        self.distance = [[dic valueForKey:@"distance"]doubleValue];*/
    }
    return self;
}

+(NSMutableArray *)arrayWithArrayDic:(NSArray *)array
{
    NSMutableArray * mutableArray = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in array) {
        Judian *judian = [[Judian alloc]initWithDic:dic];
        [mutableArray addObject:judian];
    }
    return mutableArray;
}
//实现NSCopying协议的方法，来使此类具有copy功能
-(id)copyWithZone:(NSZone *)zone
{
    Judian *_judian = [[[self class] allocWithZone:zone] init];
    
    
    return _judian;
}
@end
