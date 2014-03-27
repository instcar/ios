//
//  SetAgeViewController.m
//  CarApp
//
//  Created by 海龙 李 on 13-11-17.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "SetNickNameViewController.h"
#import "SetAgeGenderViewController.h"
#import "GDInputView.h"
#import "XmppManager.h"
#define kGDInputViewTag 22222
#define kGDInputTextFieldTag 33333

@interface SetNickNameViewController ()

@end

@implementation SetNickNameViewController

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
    [infoLabel setText:@"请输入昵称:"];
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

    UIImage * logBackImg = [UIImage imageNamed:@"btn_orange_normal"];
    logBackImg = [logBackImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage * logBackImgHL = [UIImage imageNamed:@"btn_orange_pressed"];
    logBackImgHL = [logBackImgHL stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTag:60003];
    nextBtn.showsTouchWhenHighlighted = YES;
    [nextBtn setFrame:CGRectMake(40, 122+50, 240, 40)];
    [nextBtn setBackgroundImage:logBackImg forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:logBackImgHL forState:UIControlStateHighlighted];
    [nextBtn setTitle:@"完成注册" forState:UIControlStateNormal];
    [nextBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:16]];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [nextBtn addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:nextBtn];
}


-(void)nextBtnClicked:(id)sender
{
    GDInputView *inputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    UITextField * nickTxf = inputView.textfield;
    if ([self validateNickName:nickTxf.text]) {
        [NetWorkManager networkCheckUserName:nickTxf.text success:^(BOOL flag, BOOL userable, NSString *msg) {
            if (flag) {
                if (userable) {
                    [inputView setResult:kGDInputViewStatusTure];
                    DLog(@"下一步");
                    [self.registerDic setObject:nickTxf.text forKey:@"name"];
                    
//                    SetAgeGenderViewController * ageGender = [[SetAgeGenderViewController alloc]init];
//                    ageGender.registerDic = self.registerDic;
//                    [self.navigationController pushViewController:ageGender animated:YES];
//                    [ageGender release];
                    [self regeditRequest];
                }
                else
                {
                    [inputView setResult:kGDInputViewStatusError];
                    [UIAlertView showAlertViewWithTitle:@"失败" message:@"用户名已经被使用" cancelTitle:@"确定"];
                }
            }
            else
            {
                [UIAlertView showAlertViewWithTitle:@"失败" message:msg cancelTitle:@"确定"];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
        [UIAlertView showAlertViewWithTitle:@"格式错误" message:@"格式:字母/数字，不超过16个字符" cancelTitle:@"确定"];
    }

}

//注册
-(void)regeditRequest
{
    NSString *name = [self.registerDic objectForKey:@"name"];
    NSString *password  = [self.registerDic objectForKey:@"password"];
    int age = 1;
    NSString *sex = @"男";
    NSString *phone = [self.registerDic objectForKey:@"phoneNum"];
    NSString *phoneType = kPhotoType;
    NSString *phoneuuid = [[User shareInstance ]getOpenuuid];
    //注册
    [NetWorkManager networkUserRegistName:name password:password phone:phone sex:sex age:age phonetype:phoneType phoneuuid:phoneuuid success:^(BOOL flag, NSDictionary *userDic, NSString *msg) {
        if (flag) {
            //保存用户信息
            User * user = [User shareInstance];
            user.userId = [[userDic valueForKey:@"userid"]longValue];
            user.isFirstUse = NO;
            user.isSavePwd = YES;
            user.userName  = [userDic valueForKey:@"username"];
            user.userPwd = password;
            user.phoneNum = [userDic valueForKey:@"phone"];
            [user save];
            
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AlreadyEnterApp"];
            
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
            [UIAlertView showAlertViewWithTitle:@"失败" message:msg cancelTitle:@"确定"];
        }
        
    } failure:^(NSError *error) {
        
    }];

}

//验证昵称是否符合规范
- (BOOL)validateNickName:(NSString *)nickName
{
    NSString * reg = @"^[\u4e00-\u9fa5_A-Za-z0-9]{0,12}$";
    
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    
    return  [regex evaluateWithObject:nickName];
}


-(void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - textDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    GDInputView * nickInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [nickInputView setResult:kGDInputViewStatusNomal];
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
    GDInputView * nickInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [nickInputView setResult:kGDInputViewStatusNomal];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    GDInputView * nickInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [nickInputView setResult:kGDInputViewStatusDisable];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    GDInputView * nickInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [nickInputView setResult:kGDInputViewStatusDisable];
    }
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    GDInputView * nickInputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    if (textField.tag == kGDInputTextFieldTag) {
        [nickInputView setResult:kGDInputViewStatusNull];
    }
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
