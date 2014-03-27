//
//  UIAlertView+Utility.h
//  PRJ_HQHD_BTN
//
//  Created by MacPro-Mr.Lu on 13-11-5.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Utility)

/**
 *	显示提醒框
 *
 *	@param	title	标题
 *	@param	tag	标签
 *	@param	cancelTitle	按钮标题
  *	@param	ensureTitle	按钮标题
 *	@param	delegate	代理
 */
+(void)showAlertViewWithTitle:(NSString *)title tag:(int)tag cancelTitle:(NSString *)btnTitle ensureTitle:(NSString *)ensureTitle delegate:(id<UIAlertViewDelegate>)delegate;
/**
 *	显示提醒框
 *
 *	@param	title	标题
 *	@param	message	消息
 *	@param	cancelTitle	按钮标题
 */
+(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)btnTitle;

@end

