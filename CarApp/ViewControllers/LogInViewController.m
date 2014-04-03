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

#define kErrorWarnLable 22222
#define kUseTextFieldTag 33333
#define kUseTextInputTag 33344
#define kCodeTextFieldTag 44444
#define kCodeTextInputTag 44455

@interface LogInViewController ()<UITextFieldDelegate>

@end

@implementation LogInViewController

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
    UIView * mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
    mainView.userInteractionEnabled = YES;
    [mainView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:mainView];
    [mainView release];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 180, 50)];
    [titleLabel setTag:10001];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"天地设立\n    而易行乎其中矣"];
    [titleLabel setTextAlignment:0];
    [titleLabel setLineBreakMode:0];
    [titleLabel setNumberOfLines:2];
    [titleLabel setTextColor:[UIColor colorWithRed:60./255.0 green:60./255.0 blue:60./255.0 alpha:1]];
    [titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [mainView addSubview:titleLabel];
    [titleLabel release];
    
    UIImageView * headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(320-130,30, 110, 25)];
    [headerImgView setTag:10002];
    [headerImgView setBackgroundColor:[UIColor clearColor]];
    [headerImgView setImage:[UIImage imageNamed:@"logo_start"]];
    [mainView addSubview:headerImgView];
    [headerImgView release];
    
    //输入框
    UIView *inputView = [[UIView alloc]initWithFrame:CGRectMake(40,24+55, 240, 180)];
    [inputView setTag:11111];
    [inputView setClipsToBounds:NO];
    [inputView setHidden:YES];
    [mainView addSubview:inputView];
    [inputView release];
    
    UILabel *errorWarnLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 230, 40)];
    [errorWarnLable setTag:kErrorWarnLable];
    [errorWarnLable setBackgroundColor:[UIColor clearColor]];
    [errorWarnLable setTextAlignment:0];
    [errorWarnLable setTextColor:[UIColor redColor]];
    [errorWarnLable setFont:[UIFont fontWithName:kFangZhengFont size:14]];
    [inputView addSubview:errorWarnLable];
    [errorWarnLable release];
    
    //账号
    GDInputView *userInputView = [[GDInputView alloc]initWithFrame:CGRectMake(0, 40, 240, 40)];
    [userInputView setAlpha:1.0];
    [userInputView.textfield setDelegate:self];
    [userInputView.textfield setPlaceholder:@"账号/手机号"];
    [userInputView.textfield setText:[User shareInstance].userName];
    [userInputView setTag:kUseTextInputTag];
    [userInputView.textfield setTag:kUseTextFieldTag];
    [inputView addSubview:userInputView];
    [userInputView release];
    
    //密码
    GDInputView *codeInputView = [[GDInputView alloc]initWithFrame:CGRectMake(0, 90, 240, 40)];
    [codeInputView setAlpha:1.0];
    [codeInputView.textfield setDelegate:self];
    [codeInputView.textfield setPlaceholder:@"密码"];
    [codeInputView.textfield setSecureTextEntry:YES];
    [codeInputView.textfield setText:[User shareInstance].userPwd];
    [codeInputView setTag:kCodeTextInputTag];
    [codeInputView.textfield setTag:kCodeTextFieldTag];
    [inputView addSubview:codeInputView];
    [codeInputView release];
    
    //登入按钮
    UIImage * logBackImg = [UIImage imageNamed:@"btn_blue_normal"];
    logBackImg = [logBackImg stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    UIButton * logInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logInBtn.showsTouchWhenHighlighted = YES;
    [logInBtn setFrame:CGRectMake(0, 140, 240, 40)];
    [logInBtn setBackgroundImage:logBackImg forState:UIControlStateNormal];
    [logInBtn setTitle:@"登录" forState:UIControlStateNormal];
    [logInBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:16]];
    [logInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [logInBtn addTarget:self action:@selector(ensureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:logInBtn];
    
    //底部注册和忘记密码按钮
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
    
    UIButton * forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setTag:1002];
    [forgetBtn setBackgroundColor:[UIColor clearColor]];
    [forgetBtn setFrame:CGRectMake(170, 9, 130, 32)];
    [forgetBtn setBackgroundImage:[UIImage imageNamed:@"btn_forget_normal@2x"] forState:UIControlStateNormal];
    [forgetBtn setBackgroundImage:[UIImage imageNamed:@"btn_forget_pressed@2x"] forState:UIControlStateHighlighted];
    [forgetBtn addTarget:self action:@selector(forgetBtnClikcked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:forgetBtn];
    
    //点击屏幕取消textField响应
//    UITapGestureRecognizer * tappp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
//    [mainView addGestureRecognizer:tappp];
//    [tappp release];
    
    
    [self performSelector:@selector(inputViewanimation) withObject:nil afterDelay:0.1];
}

-(void)inputViewanimation
{
    UIView *inputView = (UIView *)[self.view viewWithTag:11111];
    [inputView setFrame:CGRectMake(40, SCREEN_HEIGHT-48-180, 240, 180)];
    [inputView setHidden:NO];
    [inputView setAlpha:0.0];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [inputView setFrame:CGRectMake(40,24+55, 240, 180)];
    [inputView setAlpha:1.0];

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

-(void)becomeActived
{
    UITextField * userTxf = (UITextField *)[self.view viewWithTag:kUseTextFieldTag];
    [userTxf becomeFirstResponder];
}

-(void)hideKeyBoard
{
    UITextField * userNameTXF = (UITextField *)[self.view viewWithTag:kUseTextFieldTag];
    UITextField * passTXF = (UITextField *)[self.view viewWithTag:kCodeTextFieldTag];
    
    [userNameTXF resignFirstResponder];
    [passTXF resignFirstResponder];
}

//注册
-(void)registerBtnClicked:(id)sender
{
    RegisterViewController * registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
    [registerVC release];
}
//忘记密码
-(void)forgetBtnClikcked:(id)sender
{
    DLog(@"忘记密码");
    ForgetPassWordViewController * forgetVC = [[ForgetPassWordViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
    [forgetVC release];
}

-(void)ensureBtnClicked:(UIButton *)sender
{
    GDInputView * codeInputView = (GDInputView *)[self.view viewWithTag:kCodeTextInputTag];
    GDInputView * userInputView = (GDInputView *)[self.view viewWithTag:kUseTextInputTag];
    UILabel * errorWarnLable = (UILabel *)[self.view viewWithTag:kErrorWarnLable];
    
    NSString *userText = userInputView.textfield.text;
    NSString *codeText = codeInputView.textfield.text;
    
    [self hideKeyBoard];
    
    if ([userText isEqualToString:@""] || userText == nil ) {
        [userInputView setResult:kGDInputViewStatusError];
        [errorWarnLable setText:@"用户名不能为空"];
        return;
    }
    if ([codeText isEqualToString:@""] || codeText == nil ) {
        [codeInputView setResult:kGDInputViewStatusError];
        [errorWarnLable setText:@"密码不能为空"];
        return;
    }
    [self userLoginWithAccount:userText passWord:codeText];
}

#pragma mark - 交互
-(void)userLoginWithAccount:(NSString *)account passWord:(NSString *)password
{
    GDInputView * codeInputView = (GDInputView *)[self.view viewWithTag:kCodeTextInputTag];
    GDInputView * userInputView = (GDInputView *)[self.view viewWithTag:kUseTextInputTag];
    UILabel * errorWarnLable = (UILabel *)[self.view viewWithTag:kErrorWarnLable];
    [self checkAccountType:account accountType:^(int type) {
        [NetWorkManager networkUserLoginWithname:(type == 1?account:nil) password:password phone:(type == 2?account:nil) type:type success:^(BOOL flag, NSDictionary *userDic, NSString *msg) {
            
            if (flag) {
                //保存信息
                User * user = [User shareInstance];
                user.userId = [[userDic valueForKey:@"uid"]longValue];
                user.phoneNum = [userDic valueForKey:@"phone"];
                user.userName = [userDic valueForKey:@"username"];
                if (type==1) {
                    user.userName = account;
                }
                user.userPwd = password;
                user.isSavePwd = YES;
                [user save];
                
                UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:[AppDelegate shareDelegate].mainVC];
                [navi setNavigationBarHidden:YES];
                [AppDelegate shareDelegate].mainVC.firstEnter = YES;
                [[AppDelegate shareDelegate].mainVC enterView];
                [navi setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                [self presentViewController:navi animated:YES completion:^{
                    [[AppDelegate shareDelegate].window setRootViewController:navi];
                }];
            }
            else
            {
                if ([msg isEqualToString:@"用户名和密码不正确"]) {
                    [codeInputView setResult:kGDInputViewStatusError];
                    [userInputView setResult:kGDInputViewStatusError];
                    [errorWarnLable setText:msg];
                }
                
            }
            
        } failure:^(NSError *error) {
            
        }];
    }];
}

-(void)checkAccountType:(NSString *)account accountType:(void (^)(int type))accountType
{
    //检测是否为手机号
    BOOL state = [AppUtility validateMobile:account];
    
    if(state)
    {
        //继续使用网络检测手机号（检查用户是否使用手机号作为用户名来登入）
        //检测手机号码
        [NetWorkManager networkCheckPhone:account success:^(int status, NSObject *data, NSString *msg) {
            if (status == 200) {
                accountType(1);
            }
            else
            {
                accountType(2);
            }
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
        accountType(1);
    }
}
#pragma mark - textDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    GDInputView * codeInputView = (GDInputView *)[self.view viewWithTag:kCodeTextInputTag];
    GDInputView * userInputView = (GDInputView *)[self.view viewWithTag:kUseTextInputTag];
    UILabel * errorWarnLable = (UILabel *)[self.view viewWithTag:kErrorWarnLable];
    [errorWarnLable setText:@""];
    
    if (textField.tag == kCodeTextFieldTag) {
        [codeInputView setResult:kGDInputViewStatusNomal];
    }
    
    if (textField.tag == kUseTextFieldTag) {
        [userInputView setResult:kGDInputViewStatusNomal];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    
    GDInputView * codeInputView = (GDInputView *)[self.view viewWithTag:kCodeTextInputTag];
    GDInputView * userInputView = (GDInputView *)[self.view viewWithTag:kUseTextInputTag];
    if (textField.tag == kCodeTextFieldTag) {
        [codeInputView setResult:kGDInputViewStatusNomal];
    }
    if (textField.tag == kUseTextFieldTag) {
        [userInputView setResult:kGDInputViewStatusNomal];
    }
    
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    GDInputView * codeInputView = (GDInputView *)[self.view viewWithTag:kCodeTextInputTag];
    GDInputView * userInputView = (GDInputView *)[self.view viewWithTag:kUseTextInputTag];
    if (textField.tag == kCodeTextFieldTag) {
        [codeInputView setResult:kGDInputViewStatusDisable];
    }
    if (textField.tag == kUseTextFieldTag) {
        [userInputView setResult:kGDInputViewStatusDisable];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    GDInputView * codeInputView = (GDInputView *)[self.view viewWithTag:kCodeTextInputTag];
    GDInputView * userInputView = (GDInputView *)[self.view viewWithTag:kUseTextInputTag];
    if (textField.tag == kCodeTextFieldTag) {
        [codeInputView setResult:kGDInputViewStatusTure];
    }
    if (textField.tag == kUseTextFieldTag) {
        [userInputView setResult:kGDInputViewStatusTure];
    }
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    GDInputView * codeInputView = (GDInputView *)[self.view viewWithTag:kCodeTextInputTag];
    GDInputView * userInputView = (GDInputView *)[self.view viewWithTag:kUseTextInputTag];
    if (textField.tag == kCodeTextFieldTag) {
        [codeInputView setResult:kGDInputViewStatusNull];
    }
    if (textField.tag == kUseTextFieldTag) {
        [userInputView setResult:kGDInputViewStatusNull];
    }
    return YES;
}


-(void)backToMain
{
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
