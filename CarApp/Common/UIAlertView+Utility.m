//
//  UIAlertView+Utility.m
//  PRJ_HQHD_BTN
//
//  Created by MacPro-Mr.Lu on 13-11-5.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import "UIAlertView+Utility.h"

@implementation UIAlertView (Utility)
+(void)showAlertViewWithTitle:(NSString *)title tag:(int)tag cancelTitle:(NSString *)btnTitle ensureTitle:(NSString *)ensureTitle delegate:(id<UIAlertViewDelegate>)delegate
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:title message:nil delegate:delegate cancelButtonTitle:btnTitle otherButtonTitles:ensureTitle,nil];
    alertView.tag = tag;
    [alertView show];
}

+(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)btnTitle
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:btnTitle otherButtonTitles:nil];
    [alertView show];
}
@end
