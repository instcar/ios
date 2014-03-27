
//  MainViewController.m

//  CarApp

//

//  Created by Leno on 13-9-12.

//  Copyright (c) 2013年 Leno. All rights reserved.

//

#import "MainViewController.h"

#import "SettingViewController.h"

#import "MainFirstView.h"
#import "MainSecondView.h"
#import "MainThirdView.h"
#import "CommonRouteView.h"
#import "ConnectStateView.h"

#import "ProfileViewController.h"
#import "SetProfileViewController.h"
#import "LogInViewController.h"

#import "PeopleManager.h"
#import "XmppManager.h"


#define kBKPerRowCellNum 10
#define kmainScrollViewTag 20000

@interface MainViewController ()

@property (retain, nonatomic) Room *currentCommentRoom;//当前评论房间

@end

@implementation MainViewController

@synthesize firstEnter = _firstEnter;

-(void)dealloc
{
    [SafetyRelease release:_mainScrollView];
    [SafetyRelease release:_currentCommentRoom];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
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
    [self.navigationController setNavigationBarHidden:YES];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector() name:@"XmppStreamWillConnnect" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector() name:@"XmppStreamWillConnnect" object:nil];
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
        [alert release];
    }
    
    if ([[User shareInstance]isSavePwd]) {
        //定位
        [[LocationServer shareInstance] startLocation];
    }

    //xmpp连接
    [[XmppManager sharedInstance]connect];
    
    //获取用户信息
    [self getUserInfo];
    
    UILabel * titleLabel = (UILabel *)[self.view viewWithTag:5876];
    NSString * userName = [User shareInstance].userName;
    [titleLabel setText:[NSString stringWithFormat:@"%@好! %@,欢迎来到易行",[AppUtility ampmStrTimeDate:[NSDate date]],userName]];
    
    UIScrollView *mainScrollView = (UIScrollView *)[self.view viewWithTag:kmainScrollViewTag];
    [mainScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
}

-(void)showRouteView
{
    MainSecondView *mainsecondView = (MainSecondView *)[self.view viewWithTag:1002];
    UIPageControl * pageControl = (UIPageControl *)[self.view viewWithTag:100];
    [self.mainScrollView setContentOffset:CGPointMake(320, 0)];
    [pageControl setCurrentPage:1];
    [mainsecondView autoRefreshTable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    UIView * mainView = [[UIView alloc]initWithFrame:[AppUtility mainViewFrame]];
    [mainView setBackgroundColor:[UIColor flatWhiteColor]];
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

    //App标题
    UIImageView * titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake((320-50)/2, 20, 50, 44)];
    [titleImgView setImage:[UIImage imageNamed:@"logo_normal@2x"]];
    [titleImgView setContentMode:UIViewContentModeScaleAspectFit];
    
    ConnectStateView *connectStateView = [[ConnectStateView alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    _connectStateView = connectStateView;
    
    UINavigationItem *navgationItem = [[UINavigationItem alloc]init];
    
    [navgationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:connectStateView]];
    [connectStateView release];
    
    [navgationItem setTitleView:titleImgView];
    [titleImgView release];
    
    [navBar pushNavigationItem:navgationItem animated:NO];
    
    UIImage * welcomeImage = [UIImage imageNamed:@"nav_hint@2x"];
    //    welcomeImage = [welcomeImage stretchableImageWithLeftCapWidth:8 topCapHeight:10];
    //导航栏下方的欢迎条
    UIImageView * welcomeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 49)];
    [welcomeImgView setImage:welcomeImage];
    [mainView addSubview:welcomeImgView ];
    [welcomeImgView release];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
    [titleLabel setTag:5876];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    User *user = [User shareInstance];
    [titleLabel setText:[NSString stringWithFormat:@"%@好! %@,欢迎来到易行",[AppUtility ampmStrTimeDate:[NSDate date]],user.userName]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont appGreenWarnFont]];
    [welcomeImgView insertSubview:titleLabel belowSubview:navBar];
    [titleLabel release];
    
    //主页的ScrollView
    //因为要调用左右滑动可重复显示三个界面,所以初始时将第一个FirstView插入到最后一页,把ThirdView插入到第一页
    UIScrollView * mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, 320, SCREEN_HEIGHT -48-64)];
    [mainScrollView setTag:kmainScrollViewTag];
    [mainScrollView setBackgroundColor:[UIColor colorWithRed:(float)243/255 green:(float)243/255 blue:(float)243/255 alpha:1]];
    [mainScrollView setShowsHorizontalScrollIndicator:NO];
    [mainScrollView setShowsVerticalScrollIndicator:NO];
    [mainScrollView setContentSize:CGSizeMake( 320 *3, SCREEN_HEIGHT -82 -64)];
    [mainScrollView setContentOffset:CGPointMake(0, 0)];
    [mainScrollView setPagingEnabled:YES];
    [mainScrollView setBounces:YES];
    [mainScrollView setDelegate:self];
    [mainView insertSubview:mainScrollView belowSubview:welcomeImgView];
    self.mainScrollView = mainScrollView;
    [mainScrollView release];
    
    //第一页的背景
    MainFirstView * firstView = [[MainFirstView alloc]initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT -48-64)];
    firstView.mainVC = self;
    [firstView setTag:1001];
    [firstView setBackgroundColor:[UIColor colorWithRed:(float)243/255 green:(float)243/255 blue:(float)243/255 alpha:1]];
    [mainScrollView addSubview:firstView];
    [firstView release];
    
    //第二页的背景
    MainSecondView * secondView = [[MainSecondView alloc]initWithFrame:CGRectMake(320, 0, 320, SCREEN_HEIGHT -48-64)];
    [secondView setTag:1002];
    secondView.mainVC = self;
    [secondView setBackgroundColor:[UIColor colorWithRed:(float)243/255 green:(float)243/255 blue:(float)243/255 alpha:1]];
    [mainScrollView addSubview:secondView];
    [secondView release];
    
    //第三页码
    CommonRouteView *commonRouteView = [[CommonRouteView alloc]initWithFrame:CGRectMake(640, 0, 320, SCREEN_HEIGHT -48-64)];
    [commonRouteView setTag:1003];
    commonRouteView.mainVC = self;
    [commonRouteView setBackgroundColor:[UIColor colorWithRed:(float)243/255 green:(float)243/255 blue:(float)243/255 alpha:1]];
    [mainScrollView addSubview:commonRouteView];
    [commonRouteView release];
    
    //3个显示的PageControl
    UIPageControl * pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(130, SCREEN_HEIGHT -59, 60, 10)];
    [pageControl setTag:100];
    [pageControl setCurrentPage:0];
    [pageControl setNumberOfPages:3];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    }
    
    [mainView addSubview:pageControl];
    [pageControl release];
    
    UIImage * bottomImage = [UIImage imageNamed:@"tab_bar@2x"];
    bottomImage = [bottomImage stretchableImageWithLeftCapWidth:4 topCapHeight:10];
    //底部的背景框
    UIImageView * bottomBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT -48, 320, 48)];
    bottomBar.userInteractionEnabled = YES;
    [bottomBar setBackgroundColor:[UIColor clearColor]];
    [bottomBar setImage:bottomImage];
    [mainView addSubview:bottomBar];
    [bottomBar release];
    
    //更多按钮
    UIButton * MoreButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [MoreButton setFrame:CGRectMake(140, 4, 40, 40)];
    [MoreButton setTag:5500];
    [MoreButton setBackgroundColor:[UIColor clearColor]];
    [MoreButton setBackgroundImage:[UIImage imageNamed:@"btn_more_normal@2x"] forState:UIControlStateNormal];
    [MoreButton setBackgroundImage:[UIImage imageNamed:@"btn_more_pressed@2x"] forState:UIControlStateHighlighted];
    [MoreButton addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:MoreButton];
    
    UIButton * profileButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [profileButton setFrame:CGRectMake(300, 4, 40, 40)];
    [profileButton setTag:5501];
    [profileButton setAlpha:0.0];
    [profileButton setBackgroundColor:[UIColor clearColor]];
    [profileButton setBackgroundImage:[UIImage imageNamed:@"btn_user_normal@2x"] forState:UIControlStateNormal];
    [profileButton setBackgroundImage:[UIImage imageNamed:@"btn_user_pressed@2x"] forState:UIControlStateHighlighted];
    [profileButton addTarget:self action:@selector(enterProfile) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:profileButton];
    
    UIButton * settingButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [settingButton setFrame:CGRectMake(440, 4, 40, 40)];
    [settingButton setTag:5502];
    [settingButton setAlpha:0.0];
    [settingButton setBackgroundColor:[UIColor clearColor]];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_setting_normal@2x"] forState:UIControlStateNormal];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_setting_pressed@2x"] forState:UIControlStateHighlighted];
    [settingButton addTarget:self action:@selector(enterSetting) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:settingButton];
}

//获取用户信息
-(void)getUserInfo
{
    //保存用户信息
    [NetWorkManager networkGetUserInfoWithuid:[User shareInstance].userId success:^(BOOL flag, NSDictionary *userInfo, NSString *msg) {
        
        if (flag) {
            People *people = [[People alloc]initFromDic:userInfo];
            [User shareInstance].userName = people.userName;
            [User shareInstance].userData = [NSMutableDictionary dictionaryWithDictionary:userInfo];//保存网络请求下来的数据
            [PeopleManager insertPeopleShortInfo:people];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

static bool _bool = YES;
//点击更多按钮
-(void)showMore
{
    _bool = !_bool;
    
    DLog(@"点击更多....");
    
    UIButton * moreBtn = (UIButton *)[self.view viewWithTag:5500];
    UIButton * profileBtn = (UIButton *)[self.view viewWithTag:5501];
    UIButton * settingBtn = (UIButton *)[self.view viewWithTag:5502];
    
    if (_bool == NO) {
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"btn_more_pressed@2x"] forState:UIControlStateNormal];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        [moreBtn setFrame:CGRectMake(35, 4, 40, 40)];
        [profileBtn setFrame:CGRectMake(115, 4, 40, 40)];
        [settingBtn setFrame:CGRectMake(210, 4, 40, 40)];
        [profileBtn setAlpha:0.7];
        [settingBtn setAlpha:0.7];
        [UIView setAnimationDidStopSelector:@selector(moveBtnToNormal)];
        [UIView commitAnimations];
    }
    else if (_bool == YES)
    {
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"btn_more_normal@2x"] forState:UIControlStateNormal];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        [moreBtn setFrame:CGRectMake(140, 4, 40, 40)];
        [profileBtn setFrame:CGRectMake(300, 4, 40, 40)];
        [settingBtn setFrame:CGRectMake(440, 4, 40, 40)];
        [profileBtn setAlpha:0.0];
        [settingBtn setAlpha:0.0];
        [UIView commitAnimations];
    }
}

-(void)moveBtnToNormal
{
    UIButton * moreBtn = (UIButton *)[self.view viewWithTag:5500];
    UIButton * profileBtn = (UIButton *)[self.view viewWithTag:5501];
    UIButton * settingBtn = (UIButton *)[self.view viewWithTag:5502];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [moreBtn setFrame:CGRectMake(40, 4, 40, 40)];
    [profileBtn setFrame:CGRectMake(140, 4, 40, 40)];
    [settingBtn setFrame:CGRectMake(230, 4, 40, 40)];
    [profileBtn setAlpha:1.0];
    [settingBtn setAlpha:1.0];
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

    UIPageControl * pageControl = (UIPageControl *)[self.view viewWithTag:100];
    UILabel * titleLabel = (UILabel *)[self.view viewWithTag:5876];
    
    MainSecondView *mainsecondView = (MainSecondView *)[self.view viewWithTag:1002];
    CommonRouteView *mainThirdView = (CommonRouteView *)[self.view viewWithTag:1003];
    
    NSString * userName = [User shareInstance].userName;
    
    if(pageControl.currentPage == number) {
        return;
    }
    
    switch (number) {
        case 0:
            [pageControl setCurrentPage:0];
            [titleLabel setText:[NSString stringWithFormat:@"%@好! %@,欢迎来到易行",[AppUtility ampmStrTimeDate:[NSDate date]],userName]];
            break;
        case 1:
            [pageControl setCurrentPage:1];
            [titleLabel setText:[NSString stringWithFormat:@"%@好! %@,您的当前出行计划如下",[AppUtility ampmStrTimeDate:[NSDate date]],userName]];
            [mainsecondView autoRefreshTable];
            break;
        case 2:
            [pageControl setCurrentPage:2];
            [titleLabel setText:[NSString stringWithFormat:@"%@,您的常用路线",userName]];
            [mainThirdView autoRefreshTable];
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
    [profileVC release];
}

-(void)enterSetting
{
    SettingViewController * settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
    [settingVC release];
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
            SetProfileViewController * setProfilevc = [[[SetProfileViewController alloc]init]autorelease];
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
