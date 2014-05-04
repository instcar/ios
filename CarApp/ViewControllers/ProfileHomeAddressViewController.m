//
//  ProfileCompanyAddressViewController.m
//  CarApp
//
//  Created by 海龙 李 on 13-11-21.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "ProfileHomeAddressViewController.h"
@interface ProfileHomeAddressViewController ()

@end

@implementation ProfileHomeAddressViewController

@synthesize delegate = _delegate;

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
    
    UIView * mainView = [[UIView alloc]initWithFrame:[AppUtility mainViewFrame]];
    [mainView setBackgroundColor:[UIColor appBackgroundColor]];
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
    [titleLabel setText:@"家庭地址"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor appNavTitleColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [navBar addSubview:titleLabel];
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(320-70, 20, 70, 44)];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_confirm_normal@2x"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_confirm_pressed@2x"] forState:UIControlStateHighlighted];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_confirm_pressed@2x"] forState:UIControlStateSelected];
    [saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:saveBtn];
    
    
    UIImage * welcomeImage = [UIImage imageNamed:@"nav_hint@2x"];
    //    welcomeImage = [welcomeImage stretchableImageWithLeftCapWidth:8 topCapHeight:10];
    //导航栏下方的欢迎条
    UIImageView * welcomeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 49)];
    [welcomeImgView setImage:welcomeImage];
    [mainView addSubview:welcomeImgView];
    
    UILabel * welcomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 310, 44)];
    [welcomeLabel setBackgroundColor:[UIColor clearColor]];
    [welcomeLabel setText:@"地址可为单个或多个，多个地址请用空格或“;”号隔开"];
    [welcomeLabel setTextAlignment:NSTextAlignmentCenter];
    [welcomeLabel setTextColor:[UIColor whiteColor]];
    [welcomeLabel setFont:[UIFont appGreenWarnFont]];
    [welcomeImgView addSubview:welcomeLabel];

    UIImage * txfBackImg = [UIImage imageNamed:@"input_white_normal"];
    txfBackImg = [txfBackImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    UIImage * txfBackSelectedImg = [UIImage imageNamed:@"input_white_pressed"];
    txfBackSelectedImg = [txfBackSelectedImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    //        UIImage * txfBackErrImg = [UIImage imageNamed:@"input_error@2x"];
    //        txfBackSelectedImg = [txfBackSelectedImg stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
    UIImageView *backGtextImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 64+49+15, 300, 250)];
    [backGtextImgView  setImage:txfBackImg];
    [mainView addSubview:backGtextImgView];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(25, 64+49+25, 270, 230)];
    textView.tag = 91001;
    [textView  setBackgroundColor:[UIColor whiteColor]];
    [textView  setTextAlignment:NSTextAlignmentLeft];
    [textView  setTextColor:[UIColor colorWithRed:(float)63/255 green:(float)63/255 blue:(float)63/255 alpha:1.0]];
    [textView  setFont:[UIFont fontWithName:kFangZhengFont size:16]];
    [mainView addSubview:textView];
    
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=50)
    {
        return  NO;
    }
    else
    {
        return YES;
    }
}


-(void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveAction:(UIButton *)sender
{
    UITextView *textView  = (UITextView *)[self.view viewWithTag:91001];
    
    //    [NetWorkManager networkEdithomeaddressWithuid:[User shareInstance].userId homeaddress:textView.text success:^(BOOL flag) {
    //        if (flag) {
    //            //保存用户数据
    ////            [User shareInstance].
    //        }
    //    } failure:^(NSError *error) {
    //
    //    }];
    if ([textView.text length]>0) {
        
        [_delegate saveHomeAddress:textView.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)keyDoneAction:(id)sender
{
    UITextView *textView  = (UITextView *)[self.view viewWithTag:91001];
    [textView resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
