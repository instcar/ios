//
//  XHBKViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-18.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "XHBKViewController.h"
#import "UIImageView+WebCache.h"


@interface XHBKViewController ()

@end

@implementation XHBKViewController

-(void)dealloc
{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.dataInfo = [[NSDictionary alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	UIView * mainView = [[UIView alloc]initWithFrame:[AppUtility mainViewFrame]];
    mainView.userInteractionEnabled = YES;
    [mainView setBackgroundColor:[UIColor appBackgroundColor]];
    [self.view addSubview:mainView];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backBtnAction:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeGesture];
    
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
    
    UIButton * backButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 20, 70, 44)];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_normal@2x"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed@2x"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backButton];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 27, 120, 30)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"笑话百科"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor appNavTitleColor]];
    [titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [navBar addSubview:titleLabel];
    
    UIButton * shareButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [shareButton setFrame:CGRectMake(320- 70, 20, 70, 44)];
    [shareButton setBackgroundColor:[UIColor clearColor]];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"btn_shareWeibo_normal@2x"] forState:UIControlStateNormal];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"btn_shareWeibo_pressed@2x"] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:shareButton];
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 65, 320, SCREEN_HEIGHT - 65)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setBounces:NO];
    [mainView addSubview:scrollView];
    
//    UIImageView *imageBackGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(69., 20., 182., 222.)];
//    [imageBackGroundView setBackgroundColor:[UIColor whiteColor]];
//    [imageBackGroundView setImage:nil];
//    [mainView addSubview:imageBackGroundView];
//    [imageBackGroundView release];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 10, 200, 150.)];
    [imageView setBackgroundColor:[UIColor placeHoldColor]];
    [imageView.layer setShadowColor:[UIColor blackColor].CGColor];
    [imageView.layer setShadowOpacity:0.6];
    [imageView.layer setShadowOffset:CGSizeMake(0, 0)];
    [imageView.layer setShadowRadius:1];
    [imageView.layer setBorderWidth:2.0];
    [imageView.layer setBorderColor:[UIColor flatWhiteColor].CGColor];
    [imageView.layer setShadowPath:[UIBezierPath bezierPathWithRect:imageView.bounds].CGPath];
//    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setImageWithURL:[NSURL URLWithString:[self.dataInfo valueForKey:@"largepic"]] placeholderImage:[UIImage imageNamed:@"delt_pic_s"]];
    [scrollView addSubview:imageView];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 170, 280, 80)];
    [textView  setBackgroundColor:[UIColor clearColor]];
    [textView  setTextAlignment:NSTextAlignmentLeft];
    [textView  setTextColor:[UIColor colorWithRed:(float)63/255 green:(float)63/255 blue:(float)63/255 alpha:1.0]];
    [textView  setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [textView  setUserInteractionEnabled:NO];
    [textView setEditable:NO];
    textView.text = [NSString stringWithFormat:@"\t%@",[self.dataInfo valueForKey:@"content"]];
    [scrollView addSubview:textView];
    
    float height = [self heightForTextView:textView WithText:textView.text];
    [textView setFrame:CGRectMake(20, 170, 280, height)];
    
    UILabel *textLable = [[UILabel alloc]initWithFrame:CGRectMake(20, height + 170, 280, 30)];
    [textLable  setBackgroundColor:[UIColor clearColor]];
    [textLable  setTextAlignment:NSTextAlignmentRight];
    [textLable  setTextColor:[UIColor textGrayColor]];
    [textLable  setFont:[UIFont fontWithName:kFangZhengFont size:10]];
    [textLable  setUserInteractionEnabled:NO];
    [textLable setText:[NSString stringWithFormat:@"来自: %@",[self.dataInfo valueForKey:@"source"]]];
    [scrollView addSubview:textLable];
    
    [scrollView setContentSize:CGSizeMake(320, height + 200)];
    
}

- (void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareBtnAction:(UIButton *)sender
{
    //显示分享按钮
    DLog(@"分享");
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(textView.contentSize.width - fPadding, CGFLOAT_MAX);
    CGSize size = [strText sizeWithFont:[UIFont fontWithName:kFangZhengFont size:16] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
    float fHeight = size.height + 8;
    return fHeight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
