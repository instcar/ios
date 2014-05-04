//
//  CustomCell.h
//  SWTableViewCell
//
//  Created by Leno on 13-10-12.
//  Copyright (c) 2013年 Chris Wendel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileFirstCustomCel : UITableViewCell

@property(strong, nonatomic)UIView * cellBackGroundView;
@property(strong, nonatomic)UIButton * cellFirstBtn;
@property(strong, nonatomic)UIButton * cellSecondBtn;
@property(strong, nonatomic)UIButton * cellThirdBtn;
@property(strong, nonatomic)UIButton * cellFourthBtn;

@property(strong, nonatomic)UILabel * successNumberFirstLabel;
@property(strong, nonatomic)UILabel * successNumberSecondLabel;
@property(strong, nonatomic)UILabel * successNumberThirdLabel;

@property(strong, nonatomic)UILabel * cancelNumberFirstLabel;
@property(strong, nonatomic)UILabel * cancelNumberSecondLabel;
@property(strong, nonatomic)UILabel * cancelNumberThirdLabel;

@property(strong, nonatomic)UILabel * percentNumberFirstLabel;
@property(strong, nonatomic)UILabel * percentNumberSecondLabel;
@property(strong, nonatomic)UILabel * percentNumberThirdLabel;

@property(strong, nonatomic)UILabel * carTypeFirstLabel;
@property(strong, nonatomic)UILabel * carTypeSecondLabel;

@end
