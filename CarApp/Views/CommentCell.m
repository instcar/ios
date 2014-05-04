//
//  CommentCell.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-11.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        [backgroundView setBackgroundColor:[UIColor whiteColor]];
        [self setBackgroundView:backgroundView];
        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        // Initialization code
        self.imagerView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 9, 42, 42)];
        [self.imagerView setBackgroundColor:[UIColor flatGrayColor]];
        [self.imagerView.layer setCornerRadius:21];
        [self.imagerView.layer setMasksToBounds:YES];
        [self.contentView addSubview:self.imagerView];
        
        self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(54, 17, 150, 12)];
        [self.nameLable setBackgroundColor:[UIColor clearColor]];
        [self.nameLable setTextAlignment:NSTextAlignmentLeft];
        [self.nameLable setTextColor:[UIColor appBlackColor]];
        [self.nameLable setFont:[UIFont fontWithName:kFangZhengFont size:12]];
        [self.contentView addSubview:self.nameLable];
        
        self.typeLable = [[UILabel alloc]initWithFrame:CGRectMake(54, 35, 150, 13)];
        [self.typeLable setBackgroundColor:[UIColor clearColor]];
        [self.typeLable setTextAlignment:NSTextAlignmentLeft];
        [self.typeLable setTextColor:[UIColor appBlackColor]];
        [self.typeLable setFont:[UIFont fontWithName:kFangZhengFont size:13]];
        [self.contentView addSubview:self.typeLable];
        
        self.desLable = [[UILabel alloc]initWithFrame:CGRectMake(130, 24, 60, 12)];
        [self.desLable setBackgroundColor:[UIColor clearColor]];
        [self.desLable setTextAlignment:NSTextAlignmentCenter];
        [self.desLable setTextColor:[UIColor textGrayColor]];
        [self.desLable setFont:[UIFont fontWithName:kFangZhengFont size:12]];
        [self.contentView addSubview:self.desLable];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
