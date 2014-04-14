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
    
    _bg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, bound.size.width - 10, bound.size.height - 10)]; //线框背景
    [_bg setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin];
    [_bg.layer setCornerRadius:2.0];
    [_bg.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_bg.layer setBorderWidth:0.5];
    [self.contentView addSubview:_bg];
    [_bg release];
    
    _carLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (bound.size.height-53)/2.0, 53.0, 53.0)]; //车辆标志
    [_carLogoImageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin];
    [self.contentView addSubview:_carLogoImageView];
    [_carLogoImageView release];
    
    _carName = [[UILabel alloc]initWithFrame:CGRectMake(73, 20, 100, 20)]; //车辆名字
    [_carName setBackgroundColor:[UIColor clearColor]];
    [_carName setTextColor:[UIColor lightGrayColor]];
    [_carName setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [self.contentView addSubview:_carName];
    [_carName release];
    
    _carModel = [[UILabel alloc]initWithFrame:CGRectMake(73, 40, 100, 20)]; //车辆型号
    [_carModel setBackgroundColor:[UIColor clearColor]];
    [_carModel setTextColor:[UIColor blackColor]];
    [_carModel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [self.contentView addSubview:_carModel];
    [_carModel release];
    
    _carImageView1 = [UIButton buttonWithType:UIButtonTypeCustom]; //车辆照片1
    [_carImageView1 setFrame:CGRectMake(bound.size.width - 100, (bound.size.height-50)/2.0, 80.0, 50.0)];
    [_carImageView1 setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin];
    [self.contentView addSubview:_carImageView1];
    
    _carImageView2 = [UIButton buttonWithType:UIButtonTypeCustom]; //车辆照片2
    [_carImageView2 setFrame:CGRectMake(bound.size.width - 190, (bound.size.height-50)/2.0, 80.0, 50.0)];
    [_carImageView2 setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin];
    [self.contentView addSubview:_carImageView2];
    
    _checkState = [[UIImageView alloc]initWithFrame:CGRectMake(bound.size.width - 155, (bound.size.height-62)/2.0, 100, 62)]; //车辆照片2
    [_checkState setImage:[UIImage imageNamed:@"ic_examining"]];
    [self.contentView addSubview:_checkState];
    [_checkState release];
    
    _checkLable = [[UILabel alloc]initWithFrame:CGRectMake(bound.size.width - 190, (bound.size.height-50)/2.0, 170.0, 50.0)];
    [_checkLable setFont:AppFont(13)];
    [_checkLable setTextAlignment:NSTextAlignmentLeft];
    [_checkLable setTextColor:[UIColor redColor]];
    [_checkLable setNumberOfLines:2];
    [_checkLable setLineBreakMode:NSLineBreakByWordWrapping];
    [_checkLable setHidden:YES];
    [self.contentView addSubview:_checkLable];
    [_checkLable release];
    
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

- (void)setData:(NSDictionary *)data
{
    if (data) {
        [_data release];
        _data = [data retain];
    }
    [self loadData];
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bound = self.bounds;
    [_bg setFrame:CGRectMake(5, 5, bound.size.width - 10, bound.size.height - 10)]; //线框背景
    [_carLogoImageView setFrame:CGRectMake(15, (bound.size.height-50)/2.0, 50.0, 50.0)]; //车辆标志
    [_carName setFrame:CGRectMake(70, 20, 100, 20)]; //车辆名字
    [_carModel setFrame:CGRectMake(70, 40, 100, 20)]; //车辆型号
    
    [_carImageView1 setFrame:CGRectMake(bound.size.width - 90, (bound.size.height-50)/2.0, 80.0, 50.0)]; //车辆照片1
    
    [_carImageView2 setFrame:CGRectMake(bound.size.width - 180, (bound.size.height-50)/2.0, 80.0, 50.0)]; //车辆照片2
    
    [_checkState setFrame:CGRectMake(bound.size.width - 155, (bound.size.height-62)/2.0, 100, 62)];

}

- (void)loadData
{
    [_carLogoImageView setImageWithURL:[NSURL URLWithString:@"http://instcar-user-pic-1.oss-cn-qingdao.aliyuncs.com/java.png"] placeholderImage:[UIImage imageNamed:@"delt_pic_s"]];
    [_carName setText:@"华晨宝马"];
    [_carModel setText:@"320Li"];
    [_carImageView1 setImageWithURL:[NSURL URLWithString:@"http://instcar-user-pic-1.oss-cn-qingdao.aliyuncs.com/java.png"] forState:UIControlStateNormal  placeholderImage:[UIImage imageNamed:@"delt_pic_s"]];
    [_carImageView2 setImageWithURL:[NSURL URLWithString:@"http://instcar-user-pic-1.oss-cn-qingdao.aliyuncs.com/java.png"] forState:UIControlStateNormal  placeholderImage:[UIImage imageNamed:@"delt_pic_s"]];
}

- (void)reConfirmBtnAction:(UIButton *)sender
{
    
}

- (void)cancleConfirmBtnAction:(UIButton *)sender
{
    
}

@end
