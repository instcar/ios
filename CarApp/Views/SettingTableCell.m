//
//  SettingTableCell.m
//  CarApp
//
//  Created by leno on 13-10-13.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "SettingTableCell.h"

@implementation SettingTableCell

@synthesize titleLabel = _titleLabel;
@synthesize switchhh = _switchhh;

-(void)dealloc
{

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [backgroundView setBackgroundColor:[UIColor whiteColor]];
        [self setBackgroundView:backgroundView];
        
//        self.cellBackGroundView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)]autorelease];
//        self.cellBackGroundView.userInteractionEnabled = YES;
//        [self.cellBackGroundView setBackgroundColor:[UIColor clearColor]];
//        [self.cellBackGroundView setOpaque:YES];
//        [self addSubview:self.cellBackGroundView];
//        
//        self.cellBackGroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.cellBackGroundBtn setFrame:CGRectMake(0, 0, 320, 44)];
//        [self.cellBackGroundBtn setBackgroundColor:[UIColor clearColor]];
//        [self.cellBackGroundBtn setBackgroundImage:[[UIImage imageNamed:@"bg_function_normal"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
//        [self.cellBackGroundBtn setBackgroundImage:[[UIImage imageNamed:@"bg_function_pressed"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
//        [self.cellBackGroundBtn setOpaque:YES];
//        [self.cellBackGroundView addSubview:self.cellBackGroundBtn];
        
        UILabel *titleLable= [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 200, 20)];
        self.titleLabel = titleLable;
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.titleLabel setTextColor:[UIColor textGrayColor]];
        [self.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:14]];
        [self.titleLabel setOpaque:YES];
        [self.contentView addSubview:self.titleLabel];
    
        if (kDeviceVersion >= 7.0) {
            self.switchhh = [[UISwitch alloc]initWithFrame:CGRectMake(250, 7, 40, 30)];
        }
        else
        {
            self.switchhh = [[UISwitch alloc]initWithFrame:CGRectMake(220, 7, 70, 30)];
        }
        if(kDeviceVersion >= 6.0)
        {
            [self.switchhh setTintColor:[UIColor flatDarkGreenColor]];
        }
        [self.switchhh setOpaque:YES];
        [self.contentView addSubview:self.switchhh];
        
        self.detailLable = [[UILabel alloc]initWithFrame:CGRectMake(320 - 240, 12, 200, 20)];
        [self.detailLable setBackgroundColor:[UIColor clearColor]];
        [self.detailLable setTextAlignment:NSTextAlignmentRight];
        [self.detailLable setTextColor:[UIColor textGrayColor]];
        [self.detailLable setFont:[UIFont fontWithName:kFangZhengFont size:13]];
        [self.detailLable setOpaque:YES];
        [self.contentView addSubview:self.detailLable];
        
//        self.lineView = [[[UIView alloc]initWithFrame:CGRectMake(10, 43.5, 300, 0.5)]autorelease];
//        [self.lineView setBackgroundColor:[UIColor appLineDarkGrayColor]];
//        [self.cellBackGroundView addSubview:self.lineView];
//        [self.lineView setHidden:NO];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
