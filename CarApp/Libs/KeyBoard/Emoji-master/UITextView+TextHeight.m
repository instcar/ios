//
//  UITextView+TextHeight.m
//  WPWProject
//
//  Created by MacPro-Mr.Lu on 13-10-24.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import "UITextView+TextHeight.h"

@implementation UITextView (TextHeight)

+ (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(textView.contentSize.width - fPadding, CGFLOAT_MAX);
    CGSize size = CGSizeZero;
    
	if ([[[UIDevice currentDevice] systemVersion]floatValue] < 7.0) {
		if ([[[UIDevice currentDevice] systemVersion]floatValue] < 6.0) {
			size = [strText sizeWithFont:textView.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
		} else {
			size = [strText sizeWithFont:textView.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
		}
	}
    else
    {
       size.height = [strText boundingRectWithSize:CGSizeMake(textView.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:textView.font,NSFontAttributeName, nil] context:nil].size.height;
    }
    
    float fHeight = size.height + 16.0;
    
    return fHeight;
}

@end
