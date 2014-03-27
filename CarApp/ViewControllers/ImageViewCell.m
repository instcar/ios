//
//  ImageViewCell.m
//  WPWProject
//
//  Created by You on 13-9-23.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import "ImageViewCell.h"

@implementation ImageViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        [self configeView:image];
    }
    return self;
}


-(void)configeView:(UIImage *)image
{
    CGSize size = image.size;
    if (size.width > 100)
    {
        size.height /= (size.width / 100);
        size.width = 100;
    }
    
    
    UIButton * imageBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [imageBtn setImage:image forState:UIControlStateNormal];
    imageBtn.frame = CGRectMake(0, 0, size.width, size.height);
    imageBtn.layer.cornerRadius = 5.0;
    imageBtn.layer.masksToBounds = YES;
    [imageBtn addTarget:self action:@selector(imageTapAction:)  forControlEvents:UIControlEventTouchDown];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.image = image;
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;

    imageView.userInteractionEnabled = YES;

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapAction:)];
    [imageView addGestureRecognizer:tap];
    [tap release];
    
    self.frame = imageView.frame;
    self.imageView = imageView;
    [self addSubview:imageView];
//    [self addSubview:imageBtn];
    [imageView release];
}

-(void)imageTapAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ImageViewCell:ImageViewtapAction:)]) {
        [self.delegate ImageViewCell:self ImageViewtapAction:sender];
    }
}

@end
