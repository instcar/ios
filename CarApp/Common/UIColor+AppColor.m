//
//  UIColor+AppColor.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-10-24.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "UIColor+AppColor.h"

@implementation UIColor (AppColor)

+(UIColor *)placeHoldColor
{
    return [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
}

+(UIColor *)appBackgroundColor
{
    return [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
}

+(UIColor *)appNavTitleGreenColor
{
    return ColorRGB(119.0, 187.0, 68.0);
}

+(UIColor *)appNavTitleBlueColor
{
//    return ColorRGB(21.0, 191.0, 211.0);
    return UIColorFromRGB(0x00A7BB);
}

+(UIColor *)appNavTitleColor
{
    return UIColorFromRGB(0x333333);
}

+(UIColor *)appBlackColor
{
    return ColorRGB(50.0, 50.0, 50.0);
}

+(UIColor *)appGreenColor
{
    return ColorRGB(119., 187., 68.);
}

+(UIColor *)appLightGrayColor
{
    return ColorRGB(221., 221., 221.);
}

+(UIColor *)appDarkGrayColor
{
    return ColorRGB(85., 85., 85.);
}

+(UIColor *)appLineDarkGrayColor
{
    return ColorRGB(163.0, 179.0, 185.0);
}

+(UIColor *)textGrayColor
{
    return ColorRGB(161., 161., 161.);
}

+(UIColor *)textGreenColor
{
    return ColorRGB(126., 203., 68.);
}

+(UIColor *)appTimerColor:(kTimerColorDep)dep
{
    UIColor *color;
    switch (dep) {
        case kTimerColorDep0:
            color = UIColorFromRGB(0x367E00);
            break;
        case kTimerColorDep1:
            color = UIColorFromRGB(0x47A500);
            break;
        case kTimerColorDep2:
            color = UIColorFromRGB(0x77BB44);
            break;
        case kTimerColorDep3:
            color = UIColorFromRGB(0x94CB6E);
            break;
        default:
            break;
    }
    return color;
}

@end
