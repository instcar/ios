//
//  PulsingHaloLayerStyle2.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-1-12.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface PulsingHaloLayerStyle2 : CALayer

@property (nonatomic, assign) CGFloat radius;                   // default:60pt
@property (nonatomic, assign) NSTimeInterval animationDuration; // default:3s
@property (nonatomic, assign) NSTimeInterval pulseInterval; // default is 0s

-(void)setVoiceValue:(float)voiceValue;

@end
