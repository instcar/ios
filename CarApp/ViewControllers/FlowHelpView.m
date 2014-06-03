//
//  FlowHelpView.m
//  PRJ_HQHD_BTN
//
//  Created by MacPro-Mr.Lu on 13-10-31.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import "FlowHelpView.h"
#import "Room.h"
static FlowHelpView *flowHelp = nil;

#define KFlowHelpViewHeight 44
#define KFlowHelpViewWidth	44

#define KFlowHelpViewNormalImage
#define KFlowHelpViewSelectImage

#define KFlowHelpBoundsVerEdgeSpace 100
#define KFlowHelpAnimationDuration	0.2
#define KFlowHelpAlpha 1.0

#define KFlowActionAreaWidth		[UIScreen mainScreen].bounds.size.width
#define KFlowActionAreaHeight		[UIScreen mainScreen].bounds.size.height

static CGRect LocateRect;

typedef enum {
	KFlowHelpViewpositionTop	= 0,
	KFlowHelpViewpositionBottom = 1,
	KFlowHelpViewpositionLeft	= 2,
	KFlowHelpViewpositionRight	= 3
} KFlowHelpViewposition;

@interface FlowHelpView ()

@property (strong, nonatomic) NSMutableDictionary	*locateMapDictionary;
@property (assign, nonatomic) CGPoint				offset;
@property (retain, nonatomic) UILabel *seatLabel;
@property (retain, nonatomic) UIImageView *seatNumImageView;
@property (assign, nonatomic) BOOL touchEnable;
//@property (assign, nonatomic) static CGPoint locatePoint;

@end

@implementation FlowHelpView

- (void)dealloc
{
	_selectImage	= nil;
	_normalImage	= nil;
     [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (AppDelegate *)shareAppdelegate
{
	return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (FlowHelpView *)shareInstance
{
	@synchronized(self) {
		if (flowHelp == nil) {
			flowHelp = [[FlowHelpView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - KFlowHelpViewWidth, 75, KFlowHelpViewWidth, KFlowHelpViewHeight)];
            LocateRect = flowHelp.frame;
		}
        [flowHelp setFrame:CGRectMake(SCREEN_WIDTH - KFlowHelpViewWidth, 75, KFlowHelpViewWidth, KFlowHelpViewHeight)];
        flowHelp.touchEnable = NO;
	}
	return flowHelp;
}

-(void)tapStateChange:(NSNotification *)notification
{
    self.tapState = ![((NSNumber *)[notification object])boolValue];
    self.touchEnable = [((NSNumber *)[notification object])boolValue];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
        
        self.alpha = KFlowHelpAlpha;
        
		_mainBtn		= [UIButton buttonWithType:UIButtonTypeCustom];
		_mainBtn.frame	= self.bounds;
		_mainBtn.userInteractionEnabled = NO;
		[self addSubview:_mainBtn];
        
        
		self.tapState = YES;
		// 修改人 mrlu 背景色透明
		// 修改前开始
		//		self.backgroundColor		= [UIColor colorWithRed:100.0 / 255.0 green:100.0 / 255.0 blue:100.0 / 255.0 alpha:1];
		// 修改后结束

		// 修改后开始
		self.backgroundColor = [UIColor colorWithRed:100.0 / 255.0 green:100.0 / 255.0 blue:100.0 / 255.0 alpha:0.0];
        
		// 修改后结束
		self.layer.cornerRadius		= 10;
		self.layer.masksToBounds	= YES;

        self.seatLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KFlowHelpViewWidth/2.0, KFlowHelpViewHeight/2.0)];
        [self.seatLabel setCenter:CGPointMake(KFlowHelpViewWidth/2.0, KFlowHelpViewHeight/2.0)];
        [self.seatLabel setBackgroundColor:[UIColor clearColor]];
        [self.seatLabel setText:@"0"];
        [self.seatLabel setFont:[UIFont fontWithName:kFangZhengFont size:14]];
        [self.seatLabel setTextAlignment:NSTextAlignmentCenter];
        [self.seatLabel setUserInteractionEnabled:NO];
        [self.seatLabel setTextColor:[UIColor blackColor]];
        [self addSubview:self.seatLabel];
        
        self.seatNumImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KFlowHelpViewWidth, KFlowHelpViewHeight)];
        [self.seatNumImageView setCenter:CGPointMake(KFlowHelpViewWidth/2.0, KFlowHelpViewHeight/2.0)];
        [self.seatNumImageView setBackgroundColor:[UIColor clearColor]];
        [self.seatNumImageView setImage:[UIImage imageNamed:@"1number0"]];
        [self.seatNumImageView setUserInteractionEnabled:NO];
        [self addSubview:self.seatNumImageView];
        
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
		[self addGestureRecognizer:tapGesture];

		self.hidden = YES;
	}

	return self;
}
- (void)setRoom:(Room *)room
{
    if (room)
    {
        _room = room;
    }
    [self reflashView:room];
}

-(void)reflashView:(Room*)room
{
    int leftNullSeats = room.max_seat_num-room.booked_seat_num;
    int allSeats = room.max_seat_num;
    
    [self setAllSeat:allSeats nullSeat:leftNullSeats];
}

-(void)setAllSeat:(int)allseats nullSeat:(int)nullseats
{
    [self.seatLabel setText:[NSString stringWithFormat:@"%d",nullseats]];
    NSString *seatStr = [NSString stringWithFormat:@"%dnumber%d",allseats,allseats - nullseats];
    [self.seatNumImageView setImage:[UIImage imageNamed:seatStr]];
}

- (void)tapAction:(UIGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateEnded) {
//		if (self.delegate && [self.delegate respondsToSelector:@selector(flowHelpViewTapAction:)]) {
//            self.tapState = !self.tapState;
//			[self.delegate flowHelpViewTapAction:self.tapState];
//		}
        self.tapState = !self.tapState;
        [self sendActionsForControlEvents:UIControlEventTouchDown];
   
        if (self.tapState) {
            
            if(self.groupVC && [self.groupVC respondsToSelector:@selector(refreshRoomInfo)])
            {
                [self.groupVC performSelector:@selector(refreshRoomInfo)];
            }
            
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.frame = LocateRect;
            } completion:^(BOOL finished) {
                self.touchEnable = NO;
            }];
        }
        else
        {
            self.touchEnable = YES;
        }
	}
}

-(void)showWithInView:(UIView *)view
{
	[view addSubview:flowHelp];
//	self.delegate	= [self shareAppdelegate];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapStateChange:) name:@"infoViewHide" object:nil];
	self.hidden		= NO;
}

- (void)hide
{
	self.hidden = YES;
}

- (void)viewStyleAnimation
{
	[UIView animateWithDuration:1 delay:6 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
		self.backgroundColor = [UIColor colorWithRed:150.0 / 255.0 green:150.0 / 255.0 blue:150.0 / 255.0 alpha:0.4];
	} completion:^(BOOL finished) {}];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.touchEnable) {
        return;
    }
	UITouch *touch = [touches anyObject];

	// 修人 mrlu 取消背景色
	//    self.backgroundColor		= [UIColor colorWithRed:100.0 / 255.0 green:100.0 / 255.0 blue:100.0 / 255.0 alpha:1];
	// 修改结束

	self.offset = CGPointZero;

	if (touch.phase == UITouchPhaseBegan) {
		CGPoint touchPoint = [touch locationInView:self];
		self.offset = CGPointMake(touchPoint.x - KFlowHelpViewWidth / 2, touchPoint.y - KFlowHelpViewHeight / 2);
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.touchEnable) {
        return;
    }
	UITouch *touch = [touches anyObject];

	if (touch.phase == UITouchPhaseMoved) {
		CGPoint latMovedPoint = [touch locationInView:self];

		if ([self isContainsInView:latMovedPoint]) {
			CGPoint latTouchWindow = [touch locationInView:self.superview];
			//			CGPoint offset			= CGPointMake(latMovedPoint.x - KFlowHelpViewWidth / 2, latMovedPoint.y - KFlowHelpViewHeight / 2);

			self.center = CGPointMake(latTouchWindow.x - self.offset.x, latTouchWindow.y - self.offset.y);
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.touchEnable) {
        return;
    }
	UITouch *touch = [touches anyObject];

	if (touch.phase == UITouchPhaseEnded) {
		CGPoint endPoint = [touch locationInView:self];
		[self attachToBounds:endPoint];
		// 修人 mrlu 取消背景动画
		//        [self viewStyleAnimation];
		// 修改结束
	}
}

/**
 *	切近那个边缘
 *
 *	@param	endPoint	最后的点
 */
- (void)attachToBounds:(CGPoint)endPoint
{
	if (self.center.x > KFlowActionAreaWidth / 2) {
		if ((KFlowActionAreaHeight - KFlowHelpBoundsVerEdgeSpace < self.center.y) || (KFlowHelpBoundsVerEdgeSpace > self.center.y)) {
			if (KFlowActionAreaHeight - KFlowHelpBoundsVerEdgeSpace < self.center.y) {
				if (KFlowActionAreaHeight - self.center.y < KFlowActionAreaWidth - self.center.x) {
					[self attachAnimation:KFlowHelpViewpositionBottom];
				} else {
					[self attachAnimation:KFlowHelpViewpositionRight];
				}
			}

			if (KFlowHelpBoundsVerEdgeSpace > self.center.y) {
				if (self.center.y < KFlowActionAreaWidth - self.center.x) {
					[self attachAnimation:KFlowHelpViewpositionTop];
				} else {
					[self attachAnimation:KFlowHelpViewpositionRight];
				}
			}
		} else {
			[self attachAnimation:KFlowHelpViewpositionRight];
		}
	}

	if (self.center.x < KFlowActionAreaWidth / 2) {
		if ((KFlowActionAreaHeight - KFlowHelpBoundsVerEdgeSpace < self.center.y) || (KFlowHelpBoundsVerEdgeSpace > self.center.y)) {
			if (KFlowActionAreaHeight - KFlowHelpBoundsVerEdgeSpace < self.center.y) {
				if (KFlowActionAreaHeight - self.center.y < self.center.x) {
					[self attachAnimation:KFlowHelpViewpositionBottom];
				} else {
					[self attachAnimation:KFlowHelpViewpositionLeft];
				}
			}

			if (KFlowHelpBoundsVerEdgeSpace > self.center.y) {
				if (self.center.y < self.center.x) {
					[self attachAnimation:KFlowHelpViewpositionTop];
				} else {
					[self attachAnimation:KFlowHelpViewpositionLeft];
				}
			}
		} else {
			[self attachAnimation:KFlowHelpViewpositionLeft];
		}
	}
}

/**
 *  停止之后靠近边缘的动画
 *
 *	@param	positon	靠近那个边缘
 */
- (void)attachAnimation:(KFlowHelpViewposition)positon
{
	[UIView animateWithDuration:KFlowHelpAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
			animations:^{
		if (positon == KFlowHelpViewpositionTop) {
			CGPoint newPoint = self.center;

			if (self.center.x < KFlowHelpViewWidth / 2) {
				newPoint.x = KFlowHelpViewWidth / 2;
			}

			if (self.center.x > KFlowActionAreaWidth - KFlowHelpViewWidth / 2) {
				newPoint.x = KFlowActionAreaWidth - KFlowHelpViewWidth / 2;
			}

			self.center = CGPointMake(newPoint.x, KFlowHelpViewHeight / 2);
		}

		if (positon == KFlowHelpViewpositionBottom) {
			CGPoint newPoint = self.center;

			if (self.center.x < KFlowHelpViewWidth / 2) {
				newPoint.x = KFlowHelpViewWidth / 2;
			}

			if (self.center.x > KFlowActionAreaWidth - KFlowHelpViewWidth / 2) {
				newPoint.x = KFlowActionAreaWidth - KFlowHelpViewWidth / 2;
			}

			self.center = CGPointMake(newPoint.x, KFlowActionAreaHeight - KFlowHelpViewHeight / 2);
		}

		if (positon == KFlowHelpViewpositionLeft) {
			CGPoint newPoint = self.center;

			if (self.center.y < KFlowHelpViewHeight / 2) {
				newPoint.y = KFlowHelpViewHeight / 2;
			}

			if (self.center.y > KFlowActionAreaHeight - KFlowHelpViewHeight / 2) {
				newPoint.y = KFlowActionAreaHeight - KFlowHelpViewHeight / 2;
			}

			self.center = CGPointMake(KFlowHelpViewHeight / 2, newPoint.y);
		}

		if (positon == KFlowHelpViewpositionRight) {
			CGPoint newPoint = self.center;

			if (self.center.y < KFlowHelpViewHeight / 2) {
				newPoint.y = KFlowHelpViewHeight / 2;
			}

			if (self.center.y > KFlowActionAreaHeight - KFlowHelpViewHeight / 2) {
				newPoint.y = KFlowActionAreaHeight - KFlowHelpViewHeight / 2;
			}

			self.center = CGPointMake(KFlowActionAreaWidth - KFlowHelpViewHeight / 2, newPoint.y);
		}
	} completion:^(BOOL finished) {}];
}

/**
 *	判断点触摸点是否在视图内
 *
 *	@param	point	检测的点
 *
 *	@return	是否在视图内
 */
- (BOOL)isContainsInView:(CGPoint)point
{
	if (((point.x > self.bounds.size.width) && (point.x < 0.0)) || ((point.y > self.bounds.size.height) && (point.y < 0.0))) {
		return NO;
	} else {
		return YES;
	}
}

- (void)setNormalImage:(UIImage *)normalImage
{
	[_mainBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
}

- (void)setSelectImage:(UIImage *)selectImage
{
	[_mainBtn setBackgroundImage:selectImage forState:UIControlStateSelected];
}

@end

