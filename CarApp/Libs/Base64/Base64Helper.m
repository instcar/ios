//
//  Base64Helper.m
//  Vote
//
//  Created by Pro Mac on 13-1-28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "Base64Helper.h"

@implementation Base64Helper


+ (NSString *) image2String:(UIImage *)image 
{
    NSData *pictureData = UIImageJPEGRepresentation(image, 0.5);
    NSString *pictureDataString = [pictureData base64Encoding];
    return pictureDataString;
}

+ (UIImage *) string2Image:(NSString *)string 
{
    UIImage *image = [UIImage imageWithData:[NSData dataWithBase64EncodedString:string]];
    return image;
}
@end
