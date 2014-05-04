//
//  CarInfoTableViewCell.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-10.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CarInfoTableViewCell.h"
#import "UIButton+WebCache.h"

@implementation CarInfoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    CGRect bound = self.bounds;
    [self.contentView setClipsToBounds:YES];
    
    _bg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, bound.size.width - 10, bound.size.height - 10)]; //线框背景
    [_bg setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin];
    [_bg.layer setCornerRadius:2.0];
    [_bg.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_bg.layer setBorderWidth:0.5];
    [self.contentView addSubview:_bg];
    
    _carLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (80-53)/2.0, 53.0, 53.0)]; //车辆标志
    [_carLogoImageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin];
    [self.contentView addSubview:_carLogoImageView];
    
    _carName = [[UILabel alloc]initWithFrame:CGRectMake(75, 20, 100, 20)]; //车辆名字
    [_carName setBackgroundColor:[UIColor clearColor]];
    [_carName setTextColor:[UIColor lightGrayColor]];
    [_carName setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [self.contentView addSubview:_carName];
    
    _carModel = [[UILabel alloc]initWithFrame:CGRectMake(75, 40, 100, 20)]; //车辆型号
    [_carModel setBackgroundColor:[UIColor clearColor]];
    [_carModel setTextColor:[UIColor blackColor]];
    [_carModel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [self.contentView addSubview:_carModel];
    
    _carImageView1 = [UIButton buttonWithType:UIButtonTypeCustom]; //车辆照片1
    [_carImageView1 setFrame:CGRectMake(bound.size.width - 100, (bound.size.height-50)/2.0, 80.0, 50.0)];
    [_carImageView1 setImage:[UIImage imageNamed:kDefaultSHoldPlaceImage] forState:UIControlStateNormal];
    [_carImageView1 setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin];
    [_carImageView1 setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:_carImageView1];
    
    _carImageView2 = [UIButton buttonWithType:UIButtonTypeCustom]; //车辆照片2
    [_carImageView2 setFrame:CGRectMake(bound.size.width - 190, (bound.size.height-50)/2.0, 80.0, 50.0)];
    [_carImageView2 setImage:[UIImage imageNamed:kDefaultSHoldPlaceImage] forState:UIControlStateNormal];
    [_carImageView2 setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin];
    [_carImageView2 setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:_carImageView2];
    
    _checkState = [[UIImageView alloc]initWithFrame:CGRectMake(bound.size.width - 155, (bound.size.height-62)/2.0, 100, 62)]; //车辆照片2
    [_checkState setImage:[UIImage imageNamed:@"ic_examining"]];
    [_checkState setHidden:YES];
    [self.contentView addSubview:_checkState];
    
    _checkLable = [[UILabel alloc]initWithFrame:CGRectMake(bound.size.width - 170, (80-50)/2.0, 150.0, 50.0)];
    [_checkLable setFont:AppFont(13)];
    [_checkLable setTextAlignment:NSTextAlignmentLeft];
    [_checkLable setTextColor:[UIColor redColor]];
    [_checkLable setNumberOfLines:2];
    [_checkLable setLineBreakMode:NSLineBreakByWordWrapping];
    [_checkLable setHidden:YES];
    [_checkLable setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [self.contentView addSubview:_checkLable];
    
    _modifyView = [[UIView alloc]initWithFrame:CGRectMake(10, 75, 300, 44)];
    [_modifyView setHidden:YES];
    [self.contentView addSubview:_modifyView];
    
    UIButton * reConfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reConfirmBtn setFrame:CGRectMake(10, 0, 135, 44)];
    [reConfirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_resubmit_car_normal"] forState:UIControlStateNormal];
    [reConfirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_resubmit_car_pressed"] forState:UIControlStateHighlighted];
    [reConfirmBtn.titleLabel setFont:AppFont(14)];
    [reConfirmBtn setTitle:@"重新提交认证" forState:UIControlStateNormal];
    [reConfirmBtn addTarget:self action:@selector(reConfirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_modifyView addSubview:reConfirmBtn];
    
    UIButton * cancleConfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleConfirmBtn setFrame:CGRectMake(155, 0, 135, 44)];
    [cancleConfirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_cancel_car_normal"] forState:UIControlStateNormal];
    [cancleConfirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_cancel_car_pressed"] forState:UIControlStateHighlighted];
    [cancleConfirmBtn.titleLabel setFont:AppFont(14)];
    [cancleConfirmBtn setTitle:@"取消车辆认证" forState:UIControlStateNormal];
    [cancleConfirmBtn addTarget:self action:@selector(cancleConfirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_modifyView addSubview:cancleConfirmBtn];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCarData:(Car *)carData
{
    if (carData) {
        _carData = carData;
    }
    [self loadData];
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bound = self.bounds;
    [_bg setFrame:CGRectMake(5, 5, bound.size.width - 10, bound.size.height - 10)]; //线框背景
    [_carLogoImageView setFrame:CGRectMake(15, (80-50)/2.0, 50, 50.0)]; //车辆标志
    [_carName setFrame:CGRectMake(75, 20, 80, 20)]; //车辆名字
    [_carModel setFrame:CGRectMake(75, 40, 80, 20)]; //车辆型号
    
    [_carImageView1 setFrame:CGRectMake(bound.size.width - 90, (80-50)/2.0, 80.0, 50.0)]; //车辆照片1
    
    [_carImageView2 setFrame:CGRectMake(bound.size.width - 180, (80-50)/2.0, 80.0, 50.0)]; //车辆照片2
    
    [_checkState setFrame:CGRectMake(bound.size.width - 155, (80-62)/2.0, 100, 62)];
    [_checkLable setFrame:CGRectMake(bound.size.width - 170, (80-50)/2.0, 150.0, 50.0)];
}

- (void)loadData
{
    [_carLogoImageView setImageWithURL:[NSURL URLWithString:_carData.picture] placeholderImage:[UIImage imageNamed:@"delt_pic_s"]];
    [_carName setText:_carData.name];
    [_carModel setText:_carData.license]; //系列
    DLog(@"carinfo:%@",_carData.info);
    if ([[_carData.info valueForKey:@"cars"] count] > 0) {
        [_carImageView1 setImageWithURL:[NSURL URLWithString:[(NSArray *)[_carData.info valueForKey:@"cars"] objectAtIndex:0]] forState:UIControlStateNormal  placeholderImage:[UIImage imageNamed:@"delt_pic_s"]];
        if ([[_carData.info valueForKey:@"cars"] count] > 1) {
            [_carImageView2 setImageWithURL:[NSURL URLWithString:[(NSArray *)[_carData.info valueForKey:@"cars"] objectAtIndex:1]] forState:UIControlStateNormal  placeholderImage:[UIImage imageNamed:@"delt_pic_s"]];
        }
    }
    else
    {
        DLog(@"暂无车照");
    }
    
    
    [self setType:_carData.status];
}

- (void)reConfirmBtnAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reConfirmBtnAction:)]) {
        [self.delegate reConfirmBtnAction:self];
    }
}

- (void)cancleConfirmBtnAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancleConfirmBtnAction:)]) {
        [self.delegate cancleConfirmBtnAction:self];
    }
}

- (void)setType:(int)type
{
    [_checkState setHidden:YES];
    [_modifyView setHidden:YES];
    [_carImageView1 setHidden:NO];
    [_carImageView2 setHidden:NO];
    [_checkLable setHidden:YES];
    switch (_carData.status) {
        case 0: //完成
        {
            [_checkState setImage:[UIImage imageNamed:nil]];
        }
            break;
        case 1: //审核中
        {
            [_checkState setHidden:NO];
            [_checkState setImage:[UIImage imageNamed:@"ic_examining"]];
        }
            break;
        case 2: //拒绝
        {
            [_carImageView1 setHidden:YES];
            [_carImageView2 setHidden:YES];
            [_modifyView setHidden:NO];
            [_checkLable setHidden:NO];
            [_checkState setImage:[UIImage imageNamed:nil]];
            [_checkLable setText:@"对不起，同一个车牌不能通过两次审核"]; //系统返回错误信息
        }
            break;
        default:
            break;
    }

}

@end
