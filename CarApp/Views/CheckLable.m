//
//  CheckLable.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-4.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CheckLable.h"

@interface CheckLable()

@property (retain, nonatomic) UIImageView *icon;
@property (retain, nonatomic) UILabel *lable;

@end

@implementation CheckLable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _checkState = false;
        
        self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
        [self.icon setImage:[UIImage imageNamed:@"ic_start_empty@2x"]];
        [self addSubview:self.icon];
        
        self.lable = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, 35, 12)];
        [self.lable setText:@"未验证"];
        [self.lable setTextColor:[UIColor lightGrayColor]];
        [self.lable setFont:[UIFont fontWithName:kFangZhengFont size:10]];
        [self.lable setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.lable];
    
    }
    return self;
}


-(void)setCheckState:(BOOL)checkState
{
    if (checkState) {
        _checkState = checkState;
    }
    
    [self reloadView];
}

- (void)reloadView
{
    if (self.checkState) {
        [self.icon setImage:[UIImage imageNamed:@"ic_start_ture@2x"]];
        [self.lable setText:@"已验证"];
    }
    else
    {
        [self.icon setImage:[UIImage imageNamed:@"ic_start_empty@2x"]];
        [self.lable setText:@"未验证"];
    }
}

@end
