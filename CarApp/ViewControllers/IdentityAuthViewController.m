//
//  IdentityAuthViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-6.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "IdentityAuthViewController.h"

@interface IdentityAuthViewController ()

@end

@implementation IdentityAuthViewController

-(void)dealloc
{
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	UIView * mainView = [[UIView alloc]initWithFrame:[AppUtility mainViewFrame]];
    [mainView setBackgroundColor:[UIColor appBackgroundColor]];
    [mainView setTag:10000];
    [self.view addSubview:mainView];
    [mainView release];
    
    UIImage * naviBarImage = [UIImage imageNamed:@"navgationbar_64"];
    naviBarImage = [naviBarImage stretchableImageWithLeftCapWidth:4 topCapHeight:10];
    
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    [navBar setBackgroundImage:naviBarImage forBarMetrics:UIBarMetricsDefault];
    [mainView addSubview:navBar];
    [navBar release];
    
    if (kDeviceVersion < 7.0) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, navBar.frame.size.height, navBar.frame.size.width, 1)];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [navBar addSubview:lineView];
        [lineView release];
    }
    else
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
    
    UIButton * backButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 20, 70, 44)];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_normal@2x"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed@2x"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backButton];
    
    UIImage * welcomeImage = [UIImage imageNamed:@"nav_hint@2x"];
    //    welcomeImage = [welcomeImage stretchableImageWithLeftCapWidth:8 topCapHeight:10];
    //导航栏下方的欢迎条
    UIImageView * welcomeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 49)];
    [welcomeImgView setImage:welcomeImage];
    [mainView addSubview:welcomeImgView];
    [welcomeImgView release];
    
    UILabel * welcomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 310, 44)];
    [welcomeLabel setBackgroundColor:[UIColor clearColor]];
    [welcomeLabel setText:@"实名认证状态:"];
    [welcomeLabel setTextAlignment:NSTextAlignmentCenter];
    [welcomeLabel setTextColor:[UIColor whiteColor]];
    [welcomeLabel setFont:[UIFont appGreenWarnFont]];
    [welcomeImgView addSubview:welcomeLabel];
    [welcomeLabel release];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 66 + 44 +10, mainView.frame.size.width, SCREEN_HEIGHT - 66 - 44 -10)];
    [mainView insertSubview:scrollView belowSubview:welcomeImgView];
    [scrollView release];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 355)];
    [imageView setBackgroundColor:[UIColor whiteColor]];
    [imageView setUserInteractionEnabled:YES];
    [scrollView addSubview:imageView];
    [scrollView setContentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];
    [scrollView setAlwaysBounceHorizontal:YES];
    [imageView release];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(goAuthAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 355 - 40 - 44, 220, 44)];
    [imageView addSubview:btn];
    
    
}

-(void)goAuthAction:(UIButton *)sender
{
    DLog(@"进行实名认证");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
