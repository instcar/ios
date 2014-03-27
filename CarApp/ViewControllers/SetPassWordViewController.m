//
//  SetPassWordViewController.m
//  CarApp
//
//  Created by 海龙 李 on 13-11-19.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "SetPassWordViewController.h"
#import "SetNickNameViewController.h"
#import "GDInputView.h"

#define kGDInputViewTag 22222
#define kGDInputTextFieldTag 33333

@interface SetPassWordViewController ()

@end

@implementation SetPassWordViewController

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

    UILabel * infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,64+40, 200, 20)];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [infoLabel setTextAlignment:NSTextAlignmentLeft];
    [infoLabel setTextColor:[UIColor appBlackColor]];
    [infoLabel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [infoLabel setText:@"请输入密码:"];
    [mainView addSubview:infoLabel];
    [infoLabel release];
    
    //输入框
    GDInputView *inputView = [[GDInputView alloc]initWithFrame:CGRectMake(40, 122 , 240, 40)];
    [inputView setAlpha:1.0];
    [inputView.textfield setDelegate:self];
    [inputView.textfield setPlaceholder:@"字母、数字、或英文,最多16字符"];
    [inputView setTag:kGDInputViewTag];
    [inputView.textfield setTag:kGDInputTextFieldTag];
    [mainView addSubview:inputView];
    [inputView release];
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTag:80003];
    confirmBtn.showsTouchWhenHighlighted = YES;
    [confirmBtn setFrame:CGRectMake(40, 172, 240, 40)];
    [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_green_normal"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_green_pressed"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateSelected];
    [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_gray_normal"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateDisabled];
    [confirmBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:16]];
    [confirmBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:confirmBtn];
}

-(void)confirmBtnClicked:(id)sender
{
    GDInputView * passInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    UITextField * passTxf = passInputView.textfield;
//    UITextField * confirmPassTxf = (UITextField *)[self.view viewWithTag:80002];

    NSString * passWord = passTxf.text;
//    NSString * confirmPassWord = confirmPassTxf.text;
    
    //如果位数都不够6位
//    if (passWord.length < 6 || confirmPassWord.length < 6) {
    if (passWord.length < 6) {
        [passInputView setResult:kGDInputViewStatusError];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入6~12位密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        if ([self validatePassword:passWord]) {
            [passInputView setResult:kGDInputViewStatusTure];
//        if ([passWord isEqualToString:confirmPassWord]) {
//            DLog(@"密码一致");
            [self.registerDic setObject:[passWord copy] forKey:@"password"];
            SetNickNameViewController * nickVC = [[SetNickNameViewController alloc]init];
            nickVC.registerDic = self.registerDic;  //传值
            [self.navigationController pushViewController:nickVC animated:YES];
            [nickVC release];
//        }
//        else{
//
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次输入的秘密不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//            [alert release];
//        }
//
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"格式:字母、数字、或英文,最多16字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
}

//验证昵称是否符合规范
- (BOOL)validatePassword:(NSString *)password
{
    NSString * reg = @"^[A-Za-z0-9]{0,12}$";
    
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    
    return  [regex evaluateWithObject:password];
}


#pragma mark - textDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    GDInputView * passInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [passInputView setResult:kGDInputViewStatusNomal];
    }

    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([toBeString length] > 16) {
        textField.text = [toBeString substringToIndex:16];
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
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    GDInputView * passInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [passInputView setResult:kGDInputViewStatusDisable];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    GDInputView * passInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [passInputView setResult:kGDInputViewStatusDisable];
    }
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    GDInputView * passInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [passInputView setResult:kGDInputViewStatusNull];
    }
    return YES;
}

-(void)backToMain
{
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
