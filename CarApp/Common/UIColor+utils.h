//
//  UIColor+utils.h
//  Btn_HQHD_2.0
//
//  Created by MacPro-Mr.Lu on 14-3-20.
//  Copyright (c) 2014年 XMGD_Mr.Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (utils)

/**
 *	通过rgd值 获取颜色
 *
 *	@param	red	    red range(0.0~255.0)
 *	@param	green	green range(0.0~255.0)
 *	@param	blue	blue range(0.0~255.0)
 *	@param	alpha	alpha range(0.0~1.0)
 *
 *	@return	UIColor
 */
+ (UIColor *)colorHelpWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

/**
 *	rgb 是利用
 *
 *	@param	hexStr	000000~ffffff 十六进制的颜色
 *
 *	@return	UIColor
 */
+ (UIColor *)colorWithHexStr:(long)hexStr alpha:(CGFloat)alpha;

@end
