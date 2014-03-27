//
//  ProfileSecondCustomCell.h
//  SWTableViewCell
//
//  Created by Leno on 13-10-12.
//  Copyright (c) 2013年 Chris Wendel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileSecondCustomCell : UITableViewCell

@property(retain,nonatomic)UIView * cellBackGroundView;
@property(retain,nonatomic)UIButton * cellBackGroundBtn;

@property(retain,nonatomic)UIImageView * phoneImgView ;
@property(retain,nonatomic)UILabel * phoneLabel;

@property(retain,nonatomic)UILabel * smallLabel;
@property(retain,nonatomic)UIView *lineView;


@property(retain,nonatomic)UIImageView * verifyFirstIcon;
@property(retain,nonatomic)UIImageView * verifySecondIcon;
@property(retain,nonatomic)UIImageView * verifyThidIcon;
@property(retain,nonatomic)UIImageView * verifyFourthIcon;
@property(retain,nonatomic)UIImageView * verifyFifthIcon;




@end
