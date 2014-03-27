//
//  UITextView+TextHeight.h
//  WPWProject
//
//  Created by MacPro-Mr.Lu on 13-10-24.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (TextHeight)
+ (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText;
@end
