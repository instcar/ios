//
//  ProfilePhotoFirstCustomCell.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-8.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "People.h"

@protocol  ProfilePhotoFirstCustomCellDelegate;
@interface ProfilePhotoFirstCustomCell : UITableViewCell
{
    UILabel *_alisLableView;
    UILabel *_sexLableView;
    UILabel *_ageLableView;
}

@property (strong, nonatomic) UIButton *photoImgView;
@property (strong, nonatomic) UIImageView *userSingleInfoImageView;
@property (strong, nonatomic) People *data;
@property (assign, nonatomic) id<ProfilePhotoFirstCustomCellDelegate>deleagte;

@property (assign, nonatomic) BOOL Editing;

//数据暂时不做处理
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UILabel *goodLabel;
@property (strong, nonatomic) UILabel *mediumLabel;
@property (strong, nonatomic) UILabel *poorLable;
@property (strong, nonatomic) UIImageView *detailInfoImageView;
@property (strong, nonatomic) UIProgressView *goodProgressView;
@property (strong, nonatomic) UIProgressView *mediumProgressView;
@property (strong, nonatomic) UIProgressView *poorProgressView;

@end

@protocol  ProfilePhotoFirstCustomCellDelegate<NSObject>

- (void)photoImgViewAction:(ProfilePhotoFirstCustomCell *)sender;

@end
