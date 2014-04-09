//
//  CarInfoTableViewCell.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-10.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CarInfoTableViewCell.h"

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
    
    _carLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (bound.size.height-50)/2.0, 50.0, 50.0)]; //车辆标志
    [_carLogoImageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin];
    [self.contentView addSubview:_carLogoImageView];
    [_carLogoImageView release];
    
    _carName = [[UILabel alloc]initWithFrame:CGRectMake(70, 20, 100, 20)]; //车辆名字
    [_carName setBackgroundColor:[UIColor clearColor]];
    [_carName setTextColor:[UIColor lightGrayColor]];
    [_carName setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [self.contentView addSubview:_carName];
    [_carName release];
    
    _carModel = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, 100, 20)]; //车辆型号
    [_carModel setBackgroundColor:[UIColor clearColor]];
    [_carModel setTextColor:[UIColor blackColor]];
    [_carModel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [self.contentView addSubview:_carModel];
    [_carModel release];
    
    _carImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(bound.size.width - 100, (bound.size.height-50)/2.0, 80.0, 50.0)]; //车辆照片1
    [_carImageView1 setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin];
    [self.contentView addSubview:_carImageView1];
    [_carImageView1 release];
    
    _carImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(bound.size.width - 190, (bound.size.height-50)/2.0, 80.0, 50.0)]; //车辆照片2
    [_carImageView2 setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin];
    [self.contentView addSubview:_carImageView2];
    [_carImageView2 release];
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

}


- (void)loadData
{
    [_carLogoImageView setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"delt_pic_s"]];
    [_carName setText:@"华晨宝马"];
    [_carModel setText:@"320Li"];
    [_carImageView1 setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"delt_pic_s"]];
    [_carImageView2 setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"delt_pic_s"]];
}

@end
