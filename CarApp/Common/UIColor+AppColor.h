//
//  UIColor+AppColor.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-10-24.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ColorRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];

typedef enum {
    kTimerColorDep0 = 0,
    kTimerColorDep1 = 1,
    kTimerColorDep2 = 2,
    kTimerColorDep3 = 3
}kTimerColorDep;

@interface UIColor (AppColor)
+ (UIColor *)placeHoldColor;
+ (UIColor *)appBackgroundColor;
+(UIColor *)appNavTitleColor;
+(UIColor *)appNavTitleGreenColor;
+(UIColor *)appNavTitleBlueColor;
+ (UIColor *)appBlackColor;
//+ (UIColor *)appGreenColor;
+ (UIColor *)appLightGrayColor;
+ (UIColor *)appDarkGrayColor;
+ (UIColor *)textGrayColor;
+ (UIColor *)textGreenColor;
+(UIColor *)appLineDarkGrayColor;

+(UIColor *)appTimerColor:(kTimerColorDep)dep;
@end
