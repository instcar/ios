//
//  ProfileSecondCustomCell.h
//  SWTableViewCell
//
//  Created by Leno on 13-10-12.
//  Copyright (c) 2013年 Chris Wendel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileSecondCustomCell : UITableViewCell

@property(strong,nonatomic)UIView * cellBackGroundView;
@property(strong,nonatomic)UIButton * cellBackGroundBtn;

@property(strong,nonatomic)UIImageView * phoneImgView ;
@property(strong,nonatomic)UILabel * phoneLabel;

@property(strong,nonatomic)UILabel * smallLabel;
@property(strong,nonatomic)UIView *lineView;


@property(strong,nonatomic)UIImageView * verifyFirstIcon;
@property(strong,nonatomic)UIImageView * verifySecondIcon;
@property(strong,nonatomic)UIImageView * verifyThidIcon;
@property(strong,nonatomic)UIImageView * verifyFourthIcon;
@property(strong,nonatomic)UIImageView * verifyFifthIcon;




@end
