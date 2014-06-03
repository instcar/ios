//
//  CustomActionAnnotation.m
//  CarApp
//
//  Created by Mac_ZL on 14-5-26.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CustomActionAnnotation.h"

@implementation CustomActionAnnotation
@synthesize annotation;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame WithAnnotation:(RouteAnnotation *) ann WithType:(int) type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width-20, 20)];
        [self addSubview:_titleLabel];
        
        UIImage *greenImg = [[UIImage imageNamed:@"bg_green_normal@2x.png"] stretchableImageWithLeftCapWidth:40/2 topCapHeight:0];
        UIImage *greenPressImg = [[UIImage imageNamed:@"bg_green_pressed.png"] stretchableImageWithLeftCapWidth:40/2 topCapHeight:0];
        UIImage *blueImg = [[UIImage imageNamed:@"bg_blue_normal@2x.png"] stretchableImageWithLeftCapWidth:40/2 topCapHeight:0];
        UIImage *bluePressImg = [[UIImage imageNamed:@"bg_blue_pressed@2x.png"] stretchableImageWithLeftCapWidth:40/2 topCapHeight:0];
        _type = type;
        
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setFrame:CGRectMake(10, _titleLabel.current_y_h+10, 220, 40)];
        [_startBtn setBackgroundImage:_type==0?greenImg:blueImg forState:UIControlStateNormal];
        [_startBtn setBackgroundImage:_type==0?greenPressImg:bluePressImg forState:UIControlStateHighlighted];
        [_startBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:14]];
        [_startBtn addTarget:self action:@selector(startBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [_startBtn setTitle:@"作为起点" forState:UIControlStateNormal];
        [_startBtn setTitle:@"作为起点" forState:UIControlStateHighlighted];
        [self addSubview:_startBtn];
        
        _destinationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_destinationBtn setFrame:CGRectMake(10, _startBtn.current_y_h+6, 220, 40)];
        [_destinationBtn setBackgroundImage:_type==0?blueImg:greenImg forState:UIControlStateNormal];
        [_destinationBtn setBackgroundImage:_type==0?bluePressImg:greenPressImg forState:UIControlStateHighlighted];
        [_destinationBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:14]];
        [_destinationBtn addTarget:self action:@selector(desBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [_destinationBtn setTitle:@"作为终点" forState:UIControlStateNormal];
        [_destinationBtn setTitle:@"作为终点" forState:UIControlStateHighlighted];
        [self addSubview:_destinationBtn];
        
        self.annotation = ann;

    }
    return self;
}
- (void)setAnnotation:(RouteAnnotation *)_annotation
{
    annotation = _annotation;
    [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (_titleLabel)
    {
        [_titleLabel setText:annotation.title];
    }
  
}
#pragma mark - Inter
- (void)startBtnPressed
{
    if ([delegate respondsToSelector:@selector(selectStart:)])
    {
        [delegate selectStart:annotation];
    }
}
- (void)desBtnPressed
{
    if ([delegate respondsToSelector:@selector(selectDestination:)])
    {
        [delegate selectDestination:annotation];
    }
}
@end
