//
//  CommonViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-17.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController
-(void)dealloc
{
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
    
    UIImage * naviBarImage = [UIImage imageNamed:@"navgationbar_64"];
    naviBarImage = [naviBarImage stretchableImageWithLeftCapWidth:4 topCapHeight:10];
    
    float navWidth = (kDeviceVersion >= 7.0?64.0:44.0);
    
    _navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, navWidth)];
    [_navBar setBackgroundImage:naviBarImage forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:_navBar];
    [_navBar release];
    
    if (kDeviceVersion < 7.0) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _navBar.frame.size.height, _navBar.frame.size.width, 1)];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [_navBar addSubview:lineView];
        [lineView release];
    }
    else
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 27, 200, 30)];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor appNavTitleColor]];
    [_titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [_navBar addSubview:_titleLabel];
    [_titleLabel release];
    
    _headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 110,BarButtonoffsetY+2, 110, 25)];
    [_headerImgView setBackgroundColor:[UIColor clearColor]];
    [_headerImgView setImage:[UIImage imageNamed:@"logo_start"]];
    [_navBar addSubview:_headerImgView];
    [_headerImgView setHidden:YES];
    [_headerImgView release];
    
    float messageOffsetY = (kDeviceVersion >= 7.0?64:44);
    
    UIImage * welcomeImage = [UIImage imageNamed:@"nav_hint@2x"];
    //    welcomeImage = [welcomeImage stretchableImageWithLeftCapWidth:8 topCapHeight:10];
    //导航栏下方的欢迎条
    _messageBgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, messageOffsetY, 320, 49)];
    [_messageBgView setImage:welcomeImage];
    [self.view addSubview:_messageBgView ];
    [_messageBgView release];
    
    _desLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
    [_desLable setTag:5876];
    [_desLable setBackgroundColor:[UIColor clearColor]];
    [_desLable setTextAlignment:NSTextAlignmentLeft];
    [_desLable setTextColor:[UIColor whiteColor]];
    [_desLable setFont:[UIFont appGreenWarnFont]];
    [_messageBgView insertSubview:_desLable belowSubview:_navBar];
    [_desLable release];
    
    UIButton * backButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(BarButtonoffsetX, BarButtonoffsetY, 40, 30)];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_normal@2x"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed@2x"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    [_navBar addSubview:backButton];
}

-(void)setCtitle:(NSString *)ctitle
{
    if (ctitle) {
        [_ctitle release];
        _ctitle = ctitle;
    }
    if ([ctitle isEqualToString:@"logo"]) {
        [_titleLabel setHidden:YES];
        [_headerImgView setHidden:NO];
    }
    else
    {
        [_titleLabel setHidden:NO];
        [_headerImgView setHidden:YES];
    }

    [_titleLabel setText:ctitle];
}

- (void)setDesText:(NSString *)desText
{
    if (desText) {
        
        [_desText release];
        _desText = desText;
        
        if ([desText isEqualToString:@"null"]) {
            [_messageBgView setHidden:YES];
        }
        else
        {
            [_messageBgView setHidden:NO];
            [_desLable setText:desText];
        }
    }
    else
    {
        [_desLable setText:@"主人比较懒，都没有写心情偶"];
    }
    
}

- (void)setMessageView:(UIView *)messageView
{
    
}

- (void)setLeftBtn:(UIButton *)leftBtn
{
    if (leftBtn) {
        [_leftBtn release];
        _leftBtn = leftBtn;
    }
    [_leftBtn setFrame:CGRectMake(BarButtonoffsetX, BarButtonoffsetY, 40, 30)];
    [_navBar addSubview:_leftBtn];
}

- (void)setRightBtn:(UIButton *)rightBtn
{
    if (rightBtn) {
        [_rightBtn release];
        _rightBtn = rightBtn;
    }
    [_rightBtn setFrame:CGRectMake(SCREEN_WIDTH - 40 - BarButtonoffsetX, BarButtonoffsetY, 40, 30)];
    [_navBar addSubview:_rightBtn];
    
}

- (void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
