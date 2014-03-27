//
//  MainViewController.h
//  CarApp
//
//  Created by Leno on 13-9-12.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectStateView.h"

@interface MainViewController : UIViewController<UIScrollViewDelegate,UIAlertViewDelegate>
{
    ConnectStateView *_connectStateView;
}
@property(retain,nonatomic)UIScrollView * mainScrollView;
@property(assign,nonatomic)bool firstEnter;

-(void)enterView;
-(void)showRouteView;

@end
