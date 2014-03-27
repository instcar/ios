//
//  ProfilePhotoFirstCustomCell.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-8.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfilePhotoFirstCustomCell : UITableViewCell

@property (retain, nonatomic) UIImageView *photoImgView;
@property (retain, nonatomic) UILabel *scoreLabel;
@property (retain, nonatomic) UILabel *goodLabel;
@property (retain, nonatomic) UILabel *mediumLabel;
@property (retain, nonatomic) UILabel *poorLable;
@property (retain, nonatomic) UIImageView *detailInfoImageView;
@property (retain, nonatomic) UIProgressView *goodProgressView;
@property (retain, nonatomic) UIProgressView *mediumProgressView;
@property (retain, nonatomic) UIProgressView *poorProgressView;

@end
