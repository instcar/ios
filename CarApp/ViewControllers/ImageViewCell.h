//
//  ImageViewCell.h
//  WPWProject
//
//  Created by You on 13-9-23.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ImageViewCellDelegate;

@interface ImageViewCell : UIView

@property (retain, nonatomic)UIImage * image;
@property (retain, nonatomic)UIImageView * imageView;
@property (assign, nonatomic)id<ImageViewCellDelegate> delegate;

-(id)initWithImage:(UIImage *)image;

@end

@protocol ImageViewCellDelegate <NSObject>

-(void)ImageViewCell:(ImageViewCell *)imageViewCell ImageViewtapAction:(id)sender;

@end