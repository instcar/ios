//
//  NSDictionary+Utility.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-29.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "NSDictionary+Utility.h"

@implementation NSDictionary (Utility)
-(NSString *)configurationDicDefaultValue:(NSString *)value withKey:(NSString *)key
{
    NSString *valueStr = [self valueForKey:key] == nil?value:[self valueForKey:key];
    return valueStr;
}

-(int)configurationDicDefaultNumValue:(int)numvalue withKey:(NSString *)key
{
    int valueNum = [[self valueForKey:key] intValue]?[[self valueForKey:key] intValue]:numvalue;
    return valueNum;
}

-(BOOL)configurationDicDefaultBoolValue:(BOOL)boolvalue withKey:(NSString *)key
{
    BOOL valueNum = [[self valueForKey:key] boolValue]?[[self valueForKey:key] boolValue]:boolvalue;
    return valueNum;
}
@end
