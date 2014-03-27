//
//  XHBKCell.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-17.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "XHBKCell.h"

@implementation XHBKCell

@synthesize backButton = _backButton;
@synthesize contentTextLable = _contentTextLable;
@synthesize imageView = _imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backButton setFrame:CGRectMake(0, 0, 300, 75)];
        [self.backButton setBackgroundColor:[UIColor clearColor]];
        [self.backButton setBackgroundImage:[UIImage imageNamed:@"bg_rss_normal@2x"] forState:UIControlStateNormal];
        [self.backButton setBackgroundImage:[UIImage imageNamed:@"bg_rss_pressed@2x"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:self.backButton];
        
        self.contentTextLable = [[[UILabel alloc]initWithFrame:CGRectMake(8, 7, 200, 60)]autorelease];
        [self.contentTextLable  setBackgroundColor:[UIColor clearColor]];
        [self.contentTextLable  setTextAlignment:NSTextAlignmentLeft];
        [self.contentTextLable  setTextColor:[UIColor colorWithRed:(float)63/255 green:(float)63/255 blue:(float)63/255 alpha:1]];
        [self.contentTextLable  setFont:[UIFont systemFontOfSize:12]];
        [self.contentTextLable  setUserInteractionEnabled:NO];
        [self.contentTextLable  setNumberOfLines:4];
        [self.contentTextLable setLineBreakMode:NSLineBreakByWordWrapping];
        [self.backButton addSubview:self.contentTextLable];
        
        self.contentImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(212,7,80,60)]autorelease];
        self.contentImageView.backgroundColor = [UIColor orangeColor];
        [self.backButton addSubview:self.contentImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellData:(NSDictionary *)cellData
{
    if (cellData) {
        _celldata = cellData;
    }
}

@end
