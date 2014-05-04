//
//  AppDelegate.h
//  CarApp
//
//  Created by Leno on 13-9-12.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "Reachability.h"
#import "BMapKit.h"
#import "CustomStatueBar.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
}

@property (strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) MainViewController *mainVC;
@property (strong, nonatomic) Reachability *reachability; //检测网络状态
@property (strong, nonatomic) CustomStatueBar *statueBar;
// 获取AppDelegate的单例
+ (AppDelegate *)shareDelegate;

@end

