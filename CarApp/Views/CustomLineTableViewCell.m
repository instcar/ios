//
//  CustomLineTableViewCell.m
//  CarApp
//
//  Created by Mac_ZL on 14-6-1.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CustomLineTableViewCell.h"
@implementation CustomLineTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.current_h/2-12, 24, 24)];
        _indexLabel.layer.borderWidth = 1;
        _indexLabel.layer.borderColor = [UIColor blackColor].CGColor;
        _indexLabel.layer.cornerRadius = 12;
        _indexLabel.layer.masksToBounds = YES;
        [_indexLabel setFont:[UIFont fontWithName:kFangZhengFont size:14]];
        [_indexLabel setTextColor:[UIColor blackColor]];
        [_indexLabel setTextAlignment:NSTextAlignmentCenter];
        [_indexLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_indexLabel];
        
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_indexLabel.current_x_w+10, self.current_h/2-10, 260, 20)];
        [_nameLabel setFont:[UIFont fontWithName:kFangZhengFont size:14]];
        [_nameLabel setTextColor:[UIColor blackColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setText:@""];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_nameLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, self.current_h-0.5, 300, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithRed:146.0/255.0 green:164.0/255.0 blue:171.0/255.0 alpha:1.0];
        [self addSubview:_lineView];
        
        UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.current_w-10-16-5, self.current_h/2-8, 16, 16)];
        [arrowImgView setImage:[UIImage imageNamed:@"ic_down@2x.png"]];
        arrowImgView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [self addSubview:arrowImgView];
        
        
    }
    return self;
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
#pragma mark - Setter
- (void)setIndex:(int)index
{
    _index = index;
    [_indexLabel setText:[NSString stringWithFormat:@"%d",index]];
}
- (void)setName:(NSString *)name
{
    _name = name;
    [_nameLabel setText:name];
}
- (void)setIsHideBottomLine:(BOOL)isHideBottomLine
{
    _isHideBottomLine = isHideBottomLine;
    [_lineView setHidden:isHideBottomLine];
}
@end
