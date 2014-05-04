//
//  BaseViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-6.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = view;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //默认状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    //设置导航栏背景
    UIImage * naviBarImage = kDeviceVersion >= 7.0?[UIImage imageNamed:@"navgationbar_64"]:[UIImage imageNamed:@"navgationbar_44"];
    naviBarImage = [naviBarImage stretchableImageWithLeftCapWidth:4 topCapHeight:10];
    [self.navigationController.navigationBar setBackgroundImage:naviBarImage forBarMetrics:UIBarMetricsDefault];
    
    UINavigationBar *navbar = self.navigationController.navigationBar;
    
    if (kDeviceVersion < 7.0) {
        //添加线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, navbar.frame.size.height, navbar.frame.size.width, 1)];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [navbar addSubview:lineView];
    }
    else
    {
        //scroller滚动
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        //手势滑动
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
}

- (void)requestData
{
    //默认请求数据 需子类重写
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
