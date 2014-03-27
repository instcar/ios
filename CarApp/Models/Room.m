//
//  Room.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-29.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "Room.h"

@implementation Room

-(Room *)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.ID = [[dic valueForKey:@"id"]longValue];
        if ([dic valueForKey:@"roomid"]) {
            self.ID = [[dic valueForKey:@"roomid"]longValue];
        }   //linewithuid 参数
        self.lineid = [[dic valueForKey:@"lineid"]longValue];
        self.userid = [[dic valueForKey:@"userid"]longValue];
        if ([dic valueForKey:@"roomowneruid"]) {
            self.userid = [[dic valueForKey:@"roomowneruid"]longValue];
        }   //linewithuid 参数
        self.status = [[dic valueForKey:@"status"]intValue];
        self.seatnum = [[dic valueForKey:@"seatnum"]intValue];
        self.leftseatnum = [[dic valueForKey:@"leftseatnum"]intValue];
        
        self.username = [AppUtility getStrByNil:[dic valueForKey:@"username"]];
        self.headpic = [AppUtility getStrByNil:[dic valueForKey:@"headpic"]];
        self.stopaddr = [AppUtility getStrByNil:[dic valueForKey:@"stopaddr"]];  //linewithuid 参数
        self.startaddr = [AppUtility getStrByNil:[dic valueForKey:@"startaddr"]];//linewithuid 参数
        self.wayaddr = [AppUtility getStrByNil:[dic valueForKey:@"wayaddr"]];    //linewithuid 参数
        self.linename = [AppUtility getStrByNil:[dic valueForKey:@"linename"]];  //linewithuid 参数
        NSString *startingtimeStr = [AppUtility getStrByNil:[dic valueForKey:@"startingtime"]];
        NSString *publishtimeStr = [AppUtility getStrByNil:[dic valueForKey:@"publishtime"]];
        self.startingtime = [AppUtility dateFromStr:startingtimeStr withFormate:@"yyyy-MM-dd HH:mm:ss"];
        self.publishtime = [AppUtility dateFromStr:publishtimeStr withFormate:@"yyyy-MM-dd HH:mm:ss"];
        
        self.description = [AppUtility getStrByNil:[dic valueForKey:@"description"]];
    }
    return self;
}

+(NSArray *)arrayWithArrayDic:(NSArray *)array
{
    NSMutableArray * mutableArray = [[[NSMutableArray alloc]init]autorelease];
    [mutableArray removeAllObjects];
    for (NSDictionary * dic in array) {
        Room *room = [[Room alloc]initWithDic:dic];
        [mutableArray addObject:room];
        [room release];
    }
    return mutableArray;
}

@end
