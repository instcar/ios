//
//  SetAgeGenderViewController.m
//  CarApp
//
//  Created by 海龙 李 on 13-11-17.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "SetAgeGenderViewController.h"
#import "XmppManager.h"

@interface SetAgeGenderViewController ()

@end

@implementation SetAgeGenderViewController

@synthesize pickerBackView = _pickerBackView;
@synthesize pickerView = _pickerView;
@synthesize ageArray = _ageArray;

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

    
    UILabel * infoLabel = [[[UILabel alloc]initWithFrame:CGRectMake(45, 86, 200, 20)]autorelease];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [infoLabel setTextAlignment:NSTextAlignmentLeft];
    [infoLabel setTextColor:[UIColor blackColor]];
    [infoLabel setFont:[UIFont fontWithName:kFangZhengFont size:15]];
    [infoLabel setText:@"请选择年龄"];
    [mainView addSubview:infoLabel];
    [infoLabel release];
    
    UIImage * txfBackSelectedImg = [UIImage imageNamed:@"input_white_normal@2x"];
    txfBackSelectedImg = [txfBackSelectedImg stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    
    UIImageView * txfBackBtn = [[UIImageView alloc]initWithFrame:CGRectMake(45, 114, 230, 36)];
    [txfBackBtn setTag:61001];
    txfBackBtn.userInteractionEnabled = YES;
    [txfBackBtn setImage:txfBackSelectedImg];
    [mainView addSubview:txfBackBtn];
    [txfBackBtn release];
    
    UILabel * ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 36)];
    [ageLabel setTag:60002];
    ageLabel.userInteractionEnabled = YES;
    [ageLabel setBackgroundColor:[UIColor clearColor]];
    [ageLabel setText:@"点击设置年龄"];
    [ageLabel setTextAlignment:NSTextAlignmentLeft];
    [ageLabel setTextColor:[UIColor grayColor]];
    [ageLabel setFont:[UIFont fontWithName:kFangZhengFont size:16]];
    [txfBackBtn addSubview:ageLabel];
    [ageLabel release];
    
    
    UILabel * infoLabel2 = [[[UILabel alloc]initWithFrame:CGRectMake(45, 158, 200, 20)]autorelease];
    [infoLabel2 setBackgroundColor:[UIColor clearColor]];
    [infoLabel2 setTextAlignment:NSTextAlignmentLeft];
    [infoLabel2 setTextColor:[UIColor blackColor]];
    [infoLabel2 setFont:[UIFont fontWithName:kFangZhengFont size:15]];
    [infoLabel2 setText:@"请选择性别"];
    [mainView addSubview:infoLabel2];
    [infoLabel2 release];
    
    UIButton * maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [maleBtn setTag:70001];
    [maleBtn setFrame:CGRectMake(45, 186, 101, 35)];
    [maleBtn setBackgroundColor:[UIColor clearColor]];
    [maleBtn setBackgroundImage:[UIImage imageNamed:@"btn_male_pressed"] forState:UIControlStateNormal];
    [maleBtn addTarget:self action:@selector(maleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:maleBtn];
    
    UIButton * femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [femaleBtn setTag:70002];
    [femaleBtn setFrame:CGRectMake(320 -101 -45, 186, 101, 35)];
    [femaleBtn setBackgroundColor:[UIColor clearColor]];
    [femaleBtn setBackgroundImage:[UIImage imageNamed:@"btn_female_normal"] forState:UIControlStateNormal];
    [femaleBtn addTarget:self action:@selector(femaleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:femaleBtn];
    
    
    UIImage * logBackImg = [UIImage imageNamed:@"btn_orange_normal@2x"];
    logBackImg = [logBackImg stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    UIImage * logBackImgHl = [UIImage imageNamed:@"btn_orange_pressed@2x"];
    logBackImgHl = [logBackImgHl stretchableImageWithLeftCapWidth:12 topCapHeight:0];

    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.showsTouchWhenHighlighted = YES;
    [nextBtn setFrame:CGRectMake(45, 230, 230, 36)];
    [nextBtn setBackgroundImage:logBackImg forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:logBackImgHl forState:UIControlStateHighlighted];
    [nextBtn setTitle:@"完成注册" forState:UIControlStateNormal];
    [nextBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [nextBtn addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:nextBtn];
    
    
    UITapGestureRecognizer * ageTappp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAge:)];
    [ageLabel addGestureRecognizer:ageTappp];
    [ageTappp release];
    
    self.pickerBackView = [AMBlurView new];
    [self.pickerBackView setFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 216)];
    [self.view addSubview:self.pickerBackView];
    
    
    // 选择年龄的 Picker 及 SubView
    UIButton * confirmAgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmAgeBtn setTag:60006];
    [confirmAgeBtn setFrame:CGRectMake(280, SCREEN_HEIGHT, 40, 30)];
    [confirmAgeBtn setBackgroundColor:[UIColor orangeColor]];
    [confirmAgeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmAgeBtn addTarget:self action:@selector(hideAgePickerView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmAgeBtn];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 216)];
    self.pickerView.delegate=self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator=YES;
    [self.view addSubview:self.pickerView];
    
    self.ageArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 43; i++) {
        NSString * age = [NSString stringWithFormat:@"%d",18+i];
        NSLog(@"++++ %@ ++++",age);
        [self.ageArray addObject:age];
    }
    
}


-(void)changeAge:(id)sender
{
    UIButton * confirmAgeBtn = (UIButton *)[self.view viewWithTag:60006];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];//动画时间长度，单位秒，浮点数
    self.pickerBackView.frame = CGRectMake(0.0, SCREEN_HEIGHT - 216, 320.0, 216.0);
    self.pickerView.frame = CGRectMake(0.0, SCREEN_HEIGHT - 216, 320.0, 216.0);
    confirmAgeBtn.frame = CGRectMake(280.0, SCREEN_HEIGHT - 216 -30, 40, 30);
    [UIView commitAnimations];
}



-(void)hideAgePickerView
{
    UIButton * confirmAgeBtn = (UIButton *)[self.view viewWithTag:60006];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];//动画时间长度，单位秒，浮点数
    self.pickerBackView.frame = CGRectMake(0.0, SCREEN_HEIGHT, 320.0, 216.0);
    self.pickerView.frame = CGRectMake(0.0, SCREEN_HEIGHT, 320.0, 216.0);
    confirmAgeBtn.frame = CGRectMake(280.0, SCREEN_HEIGHT, 40, 30);
    [UIView commitAnimations];
    
    UILabel * ageLabel = (UILabel *)[self.view viewWithTag:60002];
    [ageLabel setText:[NSString stringWithFormat:@"%@岁",[self.ageArray objectAtIndex:_ageIndex]]];
    
    _age = [[self.ageArray objectAtIndex:_ageIndex]intValue];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.ageArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * ageee = [self.ageArray objectAtIndex:row];
    return ageee;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _ageIndex = row;
}


-(void)maleBtnClicked:(id)sender
{
    _sex = @"男";
    
    UIButton * maleBtn = (UIButton *)[self.view viewWithTag:70001];
    UIButton * femaleBtn = (UIButton *)[self.view viewWithTag:70002];

    [maleBtn setBackgroundImage:[UIImage imageNamed:@"btn_male_pressed"] forState:UIControlStateNormal];
    [femaleBtn setBackgroundImage:[UIImage imageNamed:@"btn_female_normal"] forState:UIControlStateNormal];
}


-(void)femaleBtnClicked:(id)sender
{
    _sex = @"女";
    
    UIButton * maleBtn = (UIButton *)[self.view viewWithTag:70001];
    UIButton * femaleBtn = (UIButton *)[self.view viewWithTag:70002];

    [maleBtn setBackgroundImage:[UIImage imageNamed:@"btn_male_normal"] forState:UIControlStateNormal];
    [femaleBtn setBackgroundImage:[UIImage imageNamed:@"btn_female_pressed"] forState:UIControlStateNormal];
}


-(void)nextBtnClicked:(id)sender
{
    if(_age > 17 && _sex != nil && ![_sex isEqualToString:@""])
    {
        NSString *name = [self.registerDic objectForKey:@"name"];
        NSString *password  = [self.registerDic objectForKey:@"password"];
        int age = _age;
        NSString *sex = _sex;
        NSString *phone = [self.registerDic objectForKey:@"phoneNum"];
        NSString *phoneType = kPhotoType;
        NSString *phoneuuid = [[User shareInstance ]getOpenuuid];
        //注册
        [NetWorkManager networkUserRegistName:name password:password phone:phone sex:sex age:age phonetype:phoneType phoneuuid:phoneuuid success:^(BOOL flag, NSDictionary *userDic, NSString *msg) {
            
            if (flag) {
                //保存用户信息
                User * user = [User shareInstance];
                user.userId = [[userDic valueForKey:@"uid"]longValue];
                user.isFirstUse = NO;
                user.isSavePwd = YES;
                user.userName  = [userDic valueForKey:@"username"];
                user.userPwd = password;
                user.phoneNum = [userDic valueForKey:@"phone"];
                
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AlreadyEnterApp"];
                
                UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:[AppDelegate shareDelegate].mainVC];
                [navi setNavigationBarHidden:YES];
                [AppDelegate shareDelegate].mainVC.firstEnter = YES;
                [[AppDelegate shareDelegate].mainVC enterView];
                [self presentViewController:navi animated:YES completion:nil];
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
        if (_age <18 ) {
            [UIAlertView showAlertViewWithTitle:@"失败" message:@"年龄不能为空" cancelTitle:@"确定"];
        }
        if (_sex == nil || [_sex isEqualToString:@""]) {
            [UIAlertView showAlertViewWithTitle:@"失败" message:@"请选择性别" cancelTitle:@"确定"];
        }
    }
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
