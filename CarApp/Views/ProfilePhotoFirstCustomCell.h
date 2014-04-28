//
//  ProfilePhotoFirstCustomCell.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-8.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "People.h"

@interface ProfilePhotoFirstCustomCell : UITableViewCell
{
    UILabel *_alisLableView;
    UIButton *_phoneButtonView;
}

@property (retain, nonatomic) UIImageView *photoImgView;
@property (retain, nonatomic) UIImageView *userSingleInfoImageView;
@property (retain, nonatomic) People *data;

//数据暂时不做处理
@property (retain, nonatomic) UILabel *scoreLabel;
@property (retain, nonatomic) UILabel *goodLabel;
@property (retain, nonatomic) UILabel *mediumLabel;
@property (retain, nonatomic) UILabel *poorLable;
@property (retain, nonatomic) UIImageView *detailInfoImageView;
@property (retain, nonatomic) UIProgressView *goodProgressView;
@property (retain, nonatomic) UIProgressView *mediumProgressView;
@property (retain, nonatomic) UIProgressView *poorProgressView;



@end
