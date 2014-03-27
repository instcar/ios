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
    if (kDeviceVersion >= 7.0) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    UIView * mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:mainView];
    [mainView release];
    
    UIScrollView * mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - 48)];
    [mainScrollView setTag:100001];
    [mainScrollView setDelegate:self];
    [mainScrollView setShowsHorizontalScrollIndicator:NO];
    [mainScrollView setShowsVerticalScrollIndicator:NO];
    [mainScrollView setBackgroundColor:[UIColor clearColor]];
    [mainScrollView setPagingEnabled:YES];
    [mainScrollView setBounces:NO];
    [mainScrollView setContentSize:CGSizeMake(320 *4, SCREEN_HEIGHT - 48)];
    [mainView addSubview:mainScrollView];
    [mainScrollView release];
    
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
        [mainScrollView addSubview:infoImgView];
        [infoImgView release];
    }
    
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setBackgroundColor:[UIColor clearColor]];
    [loginBtn setFrame:CGRectMake(320*3+55, SCREEN_HEIGHT-48-77/2, 210, 35)];
    [loginBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
    [loginBtn setShowsTouchWhenHighlighted:YES];
    [loginBtn addTarget:self action:@selector(logInBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:loginBtn];
    
    UIImageView * bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 48, 320, 48)];
    [bottomView setImage:[UIImage imageNamed:@"tab_bar"]];
    [bottomView setUserInteractionEnabled:YES];
    [mainView addSubview:bottomView];
    [bottomView release];
    
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setBackgroundColor:[UIColor clearColor]];
    [registerBtn setFrame:CGRectMake(20, 9, 130, 32)];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_register_normal"] forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_register_pressed"] forState:UIControlStateHighlighted];
    [registerBtn addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:registerBtn];

    UIButton * logInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logInBtn setTag:1002];
    [logInBtn setBackgroundColor:[UIColor clearColor]];
    [logInBtn setFrame:CGRectMake(170, 9, 130, 32)];
    [logInBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_normal@2x"] forState:UIControlStateNormal];
    [logInBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_pressed@2x"] forState:UIControlStateHighlighted];
    [logInBtn addTarget:self action:@selector(logInBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:logInBtn];
}

#pragma mark - btnAction
//忘记密码
-(void)forgetPasswordBtnClicked:(id)sender
{
    DLog(@"忘记密码");
    ForgetPassWordViewController * forgetVC = [[ForgetPassWordViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
    [forgetVC release];
}

//登入
-(void)logInBtnClicked:(id)sender
{
    DLog(@"登入");
    LogInViewController * logInVC = [[LogInViewController alloc]init];
    UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:logInVC];
    [nav setNavigationBarHidden:YES animated:NO];
    [nav setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:nav animated:YES completion:nil];
    [logInVC release];
    [nav release];
}

//注册
-(void)registerBtnClicked:(id)sender
{
    DLog(@"注册");
    RegisterViewController * registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
    [registerVC release];
}

#pragma mark - scrollerViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offSetX = scrollView.contentOffset.x;
    int page = offSetX/320;
    UIButton * logInBtn = (UIButton *)[self.view viewWithTag:1002];
    if (page == 3) {
        [logInBtn setBackgroundImage:[UIImage imageNamed:@"btn_forget_normal@2x"] forState:UIControlStateNormal];
        [logInBtn setBackgroundImage:[UIImage imageNamed:@"btn_forget_pressed@2x"] forState:UIControlStateHighlighted];
        [logInBtn removeTarget:self action:@selector(logInBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [logInBtn addTarget:self action:@selector(forgetPasswordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [logInBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_normal@2x"] forState:UIControlStateNormal];
        [logInBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_pressed@2x"] forState:UIControlStateHighlighted];
        [logInBtn removeTarget:self action:@selector(forgetPasswordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [logInBtn addTarget:self action:@selector(logInBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
