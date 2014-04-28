//
//  ForgetPassWordViewController.m
//  CarApp
//
//  Created by 海龙 李 on 13-11-10.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "ForgetPassWordViewController.h"
#import "changePassWordViewController.h"

@interface ForgetPassWordViewController ()
@property (retain, nonatomic) NSTimer *countTimer;
@end

@implementation ForgetPassWordViewController

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
    
    _inputCode= NO;
    
    
    [self setCtitle:@"logo"];
    [self setDesText:@"null"];
    
    //输入框
    _inputView = [[GDInputView alloc]initWithFrame:CGRectMake(45, 64+50 , 230, 36)];
    [_inputView setAlpha:1.0];
    [_inputView setGdInputDelegate:self];
    [_inputView.textfield setPlaceholder:@"请输入您注册时的手机号"];
    [_inputView.textfield setTag:110];
    [self.view addSubview:_inputView];
    [_inputView release];
    
    //获取验证码
    _authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_authBtn setAlpha:1.0];
    [_authBtn setShowsTouchWhenHighlighted:YES];
    [_authBtn setFrame:CGRectMake(45, 150+10, 230, 36)];
    [_authBtn setBackgroundImage:[[UIImage imageNamed:@"btn_orange"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [_authBtn setBackgroundImage:[[UIImage imageNamed:@"btn_empty"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateDisabled];
    [_authBtn setTitle:@"免费获取验证码" forState:UIControlStateNormal];
    [_authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_authBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:16]];
    [_authBtn addTarget:self action:@selector(getCodeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_authBtn];
    
    //输入框
    _authInputView = [[GDInputView alloc]initWithFrame:CGRectMake(45,196+10, 230, 36)];
    [_authInputView setAlpha:1.0];
    [_authInputView setGdInputDelegate:self];
    [_authInputView.textfield setPlaceholder:@"请输入6位短信验证"];
    [_authInputView.textfield setTag:111];
    [self.view addSubview:_authInputView];
    
    //发送验证码
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setAlpha:1.0];
    _confirmBtn.showsTouchWhenHighlighted = YES;
    [_confirmBtn setFrame:CGRectMake(45, 242+10, 230, 36)];
    [_confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_green"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [_confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_empty"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateSelected];
    [_confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_confirmBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:16]];
    [_confirmBtn addTarget:self action:@selector(sendCodeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmBtn];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [_inputView.textfield setText:@""];
    [_inputView.textfield resignFirstResponder];
    [_inputView.textfield setPlaceholder:@"请输入您的注册时手机号"];
    [_authBtn setEnabled:YES];
    [_authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_authBtn setTitle:@"免费获取验证码" forState:UIControlStateNormal];
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
    UITextField * phoneTxf = _inputView.textfield;
    NSString * numbers = phoneTxf.text;
    
    bool isPhoneCorrect = [AppUtility validateMobile:numbers];
    
    if (isPhoneCorrect) {
        DLog(@"手机号正确");
        //检测手机码号时候已经注册，有就修改密码
        [self checkPhone:numbers success:^{
            _inputCode = YES;
            _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countSecond:) userInfo:nil repeats:YES];
            _leftSeconds = 60;
        } failure:^(NSString *message) {
            
        }];

    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号以便接收验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}


-(void)countSecond:(NSTimer *)timer
{
    DLog(@"-------->%d<-------",_leftSeconds);
    
    if (_leftSeconds >= 1) {
        _leftSeconds = _leftSeconds -1;

        [_authBtn setEnabled:NO];
        [_authBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_authBtn setTitle:[NSString stringWithFormat:@"(%d秒)后重新获取验证码",_leftSeconds] forState:UIControlStateDisabled];
    }
    else{
        [_inputView.textfield setText:@""];
        [_inputView.textfield resignFirstResponder];
        [_inputView.textfield setPlaceholder:@"请输入注册时的手机号码"];
        [_authBtn setEnabled:YES];
        [_authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_authBtn setTitle:@"免费获取验证码" forState:UIControlStateNormal];
        if (self.countTimer && [self.countTimer isValid]) {
            [self.countTimer invalidate];
        }
    }
}

-(void)sendCodeBtnClicked:(id)sender
{
    UITextField * phoneTxf = _authInputView.textfield;
    NSString * numbers = phoneTxf.text;
    
    if (numbers.length == 6) {
        DLog(@"判断验证码");
        if ([self checkAuthCode:numbers]) {
            [_authInputView setResult:kGDInputViewStatusTure];
            changePassWordViewController * changeVC = [[changePassWordViewController alloc]init];
            changeVC.phoneNum = _phoneNum;
            [self.navigationController pushViewController:changeVC animated:YES];
            [changeVC release];
        }
        else
        {
            [_authInputView setResult:kGDInputViewStatusError];
            [UIAlertView showAlertViewWithTitle:@"验证码错误" tag:0 cancelTitle:@"确定" ensureTitle:nil delegate:nil];
        }
    }
    else{
        [_authInputView setResult:kGDInputViewStatusError];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请输入6位验证码" message:@"如未收到请稍等" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)becomeActived
{
    [_inputView.textfield becomeFirstResponder];
}



#pragma mark - textDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if (textField.tag == 110) {
        [_inputView setResult:kGDInputViewStatusNomal];
    }
    if (textField.tag == 111) {
        [_authInputView setResult:kGDInputViewStatusNomal];
    }
    
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == 110)
    {
        if ([toBeString length] > 11) {
            textField.text = [toBeString substringToIndex:11];
            [textField resignFirstResponder];
            return NO;
        }
    }
    if (textField.tag == 111)
    {
        if ([toBeString length] > 6) {
            textField.text = [toBeString substringToIndex:6];
            [textField resignFirstResponder];
            return NO;
        }
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{

}


//检测手机号码是否已经有注册（注册过才可以更改密码）
//检测手机号码
-(void)checkPhone:(NSString *)phone success:(void (^)(void))success failure:(void (^)(NSString *message))failure
{
//    GDInputView * phoneInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    [NetWorkManager networkCheckPhone:phone success:^(int status, NSObject *data, NSString *msg) {
        if (status == 200) {
            [SVProgressHUD showWithStatus:@"此号码还没有注册"];
        }
        else
        {
            //请求获取手机验证码
            [NetWorkManager networkGetauthcodeWithPhone:phone type:1 mode:kNetworkrequestModeRequest success:^(BOOL flag, NSString *authcode, NSString *sequenceNo, NSString *msg) {
                if (flag) {
                    _phoneNum = [phone copy];
                    _authCode = [authcode copy];
                    _sequenceNo = [sequenceNo copy];
                }
            } failure:^(NSError *error) {
                failure(error.description);
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (BOOL)checkAuthCode:(NSString *)inputAuthCode
{
    return [_authCode isEqualToString:inputAuthCode];
}

-(void)dealloc
{
    [_countTimer invalidate];
    [super dealloc];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
