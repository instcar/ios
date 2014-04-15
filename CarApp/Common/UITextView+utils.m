//
//  UITextView+utils.m
//  Btn_HQHD_2.0
//
//  Created by MacPro-Mr.Lu on 14-3-20.
//  Copyright (c) 2014年 XMGD_Mr.Lu. All rights reserved.
//

#import "UITextView+utils.h"

#define SYSTEM_VERSION_MORE_THAN(x) ([[UIDevice currentDevice].systemVersion floatValue] >= x) //IOS版本适配
#define SYSTEM_VERSION_LESS_THAN(x) ([[UIDevice currentDevice].systemVersion floatValue] < x) //IOS版本适配

@implementation UITextView (utils)
- (float )textViewLength:(NSString *)strString withFont:(UIFont *)font{
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

- (float)textViewheight:(NSString *)strString withFont:(UIFont *)font
{
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(self.contentSize.width, CGFLOAT_MAX);
    
    float height = 0.0;
    CGSize labsize = CGSizeZero;
    
    if (SYSTEM_VERSION_LESS_THAN(7.0)) {
        labsize = [strString sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    }
    else
    {
        labsize = [strString boundingRectWithSize:CGSizeMake(self.frame.size.width,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size;
    }
    height = labsize.height + fPadding;
    return height;
}

@end
