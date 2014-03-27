//
//  MrSegmentedControl.h
//  Example
//
//  Created by You on 13-9-6.
//  Copyright (c) 2013年 Hackemist. All rights reserved.
//

#import <UIKit/UIKit.h>



enum SegmentAlignment{
    UISegmentAlignmentLeft = 0,
    UISegmentAlignmentCenter,
    UISegmentAlignmentRight,                   // could add justified in future
};

@class MrSegmentedControl;

@protocol  MrSegmentedControlDelegate<NSObject>

//选中动作代理
- (void)segmentControl:(MrSegmentedControl *)segmentedControl didSelectIndex:(int)index;

@end

/**
 分段视图
 */
@interface MrSegmentedControl : UIControl

@property(assign, nonatomic) NSInteger selectedSegmentIndex;//当前选中
@property(assign, nonatomic) CGFloat arrowSize ; //箭头尺寸
@property(assign, nonatomic)float animationDuration; //动画间隔
@property(nonatomic, assign)enum SegmentAlignment segmentAlignment; //视图对齐 //暂无功能
@property(nonatomic, assign)id<MrSegmentedControlDelegate> delegate; //代理

-(id)initWithItems:(int)items;

/**
 设置按钮的图片显示
 */
-(void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment forState:(UIControlState)controlState;

-(void)setNonDateUnEnable:(int)index; //设置无效

@end

/**
 按钮类
 */
@interface SegmentedBtn : UIButton

@end
