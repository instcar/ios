//
//  CarLogoTableViewCell.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-5-1.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CarLogoTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIColor+AppColor.h"

@implementation CarLogoTableViewCell

- (void)dealloc
{

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    _iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 53, 53)];
    [self.contentView addSubview:_iconImgView];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    [_nameLabel setTextColor:[UIColor appBlackColor]];
    [_nameLabel setFont:AppFont(20)];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_nameLabel];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_iconImgView setFrame:CGRectMake(10, (self.bounds.size.height - 53)/2.0, 53, 53)];
    [_nameLabel setFrame:CGRectMake(80, (self.bounds.size.height - 40)/2.0, 200, 40)];
}

- (void)setData:(CarD *)data
{
    if (data) {
        _data = data;
        [self loadData];
    }
}

- (void)loadData
{
    [_nameLabel setText:_data.name];
    [_iconImgView setImage:[UIImage imageNamed:_data.icon]];
}


@end
