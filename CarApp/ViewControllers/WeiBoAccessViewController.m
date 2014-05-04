
//
//  WeiBoAccessViewController.m
//  CarApp
//
//  Created by 海龙 李 on 13-11-22.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "WeiBoAccessViewController.h"

@interface WeiBoAccessViewController ()

@end

@implementation WeiBoAccessViewController

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
    [mainView setBackgroundColor:[UIColor colorWithRed:(float)243/255 green:(float)243/255 blue:(float)243/255 alpha:1.0f]];
    [self.view addSubview:mainView];
    
    UIImage * naviBarImage = [UIImage imageNamed:@"navgationbar_64"];
    naviBarImage = [naviBarImage stretchableImageWithLeftCapWidth:4 topCapHeight:10];
    
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    [navBar setBackgroundImage:naviBarImage forBarMetrics:UIBarMetricsDefault];
    [mainView addSubview:navBar];
    
    if (kDeviceVersion < 7.0) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, navBar.frame.size.height, navBar.frame.size.width, 1)];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [navBar addSubview:lineView];
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
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 27, 120, 30)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"微博账号绑定"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor flatGreenColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [navBar addSubview:titleLabel];

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,64, 320, SCREEN_HEIGHT - 64)];
    _webView.delegate = self;
    [mainView insertSubview:_webView aboveSubview:navBar];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=1118290340&redirect_uri=http%3A%2F%2Flogin.qyer.com%2Flogin.php%3Faction%3Dweibo&response_type=code&display=mobile&with_offical_account=1"]];
    [_webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
//    NSString *url = request.URL.absoluteString;
    
//    if ([url hasPrefix:kWeiboRedirectURL])
//    {
//        NSString *error_code = [SinaWeiboRequest getParamValueFromUrl:url paramName:@"error_code"];
//        
//        if (error_code)
//        {
//            [self dismissModalViewControllerAnimated:YES];
//        }
//        else
//        {
//            if([url rangeOfString:@"error_code"].length)
//            {
//                [self dismissModalViewControllerAnimated:YES];
//            }
//            else
//            {
//                int begin = [url rangeOfString:@"="].location+1;
//                NSString *sina_access_code = [url substringFromIndex:(NSUInteger) begin];
//                
//                NSURL *url = [NSURL URLWithString:@"https://api.weibo.com"];
//                AFHTTPClient *httpClient = [[[AFHTTPClient alloc] initWithBaseURL:url] autorelease];
//                NSDictionary *params = @{@"client_id":kSinaAppKey,@"client_secret":kSinaAppSecret,@"grant_type":@"authorization_code",@"redirect_uri":kWeiboRedirectURL,@"code":sina_access_code};
//                
//            }
//        return NO;
//        }
//    }
    
    return YES;
}

-(void)backToMain
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
