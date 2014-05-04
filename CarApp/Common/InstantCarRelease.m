//
//  InstantCarRelease.m
//  CarApp
//
//  Created by Leno on 13-9-27.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "InstantCarRelease.h"

@implementation InstantCarRelease

+(void)safeRelease:(id)object
{
    if (object) {
//        [object release];
        object = nil;
    }
}

@end
