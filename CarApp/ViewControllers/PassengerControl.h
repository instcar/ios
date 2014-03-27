//
//  PassengerControl.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-26.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassengerControl : UIView
{
    UIButton *_addBtn;
    UIButton *_subBtn;
    UIImage *_normalImage;
    UIImage *_selectImage;
    int _allNum;
    CGSize _size;
}

@property (assign, nonatomic) int currentNum;

-(id)initWithFrame:(CGRect)frame NormalImage:(UIImage *)normalImgae SelectImage:(UIImage *)selectImage indexs:(int)indexs size:(CGSize)size;

@end
