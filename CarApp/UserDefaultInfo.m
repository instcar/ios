//
//  UserDefaultInfo.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-6.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "UserDefaultInfo.h"

static UserDefaultInfo *userDefaultInfo = nil;

@implementation UserDefaultInfo

+ (UserDefaultInfo *)shareInstance
{
	@synchronized(self) {
		if (userDefaultInfo == nil) {
			userDefaultInfo = [[UserDefaultInfo alloc]init];
		}
	}
	return userDefaultInfo;
}

@end
