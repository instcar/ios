//
//  MainViewController.h
//  CarApp
//
//  Created by Leno on 13-9-12.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "ConnectStateView.h"
#import "MainFirstView.h"
#import "MainSecondView.h"
#import "MainThirdView.h"
#import "CommonRouteView.h"

@interface MainViewController :CommonViewController<UIScrollViewDelegate,UIAlertViewDelegate>
{
    ConnectStateView *_connectStateView;
    UIPageControl *_pageControl;
    CommonRouteView *_mainThirdView;
    MainSecondView *_mainsecondView;
    UIButton * _moreBtn;
    UIButton * _profileBtn;
    UIButton * _settingBtn;
}
@property(strong,nonatomic)UIScrollView * mainScrollView;
@property(assign,nonatomic)bool firstEnter;

-(void)enterView;
-(void)showRouteView;

@end
