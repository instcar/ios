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
    return [self isExitKey:key]?(![self isNull:[self valueForKey:key]]?@"":[self valueForKey:key]):@"";
}

-(BOOL)isExitKey:(NSString *)key
{
     if ([[self allKeys]containsObject:key])
     {
        return YES;
     }
     else
     {
        return NO;
     }
}

-(BOOL)isNull:(id)object
{
    // 判断是否为空串
    if ([object isEqual:[NSNull null]]) {
        return NO;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    else if (object==nil){
        return NO;
    }
    return YES;
}

-(NSString*)convertNull:(id)object{
    // 转换空串
    if ([object isEqual:[NSNull null]]) {
        return @" ";
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return @" ";
    }
    else if (object==nil){
        return @"无";
    }
    return object;
}


@end
