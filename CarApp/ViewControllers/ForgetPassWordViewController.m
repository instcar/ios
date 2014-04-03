//
//  ForgetPassWordViewController.m
//  CarApp
//
//  Created by 海龙 李 on 13-11-10.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "ForgetPassWordViewController.h"
#import "changePassWordViewController.h"
#import "GDInputView.h"

#define kGDInputViewTag  2222
#define kGDInputTextFieldTag 2233
#define kauthBtnTag 3333
#define kconfirmBtnTag 4444
#define kGDAuthInputViewTag 5555
#define kGDAuthInputTextFieldTag 5566

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
    _inputCode= NO;
    
    UIView * mainView = [[UIView alloc]initWithFrame:[AppUtility mainViewFrame]];
    mainView.userInteractionEnabled = YES;
    [mainView setBackgroundColor:[UIColor appBackgroundColor]];
    [self.view addSubview:mainView];
    [mainView release];
    
    UIImage * naviBarImage = [UIImage imageNamed:@"navgationbar_64"];
    naviBarImage = [naviBarImage stretchableImageWithLeftCapWidth:4 topCapHeight:10];
    
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    [navBar setBackgroundImage:naviBarImage forBarMetrics:UIBarMetricsDefault];
    [mainView addSubview:navBar];
    [navBar release];
    
    if (kDeviceVersion < 7.0) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, navBar.frame.size.height, navBar.frame.size.width, 1)];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [navBar addSubview:lineView];
        [lineView release];
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
    
    UIImageView * headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(105,29, 110, 25)];
    [headerImgView setBackgroundColor:[UIColor clearColor]];
    [headerImgView setImage:[UIImage imageNamed:@"logo_start"]];
    [navBar addSubview:headerImgView];
    [headerImgView release];
    
//    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 27, 120, 30)];
//    [titleLabel setBackgroundColor:[UIColor clearColor]];
//    [titleLabel setText:@"忘记密码"];
//    [titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [titleLabel setTextColor:[UIColor flatGreenColor]];
//    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
//    [navBar addSubview:titleLabel];
//    [titleLabel release];
    
    //输入框
    GDInputView *inputView = [[GDInputView alloc]initWithFrame:CGRectMake(40, 64+55 , 240, 40)];
    [inputView setAlpha:1.0];
    [inputView.textfield setDelegate:self];
    [inputView.textfield setPlaceholder:@"请输入您注册时的手机号"];
    [inputView setTag:kGDInputViewTag];
    [inputView.textfield setTag:kGDInputTextFieldTag];
    [mainView addSubview:inputView];
    [inputView release];
    
    //获取验证码
    UIButton * authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [authBtn setTag:kauthBtnTag];
    [authBtn setAlpha:1.0];
    [authBtn setShowsTouchWhenHighlighted:YES];
    [authBtn setFrame:CGRectMake(40, 119+50, 240, 40)];
    [authBtn setBackgroundImage:[[UIImage imageNamed:@"btn_orange_normal"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [authBtn setBackgroundImage:[[UIImage imageNamed:@"btn_orange_pressed"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateSelected];
    [authBtn setBackgroundImage:[[UIImage imageNamed:@"btn_gray_normal"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateDisabled];
    [authBtn setTitle:@"免费获取验证码" forState:UIControlStateNormal];
    [authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [authBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:16]];
    [authBtn addTarget:self action:@selector(getCodeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:authBtn];
    
    //输入框
    GDInputView *authInputView = [[GDInputView alloc]initWithFrame:CGRectMake(40,169+50, 240, 40)];
    [authInputView setAlpha:1.0];
    [authInputView.textfield setDelegate:self];
    [authInputView.textfield setPlaceholder:@"请输入6位短信验证"];
    [authInputView setTag:kGDAuthInputViewTag];
    [authInputView.textfield setTag:kGDAuthInputTextFieldTag];
    [mainView addSubview:authInputView];
    [authInputView release];
    
    //发送验证码
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTag:kconfirmBtnTag];
    [confirmBtn setAlpha:1.0];
    confirmBtn.showsTouchWhenHighlighted = YES;
    [confirmBtn setFrame:CGRectMake(40, 219+50, 240, 40)];
    [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_green_normal"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_green_pressed"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateSelected];
    [confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [confirmBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:16]];
    [confirmBtn addTarget:self action:@selector(sendCodeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:confirmBtn];
    
    //测试使用lable
    //--------------------------------------------//
    UILabel * warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,219+50+50, 240, 40)];
    [warnLabel setTag:12345];
    [warnLabel setBackgroundColor:[UIColor clearColor]];
    [warnLabel setText:@""];
    [warnLabel setTextAlignment:NSTextAlignmentLeft];
    [warnLabel setTextColor:[UIColor flatGreenColor]];
    [warnLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [warnLabel setHidden:YES];
    [mainView addSubview:warnLabel];
    [warnLabel release];
    //--------------------------------------------//
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIButton *getauthBtn = (UIButton *)[self.view viewWithTag:kauthBtnTag];
    GDInputView *inputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    
    [inputView.textfield setText:@""];
    [inputView.textfield resignFirstResponder];
    [inputView.textfield setPlaceholder:@"请输入您的注册时手机号"];
    [getauthBtn setEnabled:YES];
    [getauthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getauthBtn setTitle:@"免费获取验证码" forState:UIControlStateNormal];
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
    GDInputView *inputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    UITextField * phoneTxf = inputView.textfield;
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
    UIButton *getauthBtn = (UIButton *)[self.view viewWithTag:kauthBtnTag];
    GDInputView *inputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    DLog(@"-------->%d<-------",_leftSeconds);
    
    if (_leftSeconds >= 1) {
        _leftSeconds = _leftSeconds -1;

        [getauthBtn setEnabled:NO];
        [getauthBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [getauthBtn setTitle:[NSString stringWithFormat:@"(%d秒)后重新获取验证码",_leftSeconds] forState:UIControlStateDisabled];
    }
    else{
        [inputView.textfield setText:@""];
        [inputView.textfield resignFirstResponder];
        [inputView.textfield setPlaceholder:@"请输入注册时的手机号码"];
        [getauthBtn setEnabled:YES];
        [getauthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [getauthBtn setTitle:@"免费获取验证码" forState:UIControlStateNormal];
        if (self.countTimer && [self.countTimer isValid]) {
            [self.countTimer invalidate];
        }
    }
}

-(void)sendCodeBtnClicked:(id)sender
{
    GDInputView *authinputView = (GDInputView *)[self.view viewWithTag:kGDAuthInputViewTag];
    UITextField * phoneTxf = authinputView.textfield;
    NSString * numbers = phoneTxf.text;
    
    if (numbers.length == 6) {
        DLog(@"判断验证码");
        if ([self checkAuthCode:numbers]) {
            [authinputView setResult:kGDInputViewStatusTure];
            changePassWordViewController * changeVC = [[changePassWordViewController alloc]init];
            changeVC.phoneNum = _phoneNum;
            [self.navigationController pushViewController:changeVC animated:YES];
            [changeVC release];
        }
        else
        {
            [authinputView setResult:kGDInputViewStatusError];
            [UIAlertView showAlertViewWithTitle:@"验证码错误" tag:0 cancelTitle:@"确定" ensureTitle:nil delegate:nil];
        }
    }
    else{
        [authinputView setResult:kGDInputViewStatusError];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请输入6位验证码" message:@"如未收到请稍等" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)becomeActived
{
    GDInputView *inputView = (GDInputView *)[self.view viewWithTag:kGDAuthInputViewTag];
    [inputView.textfield becomeFirstResponder];
}

-(void)backToMain
{
    [_countTimer invalidate];
    //    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - textDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    GDInputView * phoneInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    GDInputView * authInputView = (GDInputView *)[self.view viewWithTag:kGDAuthInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [phoneInputView setResult:kGDInputViewStatusNomal];
    }
    if (textField.tag == kGDAuthInputTextFieldTag) {
        [authInputView setResult:kGDInputViewStatusNomal];
    }
    
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == kGDInputTextFieldTag)
    {
        if ([toBeString length] > 11) {
            textField.text = [toBeString substringToIndex:11];
            [textField resignFirstResponder];
            return NO;
        }
    }
    if (textField.tag == kGDAuthInputTextFieldTag)
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
    GDInputView * phoneInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    GDInputView * authInputView = (GDInputView *)[self.view viewWithTag:kGDAuthInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [phoneInputView setResult:kGDInputViewStatusNomal];
    }
    if (textField.tag == kGDAuthInputTextFieldTag) {
        [authInputView setResult:kGDInputViewStatusNomal];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    GDInputView * phoneInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    GDInputView * authInputView = (GDInputView *)[self.view viewWithTag:kGDAuthInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [phoneInputView setResult:kGDInputViewStatusDisable];
    }
    if (textField.tag == kGDAuthInputTextFieldTag) {
        [authInputView setResult:kGDInputViewStatusDisable];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    GDInputView * phoneInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    GDInputView * authInputView = (GDInputView *)[self.view viewWithTag:kGDAuthInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [phoneInputView setResult:kGDInputViewStatusDisable];
    }
    if (textField.tag == kGDAuthInputTextFieldTag) {
        [authInputView setResult:kGDInputViewStatusDisable];
    }
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    GDInputView * phoneInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    GDInputView * authInputView = (GDInputView *)[self.view viewWithTag:kGDAuthInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [phoneInputView setResult:kGDInputViewStatusNull];
    }
    if (textField.tag == kGDAuthInputTextFieldTag) {
        [authInputView setResult:kGDInputViewStatusNull];
    }
    return YES;
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
                    //测试用，短信回执比较慢，直接显示验证密码
                    UILabel * warnLable = (UILabel *)[self.view viewWithTag:12345];
                    warnLable.text = [NSString stringWithFormat:@"序列号:%@ 验证码:%@ ",_sequenceNo,_authCode];
                    success();
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
    [super dealloc];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
