//
//  DriverRouteCell.m
//  CarApp
//
//  Created by leno on 13-10-9.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "DriverRouteCell.h"

@implementation DriverRouteCell

@synthesize roundImgView = _roundImgView;
@synthesize numberLabel = _numberLabel;
@synthesize routeLabel = _routeLabel;
@synthesize addressLabel = _addressLabel;
-(void)dealloc
{

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        [backgroundView setBackgroundColor:[UIColor whiteColor]];
        [self setBackgroundView:backgroundView];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        self.roundImgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 9, 26, 26)];
        [self.roundImgView setBackgroundColor:[UIColor clearColor]];
        self.roundImgView.layer.cornerRadius = 13;
        [self.roundImgView.layer setBorderColor:[UIColor appBlackColor].CGColor];
        [self.roundImgView.layer setBorderWidth:1.0];
        [self addSubview:self.roundImgView];
        
        self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
        [self.numberLabel setBackgroundColor:[UIColor clearColor]];
        [self.numberLabel setTextAlignment:NSTextAlignmentCenter];
        [self.numberLabel setTextColor:[UIColor appBlackColor]];
        [self.numberLabel setFont:[UIFont systemFontOfSize:13]];
        [self.roundImgView addSubview:self.numberLabel];
        
        self.routeLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 7, 270, 30)];
        [self.routeLabel setBackgroundColor:[UIColor clearColor]];
        [self.routeLabel setTextAlignment:NSTextAlignmentLeft];
        [self.routeLabel setTextColor:[UIColor colorWithRed:(float)85/255 green:(float)85/255 blue:(float)85/255 alpha:1]];
        
        [self.routeLabel setFont:[UIFont fontWithName:kFangZhengFont size:16]];
        [self addSubview:self.routeLabel];
        
        self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 30, 270, 30)];
        [self.addressLabel setBackgroundColor:[UIColor clearColor]];
        [self.addressLabel setTextAlignment:NSTextAlignmentLeft];
        [self.addressLabel setTextColor:[UIColor colorWithRed:(float)119/255 green:(float)187/255 blue:(float)68/255 alpha:1]];
        [self.addressLabel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
        [self addSubview:self.addressLabel];
        
        [self.roundImgView setHidden:YES];
        [self.numberLabel setHidden:YES];
        [self.routeLabel setHidden:YES];
        [self.addressLabel setHidden:YES];
    }
    
    return self;
}

-(void)prepareForReuse
{
    [self.roundImgView setHidden:YES];
    [self.numberLabel setHidden:YES];
    [self.routeLabel setHidden:YES];
    [self.addressLabel setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
