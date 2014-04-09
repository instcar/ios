//
//  RegisterViewController.m
//  CarApp
//
//  Created by 海龙 李 on 13-11-6.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "RegisterViewController.h"
#import "MBProgressHUD+Add.h"

@interface RegisterViewController ()

@property (retain, nonatomic) NSTimer *countTimer;

@end

@implementation RegisterViewController

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
    
//    UIImage * naviBarImage = [UIImage imageNamed:@"navgationbar_64"];
//    naviBarImage = [naviBarImage stretchableImageWithLeftCapWidth:4 topCapHeight:10];
//    
//    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//    [navBar setBackgroundImage:naviBarImage forBarMetrics:UIBarMetricsDefault];
//    [navBar setBackgroundColor:[UIColor clearColor]];
//    if (kDeviceVersion >= 7.0) {
//        [navBar setBarTintColor:[UIColor clearColor]];
//    }
//    [navBar setTintColor:[UIColor clearColor]];
//    [self.view addSubview:navBar];
//    [navBar release];

    UIButton * backButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 70, 44)];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_normal@2x"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed@2x"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIImageView * headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(105,49, 110, 25)];
    [headerImgView setBackgroundColor:[UIColor clearColor]];
    [headerImgView setImage:[UIImage imageNamed:@"logo_start"]];
    [self.view addSubview:headerImgView];
    [headerImgView release];
    
    //输入框
    _inputView = [[GDInputView alloc]initWithFrame:CGRectMake(45, 44 + 50 , 230, 36)];
    [_inputView setAlpha:1.0];
    [_inputView.textfield setPlaceholder:@"请输入您的手机号"];
    [self.view addSubview:_inputView];
    [_inputView release];
    
    //获取验证码
    _authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_authBtn setShowsTouchWhenHighlighted:YES];
    [_authBtn setFrame:CGRectMake(45, 130 + 10, 230, 36)];
    [_authBtn setBackgroundImage:[[UIImage imageNamed:@"btn_orange"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [_authBtn setBackgroundImage:[[UIImage imageNamed:@"btn_empty"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateDisabled];
    [_authBtn setTitle:@"免费获取验证码" forState:UIControlStateNormal];
    [_authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_authBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:16]];
    [_authBtn addTarget:self action:@selector(getCodeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_authBtn];
    
    //输入框
    _authInputView = [[GDInputView alloc]initWithFrame:CGRectMake(45,176+10, 230, 36)];
    [_authInputView.textfield setPlaceholder:@"请输入6位短信验证"];
    [self.view addSubview:_authInputView];
    [_authInputView release];
    
    //输入框
    _passInputView = [[GDInputView alloc]initWithFrame:CGRectMake(45,222+10, 230, 36)];
    [_passInputView.textfield setSecureTextEntry:YES];
    [_passInputView.textfield setPlaceholder:@"请输入6-12位密码"];
    [self.view addSubview:_passInputView];
    [_passInputView release];
    
    //发送验证码
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setShowsTouchWhenHighlighted:YES];
    [_confirmBtn setFrame:CGRectMake(45, 268+10, 230, 36)];
    [_confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_green"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [_confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_empty"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateDisabled];
    [_confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_confirmBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:16]];
    [_confirmBtn addTarget:self action:@selector(sendCodeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn setEnabled:NO];
    [self.view addSubview:_confirmBtn];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    [_inputView.textfield resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.countTimer && [self.countTimer isValid]) {
        [self.countTimer invalidate];
    }
}

-(void)getCodeBtnClicked:(id)sender
{
    NSString * numbers = _inputView.textfield.text;
    
    bool isPhoneCorrect = [AppUtility validateMobile:numbers];
    
    if (isPhoneCorrect) {
        DLog(@"手机号正确");
        //检测手机号是否被注册之后再获取验证码
        [self checkPhone:numbers success:^{
            
            [_confirmBtn setEnabled:YES];
            //保存信息
            [User shareInstance].phoneNum = numbers;
            self.countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countSecond:) userInfo:nil repeats:YES];
            _leftSeconds = 60;

        } failure:^(NSString *message) {
            [MBProgressHUD showError:message toView:self.view];
        }];
    }
    else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号以便接收验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)countSecond:(NSTimer *)timer
{
    if (_leftSeconds >= 1) {
        _leftSeconds = _leftSeconds -1;
        [_authBtn setEnabled:NO];
        [_authBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_authBtn setTitle:[NSString stringWithFormat:@"(%d秒)后重新获取验证码",_leftSeconds] forState:UIControlStateDisabled];
    }
    else{
        [_inputView.textfield setText:@""];
        [_inputView.textfield resignFirstResponder];
        [_inputView.textfield setPlaceholder:@"请输入您的手机号"];
        [_authBtn setEnabled:YES];
        [_authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_authBtn setTitle:@"免费获取验证码" forState:UIControlStateNormal];
        if ([self.countTimer isValid]) {
            [_countTimer invalidate];
        }
    }
}

#pragma mark --注册用户
-(void)sendCodeBtnClicked:(id)sender
{
    NSString * phoneNumbers = _inputView.textfield.text;
    NSString * password = _passInputView.textfield.text;
    NSString * authword = _authInputView.textfield.text;
    
    //输入异常
    if (phoneNumbers.length < 11) {
        [MBProgressHUD showError:@"手机号有误" toView:self.view];
        return;
    }
    
    if (authword.length < 6 && authword.length > 6) {
        [MBProgressHUD showError:@"验证码有误" toView:self.view];
        return;
    }
    
    if (password.length < 6 && password.length > 12) {
        [MBProgressHUD showError:@"密码长度有误" toView:self.view];
        return;
    }
    //注册用户
    [APIClient networkUserRegistWithPhone:phoneNumbers password:password authcode:authword smsid:_smsid success:^(Respone *respone) {
        if (respone.status == kEnumServerStateSuccess) {
            [[User shareInstance]setUserId:[[respone.data valueForKey:@"uid"] longValue]];
            [MBProgressHUD showSuccess:respone.msg toView:self.view];
        }
        else
        {
            [MBProgressHUD showError:respone.msg toView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark --验证手机号、获取验证码
-(void)checkPhone:(NSString *)phone success:(void (^)(void))success failure:(void (^)(NSString *message))failure
{
    //验证手机号
    [APIClient networkCheckPhone:phone success:^(Respone *respone)
    {
         if (respone.status == kEnumServerStateSuccess) {
             //获取验证码
             [APIClient networkGetauthcodeWithPhone:phone success:^(Respone *respone) {
                 if (respone.status == kEnumServerStateSuccess) {
                     _phoneNum = [respone.data valueForKey:@"phone"];
                     _smsid = [respone.data valueForKey:@"smsid"];
                     success();
                 }
                 else
                 {
                     [_authInputView setResult:kGDInputViewStatusError];
                     failure(respone.msg);
                 }
             } failure:^(NSError *error) {
                 
             }];
         }
         else
         {
             [_inputView setResult:kGDInputViewStatusError];
             failure(respone.msg);
         }
     } failure:^(NSError *error) {

     }];
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
