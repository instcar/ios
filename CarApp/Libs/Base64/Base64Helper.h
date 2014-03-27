//
//  Base64Helper.h
//  Vote
//
//  Created by Pro Mac on 13-1-28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+base64.h"
@interface Base64Helper : NSObject
+ (NSString *) image2String:(UIImage *)image;  //图片转BASE64编码
+ (UIImage *) string2Image:(NSString *)string;  //BASE64编码转图片
@end
