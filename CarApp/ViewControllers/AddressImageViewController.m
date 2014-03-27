//
//  AddressImageViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-2-10.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "AddressImageViewController.h"
#import "MRZoomScrollView.h"
#import "UIImageView+WebCache.h"

@interface AddressImageViewController ()

@end

@implementation AddressImageViewController

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
	// Do any additional setup after loading the view.
    if (kDeviceVersion >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    UIView * mainView = [[UIView alloc]initWithFrame:[AppUtility mainViewFrame]];
    [mainView setBackgroundColor:[UIColor appBackgroundColor]];
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
    
    UIButton * backButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 20, 70, 44)];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_normal@2x"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed@2x"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backButton];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 27, 200, 30)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"上车地点"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor appNavTitleColor]];
    [titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [navBar addSubview:titleLabel];
    [titleLabel release];
    
    UIImage * welcomeImage = [UIImage imageNamed:@"nav_hint@2x"];
    //    welcomeImage = [welcomeImage stretchableImageWithLeftCapWidth:8 topCapHeight:10];
    //导航栏下方的欢迎条
    UIImageView * welcomeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 49)];
    [welcomeImgView setImage:welcomeImage];
    [mainView addSubview:welcomeImgView];
    [welcomeImgView release];
    
    UILabel * warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
    [warnLabel setBackgroundColor:[UIColor clearColor]];
    [warnLabel setText:[self.line.description stringByAppendingString:@"标志牌上车"]];
    [warnLabel setTextAlignment:NSTextAlignmentCenter];
    [warnLabel setTextColor:[UIColor whiteColor]];
    [warnLabel setFont:[UIFont appGreenWarnFont]];
    [welcomeImgView addSubview:warnLabel];
    [warnLabel release];
    
    MRZoomScrollView *zoomScrollView = [[MRZoomScrollView alloc]initWithFrame:CGRectMake(0, 64+44, 320, SCREEN_HEIGHT - 44-64)];
    [zoomScrollView.imageView setImageWithURL:[NSURL URLWithString:self.line.img] placeholderImage:nil];
    [mainView insertSubview:zoomScrollView belowSubview:welcomeImgView];
    [zoomScrollView release];
}

-(void)backToMain
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
