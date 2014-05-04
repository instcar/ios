//
//  ProfileSecondCustomCell.m
//  SWTableViewCell
//
//  Created by Leno on 13-10-12.
//  Copyright (c) 2013年 Chris Wendel. All rights reserved.
//

#import "ProfileSecondCustomCell.h"

@implementation ProfileSecondCustomCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        [self setClipsToBounds:NO];
        
        self.cellBackGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.cellBackGroundView.userInteractionEnabled = YES;
        [self.cellBackGroundView setBackgroundColor:[UIColor clearColor]];
//        [self.cellBackGroundView.layer setShadowColor:[UIColor lightGrayColor].CGColor];
//        [self.cellBackGroundView.layer setShadowOffset:CGSizeMake(1, 1)];
//        [self.cellBackGroundView.layer setShadowOpacity:0.4];
        [self addSubview:self.cellBackGroundView];
        
        self.cellBackGroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cellBackGroundBtn setFrame:CGRectMake(0, 0, 320, 44)];
        [self.cellBackGroundBtn setBackgroundColor:[UIColor clearColor]];
//        [self.cellBackGroundBtn.layer setShadowColor:[UIColor lightGrayColor].CGColor];
//        [self.cellBackGroundBtn.layer setShadowOffset:CGSizeMake(1, 1)];
//        [self.cellBackGroundBtn.layer setShadowOpacity:0.4];
//        [self.cellBackGroundBtn setImage:[[UIImage imageNamed:@"bg_function_normal"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
//        [self.cellBackGroundBtn setImage:[[UIImage imageNamed:@"bg_function_pressed"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];

        [self.cellBackGroundView addSubview:self.cellBackGroundBtn];
        
        self.phoneImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10+10+4, 5+6, 22, 22)];
        [self.phoneImgView setBackgroundColor:[UIColor clearColor]];
        [self.cellBackGroundView addSubview:self.phoneImgView];
        
        self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(50+10, 7, 200, 30)];
        [self.phoneLabel setBackgroundColor:[UIColor clearColor]];
        [self.phoneLabel setTextAlignment:NSTextAlignmentLeft];
        [self.phoneLabel setTextColor:[UIColor appBlackColor]];
        [self.phoneLabel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
        [self.cellBackGroundView addSubview:self.phoneLabel];

        
        self.smallLabel = [[UILabel alloc]initWithFrame:CGRectMake(72+10, 12, 200, 20)];
        [self.smallLabel setBackgroundColor:[UIColor clearColor]];
        [self.smallLabel setTextAlignment:NSTextAlignmentLeft];
        [self.smallLabel setTextColor:[UIColor appBlackColor]];
        [self.smallLabel setFont:[UIFont fontWithName:kFangZhengFont size:10]];
        [self.cellBackGroundView addSubview:self.smallLabel];
        
        
        self.verifyFirstIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10+10, 5, 30, 30)];
        [self.verifyFirstIcon setHidden:YES];
        [self.cellBackGroundView addSubview:self.verifyFirstIcon];
        
        self.verifySecondIcon = [[UIImageView alloc]initWithFrame:CGRectMake(50+10, 5, 30, 30)];
        [self.verifySecondIcon setHidden:YES];
        [self.cellBackGroundView addSubview:self.verifySecondIcon];
        
        self.verifyThidIcon = [[UIImageView alloc]initWithFrame:CGRectMake(90+10, 5, 30, 30)];
        [self.verifyThidIcon setHidden:YES];
        [self.cellBackGroundView addSubview:self.verifyThidIcon];
        
        self.verifyFourthIcon = [[UIImageView alloc]initWithFrame:CGRectMake(130+10, 5, 30, 30)];
        [self.verifyFourthIcon setHidden:YES];
        [self.cellBackGroundView addSubview:self.verifyFourthIcon];
        
        self.verifyFifthIcon = [[UIImageView alloc]initWithFrame:CGRectMake(170+10, 5, 30, 30)];
        [self.verifyFifthIcon setHidden:YES];
        [self.cellBackGroundView addSubview:self.verifyFifthIcon];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(10,43.5, 300, 0.5)];
        [self.lineView setBackgroundColor:[UIColor appLineDarkGrayColor]];
        [self.lineView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self.cellBackGroundView addSubview:self.lineView];
        [self.lineView setOpaque:YES];
        [self.lineView setHidden:NO];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
