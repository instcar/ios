//
//  NSDictionary+IsExitKey.h
//  WPWProject
//
//  Created by Mr.Lu on 13-7-20.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (IsExitKey)

-(NSString *)utilityValueForKey:(NSString *)key;

-(BOOL)isExitKey:(NSString *)key;

@end
