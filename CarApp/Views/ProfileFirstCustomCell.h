//
//  CustomCell.h
//  SWTableViewCell
//
//  Created by Leno on 13-10-12.
//  Copyright (c) 2013年 Chris Wendel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileFirstCustomCel : UITableViewCell

@property(retain, nonatomic)UIView * cellBackGroundView;
@property(retain, nonatomic)UIButton * cellFirstBtn;
@property(retain, nonatomic)UIButton * cellSecondBtn;
@property(retain, nonatomic)UIButton * cellThirdBtn;
@property(retain, nonatomic)UIButton * cellFourthBtn;

@property(retain, nonatomic)UILabel * successNumberFirstLabel;
@property(retain, nonatomic)UILabel * successNumberSecondLabel;
@property(retain, nonatomic)UILabel * successNumberThirdLabel;

@property(retain, nonatomic)UILabel * cancelNumberFirstLabel;
@property(retain, nonatomic)UILabel * cancelNumberSecondLabel;
@property(retain, nonatomic)UILabel * cancelNumberThirdLabel;

@property(retain, nonatomic)UILabel * percentNumberFirstLabel;
@property(retain, nonatomic)UILabel * percentNumberSecondLabel;
@property(retain, nonatomic)UILabel * percentNumberThirdLabel;

@property(retain, nonatomic)UILabel * carTypeFirstLabel;
@property(retain, nonatomic)UILabel * carTypeSecondLabel;

@end
