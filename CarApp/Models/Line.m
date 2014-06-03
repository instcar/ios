//
//  Line.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-27.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "Line.h"
#import "LinePoint.h"
@implementation Line

-(Line *)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.ID = [[dic valueForKey:@"id"] intValue];
        self.name = [dic valueForKey:@"name"];
        self.description = [dic valueForKey:@"description"];
        self.price = [[dic valueForKey:@"id"] floatValue];
        self.addtime = [dic valueForKey:@"addtime"];
        self.modtime = [dic valueForKey:@"modtime"];
        self.list = [LinePoint arrayWithArrayDic:[dic objectForKey:@"list"]];
        /*
        self.jidianid = [[dic valueForKey:@"jidianid"]intValue];
        self.cityregion = [AppUtility getStrByNil:[dic valueForKey:@"cityregion"]];
        self.startaddr = [AppUtility getStrByNil:[dic valueForKey:@"startaddr"]];
        self.wayaddr = [AppUtility getStrByNil:[dic valueForKey:@"wayaddr"]];
        self.stopaddr = [AppUtility getStrByNil:[dic valueForKey:@"stopaddr"]];

        self.img = [AppUtility getStrByNil:[dic valueForKey:@"img"]];
        self.distance = [[dic valueForKey:@"distance"]doubleValue];
        self.startlongitude = [[dic valueForKey:@"startlongitude"]doubleValue];
        self.startlatitude = [[dic valueForKey:@"startlatitude"]doubleValue];
        self.stoplongitude = [[dic valueForKey:@"stoplongitude"]doubleValue];
        self.stoplatitude = [[dic valueForKey:@"stoplatitude"]doubleValue];*/
    }
    return self;
}

+(NSMutableArray *)arrayWithArrayDic:(NSArray *)array
{
    NSMutableArray * mutableArray = [[NSMutableArray alloc]init];
    [mutableArray removeAllObjects];
    for (NSDictionary * dic in array) {
        Line *line = [[Line alloc]initWithDic:dic];
        [mutableArray addObject:line];
    }
    return mutableArray;
}

@end
