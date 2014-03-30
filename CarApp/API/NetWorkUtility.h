//
//  MD5Methd.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-13.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkUtility : NSObject

/**
 *	实现 secretcode 的加密
 *
 *	@param	input	加密前字符串
 *
 *	@return	加密后字符串
 */
+ (NSString*)md5HexDigest:(NSString*)input;

+ (NSString *)generateSign:(NSString *)keyValueStr;

/**
 *	url 中文加密解密必须两次 解码utf8
 *
 *	@param	input	输入字符串
 *
 *	@return	返回解密字符串
 */
+ (NSString*)StringDecode:(NSString *)input;

/**
 *	url 中文加密必须一次 编码utf8
 *
 *	@param	input	输入字符串
 *
 *	@return	返回加密字符串
 */
+ (NSString*)StringEncode:(NSString *)input;


/**
 *	url 中文加密必须两次 编码utf8 计算 sign的时候用
 *
 *	@param	input	输入字符串
 *
 *	@return	返回加密字符串
 */
+ (NSString*)StringEncodeTwo:(NSString *)input;
@end
