//
//  Message.m
//  WPWProject
//
//  Created by Mr.Lu on 13-7-1.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import "CommonMessage.h"

@implementation CommonMessage
- (id)init
{
    self = [super init];
    if (self)
    {
        self.date = [NSDate dateWithTimeIntervalSinceNow:0];//默认时间为当前
        self.type = 1; //默认为 接受
        
//        self.state = 1; //默认为 未读

        
//        CLLocationCoordinate2D lastcoord = CLLocationCoordinate2DMake(0.0, 0.0);
//        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"location"]) {
//            float lng = [[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]valueForKey:@"lng"]floatValue];
//            float lat = [[[[NSUserDefaults standardUserDefaults]objectForKey:@"location"]valueForKey:@"lat"]floatValue];
//            lastcoord = CLLocationCoordinate2DMake(lat, lng);;
//        }
//        self.loginLocate = lastcoord;

    }
    return self;
}

@end
