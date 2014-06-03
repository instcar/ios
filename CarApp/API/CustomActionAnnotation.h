//
//  CustomActionAnnotation.h
//  CarApp
//
//  Created by Mac_ZL on 14-5-26.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteAnnotation.h"
@protocol CustomActionAnnotationDelegate;
@interface CustomActionAnnotation : UIView
{
    UILabel *_titleLabel;
    UIButton *_startBtn;
    UIButton *_destinationBtn;
    /*
     *  起点和终点按钮颜色不一样
     *  0:我有车界面 1:我搭车界面
     */
   
    int _type;
}

@property (strong, nonatomic) RouteAnnotation *annotation;
@property (weak, nonatomic) id<CustomActionAnnotationDelegate> delegate;
- (id)initWithFrame:(CGRect)frame WithAnnotation:(RouteAnnotation *) ann WithType:(int) type;
@end

@protocol CustomActionAnnotationDelegate <NSObject>

- (void)selectStart:(RouteAnnotation *) ann;
- (void)selectDestination:(RouteAnnotation *) ann;

@end