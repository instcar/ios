//
//  UITextView+utils.h
//  Btn_HQHD_2.0
//
//  Created by MacPro-Mr.Lu on 14-3-20.
//  Copyright (c) 2014年 XMGD_Mr.Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (utils)

//返回长度
- (float)textViewLength:(NSString *)strString withFont:(UIFont *)font;

//返回高度
- (float)textViewheight:(NSString *)strString withFont:(UIFont *)font;

@end
