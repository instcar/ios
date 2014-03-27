//
//  PulsingHaloLayer.m
//  https://github.com/shu223/PulsingHalo
//
//  Created by shuichi on 12/5/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//
//  Inspired by https://github.com/samvermette/SVPulsingAnnotationView


#import "PulsingHaloLayer.h"


@interface PulsingHaloLayer ()
@property (nonatomic, retain) CAAnimationGroup *animationGroup;
@end


@implementation PulsingHaloLayer

- (id)init {
    self = [super init];
    if (self) {
        
        self.contentsScale = [UIScreen mainScreen].scale;
        self.opacity = 0;
        
        // default
        self.radius = 60;
        self.animationDuration = 3;
        self.pulseInterval = 0;
        self.backgroundColor = [UIColor clearColor].CGColor;

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            
            [self setupAnimationGroup];

            if(self.pulseInterval != INFINITY) {
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    
                    [self addAnimation:self.animationGroup forKey:@"pulse"];
                });
            }
        });
    }
    return self;
}

- (void)setRadius:(CGFloat)radius {

    _radius = radius;
    
    CGPoint tempPos = self.position;

    CGFloat diameter = self.radius * 2;

    self.bounds = CGRectMake(0, 0, diameter, diameter);
    self.cornerRadius = self.radius;
    self.position = tempPos;
    self.borderColor = [UIColor colorWithRed:119.0/255 green:187.0/255 blue:68.0/255 alpha:0.7].CGColor;
    self.borderWidth = 2.0;
}

- (void)setupAnimationGroup {
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    self.animationGroup = [CAAnimationGroup animation];
    self.animationGroup.duration = self.animationDuration + self.pulseInterval;
    self.animationGroup.repeatCount = INFINITY;
    self.animationGroup.removedOnCompletion = NO;
    self.animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.0;
    scaleAnimation.toValue = @1.0;
    scaleAnimation.duration = self.animationDuration;
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = self.animationDuration;
    opacityAnimation.values = @[@1.0, @1.0, @0];
    opacityAnimation.keyTimes = @[@0, @0.7, @1];
    opacityAnimation.removedOnCompletion = NO;
    
    NSArray *animations = @[scaleAnimation, opacityAnimation];
    
    self.animationGroup.animations = animations;
}

@end
