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
        self.ID = [[dic valueForKey:@"id"] intValue];
        self.openfire = [dic valueForKey:@"openfire"];
        self.user_id = [[dic valueForKey:@"user_id"] intValue];
        self.line_id = [[dic valueForKey:@"line_id"] intValue];
        self.price = [[dic valueForKey:@"price"] floatValue];
        self.status = [[dic valueForKey:@"status"] intValue];
        self.start_time = [dic valueForKey:@"start_time"];
        self.max_seat_num = [[dic valueForKey:@"max_seat_num"] intValue];
        self.booked_seat_num =[[dic valueForKey:@"booked_seat_num"] intValue];
        self.description = [dic valueForKey:@"description"];
        self.addtime = [dic valueForKey:@"addtime"];
        self.modtime = [dic valueForKey:@"addtime"];
        /*
        self.leftseatnum = [[dic valueForKey:@"leftseatnum"]intValue];
        
        self.username = [AppUtility getStrByNil:[dic valueForKey:@"username"]];
        self.headpic = [AppUtility getStrByNil:[dic valueForKey:@"headpic"]];
        self.stopaddr = [AppUtility getStrByNil:[dic valueForKey:@"stopaddr"]];  //linewithuid 参数
        self.startaddr = [AppUtility getStrByNil:[dic valueForKey:@"startaddr"]];//linewithuid 参数
        self.wayaddr = [AppUtility getStrByNil:[dic valueForKey:@"wayaddr"]];    //linewithuid 参数
        self.linename = [AppUtility getStrByNil:[dic valueForKey:@"linename"]];  //linewithuid 参数
        NSString *startingtimeStr = [AppUtility getStrByNil:[dic valueForKey:@"startingtime"]];
        NSString *publishtimeStr = [AppUtility getStrByNil:[dic valueForKey:@"publishtime"]];
    
        self.publishtime = [AppUtility dateFromStr:publishtimeStr withFormate:@"yyyy-MM-dd HH:mm:ss"];*/
    }
    return self;
}

+(NSArray *)arrayWithArrayDic:(NSArray *)array
{
    NSMutableArray * mutableArray = [[NSMutableArray alloc]init];
    [mutableArray removeAllObjects];
    for (NSDictionary * dic in array) {
        Room *room = [[Room alloc]initWithDic:dic];
        [mutableArray addObject:room];
    }
    return mutableArray;
}

@end
