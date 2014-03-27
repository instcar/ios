//
//  DataBase.h
//  SQList Data Controller
//
//  Created by ibokan on 13-2-25.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import <sqlite3.h>
@interface DataBase : NSObject
+(FMDatabase *)getDataBase;

@end
