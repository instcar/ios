//
//  CommonRoutCell.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-2.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CommonRoutCell.h"
#import "PassgerEditRouteViewController.h"
#import "EditRouteViewController.h"

@interface CommonLable()

@property (retain, nonatomic) UILabel *lable;
@property (retain, nonatomic) UILabel *startAddLable;
@property (retain, nonatomic) UILabel *desAddLable;

@end

@implementation CommonLable

-(void)dealloc
{
    [SafetyRelease release:_lable];
    [SafetyRelease release:_startAddLable];
    [SafetyRelease release:_desAddLable];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupView];
    }
    
    return self;
}

- (void)setupView
{
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 30, 10)];
    [lable setText:@"起点"];
    [lable setFont:[UIFont fontWithName:kFangZhengFont size:10]];
    [lable setTextColor:[UIColor lightGrayColor]];
    [self addSubview:lable];
    self.lable = lable;
    [lable release];
    
    UILabel *startAddLable = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 120, 16)];
    [startAddLable setText:@"大望路"];
    [startAddLable setFont:[UIFont fontWithName:kFangZhengFont size:16]];
    [startAddLable setTextColor:[UIColor appBlackColor]];
    [self addSubview:startAddLable];
    self.startAddLable = startAddLable;
    [startAddLable release];
    
    UILabel *desAddLable = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, 120, 10)];
    [desAddLable setText:@"905公交站牌旁"];
    [desAddLable setFont:[UIFont fontWithName:kFangZhengFont size:10]];
    [desAddLable setTextColor:[UIColor lightGrayColor]];
    [self addSubview:desAddLable];
    self.desAddLable = desAddLable;
    [desAddLable release];
}

@end

@implementation CommonRoutCell

-(void)dealloc
{
    [SafetyRelease release:_data];
    
    [SafetyRelease release:_mainVC];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
        [background.layer setCornerRadius:4];
        [background.layer setBorderColor:[UIColor appLightGrayColor].CGColor];
        [background.layer setBorderWidth:1.0];
        [background.layer setMasksToBounds:YES];
        [background setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:background];
        [background release];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, 160, 1)];
        [lineView setBackgroundColor:[UIColor appLightGrayColor]];
        [self.contentView addSubview:lineView];
        [lineView release];
        
        CommonLable *startCommonLable = [[CommonLable alloc]initWithFrame:CGRectMake(10, 0, 300, 50)];
        [startCommonLable setTag:1001];
        [self.contentView addSubview:startCommonLable];
        [startCommonLable release];
        
        CommonLable *disCommonLable = [[CommonLable alloc]initWithFrame:CGRectMake(10, 50, 300, 50)];
        [disCommonLable setTag:1002];
        [self.contentView addSubview:disCommonLable];
        [disCommonLable release];
        
        UIButton * driverButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [driverButton setFrame:CGRectMake(160,20, 60, 60)];
        [driverButton setBackgroundColor:[UIColor clearColor]];
        [driverButton setBackgroundImage:[UIImage imageNamed:@"btn_have_s"] forState:UIControlStateNormal];
        [driverButton addTarget:self action:@selector(driverGetRoute) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:driverButton];
        
        //乘客的选项按钮
        UIButton * passengerButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [passengerButton setFrame:CGRectMake(227.5,20, 60, 60)];
        [passengerButton setBackgroundColor:[UIColor clearColor]];
        [passengerButton addTarget:self action:@selector(enterPassenger) forControlEvents:UIControlEventTouchUpInside];
        [passengerButton setBackgroundImage:[UIImage imageNamed:@"btn_pool_s"] forState:UIControlStateNormal];;
        [self.contentView addSubview:passengerButton];
    }
    return self;
}

-(void)setData:(Line *)data
{
    if (data) {
        [_data release];
        [data retain];
        _data = data;
    }
    CommonLable *startCommonLable = (CommonLable *)[self.contentView viewWithTag:1001];
    CommonLable *disCommonLable = (CommonLable *)[self.contentView viewWithTag:1002];
    [startCommonLable.lable setText:@"起点"];
    [startCommonLable.startAddLable setText:data.startaddr];
    [startCommonLable.desAddLable setText:data.description];
    [disCommonLable.lable setText:@"终点"];
    [disCommonLable.startAddLable setText:data.stopaddr];
    [disCommonLable.desAddLable setText:@"暂无"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)driverGetRoute
{
    if (self.mainVC) {
        EditRouteViewController * editRouteVC = [[EditRouteViewController alloc]init];
        editRouteVC.line = self.data;
        [self.mainVC.navigationController pushViewController:editRouteVC animated:YES];
        [editRouteVC release];
    }
}

-(void)enterPassenger
{
    if (self.mainVC) {
        PassgerEditRouteViewController * editRouteVC = [[PassgerEditRouteViewController alloc]init];
        editRouteVC.line = self.data;
        [self.mainVC.navigationController pushViewController:editRouteVC animated:YES];
        [editRouteVC release];
    }
}

@end
