//
//  SetProfileHeadTableCell.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-6.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "SetProfileHeadTableCell.h"

@implementation SetProfileHeadTableCell


-(void)dealloc
{
    [SafetyRelease release:_photoImgView];
    [SafetyRelease release:_titleLabel];
    [SafetyRelease release:_nameLabel];
    [SafetyRelease release:_sexLabel];
    [SafetyRelease release:_ageLable];
    [SafetyRelease release:_realAuthImageView];
    [SafetyRelease release:_weiboImageView];
    [SafetyRelease release:_emailImageView];
    [SafetyRelease release:_carImageView];
    [SafetyRelease release:_arrowImgView];

    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(9, 9, 92, 92)];
        [photoImgView setBackgroundColor:[UIColor clearColor]];
        [photoImgView setHidden:YES];
        [photoImgView setOpaque:YES];
        [self.contentView addSubview:photoImgView];
        [self setPhotoImgView:photoImgView];
        [photoImgView release];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 9 + 92/2 - 15.0, 200, 30)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setFont:[UIFont fontWithName:@"FZY3JW--GB1-0" size:16]];
        [titleLabel setHidden:YES];
        [titleLabel setOpaque:YES];
        [self.contentView addSubview:titleLabel];
        [self setTitleLabel:titleLabel];
        [titleLabel release];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 10, 150, 30)];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:[UIColor blackColor]];
        [nameLabel setFont:[UIFont fontWithName:@"FZY3JW--GB1-0" size:14]];
        [nameLabel setHidden:YES];
        [nameLabel setOpaque:YES];
        [self.contentView addSubview:nameLabel];
        [self setNameLabel:nameLabel];
        [nameLabel release];
        
        UILabel *sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 40, 50, 30)];
        [sexLabel setBackgroundColor:[UIColor clearColor]];
        [sexLabel setTextAlignment:NSTextAlignmentLeft];
        [sexLabel setTextColor:[UIColor blackColor]];
        [sexLabel setFont:[UIFont fontWithName:@"FZY3JW--GB1-0" size:14]];
        [sexLabel setHidden:YES];
        [sexLabel setOpaque:YES];
        [self.contentView addSubview:sexLabel];
        [self setSexLabel:sexLabel];
        [sexLabel release];
        
        UILabel *ageLable = [[UILabel alloc]initWithFrame:CGRectMake(155, 40, 50, 30)];
        [ageLable setBackgroundColor:[UIColor clearColor]];
        [ageLable setTextAlignment:NSTextAlignmentLeft];
        [ageLable setTextColor:[UIColor blackColor]];
        [ageLable setFont:[UIFont fontWithName:@"FZY3JW--GB1-0" size:14]];
        [ageLable setHidden:YES];
        [ageLable setOpaque:YES];
        [self.contentView addSubview:ageLable];
        [ageLable release];
        
        UIImageView *realAuthImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+115, 70, 30, 30)];
        [realAuthImageView setImage:[UIImage imageNamed:@"tag_shiming@2x"]];
        [realAuthImageView setHidden:YES];
        [realAuthImageView setOpaque:YES];
        [self.contentView addSubview:realAuthImageView];
        [self setRealAuthImageView:realAuthImageView];
        [realAuthImageView release];
        
        UIImageView *weiboImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40+115, 70, 30, 30)];
        [weiboImageView setImage:[UIImage imageNamed:@"tag_sina@2x"]];
        [weiboImageView setHidden:YES];
        [weiboImageView setOpaque:YES];
        [self.contentView addSubview:weiboImageView];
        [self setWeiboImageView:weiboImageView];
        [weiboImageView release];
        
        UIImageView *emailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(70+115, 70, 30, 30)];
        [emailImageView setImage:[UIImage imageNamed:@"tag_mail@2x"]];
        [emailImageView setHidden:YES];
        [emailImageView setOpaque:YES];
        [self.contentView addSubview:emailImageView];
        [self setEmailImageView:emailImageView];
        [emailImageView release];
        
        UIImageView *carImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100+115, 70, 30, 30)];
        [carImageView setImage:[UIImage imageNamed:@"tag_car@2x"]];
        [carImageView setHidden:YES];
        [carImageView setOpaque:YES];
        [self.contentView addSubview:carImageView];
        [self setCarImageView:carImageView];
        [carImageView release];
        
        UIImageView *arrowImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 19, 12, 12)];
        [arrowImgView  setImage:[UIImage imageNamed:@"ic_start_ture@2x"]];
        [arrowImgView  setHidden:YES];
        [arrowImgView  setOpaque:YES];
        [self.contentView addSubview:arrowImgView ];
        [self setArrowImgView:arrowImgView];
        [arrowImgView release];
    }
    
    return self;
}

-(void)prepareForReuse
{
    [self.photoImgView setHidden:YES];
    [self.titleLabel setHidden:YES];
    [self.nameLabel setHidden:YES];
    [self.sexLabel setHidden:YES];
    [self.ageLable setHidden:YES];
    [self.realAuthImageView setHidden:YES];
    [self.weiboImageView setHidden:YES];
    [self.emailImageView setHidden:YES];
    [self.carImageView setHidden:YES];
    [self.arrowImgView setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
