
//  MainViewController.m

//  CarApp

//

//  Created by Leno on 13-9-12.

//  Copyright (c) 2013年 Leno. All rights reserved.

//

#import "MainViewController.h"

#import "SettingViewController.h"


#import "ConnectStateView.h"

#import "ProfileViewController.h"
#import "SetProfileViewController.h"
#import "LogInViewController.h"

#import "PeopleManager.h"
#import "XmppManager.h"
#import "Room.h"

#define kBKPerRowCellNum 10

@interface MainViewController ()

@property (strong, nonatomic) Room *currentCommentRoom;//当前评论房间

@end

@implementation MainViewController

@synthesize firstEnter = _firstEnter;

-(void)dealloc
{
    _currentCommentRoom = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector() name:@"XmppStreamWillConnnect" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector() name:@"XmppStreamWillConnnect" object:nil];
    
    [self reloadViewData];
}

- (void)reloadViewData
{
    switch ((int)self.mainScrollView.contentOffset.x/320) {
        case 0:
            break;
        case 1:
            [_mainsecondView autoRefreshTable];
            break;
        case 2:
            [_mainThirdView autoRefreshTable];
            break;
        default:
            break;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)enterView
{
    //如首次进入则提示补充资料
    if (self.firstEnter == YES) {
        DLog(@"===========>>首次进入首页");
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"欢迎来到易行" delegate:self cancelButtonTitle:@"直接使用" otherButtonTitles:@"补充资料",nil];
        [alert setTag:11001];
        [alert setDelegate:self];
        [alert show];
    }
    
    if ([User shareInstance].isSavePwd) {
        //定位
        [[LocationServer shareInstance] startLocation];
    }

    //xmpp连接
//    [[XmppManager sharedInstance]connect];
    
    //获取用户信息
    [self getUserInfo];
    
    NSString * userName = [User shareInstance].userName;
    [self setMessageText:[NSString stringWithFormat:@"%@好! %@,欢迎来到易行",[AppUtility ampmStrTimeDate:[NSDate date]],userName]];
    
    [self.mainScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
}

-(void)showRouteView
{
    [self.mainScrollView setContentOffset:CGPointMake(320, 0)];
    [_pageControl setCurrentPage:1];
    [_mainsecondView autoRefreshTable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     User *user = [User shareInstance];
    
    [self setMessageText:[NSString stringWithFormat:@"%@好! %@,欢迎来到易行",[AppUtility ampmStrTimeDate:[NSDate date]],user.userName]];
    
    ConnectStateView *connectStateView = [[ConnectStateView alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    _connectStateView = connectStateView;
    
    //主页的ScrollView
    //因为要调用左右滑动可重复显示三个界面,所以初始时将第一个FirstView插入到最后一页,把ThirdView插入到第一页
    UIScrollView * mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 45, 320, APPLICATION_HEGHT -45-44-48)];
    [mainScrollView setBackgroundColor:[UIColor colorWithRed:(float)243/255 green:(float)243/255 blue:(float)243/255 alpha:1]];
    [mainScrollView setShowsHorizontalScrollIndicator:NO];
    [mainScrollView setShowsVerticalScrollIndicator:NO];
    [mainScrollView setContentSize:CGSizeMake( 320 *3, APPLICATION_HEGHT -45 -44-48)];
    [mainScrollView setContentOffset:CGPointMake(0, 0)];
    [mainScrollView setPagingEnabled:YES];
    [mainScrollView setBounces:YES];
    [mainScrollView setDelegate:self];
    [self.view insertSubview:mainScrollView belowSubview:_messageBgView];
    self.mainScrollView = mainScrollView;

    //第一页的背景
    MainFirstView * firstView = [[MainFirstView alloc]initWithFrame:CGRectMake(0, 0, 320, APPLICATION_HEGHT -48-44-45)];
    firstView.mainVC = self;
    [firstView setBackgroundColor:[UIColor colorWithRed:(float)243/255 green:(float)243/255 blue:(float)243/255 alpha:1]];
    [mainScrollView addSubview:firstView];
    
    //第二页的背景
    MainSecondView * secondView = [[MainSecondView alloc]initWithFrame:CGRectMake(320, 0, 320, APPLICATION_HEGHT -48-44-45)];
    secondView.mainVC = self;
    [secondView setBackgroundColor:[UIColor colorWithRed:(float)243/255 green:(float)243/255 blue:(float)243/255 alpha:1]];
    [mainScrollView addSubview:secondView];
    
    //第三页码
    CommonRouteView *commonRouteView = [[CommonRouteView alloc]initWithFrame:CGRectMake(640, 0, 320, APPLICATION_HEGHT -48-44-45)];
    commonRouteView.mainVC = self;
    [commonRouteView setBackgroundColor:[UIColor colorWithRed:(float)243/255 green:(float)243/255 blue:(float)243/255 alpha:1]];
    [mainScrollView addSubview:commonRouteView];
    
    //3个显示的PageControl
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(130, APPLICATION_HEGHT-44 -59, 60, 10)];
    [_pageControl setCurrentPage:0];
    [_pageControl setNumberOfPages:3];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        [_pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    }
    
    [self.view addSubview:_pageControl];
    
    UIImage * bottomImage = [UIImage imageNamed:@"tab_bar@2x"];
    bottomImage = [bottomImage stretchableImageWithLeftCapWidth:4 topCapHeight:10];
    //底部的背景框
    UIImageView * bottomBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, APPLICATION_HEGHT -48-44, 320, 48)];
    bottomBar.userInteractionEnabled = YES;
    [bottomBar setBackgroundColor:[UIColor clearColor]];
    [bottomBar setImage:bottomImage];
    [self.view addSubview:bottomBar];
    
    //更多按钮
    UIButton * MoreButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [MoreButton setFrame:CGRectMake(140, 4, 40, 40)];
    [MoreButton setBackgroundColor:[UIColor clearColor]];
    [MoreButton setBackgroundImage:[UIImage imageNamed:@"btn_more_normal@2x"] forState:UIControlStateNormal];
    [MoreButton setBackgroundImage:[UIImage imageNamed:@"btn_more_pressed@2x"] forState:UIControlStateHighlighted];
    [MoreButton addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:MoreButton];
    _moreBtn = MoreButton;
    
    UIButton * profileButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [profileButton setFrame:CGRectMake(300, 4, 40, 40)];
    [profileButton setAlpha:0.0];
    [profileButton setBackgroundColor:[UIColor clearColor]];
    [profileButton setBackgroundImage:[UIImage imageNamed:@"btn_user_normal@2x"] forState:UIControlStateNormal];
    [profileButton setBackgroundImage:[UIImage imageNamed:@"btn_user_pressed@2x"] forState:UIControlStateHighlighted];
    [profileButton addTarget:self action:@selector(enterProfile) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:profileButton];
    _profileBtn = profileButton;
    
    UIButton * settingButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [settingButton setFrame:CGRectMake(440, 4, 40, 40)];
    [settingButton setAlpha:0.0];
    [settingButton setBackgroundColor:[UIColor clearColor]];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_setting_normal@2x"] forState:UIControlStateNormal];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_setting_pressed@2x"] forState:UIControlStateHighlighted];
    [settingButton addTarget:self action:@selector(enterSetting) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:settingButton];
    _settingBtn = settingButton;
}

//获取用户信息
-(void)getUserInfo
{
    /*
    //保存用户信息
    [NetWorkManager networkGetUserInfoWithuid:[User shareInstance].userId success:^(BOOL flag, NSDictionary *userInfo, NSString *msg) {
        
        if (flag) {
            People *people = [[People alloc]initFromDic:userInfo];
            [User shareInstance].userName = people.name;
            [User shareInstance].userData = [NSMutableDictionary dictionaryWithDictionary:userInfo];//保存网络请求下来的数据
            [PeopleManager insertPeopleShortInfo:people];
        }
        
    } failure:^(NSError *error) {
        
    }];
     */
}

static bool _bool = YES;
//点击更多按钮
-(void)showMore
{
    _bool = !_bool;
    
    DLog(@"点击更多....");
    
    if (_bool == NO) {
        [_moreBtn setBackgroundImage:[UIImage imageNamed:@"btn_more_pressed@2x"] forState:UIControlStateNormal];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        [_moreBtn setFrame:CGRectMake(35, 4, 40, 40)];
        [_profileBtn setFrame:CGRectMake(115, 4, 40, 40)];
        [_settingBtn setFrame:CGRectMake(210, 4, 40, 40)];
        [_profileBtn setAlpha:0.7];
        [_settingBtn setAlpha:0.7];
        [UIView setAnimationDidStopSelector:@selector(moveBtnToNormal)];
        [UIView commitAnimations];
    }
    else if (_bool == YES)
    {
        [_moreBtn setBackgroundImage:[UIImage imageNamed:@"btn_more_normal@2x"] forState:UIControlStateNormal];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        [_moreBtn setFrame:CGRectMake(140, 4, 40, 40)];
        [_profileBtn setFrame:CGRectMake(300, 4, 40, 40)];
        [_settingBtn setFrame:CGRectMake(440, 4, 40, 40)];
        [_profileBtn setAlpha:0.0];
        [_settingBtn setAlpha:0.0];
        [UIView commitAnimations];
    }
}

-(void)moveBtnToNormal
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [_moreBtn setFrame:CGRectMake(40, 4, 40, 40)];
    [_profileBtn setFrame:CGRectMake(140, 4, 40, 40)];
    [_settingBtn setFrame:CGRectMake(230, 4, 40, 40)];
    [_profileBtn setAlpha:1.0];
    [_settingBtn setAlpha:1.0];
    [UIView commitAnimations];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    int page = (int)offset/320;
    
    [self setPageControlIndex:page];
}


-(void)setPageControlIndex:(int)number
{
    
    NSString * userName = [User shareInstance].userName;
    
    if(_pageControl.currentPage == number) {
        return;
    }
    
    switch (number) {
        case 0:
            [_pageControl setCurrentPage:0];
            [self setMessageText:[NSString stringWithFormat:@"%@好! %@,欢迎来到易行",[AppUtility ampmStrTimeDate:[NSDate date]],userName]];
            break;
        case 1:
            [_pageControl setCurrentPage:1];
            [self setMessageText:[NSString stringWithFormat:@"%@好! %@,您的当前出行计划如下",[AppUtility ampmStrTimeDate:[NSDate date]],userName]];
            [_mainsecondView autoRefreshTable];
            break;
        case 2:
            [_pageControl setCurrentPage:2];
            [self setMessageText:[NSString stringWithFormat:@"%@,您的常用路线",userName]];
            [_mainThirdView autoRefreshTable];
            break;
        default:
            break;
    }
}

-(void)enterProfile
{
    ProfileViewController * profileVC = [[ProfileViewController alloc]init];
    profileVC.uid = [User shareInstance].userId;
    profileVC.state = 2;
    [self.navigationController pushViewController:profileVC animated:YES];
}

-(void)enterSetting
{
    SettingViewController * settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - UIAleartViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //首次登入引导
    if (alertView.tag == 11001) {
//        if (buttonIndex == 1) {
//            DLog(@"查看引导");
//        }
        if (buttonIndex == 1) {
            DLog(@"补充资料");
            SetProfileViewController * setProfilevc = [[SetProfileViewController alloc]init];
            [self.navigationController pushViewController:setProfilevc animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
