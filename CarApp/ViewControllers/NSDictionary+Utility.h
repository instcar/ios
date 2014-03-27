//
//  NSDictionary+Utility.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-29.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utility)

-(int)configurationDicDefaultNumValue:(int)numvalue withKey:(NSString *)key;

-(NSString *)configurationDicDefaultValue:(NSString *)value withKey:(NSString *)key;

-(BOOL)configurationDicDefaultBoolValue:(BOOL)boolvalue withKey:(NSString *)key;

@end
