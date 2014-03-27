//
//  CustomStatueBar.m
//  CustomStatueBar
//
//  Created by 贺 坤 on 12-5-21.
//  Copyright (c) 2012年 深圳市瑞盈塞富科技有限公司. All rights reserved.
//

#import "CustomStatueBar.h"

@implementation CustomStatueBar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelNormal;
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
		self.frame = [UIApplication sharedApplication].statusBarFrame;
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            self.backgroundColor = [UIColor whiteColor];
        }
        else
            self.backgroundColor = [UIColor blackColor];
        
        CGRect frame = [UIApplication sharedApplication].statusBarFrame;
        frame.origin.x = frame.size.width - 100.0;
        frame.size.width = 100.0;
        self.frame = frame;
        
        frame.origin.x = 0;
        
        defaultLabel = [[BBCyclingLabel alloc]initWithFrame:frame andTransitionType:BBCyclingLabelTransitionEffectScrollUp];
        defaultLabel.backgroundColor = [UIColor clearColor];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            defaultLabel.textColor = [UIColor blackColor];
        }
        else
        {
            defaultLabel.textColor = [UIColor whiteColor];
        }
        defaultLabel.font = [UIFont systemFontOfSize:10.0f];
        defaultLabel.textAlignment = UITextAlignmentLeft;
        [self addSubview:defaultLabel];
        
        [defaultLabel setText:@"new message" animated:NO];
        defaultLabel.transitionDuration = 0.75;
//        defaultLabel.shadowOffset = CGSizeMake(0, 1);
        [defaultLabel setUserInteractionEnabled:YES];
        defaultLabel.font = [UIFont systemFontOfSize:15];
        defaultLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        defaultLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.75];
        defaultLabel.clipsToBounds = YES;
        
        isHide = YES;
        [self setHidden:YES];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(messageAction:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer release];
        
    }
    return self;
}

- (void)messageAction:(UITapGestureRecognizer *)gesture
{
    [self hide];
    
}

- (void)showStateBar:(BOOL)state{

    CGRect frame = [UIApplication sharedApplication].statusBarFrame;
    frame.origin.x = frame.size.width - 100.0;
    frame.size.width = 100.0;
    
    if (!state) {
        isHide = YES;
        frame.origin.y = -20;
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        self.frame = frame;
        [defaultLabel setText:@"" animated:NO];
        [UIView commitAnimations];
    }else {
        isHide = NO;
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        self.frame = frame;
        [UIView commitAnimations];
    }
}

- (void)showStatusMessage:(NSString *)message{
    if (isHide) {
        self.hidden = NO;
        self.alpha = 1.0f;
        [defaultLabel setText:message animated:NO];

        [self showStateBar:YES];
    }
    else
    {
        [self changeMessge:message];
    }
}

- (void)hide{
    [self showStateBar:NO];
}

- (void)changeMessge:(NSString *)message{
    [defaultLabel setText:message animated:YES];
}

- (void)dealloc{
    [defaultLabel release];
    [super dealloc];
}
@end
