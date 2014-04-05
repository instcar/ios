//
//  AgreementViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-5.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "AgreementViewController.h"

@implementation AgreementViewController

-(void)dealloc
{
    [SafetyRelease release:_webView];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    UIView * mainView = [[UIView alloc]initWithFrame:[AppUtility mainViewFrame]];
    [mainView setBackgroundColor:[UIColor flatWhiteColor]];
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
    
    //App标题
    UIImageView * titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake((320-50)/2, 20, 50, 44)];
    [titleImgView setImage:[UIImage imageNamed:@"logo_normal@2x"]];
    [navBar addSubview:titleImgView];
    [titleImgView release];
    
    UIImage * welcomeImage = [UIImage imageNamed:@"nav_hint@2x"];
    //    welcomeImage = [welcomeImage stretchableImageWithLeftCapWidth:8 topCapHeight:10];
    //导航栏下方的欢迎条
    UIImageView * welcomeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 49)];
    [welcomeImgView setImage:welcomeImage];
    [mainView addSubview:welcomeImgView ];
    [welcomeImgView release];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
    [titleLabel setTag:5876];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    User *user = [User shareInstance];
    [titleLabel setText:[NSString stringWithFormat:@"%@,请仔细查阅相关协议噢",user.userName]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont appGreenWarnFont]];
    [welcomeImgView insertSubview:titleLabel belowSubview:navBar];
    [titleLabel release];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64+45, 320, SCREEN_HEIGHT -64-45)];
    [_webView setDelegate:self];
    _webView.scalesPageToFit = YES;
    [mainView insertSubview:_webView belowSubview:welcomeImgView];
    
    [self loadDocument:@"agreement"];
}

- (void)loadDocument:(NSString*)docName {
    NSString *filePath = [ [NSBundle mainBundle] pathForResource:docName ofType:@"htm"];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *htmlstring=[[NSString alloc] initWithContentsOfFile:filePath  encoding:enc error:nil];
    [_webView loadHTMLString:htmlstring  baseURL:[NSURL fileURLWithPath: [ [NSBundle mainBundle]  bundlePath]]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

-(void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
