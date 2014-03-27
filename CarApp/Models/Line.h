//
//  Line.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-27.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line : NSObject

//{
//    "id": 1,//线路ID
//    "judianid": 1,//聚点ID
//    "cityregion": "厦门思明区",
//    "name": "卧龙-软件园",
//    "startlongitude": 118.14774,
//    "startlatitude": 24.483591,
//    "stoplongitude": 118.187889,
//    "stoplatitude": 24.490472,
//    "startaddr": "卧龙晓城",
//    "wayaddr": "东方山庄,瑞景商业广场,国贸新城",
//    "stopaddr": "软件园二期",
//    "img": null,
//    "description": "线路描述"
//}

@property (assign, nonatomic) int ID;
@property (assign, nonatomic) int jidianid;
@property (assign, nonatomic) double distance;
@property (assign, nonatomic) double startlongitude;
@property (assign, nonatomic) double startlatitude;
@property (assign, nonatomic) double stoplongitude;
@property (assign, nonatomic) double stoplatitude;

@property (copy, nonatomic) NSString *cityregion;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *description;
@property (copy, nonatomic) NSString *startaddr;
@property (copy, nonatomic) NSString *wayaddr;
@property (copy, nonatomic) NSString *stopaddr;
@property (copy, nonatomic) NSString *img;

-(Line *)initWithDic:(NSDictionary *)dic;
+(NSArray *)arrayWithArrayDic:(NSArray *)array;
@end
