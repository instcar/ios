//
//  SetProfileTableCell.m
//  CarApp
//
//  Created by 海龙 李 on 13-11-17.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "SetProfileTableCell.h"

@implementation SetProfileTableCell

-(void)dealloc
{

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [backgroundView setBackgroundColor:[UIColor whiteColor]];
        [backgroundView setOpaque:YES];
        [self setBackgroundView:backgroundView];
        
        UIImageView *photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(9, 9, 92, 92)];
        [photoImgView setBackgroundColor:[UIColor clearColor]];
        [photoImgView setHidden:YES];
        [self.contentView addSubview:photoImgView];
        [self setPhotoImgView:photoImgView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setFont:[UIFont fontWithName:@"FZY3JW--GB1-0" size:16]];
        [titleLabel setHidden:YES];
        [self.contentView addSubview:titleLabel];
        [self setTitleLabel:titleLabel];
        
        UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, 180, 30)];
        [infoLabel setBackgroundColor:[UIColor clearColor]];
        [infoLabel setTextAlignment:NSTextAlignmentLeft];
        [infoLabel setTextColor:[UIColor blackColor]];
        [infoLabel setFont:[UIFont fontWithName:@"FZY3JW--GB1-0" size:14]];
        [infoLabel setHidden:YES];
        [self.contentView addSubview:infoLabel];
        [self setInfoLabel:infoLabel];

        UIImageView *arrowImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 19, 12, 12)];
        [arrowImgView setImage:[UIImage imageNamed:@"ic_start_ture@2x"]];
        [arrowImgView setHidden:YES];
        [self.contentView addSubview:arrowImgView];
        [self setArrowImgView:arrowImgView];
    }
    
    return self;
}

-(void)prepareForReuse
{
    [self.photoImgView setHidden:YES];
    [self.titleLabel setHidden:YES];
    [self.infoLabel setHidden:YES];
    [self.arrowImgView setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
