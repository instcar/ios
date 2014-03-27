//
//  NSDictionary+IsExitKey.m
//  WPWProject
//
//  Created by Mr.Lu on 13-7-20.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import "NSDictionary+IsExitKey.h"

@implementation NSDictionary (IsExitKey)

-(NSString *)utilityValueForKey:(NSString *)key
{
    return [self isExitKey:key]?[self valueForKey:key]:@"";
}

-(BOOL)isExitKey:(NSString *)key
{
    if ([[self allKeys]containsObject:key]&& ![[self valueForKey:key]isEqual:[NSNull null]])
    {
        return YES;
    }
     else
    {
        return NO;
    }
}

@end
