//
//  StartViewController.m
//  CarApp
//
//  Created by Leno on 13-9-27.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "StartViewController.h"
#import "LogInViewController.h"
#import "RegisterViewController.h"
#import "ForgetPassWordViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

-(void)dealloc
{

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[LocationServer shareInstance] startLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - 48)];
    [_mainScrollView setDelegate:self];
    [_mainScrollView setShowsHorizontalScrollIndicator:NO];
    [_mainScrollView setShowsVerticalScrollIndicator:NO];
    [_mainScrollView setBackgroundColor:[UIColor clearColor]];
    [_mainScrollView setPagingEnabled:YES];
    [_mainScrollView setBounces:NO];
    [_mainScrollView setContentSize:CGSizeMake(320 *4, SCREEN_HEIGHT - 48)];
    [self.view addSubview:_mainScrollView];
    
    for (int i = 0 ; i < 4; i++) {
        for (int i = 0 ; i < 4; i++) {
            
            UIImageView * infoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(320 *i, 0, 320, SCREEN_HEIGHT-48)];
            [infoImgView setContentMode:UIViewContentModeCenter];
            [infoImgView setClipsToBounds:YES];
            [infoImgView setBackgroundColor:[UIColor clearColor]];
            NSString * str = [NSString stringWithFormat:@"st%d.jpg",i+1];
            if (IS_IPHONE_5) {
                str = [NSString stringWithFormat:@"st%d-568.jpg",i+1];
            }
            [infoImgView setImage:[UIImage imageNamed:str]];
            [_mainScrollView addSubview:infoImgView];
        }
    }
    
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setBackgroundColor:[UIColor clearColor]];
    [loginBtn setFrame:CGRectMake(320*3+45, IS_IPHONE_5?SCREEN_HEIGHT-48-82:SCREEN_HEIGHT-48-55, 210, 35)];
    [loginBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
    [loginBtn setShowsTouchWhenHighlighted:YES];
    [loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:loginBtn];
    
    _bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 48, 320, 48)];
    [_bottomView setImage:[UIImage imageNamed:@"tab_bar"]];
    [_bottomView setUserInteractionEnabled:YES];
    [self.view addSubview:_bottomView];
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBtn setBackgroundColor:[UIColor clearColor]];
    [_registerBtn setFrame:CGRectMake(20, 9, 130, 32)];
    [_registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_m"] forState:UIControlStateNormal];
    [_registerBtn setImage:[UIImage imageNamed:@"ic_registration"] forState:UIControlStateNormal];
    [_registerBtn.titleLabel setFont:AppFont(14)];
    [_registerBtn setTitle:@"免费注册" forState:UIControlStateNormal];
    [_registerBtn addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_registerBtn];

    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setBackgroundColor:[UIColor clearColor]];
    [_loginBtn setFrame:CGRectMake(170, 9, 130, 32)];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_green"] forState:UIControlStateNormal];
    [_loginBtn.titleLabel setFont:AppFont(14)];
    [_loginBtn setImage:[UIImage imageNamed:@"ic_login"] forState:UIControlStateNormal];
    [_loginBtn setTitle:@"登入" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_loginBtn];
}

#pragma mark - btnAction
//忘记密码
-(void)forgetPasswordBtnClicked:(id)sender
{
    DLog(@"忘记密码");
    ForgetPassWordViewController * forgetVC = [[ForgetPassWordViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

//登入
-(void)loginBtnClicked:(id)sender
{
    DLog(@"登入");
    LogInViewController * logInVC = [[LogInViewController alloc]init];
    UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:logInVC];
    [nav setNavigationBarHidden:YES animated:NO];
    [nav setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:nav animated:YES completion:nil];

}

//注册
-(void)registerBtnClicked:(id)sender
{
    DLog(@"注册");
    RegisterViewController * registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark - scrollerViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offSetX = scrollView.contentOffset.x;
    int page = offSetX/320;
    
    //改变按钮
    if (page == 3) {
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_empty_m"] forState:UIControlStateNormal];
        [_loginBtn setImage:nil forState:UIControlStateNormal];
        [_loginBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_loginBtn removeTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_loginBtn addTarget:self action:@selector(forgetPasswordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_green"] forState:UIControlStateNormal];
        [_loginBtn setImage:[UIImage imageNamed:@"ic_login"] forState:UIControlStateNormal];
        [_loginBtn setTitle:@"登入" forState:UIControlStateNormal];
        [_loginBtn removeTarget:self action:@selector(forgetPasswordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
