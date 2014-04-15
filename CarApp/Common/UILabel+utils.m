//
//  UILabel+utils.m
//  Btn_HQHD_2.0
//
//  Created by MacPro-Mr.Lu on 14-3-20.
//  Copyright (c) 2014年 XMGD_Mr.Lu. All rights reserved.
//

#import "UILabel+utils.h"

#define SYSTEM_VERSION_MORE_THAN(x) ([[UIDevice currentDevice].systemVersion floatValue] >= x) //IOS版本适配
#define SYSTEM_VERSION_LESS_THAN(x) ([[UIDevice currentDevice].systemVersion floatValue] < x) //IOS版本适配

@implementation UILabel (utils)

- (float )labelLength:(NSString *)strString withFont:(UIFont *)font{
    float width = 0.0;
    CGSize labsize = CGSizeZero;
    if (SYSTEM_VERSION_LESS_THAN(7.0)) {
        labsize = [strString sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, self.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    }
    else
    {
        labsize = [strString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size;
    }
    
    width = labsize.width;
    return width;
}

- (float)labelheight:(NSString *)strString withFont:(UIFont *)font
{
    float height = 0.0;
    CGSize labsize = CGSizeZero;
    if (SYSTEM_VERSION_LESS_THAN(7.0)) {
        labsize = [strString sizeWithFont:font constrainedToSize:CGSizeMake(self.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    }
    else
    {
        labsize = [strString boundingRectWithSize:CGSizeMake(self.frame.size.width,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size;
    }
    height = labsize.height;
    return height;
}


@end
