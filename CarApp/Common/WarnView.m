//
//  WarnView.m
//  CloudThinkProject
//
//  Created by Mr.Lu on 13-5-30.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import "WarnView.h"

@implementation WarnView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	if (self) {}

	return self;
}

- (id)initWithFrame:(CGRect)frame showImage:(NSString *)logoImage withTitle:(NSString *)title withButtonStr:(NSString *)buttonTitle withDelegate:(id)delegate
{
	self = [super initWithFrame:frame];

	if (self) {
		self.backgroundColor	= [UIColor clearColor];
		self.delegate			= delegate;

		if (logoImage) {
			UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 40, 40)];
			image.image		= [logoImage isEqual:@""] ?[UIImage imageNamed:@"hint_none"] :[UIImage imageNamed:logoImage];
			[self addSubview:image];
            [image release];
		}

		UILabel *lable = [[UILabel alloc]init];
		lable.font = [UIFont fontWithName:kFangZhengFont size:12];

		if (kDeviceVersion >= 6.0) {
			lable.lineBreakMode = NSLineBreakByCharWrapping;
		}

		if (logoImage) {
//			lable.frame = CGRectMake(40, 0, 200-40, [AppUtility heightForRect:CGRectMake(0, 0, frame.size.width, MAXFLOAT) WithText:title font:[UIFont fontWithName:kFangZhengFont size:12]]);
            lable.frame = CGRectMake(40, 0, 200-40, 40);
            
		} else {
//			lable.frame = CGRectMake(0, 0, 200-40, [AppUtility heightForRect:CGRectMake(0, 0, frame.size.width, MAXFLOAT) WithText:title font:[UIFont fontWithName:kFangZhengFont size:12]]);
			lable.frame = CGRectMake(0, 0, 200-40, 40);
		}

		lable.backgroundColor	= [UIColor clearColor];
		lable.textColor			= [UIColor appDarkGrayColor];
		lable.numberOfLines		= 2;
		lable.text				= title;

		if (kDeviceVersion >= 6.0) {
			lable.textAlignment = NSTextAlignmentCenter;
		}

		if (buttonTitle) {
			UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
			btn.frame = CGRectMake(0, 0, 50, 30);
			[btn setTitle:buttonTitle forState:UIControlStateNormal];
			[btn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
			[btn setShowsTouchWhenHighlighted:YES];
			[btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
			btn.center = CGPointMake(lable.center.x, lable.center.y + lable.frame.size.height);
			[btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchDown];
			[self addSubview:btn];
		}

		warnLable = lable;
		[self addSubview:lable];
	}

	return self;
}

//按钮动作
- (void)btnAction:(id)sender
{
	if (self.delegate && [self.delegate respondsToSelector:@selector(warnViewBtnAction:)]) {
		[self.delegate warnViewBtnAction:sender];
	}
}

+ (WarnView *)initWarnViewWithText:(NSString *)text withView:(UIView *)view height:(float)height withDelegate:(id)delegate
{
	// 提醒视图
	WarnView *warnView = [[WarnView alloc]initWithFrame:CGRectMake(60, height, 200, view.bounds.size.height) showImage:@"hint_none" withTitle:text withButtonStr:nil withDelegate:delegate];

	warnView.tag	= 10111;
	warnView.hidden = YES;
	[view addSubview:warnView];
	return [warnView autorelease];
}

- (void)show:(kenumWarnViewType)type
{
    if (type == kenumWarnViewTypeNullData) {
        _warnTitle = @"非常抱歉,暂无数据...";
    }
    if (type == kenumWarnViewTypeServeError) {
        _warnTitle = @"非常抱歉,服务器暂时无法连接...";
    }
	self.hidden = NO;
}

- (void)dismiss
{
	self.hidden = YES;
}

- (void)setWarnTitle:(NSString *)warnTitle
{
	if (warnTitle) {
		_warnTitle = warnTitle;
	}

	warnLable.text = warnTitle;
}

@end
