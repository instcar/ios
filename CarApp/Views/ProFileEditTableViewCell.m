//
//  ProFileEditTableViewCell.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-15.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "ProFileEditTableViewCell.h"
#import "UILabel+utils.h"

@implementation ProFileEditTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setView];
    }
    return self;
}

- (void)setView
{
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, (self.contentView.frame.size.height-20)/2.0, 70, 20)];
    [_titleLabel setTextColor:[UIColor appNavTitleGreenColor]];
    [_titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:14]];
    [_titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_titleLabel];
    
    _infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(75,(self.contentView.frame.size.height-20)/2.0, 150, 20)];
    [_infoLabel setTextColor:[UIColor appBlackColor]];
    [_infoLabel setFont:[UIFont fontWithName:kFangZhengFont size:14]];
    [_infoLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_infoLabel];
    
    [self setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_next"]]];
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

- (void)setTitleStr:(NSString *)titleStr
{
    if (titleStr) {
        _titleStr = titleStr;
        [_titleLabel setText:_titleStr];
        float width = [_titleLabel labelLength:_titleStr withFont:AppFont(14)];
        [_titleLabel setFrame:CGRectMake(10, (self.contentView.frame.size.height-20)/2.0, width, 20)];
    }
}

- (void)setInfoStr:(NSString *)infoStr
{
    if (infoStr) {
        _infoStr = infoStr;
        [_infoLabel setText:_infoStr];
        float x = _titleLabel.bounds.size.width + _titleLabel.frame.origin.x;
        [_infoLabel setFrame:CGRectMake(10+x, (self.contentView.frame.size.height-20)/2.0, SCREEN_WIDTH - x - 40, 20)];
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

@end
