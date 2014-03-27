//
//  ProfilePhotoFirstCustomCell.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-8.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "ProfilePhotoFirstCustomCell.h"

@implementation ProfilePhotoFirstCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setClipsToBounds:NO];
        [self.contentView setClipsToBounds:NO];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        self.photoImgView = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 95, 95)]autorelease];
//        [self.photoImgView.layer setShadowColor:[UIColor darkGrayColor].CGColor];
//        [self.photoImgView.layer setShadowOpacity:1.0];
//        [self.photoImgView.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.photoImgView.bounds] CGPath]];
        [self.photoImgView.layer setCornerRadius:2.0];
        [self.photoImgView.layer setMasksToBounds:YES];
        [self.photoImgView.layer setBorderWidth:0.5];
        [self.photoImgView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        
        [self.photoImgView setBackgroundColor:[UIColor whiteColor]];
        [self.photoImgView setHidden:NO];
        [self.contentView addSubview:self.photoImgView];
        
        self.detailInfoImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(110, 10, 320-115, 95)]autorelease];
        [self.detailInfoImageView setImage:[[UIImage imageNamed:nil] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        [self.detailInfoImageView.layer setCornerRadius:2.0];
        [self.detailInfoImageView.layer setMasksToBounds:YES];
        [self.detailInfoImageView.layer setBorderWidth:0.5];
        [self.detailInfoImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.detailInfoImageView setHidden:NO];
        [self.contentView addSubview:self.detailInfoImageView];
        
        UILabel *xyLable = [[[UILabel alloc]initWithFrame:CGRectMake(15, 17, 70, 15)]autorelease];
        [xyLable setBackgroundColor:[UIColor clearColor]];
        [xyLable setTextAlignment:NSTextAlignmentLeft];
        [xyLable setTextColor:[UIColor lightGrayColor]];
        [xyLable setFont:[UIFont boldSystemFontOfSize:12]];
        [xyLable setHidden:NO];
        [xyLable setText:@"信誉度"];
        [self.detailInfoImageView addSubview:xyLable];
        
        self.scoreLabel = [[[UILabel alloc]initWithFrame:CGRectMake(85, 10, 195-20, 30)]autorelease];
        [self.scoreLabel setBackgroundColor:[UIColor clearColor]];
        [self.scoreLabel setTextAlignment:NSTextAlignmentLeft];
        [self.scoreLabel setTextColor:[UIColor orangeColor]];
        [self.scoreLabel setFont:[UIFont boldSystemFontOfSize:26]];
        [self.scoreLabel setHidden:NO];
        [self.scoreLabel setText:@"0.0%"];
        [self.detailInfoImageView addSubview:self.scoreLabel];
        
        self.goodLabel = [[[UILabel alloc]initWithFrame:CGRectMake(15, 45, 70, 15)]autorelease];
        [self.goodLabel setBackgroundColor:[UIColor clearColor]];
        [self.goodLabel setTextAlignment:NSTextAlignmentLeft];
        [self.goodLabel setTextColor:[UIColor lightGrayColor]];
        [self.goodLabel setFont:[UIFont fontWithName:@"FZY3JW--GB1-0" size:12]];
        [self.goodLabel setHidden:NO];
        [self.goodLabel setText:@"好评 (0.0%) "];
        [self.detailInfoImageView addSubview:self.goodLabel];
        
        self.mediumLabel = [[[UILabel alloc]initWithFrame:CGRectMake(15, 60, 70, 15)]autorelease];
        [self.mediumLabel setBackgroundColor:[UIColor clearColor]];
        [self.mediumLabel setTextAlignment:NSTextAlignmentLeft];
        [self.mediumLabel setTextColor:[UIColor lightGrayColor]];
        [self.mediumLabel setFont:[UIFont fontWithName:@"FZY3JW--GB1-0" size:12]];
        [self.mediumLabel setText:@"中评 (0.0%) "];
        [self.mediumLabel setHidden:NO];
        
        [self.detailInfoImageView addSubview:self.mediumLabel];
        
        self.poorLable = [[[UILabel alloc]initWithFrame:CGRectMake(15, 75, 70, 15)]autorelease];
        [self.poorLable setBackgroundColor:[UIColor clearColor]];
        [self.poorLable setTextAlignment:NSTextAlignmentLeft];
        [self.poorLable setTextColor:[UIColor lightGrayColor]];
        [self.poorLable setFont:[UIFont fontWithName:@"FZY3JW--GB1-0" size:12]];
        [self.poorLable setText:@"差评 (0.0%) "];
        [self.poorLable setHidden:NO];
        [self.detailInfoImageView addSubview:self.poorLable];
        
        self.goodProgressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self.goodProgressView setProgressTintColor:[UIColor appNavTitleGreenColor]];
        [self.goodProgressView setFrame:CGRectMake(85, 45+7, 195-20-50-20,15)];
        [self.detailInfoImageView addSubview:self.goodProgressView];
        
        self.mediumProgressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self.mediumProgressView setProgressTintColor:[UIColor appNavTitleGreenColor]];
        [self.mediumProgressView setFrame:CGRectMake(85, 60+7, 195-20-50-20, 15)];
        [self.detailInfoImageView addSubview:self.mediumProgressView];
        
        self.poorProgressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self.poorProgressView setProgressTintColor:[UIColor appNavTitleGreenColor]];
        [self.poorProgressView setFrame:CGRectMake(85, 75+7, 195-20-50-20, 15)];
        [self.detailInfoImageView addSubview:self.poorProgressView];
        
    }
    
    return self;
}

//-(void)prepareForReuse
//{
//    [self.photoImgView setHidden:YES];
//    [self.titleLabel setHidden:YES];
//    [self.nameLabel setHidden:YES];
//    [self.sexLabel setHidden:YES];
//    [self.ageLable setHidden:YES];
//    [self.realAuthImageView setHidden:YES];
//    [self.weiboImageView setHidden:YES];
//    [self.emailImageView setHidden:YES];
//    [self.carImageView setHidden:YES];
//    [self.arrowImgView setHidden:YES];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
