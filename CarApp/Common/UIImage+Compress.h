//
//  compress.h
//  WPWProject
//
//  Created by Mr.Lu on 13-7-16.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_IMAGEPIX 1000.0 // max pix 200.0px
#define MAX_IMAGEDATA_LEN 100000.0 // max data length 300k

@interface UIImage (Compress)

//图像质量压缩
-(UIImage *)compressedImage;

-(CGFloat)compressionQuality;

-(NSData *)compressedData;

-(NSData *)compressedDataWithRate;

-(NSData *)compressedData:(CGFloat)compressionQuality;

//图像尺寸压缩
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end



