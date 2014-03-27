//
//  ChangerPhoneViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-5.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "ChangerPhoneViewController.h"
#import "SetProfileTableCell.h"
#import "GDInputView.h"

#define kSetProfileTableCellTag 1111
#define kGDInputViewTag  2222
#define kauthBtnTag 3333
#define kconfirmBtnTag 4444

@interface ChangerPhoneViewController ()

@property (copy, nonatomic) NSString *authcode;
@property (copy, nonatomic) NSString *sequenceNo;
@property (copy, nonatomic) NSString *phoneNum;

@end

@implementation ChangerPhoneViewController

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
    
    self.phoneNum = NO;
    self.authcode = @"";
    self.sequenceNo = @"";
    
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
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 27, 120, 30)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"手机号码"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor appNavTitleColor]];
    [titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [navBar addSubview:titleLabel];
    [titleLabel release];
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(320-70, 20, 70, 44)];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_edit_normal@2x"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_edit_pressed@2x"] forState:UIControlStateHighlighted];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_confirm_pressed@2x"] forState:UIControlStateSelected];
    [saveBtn addTarget:self action:@selector(saveAtion:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:saveBtn];
    
    UIImage * welcomeImage = [UIImage imageNamed:@"nav_hint@2x"];
    //    welcomeImage = [welcomeImage stretchableImageWithLeftCapWidth:8 topCapHeight:10];
    //导航栏下方的欢迎条
    UIImageView * welcomeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 49)];
    [welcomeImgView setImage:welcomeImage];
    [mainView addSubview:welcomeImgView];
    [welcomeImgView release];
    
    UILabel * welcomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 310, 44)];
    [welcomeLabel setBackgroundColor:[UIColor clearColor]];
    [welcomeLabel setText:@"更换手机号需要重新进行短信验证"];
    [welcomeLabel setTextAlignment:NSTextAlignmentCenter];
    [welcomeLabel setTextColor:[UIColor whiteColor]];
    [welcomeLabel setFont:[UIFont appGreenWarnFont]];
    [welcomeImgView addSubview:welcomeLabel];
    [welcomeLabel release];
    
    
    SetProfileTableCell *cell = [[SetProfileTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setTag:kSetProfileTableCellTag];
    [cell setFrame:CGRectMake(0, 49+64+20, 320, 45)];
    [cell.titleLabel setHidden:NO];
    [cell.arrowImgView setHidden:NO];
    [cell.infoLabel setHidden:NO];
    [cell.titleLabel setText:@"手机号码"];
    [cell.infoLabel setText:[User shareInstance].phoneNum];
    [mainView addSubview:cell];
    [cell release];

    CGSize mLblHieht = [cell.infoLabel.text sizeWithFont:[UIFont fontWithName:@"FZY3JW--GB1-0" size:16] constrainedToSize:CGSizeMake(220, 30) lineBreakMode:NSLineBreakByCharWrapping];
    [cell.arrowImgView setFrame:CGRectMake(mLblHieht.width + 120, 19, 12, 12)];
    
    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    [bgImgView setImage:[UIImage imageNamed:@"bg_rss_pressed@2x"]];
    [cell setBackgroundView:bgImgView];
    [bgImgView release];
    
    //输入框
    GDInputView *inputView = [[GDInputView alloc]initWithFrame:CGRectMake(45, 65 + 135 + 100, 230, 36)];
    [inputView setAlpha:0.0];
    inputView.textfield.delegate = self;
    [inputView.textfield setPlaceholder:@"请输入新的手机号码"];
    [inputView setTag:kGDInputViewTag];
    [mainView addSubview:inputView];
    [inputView release];
    
    //获取验证码
    UIButton * authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [authBtn setTag:kauthBtnTag];
    [authBtn setAlpha:0.0];
    authBtn.showsTouchWhenHighlighted = YES;
    [authBtn setFrame:CGRectMake(45, 220+30+150, 230, 36)];
    [authBtn setBackgroundImage:[[UIImage imageNamed:@"btn_orange_normal"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [authBtn setBackgroundImage:[[UIImage imageNamed:@"btn_orange_pressed"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateSelected];
    [authBtn setBackgroundImage:[[UIImage imageNamed:@"btn_gray_normal"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateDisabled];
    [authBtn setTitle:@"免费获取验证码" forState:UIControlStateNormal];
    [authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [authBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [authBtn addTarget:self action:@selector(getAuthBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:authBtn];
    
    //发送验证码
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTag:kconfirmBtnTag];
    [confirmBtn setAlpha:0.0];
    confirmBtn.showsTouchWhenHighlighted = YES;
    [confirmBtn setFrame:CGRectMake(45, 270+50+200, 230, 36)];
    [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_blue_normal"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_blue_pressed"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateSelected];
    [confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [confirmBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [confirmBtn addTarget:self action:@selector(ensureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:confirmBtn];
    
    //测试使用lable
    //--------------------------------------------//
    UILabel * warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 290+56 +250, 250, 30)];
    [warnLabel setTag:12345];
    [warnLabel setBackgroundColor:[UIColor clearColor]];
    [warnLabel setText:@""];
    [warnLabel setAlpha:0.0];
    [warnLabel setTextAlignment:NSTextAlignmentLeft];
    [warnLabel setTextColor:[UIColor flatGreenColor]];
    [warnLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [mainView addSubview:warnLabel];
    [warnLabel release];
    //--------------------------------------------//
    
    
//    UIImage * txfBackImg = [UIImage imageNamed:@"input_white_normal@2x"];
//    txfBackImg = [txfBackImg stretchableImageWithLeftCapWidth:32 topCapHeight:32];
//    
//    UIImage * txfBackSelectedImg = [UIImage imageNamed:@"input_white_pressed@2x"];
//    txfBackSelectedImg = [txfBackSelectedImg stretchableImageWithLeftCapWidth:32 topCapHeight:32];
//    
//    UIImageView * txfBackBtn = [[UIImageView alloc]initWithFrame:CGRectMake(45, 80, 230, 36)];
//    [txfBackBtn setTag:31001];
//    txfBackBtn.userInteractionEnabled = YES;
//    [txfBackBtn setImage:txfBackImg];
//    [mainView addSubview:txfBackBtn];
//    [txfBackBtn release];
//    
//    UITextField * userNameTxf = [[UITextField alloc]initWithFrame:CGRectMake(9, 0, 220, 36)];
//    [userNameTxf setTag:30001];
//    [userNameTxf setDelegate:self];
//    [userNameTxf setBackgroundColor:[UIColor clearColor]];
//    [userNameTxf setBorderStyle:UITextBorderStyleNone];
//    [userNameTxf setPlaceholder:@"绑定账号的手机号"];
//    [userNameTxf setKeyboardType:UIKeyboardTypeNumberPad];
//    [txfBackBtn addSubview:userNameTxf];
//    [userNameTxf release];
//    
////    [self performSelector:@selector(becomeActived) withObject:self afterDelay:1.0];
//    
//    UIImage * authBackImg = [UIImage imageNamed:@"btn_blue_normal@2x"];
//    authBackImg = [authBackImg stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//    
//    UIButton * authInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    authInBtn.showsTouchWhenHighlighted = YES;
//    [authInBtn setFrame:CGRectMake(45, 180, 230, 36)];
//    [authInBtn setBackgroundImage:authBackImg forState:UIControlStateNormal];
//    [authInBtn setTitle:@"登录" forState:UIControlStateNormal];
//    [authInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [authInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [authInBtn addTarget:self action:@selector(getAuthBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [mainView addSubview:authInBtn];
//    
//    
//    UIImage * ensureBackImg = [UIImage imageNamed:@"btn_blue_normal@2x"];
//    ensureBackImg = [ensureBackImg stretchableImageWithLeftCapWidth:12 topCapHeight:0];
//    
//    UIButton * ensureInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    ensureInBtn.showsTouchWhenHighlighted = YES;
//    [ensureInBtn setFrame:CGRectMake(45, 180, 230, 36)];
//    [ensureInBtn setBackgroundImage:ensureBackImg forState:UIControlStateNormal];
//    [ensureInBtn setTitle:@"登录" forState:UIControlStateNormal];
//    [ensureInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [ensureInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [ensureInBtn addTarget:self action:@selector(ensureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [mainView addSubview:ensureInBtn];
    
}

-(void)saveAtion:(UIButton *)button
{
    button.selected = !button.selected;
    button.hidden = YES;
    if (button.selected) {
        [self showAuthViews];
    }
    else
    {
        //保存
    }
}

-(void)showAuthViews
{
    SetProfileTableCell * cell = (SetProfileTableCell *)[self.view viewWithTag:kSetProfileTableCellTag];
    [cell.titleLabel setTextColor:[UIColor lightGrayColor]];
    [cell.infoLabel setTextColor:[UIColor lightGrayColor]];
    [cell.arrowImgView setImage:[UIImage imageNamed:@"ic_start_empty@2x"]];
    
    GDInputView * inputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    UIButton *getauthBtn = (UIButton *)[self.view viewWithTag:kauthBtnTag];
    UIButton *ensureBtn = (UIButton *)[self.view viewWithTag:kconfirmBtnTag];
     UILabel * warnLable = (UILabel *)[self.view viewWithTag:12345];

    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        inputView.frame = CGRectMake(45, 65 + 135, 230, 36);
        inputView.alpha = 1.0;
        getauthBtn.frame = CGRectMake(45, 220+30, 230, 36);
        getauthBtn.alpha = 1.0;
        ensureBtn.frame = CGRectMake(45, 270+40, 230, 36);
        ensureBtn.alpha = 1.0;
        warnLable.frame = CGRectMake(45, 290+56, 250, 30);
        warnLable.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)getAuthBtnClicked:(UIButton *)sender
{
    GDInputView * inputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    NSString * phoneNum = inputView.textfield.text;
    [inputView.textfield resignFirstResponder];
    
    if ([AppUtility validateMobile:phoneNum]) {
        //检测手机号是否被注册之后再获取验证码
        [self checkPhone:phoneNum success:^{
            
            inputView.textfield.text = @"";
            [inputView.textfield setPlaceholder:@"请输入6位验证码"];
            _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countSecond:) userInfo:nil repeats:YES];
            _leftSeconds = 60;
            
        } failure:^(NSString *message) {
            
        }];

    }
    else
    {
        [inputView setResult:kGDInputViewStatusError];
    }

}

//检测手机号码
-(void)checkPhone:(NSString *)phone success:(void (^)(void))success failure:(void (^)(NSString *message))failure
{
    GDInputView * inputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];

    [NetWorkManager networkCheckPhone:phone success:^(BOOL flag, BOOL userable, NSString *msg) {
        if (flag) {
            if (userable) {
                //保存手机号
                self.phoneNum = [phone copy];
                [self getAuthCode:phone type:2 success:^{
                    success();
                } failure:^(NSString *message) {
                    failure(message);
                }];
                [inputView setResult:kGDInputViewStatusTure];
            }
            else
            {
                [UIAlertView showAlertViewWithTitle:@"此号码已经被注册" tag:80000 cancelTitle:@"确定" ensureTitle:nil delegate:nil];
                [inputView setResult:kGDInputViewStatusError];
            }
        }
        else
        {
            [UIAlertView showAlertViewWithTitle:msg tag:80000 cancelTitle:@"确定" ensureTitle:nil delegate:nil];
            failure(msg);
        }
    } failure:^(NSError *error) {
        failure([error localizedDescription]);
    }];
}

//获取验证码
-(void)getAuthCode:(NSString *)phone type:(int)type success:(void (^)(void))success failure:(void (^)(NSString *message))failure
{
     GDInputView * inputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    [NetWorkManager networkGetauthcodeWithPhone:phone type:type mode:kNetworkrequestModeRequest success:^(BOOL flag, NSString *authcode, NSString *sequenceNo, NSString *msg) {
        if (flag) {
            self.authcode = [authcode copy];
            self.sequenceNo = [sequenceNo copy];
            
            //测试用，短信回执比较慢，直接显示验证密码
            UILabel * warnLable = (UILabel *)[self.view viewWithTag:12345];
            warnLable.text = [NSString stringWithFormat:@"序列号:%@ 验证码:%@ ",self.sequenceNo,self.authcode];
            success();
        }
        else
        {
            [UIAlertView showAlertViewWithTitle:msg tag:80000 cancelTitle:@"确定" ensureTitle:nil delegate:nil];
            [inputView setResult:kGDInputViewStatusError];
            failure(msg);
        }
    } failure:^(NSError *error) {
        failure([error localizedDescription]);
    }];
}


-(void)ensureBtnClicked:(UIButton *)sender
{
    GDInputView * inputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];

    //提交
    if (_leftSeconds > 0) {
        if ([_authcode isEqualToString:inputView.textfield.text]) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(savePhoneNum:)])
            {
                [self.delegate savePhoneNum:self.phoneNum];
            }
            [self backToMain];
        }
    }
    else
    {

    }
}

-(void)hideKeyBoard
{
    GDInputView * inputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    [inputView.textfield resignFirstResponder];
}

-(void)backToMain
{
    [_countTimer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)countSecond:(NSTimer *)timer
{
    UIButton *getauthBtn = (UIButton *)[self.view viewWithTag:kauthBtnTag];
    GDInputView *inputView = (GDInputView *)[self.view viewWithTag:kGDInputViewTag];
    
    if (_leftSeconds >= 1) {
        _leftSeconds = _leftSeconds -1;
        [getauthBtn setEnabled:NO];
        [getauthBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [getauthBtn setTitle:[NSString stringWithFormat:@"(%d)免费获取验证码",_leftSeconds] forState:UIControlStateNormal];
    }
    else{

        [inputView.textfield resignFirstResponder];
        [inputView.textfield setPlaceholder:@"请输入新的手机号码"];
        [getauthBtn setEnabled:YES];
        [getauthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [getauthBtn setTitle:@"免费获取验证码" forState:UIControlStateNormal];
        
        [_countTimer invalidate];
    }
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
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
