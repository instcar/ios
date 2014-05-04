//
//  LogInViewController.m
//  CarApp
//
//  Created by leno on 13-10-14.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "LogInViewController.h"
#import "MainViewController.h"
#import "RegisterViewController.h"
#import "ForgetPassWordViewController.h"
#import "GDInputView.h"
#import "XmppManager.h"

@interface LogInViewController ()<UITextFieldDelegate>

@end

@implementation LogInViewController

-(void)dealloc
{

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
}

- (void)viewDidLoad
{
    _mainScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [_mainScrollView setScrollEnabled:YES];
    [self.view addSubview:_mainScrollView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 180, 50)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"天地设立\n    而易行乎其中矣"];
    [titleLabel setTextAlignment:0];
    [titleLabel setLineBreakMode:0];
    [titleLabel setNumberOfLines:2];
    [titleLabel setTextColor:[UIColor colorWithRed:60./255.0 green:60./255.0 blue:60./255.0 alpha:1]];
    [titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [_mainScrollView addSubview:titleLabel];
    
    UIImageView * headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(320-130,30, 110, 25)];
    [headerImgView setTag:10002];
    [headerImgView setBackgroundColor:[UIColor clearColor]];
    [headerImgView setImage:[UIImage imageNamed:@"logo_start"]];
    [_mainScrollView addSubview:headerImgView];
    
    //输入框
    _inputView = [[UIView alloc]initWithFrame:CGRectMake(40,24+55, 240, 180)];
    [_inputView setClipsToBounds:NO];
    [_inputView setHidden:YES];
    [_mainScrollView addSubview:_inputView];
    
    _errorWarnLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 230, 36)];
    [_errorWarnLable setBackgroundColor:[UIColor clearColor]];
    [_errorWarnLable setTextAlignment:0];
    [_errorWarnLable setTextColor:[UIColor redColor]];
    [_errorWarnLable setFont:[UIFont fontWithName:kFangZhengFont size:14]];
    [_inputView addSubview:_errorWarnLable];
    
    //账号
    _userInputView = [[GDInputView alloc]initWithFrame:CGRectMake(5, 40, 230, 36)];
    [_userInputView setAlpha:1.0];
    [_userInputView.textfield setTag:110];
    [_userInputView setGdInputDelegate:self];
//    [_userInputView.textfield setPlaceholder:@"账号/手机号/邮箱"];
    [_userInputView.textfield setPlaceholder:@"手机号"];
    [_userInputView.textfield setText:[User shareInstance].phoneNum];
    [_userInputView setResult:([User shareInstance].phoneNum && ![[User shareInstance].phoneNum isEqualToString:@""])?kGDInputViewStatusTure:kGDInputViewStatusNomal];
    [_inputView addSubview:_userInputView];
    
    //密码
    _codeInputView = [[GDInputView alloc]initWithFrame:CGRectMake(5, 90, 230, 36)];
    [_codeInputView setAlpha:1.0];
    [_codeInputView.textfield setTag:111];
    [_codeInputView setGdInputDelegate:self];
    [_codeInputView.textfield setPlaceholder:@"密码"];
    [_codeInputView.textfield setSecureTextEntry:YES];
    [_codeInputView.textfield setText:[User shareInstance].userPwd];
    [_codeInputView setResult:([User shareInstance].userPwd && ![[User shareInstance].userPwd isEqualToString:@""])?kGDInputViewStatusTure:kGDInputViewStatusNomal];
    [_inputView addSubview:_codeInputView];
    
    //登入按钮
    UIImage * logBackImg = [UIImage imageNamed:@"btn_blue"];
    logBackImg = [logBackImg stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.showsTouchWhenHighlighted = YES;
    [_loginBtn setFrame:CGRectMake(5, 140, 230, 36)];
    [_loginBtn setBackgroundImage:logBackImg forState:UIControlStateNormal];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:16]];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_loginBtn addTarget:self action:@selector(ensureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_inputView addSubview:_loginBtn];
    
    //底部注册和忘记密码按钮
    _bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 48, 320, 48)];
    [_bottomView setImage:[UIImage imageNamed:@"tab_bar"]];
    [_bottomView setUserInteractionEnabled:YES];
    [self.view addSubview:_bottomView];
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBtn setBackgroundColor:[UIColor clearColor]];
    [_registerBtn setFrame:CGRectMake(20, 9, 130, 32)];
    [_registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_m"] forState:UIControlStateNormal];
    [_registerBtn setImage:[UIImage imageNamed:@"ic_registration"] forState:UIControlStateNormal];
    [_registerBtn.titleLabel setFont:AppFont(14)];
    [_registerBtn addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_registerBtn setTitle:@"免费注册" forState:UIControlStateNormal];
    [_bottomView addSubview:_registerBtn];
    
    _forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_forgetBtn setTag:1002];
    [_forgetBtn setBackgroundColor:[UIColor clearColor]];
    [_forgetBtn setFrame:CGRectMake(170, 9, 130, 32)];
    [_forgetBtn setBackgroundImage:[UIImage imageNamed:@"btn_empty_m"] forState:UIControlStateNormal];
    [_forgetBtn.titleLabel setFont:AppFont(14)];
    [_forgetBtn setTitle:@"忘记密码了?" forState:UIControlStateNormal];
    [_forgetBtn addTarget:self action:@selector(forgetBtnClikcked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_forgetBtn];
    
    //点击屏幕取消textField响应
//    UITapGestureRecognizer * tappp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
//    [mainView addGestureRecognizer:tappp];
//    [tappp release];
    
    [self performSelector:@selector(inputViewanimation) withObject:nil afterDelay:0.1];
}

-(void)inputViewanimation
{
    [_userInputView.textfield setText:[User shareInstance].phoneNum];
    [_codeInputView.textfield setText:[User shareInstance].userPwd];
    [_inputView setFrame:CGRectMake(40, SCREEN_HEIGHT-48-180, 240, 180)];
    [_inputView setHidden:NO];
    [_inputView setAlpha:0.0];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [_inputView setFrame:CGRectMake(40,24+55, 240, 180)];
    [_inputView setAlpha:1.0];

    [UIView commitAnimations];
    
    //标志动画
//    UILabel *titleLable = (UILabel *)[self.view viewWithTag:10001];
//    UIImageView *headImgView = (UIImageView *)[self.view viewWithTag:10002];
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1.0];
//    [UIView setAnimationDelegate:self];
//    [inputView setFrame:CGRectMake(40,24+55, 240, 180)];
//    [inputView setAlpha:1.0];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView commitAnimations];
    
}

-(void)hideKeyBoard
{
    [_userInputView.textfield resignFirstResponder];
    [_codeInputView.textfield resignFirstResponder];
}

#pragma mark - 按钮事件
//注册
-(void)registerBtnClicked:(id)sender
{
    DLog(@"注册");
    RegisterViewController * registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

//忘记密码
-(void)forgetBtnClikcked:(id)sender
{
    DLog(@"忘记密码");
    ForgetPassWordViewController * forgetVC = [[ForgetPassWordViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

//登入按钮
-(void)ensureBtnClicked:(UIButton *)sender
{
    
    NSString *userText = _userInputView.textfield.text;
    NSString *codeText = _codeInputView.textfield.text;
    
    [self hideKeyBoard];
    
    if ([userText isEqualToString:@""] || userText == nil ) {
        [_userInputView setResult:kGDInputViewStatusError];
        [_errorWarnLable setText:@"用户名不能为空"];
        return;
    }
    if ([codeText isEqualToString:@""] || codeText == nil ) {
        [_codeInputView setResult:kGDInputViewStatusError];
        [_errorWarnLable setText:@"密码不能为空"];
        return;
    }
    [self userLoginWithAccount:userText passWord:codeText];
}

#pragma mark - 交互
-(void)userLoginWithAccount:(NSString *)account passWord:(NSString *)password
{
    [self hideKeyBoard];
    MBProgressHUD *hub = [MBProgressHUD showMessag:@"正在登录" toView:self.view];
    [APIClient networkUserLoginWithPhone:account password:password success:^(Respone *respone) {
        if (respone.status == kEnumServerStateSuccess) {
            
            [hub setLabelText:@"登录成功"];
            [hub hide:YES afterDelay:0.7];
            
            //保存信息
            User * user = [User shareInstance];
            if ([respone.data valueForKey:@"id"]) {
                user.userId = [((NSString *)[respone.data valueForKey:@"id"])longLongValue];
            }
            user.phoneNum = account;
            user.userPwd = password;
            user.isSavePwd = YES;
            
            UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:[AppDelegate shareDelegate].mainVC];
            [AppDelegate shareDelegate].mainVC.firstEnter = YES;
            [[AppDelegate shareDelegate].mainVC enterView];
            [navi setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:navi animated:YES completion:^{
                [[AppDelegate shareDelegate].window setRootViewController:navi];
            }];
        }
        else
        {
            [hub setLabelText:respone.msg];
            [hub hide:YES afterDelay:0.7];
            [_errorWarnLable setText:respone.msg];
            [_userInputView setResult:kGDInputViewStatusError];
            [_codeInputView setResult:kGDInputViewStatusError];
        }
    }failure:^(NSError *error) {
        [hub hide:YES];
    }];
}

//-(void)checkAccountType:(NSString *)account accountType:(void (^)(int type))accountType
//{
//    //检测是否为手机号
//    BOOL state = [AppUtility validateMobile:account];
//    
//    if(state)
//    {
//        //继续使用网络检测手机号（检查用户是否使用手机号作为用户名来登入）
//        //检测手机号码
//        [NetWorkManager networkCheckPhone:account success:^(int status, NSObject *data, NSString *msg) {
//            if (status == 200) {
//                accountType(1);
//            }
//            else
//            {
//                accountType(2);
//            }
//        } failure:^(NSError *error) {
//            
//        }];
//    }
//    else
//    {
//        accountType(1);
//    }
//}
#pragma mark - textDelegate
-(void)textFieldDidChanged:(UITextField *)textField
{
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_errorWarnLable setText:@""];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField.text length] == 0)
    {
        [_userInputView setResult:kGDInputViewStatusNomal];
        return;
    }
    //输入正确与否判断
    if (textField.tag == 110) {
        if(![AppUtility validateMobile:textField.text])
        {
            [_errorWarnLable setText:@"手机号格式不正确"];
            [_userInputView setResult:kGDInputViewStatusError];
        }
    }
    if (textField.tag == 111) {
        if([textField.text length] < 6)
        {
            [_errorWarnLable setText:@"密码长度不正确"];
            [_codeInputView setResult:kGDInputViewStatusError];
        }
    }
}

-(void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
