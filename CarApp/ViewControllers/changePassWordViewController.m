//
//  changePassWordViewController.m
//  CarApp
//
//  Created by 海龙 李 on 13-11-12.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "changePassWordViewController.h"
#import "GDInputView.h"

#define kGDInputViewTag 22222
#define kGDInputTextFieldTag 33333
#define kGDReInputViewTag 44444
#define kGDReInputTextFieldTag 55555


@interface changePassWordViewController ()

@end

@implementation changePassWordViewController

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
    
    UIView * mainView = [[UIView alloc]initWithFrame:[AppUtility mainViewFrame]];
    mainView.userInteractionEnabled = YES;
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
    
    UIImageView * headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(105,29, 110, 25)];
    [headerImgView setBackgroundColor:[UIColor clearColor]];
    [headerImgView setImage:[UIImage imageNamed:@"logo_start"]];
    [navBar addSubview:headerImgView];
    
    UILabel * codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(54,64+40, 200, 20)];
    [codeLabel setBackgroundColor:[UIColor clearColor]];
    [codeLabel setText:@"重置密码:"];
    [codeLabel setTextAlignment:NSTextAlignmentLeft];
    [codeLabel setTextColor:[UIColor appBlackColor]];
    [codeLabel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [navBar addSubview:codeLabel];

    
    //输入框
    GDInputView *inputView = [[GDInputView alloc]initWithFrame:CGRectMake(54, 122 , 212, 36)];
    [inputView setAlpha:1.0];
    [inputView.textfield setDelegate:self];
    [inputView.textfield setPlaceholder:@"输入新密码"];
    [inputView setTag:kGDInputViewTag];
    [inputView.textfield setTag:kGDInputTextFieldTag];
    [inputView.textfield setSecureTextEntry:YES];
    [mainView addSubview:inputView];
    
    //输入框
    GDInputView *reInputView = [[GDInputView alloc]initWithFrame:CGRectMake(54, 158+8, 212, 36)];
    [reInputView setAlpha:1.0];
    [reInputView.textfield setDelegate:self];
    [reInputView.textfield setPlaceholder:@"重复密码"];
    [reInputView setTag:kGDReInputViewTag];
    [reInputView.textfield setTag:kGDReInputTextFieldTag];
    [reInputView.textfield setSecureTextEntry:YES];
    [mainView addSubview:reInputView];

    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTag:80003];
    confirmBtn.showsTouchWhenHighlighted = YES;
    [confirmBtn setFrame:CGRectMake(54, 166+36+8, 212, 36)];
    [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_green_normal"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_green_pressed"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateSelected];
    [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_gray_normal"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateDisabled];
    [confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [confirmBtn addTarget:self action:@selector(confirmPasswordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:confirmBtn];
}


-(void)confirmPasswordBtnClicked:(id)sender
{
    GDInputView * passInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    GDInputView * repassInputView = (GDInputView *)[self.view viewWithTag:kGDReInputViewTag];
    UITextField * passwordTxf = (UITextField *)passInputView.textfield;
    UITextField * confirmPassWordTxf = (UITextField *)repassInputView.textfield;

    [passwordTxf resignFirstResponder];
    [confirmPassWordTxf resignFirstResponder];
    
    if ([passwordTxf.text isEqualToString:confirmPassWordTxf.text]) {
        
        NSString * passWord = passwordTxf.text;
        
        if (passWord.length < 6 || passWord.length > 12 ) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入6-12位密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else{
            //修改密码
            [self editpassword:passWord withuid:[User shareInstance].userId];
            
        }
    }
    else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次输入的密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)editpassword:(NSString *)password withuid:(int)uid
{
    /*
    [NetWorkManager networkResetpasswordeWithphone:self.phoneNum password:password success:^(BOOL flag) {
        if (flag) {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"重置密码成功" message:@"前往登录页" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [alert setTag:52001];
            [alert show];
            [alert release];
        }
    } failure:^(NSError *error) {
        
    }];*/
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 52001) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}



#pragma mark - textDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    GDInputView * passInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [passInputView setResult:kGDInputViewStatusNomal];
    }
    GDInputView * repassInputView = (GDInputView *)[self.view viewWithTag:kGDReInputViewTag];
    if (textField.tag == kGDReInputTextFieldTag) {
        [repassInputView setResult:kGDInputViewStatusNomal];
    }
    
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([toBeString length] > 11) {
        textField.text = [toBeString substringToIndex:11];
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    GDInputView * passInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [passInputView setResult:kGDInputViewStatusNomal];
    }
    GDInputView * repassInputView = (GDInputView *)[self.view viewWithTag:kGDReInputViewTag];
    if (textField.tag == kGDReInputTextFieldTag) {
        [repassInputView setResult:kGDInputViewStatusNomal];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    GDInputView * passInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [passInputView setResult:kGDInputViewStatusDisable];
    }
    GDInputView * repassInputView = (GDInputView *)[self.view viewWithTag:kGDReInputViewTag];
    if (textField.tag == kGDReInputTextFieldTag) {
        [repassInputView setResult:kGDInputViewStatusDisable];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    GDInputView * passInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [passInputView setResult:kGDInputViewStatusDisable];
    }
    GDInputView * repassInputView = (GDInputView *)[self.view viewWithTag:kGDReInputViewTag];
    if (textField.tag == kGDReInputTextFieldTag) {
        [repassInputView setResult:kGDInputViewStatusDisable];
    }
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    GDInputView * passInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [passInputView setResult:kGDInputViewStatusNull];
    }
    GDInputView * repassInputView = (GDInputView *)[self.view viewWithTag:kGDReInputViewTag];
    if (textField.tag == kGDReInputTextFieldTag) {
        [repassInputView setResult:kGDInputViewStatusNull];
    }
    return YES;
}


-(void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
