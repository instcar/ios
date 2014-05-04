//
//  CustomCell.m
//  SWTableViewCell
//
//  Created by Leno on 13-10-12.
//  Copyright (c) 2013年 Chris Wendel. All rights reserved.
//

#import "ProfileFirstCustomCell.h"

@implementation ProfileFirstCustomCel

@synthesize cellBackGroundView = _cellBackGroundView;
@synthesize cellFirstBtn = _cellFirstBtn;
@synthesize cellSecondBtn = _cellSecondBtn;
@synthesize cellThirdBtn = _cellThirdBtn;
@synthesize cellFourthBtn = _cellFourthBtn;

@synthesize successNumberFirstLabel = _successNumberFirstLabel;
@synthesize successNumberSecondLabel = _successNumberSecondLabel;
@synthesize successNumberThirdLabel = _successNumberThirdLabel;

@synthesize cancelNumberFirstLabel = _cancelNumberFirstLabel;
@synthesize cancelNumberSecondLabel = _cancelNumberSecondLabel;
@synthesize cancelNumberThirdLabel = _cancelNumberThirdLabel;

@synthesize percentNumberFirstLabel = _percentNumberFirstLabel;
@synthesize percentNumberSecondLabel = _percentNumberSecondLabel;
@synthesize percentNumberThirdLabel = _percentNumberThirdLabel;

@synthesize carTypeFirstLabel = _carTypeFirstLabel;
@synthesize carTypeSecondLabel = _carTypeSecondLabel;

-(void)dealloc
{

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.cellBackGroundView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 60)];
        self.cellBackGroundView.userInteractionEnabled = YES;
        [self.cellBackGroundView setBackgroundColor:[UIColor clearColor]];
//        [self.cellBackGroundView.layer setShadowColor:[UIColor lightGrayColor].CGColor];
//        [self.cellBackGroundView.layer setShadowOffset:CGSizeMake(1, 1)];
//        [self.cellBackGroundView.layer setShadowOpacity:0.4];
        [self addSubview:self.cellBackGroundView];
    
        self.cellFirstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cellFirstBtn setFrame:CGRectMake(0, 0, 74, 60)];
        [self.cellFirstBtn setBackgroundColor:[UIColor whiteColor]];
        [self.cellBackGroundView addSubview:self.cellFirstBtn];
        
        self.cellSecondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cellSecondBtn setFrame:CGRectMake(75, 0, 74, 60)];
        [self.cellSecondBtn setBackgroundColor:[UIColor whiteColor]];
        [self.cellBackGroundView addSubview:self.cellSecondBtn];

        self.cellThirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cellThirdBtn setFrame:CGRectMake(150, 0, 74, 60)];
        [self.cellThirdBtn setBackgroundColor:[UIColor whiteColor]];
        [self.cellBackGroundView addSubview:self.cellThirdBtn];

        self.cellFourthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cellFourthBtn setFrame:CGRectMake(225, 0, 74, 60)];
        [self.cellFourthBtn setBackgroundColor:[UIColor whiteColor]];
        [self.cellBackGroundView addSubview:self.cellFourthBtn];
        
        self.successNumberFirstLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, 60, 30)];
        [self.successNumberFirstLabel setBackgroundColor:[UIColor clearColor]];
        [self.successNumberFirstLabel setTextAlignment:NSTextAlignmentLeft];
        [self.successNumberFirstLabel setTextColor:[UIColor colorWithRed:(float)119/255 green:(float)187/255 blue:(float)68/255 alpha:1]];
        [self.successNumberFirstLabel setFont:[UIFont boldSystemFontOfSize:24]];
        [self.cellFirstBtn addSubview:self.successNumberFirstLabel];
        self.successNumberSecondLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 8, 14, 30)];
        [self.successNumberSecondLabel setBackgroundColor:[UIColor clearColor]];
        [self.successNumberSecondLabel setTextAlignment:NSTextAlignmentLeft];
        [self.successNumberSecondLabel setTextColor:[UIColor colorWithRed:(float)119/255 green:(float)187/255 blue:(float)68/255 alpha:1]];
        [self.successNumberSecondLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [self.cellFirstBtn addSubview:self.successNumberSecondLabel];
        self.successNumberThirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 27, 74, 30)];
        [self.successNumberThirdLabel setBackgroundColor:[UIColor clearColor]];
        [self.successNumberThirdLabel setTextAlignment:NSTextAlignmentLeft];
        [self.successNumberThirdLabel setTextColor:[UIColor lightGrayColor]];
        [self.successNumberThirdLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self.cellFirstBtn addSubview:self.successNumberThirdLabel];        
        
        self.cancelNumberFirstLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 4, 60, 30)];
        [self.cancelNumberFirstLabel setBackgroundColor:[UIColor clearColor]];
        [self.cancelNumberFirstLabel setTextAlignment:NSTextAlignmentLeft];
        [self.cancelNumberFirstLabel setTextColor:[UIColor colorWithRed:(float)119/255 green:(float)187/255 blue:(float)68/255 alpha:1]];
        [self.cancelNumberFirstLabel setFont:[UIFont boldSystemFontOfSize:24]];
        [self.cellSecondBtn addSubview:self.cancelNumberFirstLabel];
        self.cancelNumberSecondLabel = [[UILabel alloc]initWithFrame:CGRectMake(38, 8, 14, 30)];
        [self.cancelNumberSecondLabel setBackgroundColor:[UIColor clearColor]];
        [self.cancelNumberSecondLabel setTextAlignment:NSTextAlignmentLeft];
        [self.cancelNumberSecondLabel setTextColor:[UIColor colorWithRed:(float)119/255 green:(float)187/255 blue:(float)68/255 alpha:1]];
        [self.cancelNumberSecondLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [self.cellSecondBtn addSubview:self.cancelNumberSecondLabel];
        self.cancelNumberThirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 27, 74, 30)];
        [self.cancelNumberThirdLabel setBackgroundColor:[UIColor clearColor]];
        [self.cancelNumberThirdLabel setTextAlignment:NSTextAlignmentLeft];
        [self.cancelNumberThirdLabel setTextColor:[UIColor lightGrayColor]];
        [self.cancelNumberThirdLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self.cellSecondBtn addSubview:self.cancelNumberThirdLabel];
        
        self.percentNumberFirstLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 4, 30, 30)];
        [self.percentNumberFirstLabel setBackgroundColor:[UIColor clearColor]];
        [self.percentNumberFirstLabel setTextAlignment:NSTextAlignmentLeft];
        [self.percentNumberFirstLabel setTextColor:[UIColor colorWithRed:(float)255/255 green:(float)119/255 blue:(float)0/255 alpha:1]];
        [self.percentNumberFirstLabel setFont:[UIFont boldSystemFontOfSize:22]];
        [self.cellThirdBtn addSubview:self.percentNumberFirstLabel];
        self.percentNumberSecondLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 8, 14, 30)];
        [self.percentNumberSecondLabel setBackgroundColor:[UIColor clearColor]];
        [self.percentNumberSecondLabel setTextAlignment:NSTextAlignmentLeft];
        [self.percentNumberSecondLabel setTextColor:[UIColor colorWithRed:(float)255/255 green:(float)119/255 blue:(float)0/255 alpha:1]];
        [self.percentNumberSecondLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [self.cellThirdBtn addSubview:self.percentNumberSecondLabel];
        self.percentNumberThirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 27, 74, 30)];
        [self.percentNumberThirdLabel setBackgroundColor:[UIColor clearColor]];
        [self.percentNumberThirdLabel setTextAlignment:NSTextAlignmentLeft];
        [self.percentNumberThirdLabel setTextColor:[UIColor lightGrayColor]];
        [self.percentNumberThirdLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self.cellThirdBtn addSubview:self.percentNumberThirdLabel];
        
        
        self.carTypeFirstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 4, 74, 30)];
        [self.carTypeFirstLabel setBackgroundColor:[UIColor clearColor]];
        [self.carTypeFirstLabel setTextAlignment:NSTextAlignmentCenter];
        [self.carTypeFirstLabel setTextColor:[UIColor colorWithRed:(float)255/255 green:(float)119/255 blue:(float)0/255 alpha:1]];
        [self.carTypeFirstLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [self.cellFourthBtn addSubview:self.carTypeFirstLabel];

        self.carTypeSecondLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 27, 74, 30)];
        [self.carTypeSecondLabel setBackgroundColor:[UIColor clearColor]];
        [self.carTypeSecondLabel setTextAlignment:NSTextAlignmentLeft];
        [self.carTypeSecondLabel setTextColor:[UIColor lightGrayColor]];
        [self.carTypeSecondLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self.cellFourthBtn addSubview:self.carTypeSecondLabel];

    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
