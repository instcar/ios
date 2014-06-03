//
//  FlowHelpView.h
//  PRJ_HQHD_BTN
//
//  Created by MacPro-Mr.Lu on 13-10-31.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Room;
@interface FlowHelpView : UIControl
{
	UIButton *_mainBtn;	// 主要按钮
    NSTimer * timer;
}

@property (strong, nonatomic) UIImage	*selectImage;
@property (strong, nonatomic) UIImage	*normalImage;
//@property (assign, nonatomic) id<FlowHelpViewDelegate> delegate;
@property (assign, nonatomic) BOOL	tapState;
@property (assign, nonatomic) Room *room;
@property (assign, nonatomic) UIViewController *groupVC;

/**
 *	浮动框单例
 *
 *	@return	浮动框
 */
+ (FlowHelpView *)shareInstance;

/**
 *	显示浮动框
 */
- (void)showWithInView:(UIView *)view;

- (void)setAllSeat:(int)allseats nullSeat:(int)nullseats;
/**
 *	隐藏浮动框
 */
- (void)hide;


@end


//@protocol FlowHelpViewDelegate <NSObject>
//
//-(void)flowHelpViewTapAction:(BOOL)state;
//
//@end
