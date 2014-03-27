//
//  SafetyRelease.m
//  CarApp
//
//  Created by Leno on 13-9-12.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "SafetyRelease.h"

@implementation SafetyRelease

+(void)release:(NSObject *)something
{
    if (something) {
        if (something.retainCount >=1) {
            [something release];
            something = nil;
        }
        else
        {
            something = nil;
        }
    }
    else
    {
        something = nil;
    }
}

@end
