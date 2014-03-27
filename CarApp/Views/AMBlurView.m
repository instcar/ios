//
//  AMBlurView.m
//  blur
//
//  Created by Cesar Pinto Castillo on 7/1/13.
//  Copyright (c) 2013 Arctic Minds Inc. All rights reserved.
//

#import "AMBlurView.h"
#import <QuartzCore/QuartzCore.h>

@interface AMBlurView ()

@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation AMBlurView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // If we don't clip to bounds the toolbar draws a thin shadow on top
    [self setClipsToBounds:YES];
    
    if (kDeviceVersion >= 7.0) {
        if (![self toolbar]) {
            [self setToolbar:[[UIToolbar alloc] initWithFrame:[self bounds]]];
            [self.layer addSublayer:[self.toolbar layer]];
        }
    }
    else
    {
        [self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
    }
}

- (void) setBlurTintColor:(UIColor *)blurTintColor {
    [self.toolbar setBarTintColor:blurTintColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.toolbar setFrame:[self bounds]];
}

@end
