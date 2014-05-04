//
//  UIColor+utils.m
//  Btn_HQHD_2.0
//
//  Created by MacPro-Mr.Lu on 14-3-20.
//  Copyright (c) 2014年 XMGD_Mr.Lu. All rights reserved.
//

#import "UIColor+utils.h"

@implementation UIColor (utils)

+ (UIColor *)colorHelpWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
	return [self colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

+ (UIColor *)colorWithHexStr:(long)hexStr alpha:(CGFloat)alpha
{
	return [UIColor colorWithRed:((float)((hexStr & 0xFF0000) >> 16)) / 255.0 \
                         green		:((float)((hexStr & 0xFF00) >> 8)) / 255.0	  \
                          blue		:((float)(hexStr & 0xFF)) / 255.0			  \
                         alpha		:alpha];
    
}

@end
