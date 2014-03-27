//
//  PeopleManager.m
//  WPWProject
//
//  Created by Mr.Lu on 13-7-26.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import "PeopleManager.h"
#import "FMDatabase.h"
#import "DataBase.h"
#import "FMDatabaseAdditions.h"

@implementation PeopleManager
+(void)creatTable
{
    FMDatabase * db = [DataBase getDataBase];
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![db open])
    {
        DLog(@"数据库打开失败");
        return;
    }
    
    //为数据库设置缓存，提高查询效率
    [db setShouldCacheStatements:YES];
    
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![db tableExists:@"PeopleCacheList"])
    {
        [db executeUpdate:@"CREATE TABLE PeopleCacheList(ID INTEGER PRIMARY KEY AUTOINCREMENT,UserID INTEGER,UserName varchar,Sex varchar,Headpic TEXT,LastCoord varchar,LastLoginTime varchar)"];
        DLog(@"数据库创建完成");
    }
}

+(BOOL)peopleExitInTableWithFid:(long)fid
{
    FMDatabase * db = [DataBase getDataBase];
	if (![db open])
    {
        DLog(@"数据库打开失败");
        return NO;
	}
    
	[db setShouldCacheStatements:YES];
    
	if(![db tableExists:@"PeopleCacheList"])
	{
        [self creatTable];
	}
    
    int ret = [db intForQuery:@"select count(*) from PeopleCacheList Where UserID = ? ",[NSNumber numberWithLong:fid]];
    return ret;
}

+(void)insertPeopleShortInfo:(People *)people
{
    FMDatabase * db = [DataBase getDataBase];
	if (![db open])
    {
        DLog(@"数据库打开失败");
        return;
	}
    
	[db setShouldCacheStatements:YES];
    
	if(![db tableExists:@"PeopleCacheList"])
	{
        [self creatTable];
	}
    
    int ret = [db intForQuery:@"select count(*) from PeopleCacheList Where UserID = ? ",[NSNumber numberWithLong:people.ID]];
    if (ret) {
        [db executeUpdate:@"UPDATE PeopleCacheList SET headpic = ?,LastCoord = ?,LastLoginTime = ?,UserID = ?,Sex = ?,UserName = ? WHERE UserID = ?",people.headpic,people.lastcoord,people.lastloginTime,[NSNumber numberWithLong:people.ID],people.sex,people.userName,[NSNumber numberWithInt:people.ID]];
    }
    else
    {
        [db executeUpdate:@"INSERT INTO PeopleCacheList (headpic ,LastCoord ,LastLoginTime,UserID,Sex,UserName)  VALUES (?,?,?,?,?,?)",people.headpic,people.lastcoord,people.lastloginTime,[NSNumber numberWithLong:people.ID],people.sex,people.userName];
    }
}

+(People *)getPeopleWithFriendID:(int)peopleID
{
    
    FMDatabase * db = [DataBase getDataBase];
	if (![db open])
    {
        DLog(@"数据库打开失败");
        return nil;
	}
    
	[db setShouldCacheStatements:YES];
    
	if(![db tableExists:@"PeopleCacheList"])
	{
        return nil;
	}
    
     FMResultSet *rs = [db executeQuery:@"select * from PeopleCacheList where UserID = ?",[NSNumber numberWithLong:peopleID]];
     People * people = [[[People alloc]init]autorelease];
    while ([rs next])
    {
        people.headpic = [[rs stringForColumn:@"Headpic"] copy];
        people.ID = [rs intForColumn:@"UserID"];
        people.userName = [[rs stringForColumn:@"UserName"] copy];
        people.lastloginTime = [rs stringForColumn:@"LastLoginTime"];
        people.lastcoord = [[rs stringForColumn:@"LastCoord"] copy];
        people.sex = [[rs stringForColumn:@"Sex"] copy];
    }
    return people;
}

+(BOOL)deletePeopleCache
{

    FMDatabase * db = [DataBase getDataBase];
    if (![db open])
    {
        DLog(@"数据库打开失败");
        return NO;
    }
    
    [db setShouldCacheStatements:YES];
    
    if(![db tableExists:@"PeopleCacheList"])
    {
        return NO;
    }
    BOOL ret;
    @try {
        //删除操作
        NSString * sql = @"delete from PeopleCacheList";
        ret = [db executeUpdate:sql];
    }
    @catch (NSException *exception)
    {
        DLog(@"%@",exception.description);
    }
    @finally
    {
//        DLog(@"delete from PeopleCacheList");
    }
    
    return ret;

}
@end
