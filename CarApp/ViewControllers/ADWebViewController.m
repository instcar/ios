//
//  ADWebViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-1-6.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "ADWebViewController.h"
#import "SafetyRelease.h"

@interface ADWebViewController ()<UIWebViewDelegate>
@property (retain, nonatomic) UIWebView *adWebView;
@end

@implementation ADWebViewController

-(void)dealloc
{
    [SafetyRelease release:_adWebView];
    [SafetyRelease release:_url];
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
    [mainView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:mainView];
    [mainView release];

    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backAction:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeGesture];
    [swipeGesture release];
    
    UIWebView *adWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, 320, SCREEN_HEIGHT-40-20)];
    [adWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url]]];
    [adWebView setDelegate:self];
    [adWebView.scrollView setBackgroundColor:[UIColor whiteColor]];
    [adWebView.scrollView setShowsVerticalScrollIndicator:NO];
    [adWebView.scrollView setShowsHorizontalScrollIndicator:NO];
//    [adWebView.scrollView setClipsToBounds:NO];
    [mainView addSubview:adWebView];
    self.adWebView = adWebView;
    [adWebView release];
    
    //底部导航栏
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, 320, 40)];
    [toolBar setTranslucent:YES];

    
    if (kDeviceVersion >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        [toolBar setBarTintColor:[UIColor whiteColor]];
    }
    else
    {
        [toolBar setTintColor:[UIColor whiteColor]];
        [toolBar setBackgroundImage:[UIImage imageNamed:@"navgationbar_44"] forToolbarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    }
    [mainView addSubview:toolBar];
    [toolBar release];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [backBtn setShowsTouchWhenHighlighted:YES];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"tb_icon_toolbar_back_56"] forState:UIControlStateHighlighted];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"tb_icon_toolbar_back_56"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [backBtn release];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *backForwardBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [backForwardBtn setShowsTouchWhenHighlighted:YES];
    [backForwardBtn setBackgroundImage:[UIImage imageNamed:@"tb_icon_toolbar_backward_disable_56"] forState:UIControlStateDisabled];
    [backForwardBtn setBackgroundImage:[UIImage imageNamed:@"tb_icon_toolbar_backward_normal_56"] forState:UIControlStateNormal];
    [backForwardBtn addTarget:self action:@selector(backForwardAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backForwardBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backForwardBtn];
    [backForwardBtn release];
    
    UIButton *frontForwardBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [frontForwardBtn setShowsTouchWhenHighlighted:YES];
    [frontForwardBtn setBackgroundImage:[UIImage imageNamed:@"tb_icon_toolbar_forward_disable_56"] forState:UIControlStateDisabled];
    [frontForwardBtn setBackgroundImage:[UIImage imageNamed:@"tb_icon_toolbar_forward_normal_56"] forState:UIControlStateNormal];
    [frontForwardBtn addTarget:self action:@selector(frontForwardAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *frontForwardBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:frontForwardBtn];
    [frontForwardBtn release];
    
    UIButton *reflushBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [reflushBtn setShowsTouchWhenHighlighted:YES];
    [reflushBtn setBackgroundImage:[UIImage imageNamed:@"tb_icon_toolbar_refresh_56"] forState:UIControlStateNormal];
//    [reflushBtn setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed@2x"] forState:UIControlStateHighlighted];
    [reflushBtn addTarget:self action:@selector(reflushAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *reflushButtonItem = [[UIBarButtonItem alloc]initWithCustomView:reflushBtn];
    [reflushBtn release];
    
    [toolBar setItems:[NSArray arrayWithObjects:backBarButtonItem,spaceItem,backForwardBarButtonItem,frontForwardBarButtonItem,reflushButtonItem,nil]];
    [backBarButtonItem release];
    [backForwardBarButtonItem release];
    [frontForwardBarButtonItem release];
    [reflushButtonItem release];
}

- (void)backAction:(UIButton *)sender
{
    if ([self.adWebView isLoading]) {
        [self.adWebView stopLoading];
    }
    
    [self.adWebView setDelegate:nil];
    self.adWebView = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backForwardAction:(UIButton *)sener
{
    if ([self.adWebView canGoBack]) {
       [self.adWebView goBack];
    }
}

- (void)frontForwardAction:(UIButton *)sener
{
    if ([self.adWebView canGoForward]) {
        [self.adWebView goForward];
    }
}

- (void)reflushAction:(UIButton *)sender
{
    if (![self.adWebView isLoading]) {
        [self.adWebView reload];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
