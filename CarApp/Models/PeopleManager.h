//
//  PeopleManager.h
//  WPWProject
//
//  Created by Mr.Lu on 13-7-26.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "People.h"
@interface PeopleManager : NSObject

+(void)creatTable;

+(BOOL)peopleExitInTableWithFid:(long)fid;

+(void)insertPeopleShortInfo:(People *)people; //插入人物信息

//+(void)deletePeopleByID:(int)ID; //删除任务信息

+(People *)getPeopleWithFriendID:(int)peopleID; //通过peopleid得到people信息

+(BOOL)deletePeopleCache; //删除用户信息

@end
