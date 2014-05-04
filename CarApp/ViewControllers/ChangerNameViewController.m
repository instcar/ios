//
//  ChangerNameViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-7.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "ChangerNameViewController.h"
#import "GDInputView.h"

#define kGDInputViewTag  2222

@interface ChangerNameViewController ()<UITextFieldDelegate>

@end

@implementation ChangerNameViewController

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
    [titleLabel setText:@"昵称"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor appNavTitleColor]];
    [titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [navBar addSubview:titleLabel];
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(320-70, 20, 70, 44)];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_confirm_normal@2x"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_confirm_pressed@2x"] forState:UIControlStateHighlighted];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_confirm_pressed@2x"] forState:UIControlStateSelected];
    [saveBtn addTarget:self action:@selector(saveAtion:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:saveBtn];
    
    UIImage * welcomeImage = [UIImage imageNamed:@"nav_hint@2x"];
    //    welcomeImage = [welcomeImage stretchableImageWithLeftCapWidth:8 topCapHeight:10];
    //导航栏下方的欢迎条
    UIImageView * welcomeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 49)];
    [welcomeImgView setImage:welcomeImage];
    [mainView addSubview:welcomeImgView];
    
    UILabel * welcomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 310, 44)];
    [welcomeLabel setBackgroundColor:[UIColor clearColor]];
    [welcomeLabel setText:@"字母、数字、英文、下划线或汉字，最多16个字符"];
    [welcomeLabel setTextAlignment:NSTextAlignmentCenter];
    [welcomeLabel setTextColor:[UIColor whiteColor]];
    [welcomeLabel setFont:[UIFont appGreenWarnFont]];
    [welcomeImgView addSubview:welcomeLabel];
    
//    UILabel * nameLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 4, 310, 40)];
//    [nameLable setBackgroundColor:[UIColor clearColor]];
//    [nameLable setText:@"更换手机号需要重新进行短信验证"];
//    [nameLable setTextAlignment:NSTextAlignmentCenter];
//    [nameLable setTextColor:[UIColor whiteColor]];
//    [nameLable setFont:[UIFont fontWithName:@"FZY3JW--GB1-0" size:12]];
//    [nameLable addSubview:welcomeLabel];
//    [nameLable release];
    
    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 65 + 60, 320, 45)];
    [bgImgView setImage:[UIImage imageNamed:@"bg_rss_pressed@2x"]];
    [mainView addSubview:bgImgView];
    
    //输入框
    GDInputView *inputView = [[GDInputView alloc]initWithFrame:CGRectMake(45, 65 + 64, 230, 36)];
    inputView.textfield.delegate = self;
    [inputView.textfield setPlaceholder:@"请输入新的昵称"];
    [inputView setTag:kGDInputViewTag];
    [mainView addSubview:inputView];
}

-(void)saveAtion:(UIButton *)button
{

    //保存
    GDInputView * inputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    
    if ([inputView.textfield.text isEqualToString:@""]) {
        [self performSelector:@selector(backToMain) withObject:nil afterDelay:0.3];
        return;
    }
    if ([self validateNickName:inputView.textfield.text]) {
        /*
        [NetWorkManager networkCheckUserName:inputView.textfield.text success:^(int status, NSObject *data, NSString *msg) {
            if (status == 200) {
                    [inputView setResult:kGDInputViewStatusTure];
                    
                    [self.delegate saveNickName:inputView.textfield.text];
                    
                    [self performSelector:@selector(backToMain) withObject:nil afterDelay:0.3];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:msg];
                [inputView setResult:kGDInputViewStatusError];
                
            }
        } failure:^(NSError *error) {
            
        }];*/
    }
    else
    {
        [inputView setResult:kGDInputViewStatusError];
        [UIAlertView showAlertViewWithTitle:@"格式错误" message:@"格式:字母、数字、英文、下划线或汉字，不超过16个字符" cancelTitle:@"确定"];
    }

}

-(void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

//验证昵称是否符合规范
- (BOOL)validateNickName:(NSString *)nickName
{
    NSString * reg = @"^[\u4e00-\u9fa5_A-Za-z0-9]{0,12}$";
    
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    
    return  [regex evaluateWithObject:nickName];
}


#pragma mark - textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    GDInputView * inputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    [inputView setResult:kGDInputViewStatusNomal];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    GDInputView * inputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    [inputView setResult:kGDInputViewStatusDisable];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    GDInputView * inputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    [inputView setResult:kGDInputViewStatusNomal];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    GDInputView * inputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    if (YES) {
        [inputView setResult:kGDInputViewStatusTure];
    }
    else
    {
        [inputView setResult:kGDInputViewStatusError];
    }
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    GDInputView * inputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    [inputView setResult:kGDInputViewStatusNull];
    return YES;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
