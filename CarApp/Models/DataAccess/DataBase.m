//
//  DataBase.m
//  SQList Data Controller
//
//  Created by ibokan on 13-2-25.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "DataBase.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "CommonMessage.h"

static FMDatabase * db = nil;
@implementation DataBase

+(NSString *)databaseFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:@"db.sqlite"];
    return dbFilePath;
}

+(void)creatDatabase
{
    db = [[FMDatabase databaseWithPath:[self databaseFilePath]] retain];
}

+(FMDatabase *)getDataBase
{
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!db)
    {
        [self creatDatabase];
    }
    
    //为数据库设置缓存，提高查询效率
    [db setShouldCacheStatements:YES];
    
    return db;
}

@end
