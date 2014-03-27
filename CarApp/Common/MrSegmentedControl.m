//
//  MrSegmentedControl.m
//  Example
//
//  Created by You on 13-9-6.
//  Copyright (c) 2013年 Hackemist. All rights reserved.
//

#import "MrSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>

const NSTimeInterval kSDSegmentedControlDefaultDuration = 0.2; //默认动画的时间
const CGFloat kSDSegmentedControlArrowSize = 6.5; //默认的箭头高度

@interface MrSegmentedControl()
{
    UIView * _btnViewSubstain; //按钮容器
//    CAShapeLayer *_borderBottomLayer; //箭头层
    float _currentPosition;
}

@end

@implementation MrSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}


-(id)initWithItems:(int)items
{
    
    self = [super init];
    if (self) {
        
        // Initialization code
        _segmentAlignment = UISegmentAlignmentCenter;
        
        // Init border bottom layer
//        [self.layer addSublayer:_borderBottomLayer = CAShapeLayer.layer];
//        _borderBottomLayer.lineWidth = .5;
//        _borderBottomLayer.fillColor = nil;
//        _borderBottomLayer.shadowColor = [UIColor blackColor].CGColor;
//        _borderBottomLayer.shadowOffset = CGSizeMake(0, 2);
//        _borderBottomLayer.shadowRadius = 2;
//        _borderBottomLayer.shadowOpacity = 0.5;
    
        _animationDuration = kSDSegmentedControlDefaultDuration; //按钮动画
        _selectedSegmentIndex = -1; //默认选中状态
        _arrowSize = kSDSegmentedControlArrowSize; //配置箭头尺寸

        
        float hSpace = 300/items;
        
        _btnViewSubstain = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 45)];
        _btnViewSubstain.backgroundColor = [UIColor clearColor];
        [self addSubview:_btnViewSubstain];
        
        //创建按钮
        for (int i = 0 ; i < items; i++) {
            SegmentedBtn * btn = [SegmentedBtn buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*hSpace, 0,hSpace, _btnViewSubstain.frame.size.height);
            [btn.titleLabel setFont:[UIFont systemFontOfSize:11]];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn setAdjustsImageWhenDisabled:NO];
            [btn setAdjustsImageWhenHighlighted:NO];
            [btn addTarget:self action:@selector(chagerBtnSelected:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchDown];
            
            [_btnViewSubstain addSubview:btn];
            btn.tag = i+1;
            

        }
//        self.selectedSegmentIndex = 0; //设置当前选中状态
        [self addTarget:self action:@selector(valueChange) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
//    [_borderBottomLayer setFillColor:backgroundColor.CGColor];
}

-(void)chagerBtnSelected:(id)sender
{
    UIButton * currentBtn = (UIButton *)sender;
    if (currentBtn.selected) {
        return;
    }
    //设置按钮
    for (UIButton * btn in _btnViewSubstain.subviews) {
        if (btn.enabled) {
            if (btn.tag == currentBtn.tag) {
                if (!btn.selected) {
                    btn.selected = YES;
                }
            }
            else
            {
                btn.selected = NO;
            }
        }
    }
    
    self.selectedSegmentIndex = currentBtn.tag-1; //设置当前选中视图

    //响应事件
    if (_delegate && [_delegate respondsToSelector:@selector(segmentControl:didSelectIndex:)]) {
        [_delegate segmentControl:self didSelectIndex:_selectedSegmentIndex];
    }
    
    [self setNeedsLayout];
}

-(void)setNonDateUnEnable:(int)index
{
    
}

//重新排布
-(void)layoutSubviews
{
    [super layoutSubviews];
//    _btnViewSubstain.center = self.center;
//
//    if ([_btnViewSubstain viewWithTag:1]) {
//        _currentPosition = _btnViewSubstain.frame.origin.x + [_btnViewSubstain viewWithTag:1].frame.origin.x;
//    }
//    
//    if ([_btnViewSubstain.subviews count]>0) {
//        
//        UIButton * btn = (UIButton *)[_btnViewSubstain viewWithTag:self.selectedSegmentIndex+1];
//        
//        [self drawPathsToPosition:(btn.center.x+ _btnViewSubstain.frame.origin.x) animated:YES];
//    }
}

//设置按钮图片
-(void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment forState:(UIControlState)controlState
{
    UIButton * btn = (UIButton *)[_btnViewSubstain viewWithTag:segment+1];
    [btn setBackgroundImage:image forState:controlState];
}


#pragma mark - Draw paths
////绘制箭头层
//- (void)drawPathsToPosition:(CGFloat)position animated:(BOOL)animated
//{
//    UIBezierPath* aPath = [UIBezierPath bezierPath];
//    
//    // Set the starting point of the shape.
//    [aPath moveToPoint:CGPointMake(self.bounds.origin.x , self.bounds.origin.y)];
//    // Draw the lines
//    [aPath addLineToPoint:CGPointMake(self.bounds.origin.x , self.bounds.origin.y+self.bounds.size.height)];
//    
//    /**
//        *
//     *** ****
//     */
//    //braw the 箭头
//    [aPath addLineToPoint:CGPointMake(position - self.arrowSize , self.bounds.origin.y+self.bounds.size.height)];
//    
//    [aPath addLineToPoint:CGPointMake(position, self.bounds.origin.y+self.bounds.size.height - self.arrowSize )];
//
//    [aPath addLineToPoint:CGPointMake(position + self.arrowSize , self.bounds.origin.y+self.bounds.size.height)];
//    
//    // Draw the lines
//    [aPath addLineToPoint:CGPointMake(self.bounds.origin.x + self.bounds.size.width , self.bounds.origin.y + self.bounds.size.height)];
//
//    [aPath addLineToPoint:CGPointMake(self.bounds.origin.x + self.bounds.size.width , self.bounds.origin.y)];
//    
//    [aPath closePath]; //封闭路径
//    
//    
//    _borderBottomLayer.path = aPath.CGPath;
//    _borderBottomLayer.shadowPath = aPath.CGPath;
//    
//}

@end


@implementation SegmentedBtn

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


@end