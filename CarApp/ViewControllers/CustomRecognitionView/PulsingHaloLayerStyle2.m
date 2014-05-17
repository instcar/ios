//
//  PulsingHaloLayerStyle2.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-1-12.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "PulsingHaloLayerStyle2.h"

@interface PulsingHaloLayerStyle2 ()
@property (nonatomic, retain) CAAnimationGroup *animationGroup;
@property (nonatomic, retain) NSTimer *timer;
@end

@implementation PulsingHaloLayerStyle2

- (id)init {
    self = [super init];
    if (self) {
        
        self.contentsScale = [UIScreen mainScreen].scale;
        self.opacity = 0.45;
        // default
        self.radius = 60;
        self.animationDuration = 0.5;
        self.pulseInterval = 0;
        self.backgroundColor = [UIColor colorWithRed:119.0/255 green:187.0/255 blue:68.0/255 alpha:0.3].CGColor;
        
        
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//            
//            [self setupAnimationGroup];
//            
//            if(self.pulseInterval != INFINITY) {
//                
//                dispatch_async(dispatch_get_main_queue(), ^(void) {
//                    
//                    [self addAnimation:self.animationGroup forKey:@"pulse"];
//                });
//            }
//        });
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
    
    self.borderColor = [UIColor colorWithRed:119.0/255 green:187.0/255 blue:68.0/255 alpha:0.8].CGColor;
    self.borderWidth = 3.0;
    
    self.transform = CATransform3DMakeScale(0.2, 0.2,1);
}

-(void)setVoiceValue:(float)voiceValue
{
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(voiceOver) userInfo:nil repeats:NO];
    [self setupAnimationGroup:voiceValue/50];
    /*
    if (voiceValue >= 10) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(voiceOver) object:nil];
        [self performSelector:@selector(voiceOver) withObject:nil afterDelay:self.animationDuration];
        
        if (voiceValue/60.0 < 0.3) {
            voiceValue = (voiceValue/(60.0*0.3))*0.2+0.3;
            [self setupAnimationGroup:voiceValue];
        }
        else
            if (voiceValue/60.0>0.6) {
                voiceValue = (voiceValue/(60.0*0.6))*0.2+0.6;
                [self setupAnimationGroup:voiceValue];
            }
            else
            [self setupAnimationGroup:voiceValue/60.0];
    }*/
}

-(void)voiceOver
{
    
    /*
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    self.animationGroup = [CAAnimationGroup animation];
    self.animationGroup.duration = self.animationDuration + self.pulseInterval;
    self.animationGroup.repeatCount = 0;
    self.animationGroup.removedOnCompletion = NO;
    self.animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
//    scaleAnimation.fromValue = @1.0;
    scaleAnimation.toValue = @0.0;
    scaleAnimation.duration = self.animationDuration;
    [scaleAnimation setAutoreverses:YES];
    [scaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:@"easeInEaseOut"]];
    
//    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//    opacityAnimation.duration = self.animationDuration;
//    opacityAnimation.values = @[@0.45, @0.45, @0];
//    opacityAnimation.keyTimes = @[@0, @0.2, @1];
//    opacityAnimation.removedOnCompletion = NO;
    
//    NSArray *animations = @[scaleAnimation, opacityAnimation];
    NSArray *animations = @[scaleAnimation];
    self.animationGroup.animations = animations;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if(self.pulseInterval != INFINITY) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                [self addAnimation:self.animationGroup forKey:@"pulseOver"];
            });
        }
    });
     */
}

- (void)setupAnimationGroup:(float)value {
    
    if (value < 0.2) {
        value = 0.2+(arc4random()%10)/100.0;
    }
    
    if (value > 1.0) {
        value = 1.0+(arc4random()%10)/100.0;
    }
    
    self.transform = CATransform3DMakeScale(value, value,1);
    /*
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    self.animationGroup = [CAAnimationGroup animation];
    self.animationGroup.duration = self.animationDuration;
    self.animationGroup.repeatCount = 0;
    self.animationGroup.removedOnCompletion = NO;
    self.animationGroup.timingFunction = defaultCurve;
    [self.animationGroup setFillMode:kCAFillModeForwards];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
//    scaleAnimation.fromValue = @0.4;
    scaleAnimation.toValue = [NSNumber numberWithFloat:value];
    scaleAnimation.duration = 0.0;
    [scaleAnimation setFillMode:kCAFillModeForwards];
    
//    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//    opacityAnimation.duration = self.animationDuration;
//    opacityAnimation.values = @[@0.45, @0.45, @1];
//    opacityAnimation.keyTimes = @[@0, @0.2, @1];
//    [scaleAnimation setFillMode:kCAFillModeForwards];
//    opacityAnimation.removedOnCompletion = NO;
    
//    NSArray *animations = @[scaleAnimation, opacityAnimation];
    NSArray *animations = @[scaleAnimation];
    
    self.animationGroup.animations = animations;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if(self.pulseInterval != INFINITY) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                [self addAnimation:self.animationGroup forKey:@"pulse"];
            });
        }
    });
     */
}


@end
