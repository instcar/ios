//
//  MainRouteTableCell.m
//  CarApp
//
//  Created by 海龙 李 on 13-11-18.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "MainRouteTableCell.h"

@implementation MainRouteTableCell

@synthesize backButton = _backButton;
@synthesize backImgView = _backImgView;
@synthesize routeTitleLabel = _routeTitleLabel;
@synthesize routeInfoLabel = _routeInfoLabel;
@synthesize routeTimeLabel = _routeTimeLabel;
@synthesize routeAccessImgView = _routeAccessImgView;
@synthesize commentBtn = _commentBtn;

-(void)dealloc
{

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setClipsToBounds:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        
        UIImage * white = [UIImage imageNamed:@"whitePoint"];
        white = [white stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        
        UIImage * gray = [UIImage imageNamed:@"GrayPoint"];
        gray = [gray stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(10, 0, 300, 60)];
        [backButton setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
        [backButton setBackgroundColor:[UIColor whiteColor]];
        [backButton setBackgroundImage:white forState:UIControlStateNormal];
        [backButton setBackgroundImage:gray forState:UIControlStateHighlighted];
        [backButton.layer setCornerRadius:2];
        [backButton.layer setBorderWidth:0.5];
        [backButton.layer setMasksToBounds:YES];
        [backButton.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [backButton setOpaque:YES];
        [self.contentView addSubview:backButton];
        [self setBackButton:backButton];
//
//        self.backImgView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 60)]autorelease];
//        [self.backImgView setBackgroundColor:[UIColor redColor]];
//        [self.contentView addSubview:self.backImgView];
        
        UILabel *routeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 155, 40)];
        [routeTitleLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [routeTitleLabel setBackgroundColor:[UIColor clearColor]];
        [routeTitleLabel setTextAlignment:NSTextAlignmentLeft];
        [routeTitleLabel setTextColor:[UIColor appBlackColor]];
        [routeTitleLabel setFont:[UIFont fontWithName:kFangZhengFont size:16]];
        [routeTitleLabel setOpaque:YES];
        [self.contentView addSubview:routeTitleLabel];
        [self setRouteTitleLabel:routeTitleLabel];

        UILabel *routeInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 155, 30)];
        [routeInfoLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [routeInfoLabel setBackgroundColor:[UIColor clearColor]];
        [routeInfoLabel setTextAlignment:NSTextAlignmentLeft];
        [routeInfoLabel setTextColor:[UIColor textGrayColor]];
        [routeInfoLabel setFont:[UIFont fontWithName:kFangZhengFont size:10]];
        [routeInfoLabel setOpaque:YES];
        [self.contentView addSubview:routeInfoLabel];
        [self setRouteInfoLabel:routeInfoLabel];
        
        UILabel *routeTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(195, 15, 100, 30)];
        [routeTimeLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [routeTimeLabel setBackgroundColor:[UIColor clearColor]];
        [routeTimeLabel setTextAlignment:NSTextAlignmentCenter];
        [routeTimeLabel setTextColor:[UIColor appNavTitleGreenColor]];
        [routeTimeLabel setFont:[UIFont fontWithName:kFangZhengFont size:20]];
        [routeTimeLabel setHidden:YES];
        [routeTimeLabel setOpaque:YES];
        [self.contentView addSubview:routeTimeLabel];
        [self setRouteTimeLabel:routeTimeLabel];

        UIImageView *routeAccessImgView = [[UIImageView alloc]initWithFrame:CGRectMake(285,22.5,15,15)];
        [routeAccessImgView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [routeAccessImgView setBackgroundColor:[UIColor clearColor]];
        [routeAccessImgView setImage:[UIImage imageNamed:@"ic_next@2x"]];
        [routeAccessImgView setOpaque:YES];
        [self.contentView addSubview:routeAccessImgView];
        [self setRouteAccessImgView:routeAccessImgView];

        UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commentBtn setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [commentBtn setFrame:CGRectMake(215, 13, 65, 34)];
        [commentBtn setBackgroundColor:[UIColor clearColor]];
        [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [commentBtn setBackgroundImage:[UIImage imageNamed:@"btn_evaluate_normal@2x"] forState:UIControlStateNormal];
        [commentBtn setBackgroundImage:[UIImage imageNamed:@"btn_evaluate_pressed@2x"] forState:UIControlStateHighlighted];
        [commentBtn setBackgroundImage:[UIImage imageNamed:@"btn_evaluate_none@2x"] forState:UIControlStateDisabled];
        [commentBtn  setHidden:YES];
        [commentBtn setOpaque:YES];
        [self.contentView addSubview:commentBtn];
        [self setCommentBtn:commentBtn];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, 59.5, 280, 0.5)];
        [lineView setBackgroundColor:[UIColor appLineDarkGrayColor]];
        [lineView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
        [self.contentView addSubview:lineView];
        [lineView setOpaque:YES];
        [lineView setHidden:NO];
        [self setLineView:lineView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
