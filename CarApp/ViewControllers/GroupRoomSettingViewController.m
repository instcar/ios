//
//  GroupRoomSettingViewController.m
//  PRJ_MrLu_GroupChat
//
//  Created by MacPro-Mr.Lu on 13-11-25.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import "GroupRoomSettingViewController.h"
#import "XmppManager.h"
#import "DateSelectControl.h"
#import "MapViewController.h"
#import "MapViewController.h"
#import "AddressImageViewController.h"
#import "RoomInfoView.h"
#import "GroupChatViewController.h"

#define kMessageWarnLableTag 100000
#define kSignPintImageTag  100001
#define kSignPintLableTag  100007
#define kStartaddrLableTag 100002
#define kStopaddrLablekTag 100003
#define kDistanceLableTag 100004
#define kDateSelectControlTag 100005
#define pListSettingViewtag 100006
#define kTimeLabelTag 100008


@interface GroupRoomSettingViewController ()<UIAlertViewDelegate>

@property (copy ,nonatomic) NSString *selectDateStr;
@property (assign, nonatomic) int currentSeatNum;
@property (strong, nonatomic) NSDictionary *roomInfo;
@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic) Line *line;
@property (strong, nonatomic) RoomInfoView *roomInfoView;

@end

@implementation GroupRoomSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - 刷新房间信息
-(void)refreshRoomInfo
{
    UILabel *timerLabe = (UILabel *)[self.view viewWithTag:kTimeLabelTag];
    UILabel *messLable = (UILabel *)[self.view viewWithTag:kMessageWarnLableTag];
    UIImageView *signPintImageView = (UIImageView *)[self.view viewWithTag:kSignPintImageTag];
    UILabel *signPintLableView = (UILabel *)[self.view viewWithTag:kSignPintLableTag];
    UILabel *startaddrLable = (UILabel *)[self.view viewWithTag:kStartaddrLableTag];
    UILabel *stopaddrLablek = (UILabel *)[self.view viewWithTag:kStopaddrLablekTag];
    UILabel *distanceLable = (UILabel *)[self.view viewWithTag:kDistanceLableTag];
//    DateSelectControl *startTime = (DateSelectControl *)[self.view viewWithTag:kDateSelectControlTag];
//    PListSettingView *plistview = (PListSettingView *)_roomInfoView.pListSettingView;
    /*
    //刷新房间信息
    [NetWorkManager networkGetRoomInfoWithRoomID:self.roomid success:^(BOOL flag, NSDictionary *roomInfo, NSString *msg) {
        
        if (flag) {
            self.roomInfo = roomInfo;
            Room *room = [[Room alloc]initWithDic:[roomInfo valueForKey:@"room"]];
            NSString *timer = [NSString stringWithFormat:@"%.0f",[room.startingtime timeIntervalSinceDate:[NSDate date] ]/60];
            [timerLabe setText:timer];
            CGSize size = [timer sizeWithFont:timerLabe.font constrainedToSize:CGSizeMake(MAXFLOAT, timerLabe.frame.size.height)];
            [timerLabe setFrame:CGRectMake(10, 0, size.width, 44)];
            [messLable setFrame:CGRectMake(12+size.width, 0, 300, 44)];
            
            NSString *img = [AppUtility getStrByNil:[[roomInfo valueForKey:@"line"]valueForKey:@"img"]];
            [signPintImageView setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"delt_pic_b"]];
            
            NSString *description = [AppUtility getStrByNil:[[roomInfo valueForKey:@"line"]valueForKey:@"description"]];
            [signPintLableView setText:[NSString stringWithFormat:@"标志物:%@",description]];
            
            NSString *startaddr = [AppUtility getStrByNil:[[roomInfo valueForKey:@"line"]valueForKey:@"startaddr"]];
            [startaddrLable setText:startaddr];
            
            NSString *stopaddr = [AppUtility getStrByNil:[[roomInfo valueForKey:@"line"]valueForKey:@"stopaddr"]];
            [stopaddrLablek setText:stopaddr];
            
            self.line = [[Line alloc]initWithDic:[roomInfo valueForKey:@"line"]];
            
            double stoplng = [[[roomInfo valueForKey:@"line"]valueForKey:@"stoplongitude"]doubleValue];
            double stoplat = [[[roomInfo valueForKey:@"line"]valueForKey:@"stoplatitude"]doubleValue];
            double startlng = [[[roomInfo valueForKey:@"line"]valueForKey:@"startlongitude"]doubleValue];
            double startlat = [[[roomInfo valueForKey:@"line"]valueForKey:@"startlatitude"]doubleValue];
            NSString *distance = [AppUtility LantitudeLongitudeDist:stoplng other_Lat:stoplat self_Lon:startlng self_Lat:startlat];
            [distanceLable setText:distance];
            
//            NSString *startdate = [AppUtility getStrByNil:[[roomInfo valueForKey:@"room"]valueForKey:@"startingtime"]];
//            NSDate *startDate = [AppUtility dateFromStr:startdate withFormate:@"yyyy-MM-dd HH:mm:ss"];
//            NSString *dayStr = [AppUtility dayStrTimeDate:startDate];
//            NSString *tiemStr = [AppUtility strFromDate:startDate withFormate:@"HH:mm"];
//            [startTime setSelectDay:[NSArray arrayWithObject:dayStr] andSelectTime:tiemStr];
            
//            NSMutableArray *users = [NSMutableArray arrayWithArray:[roomInfo valueForKey:@"users"]];
            
//            NSDictionary *owner = (NSDictionary *)[((NSArray *)[roomInfo objectForKey:@"owener"]) objectAtIndex:0];
            int seats = [[[roomInfo valueForKey:@"room"]valueForKey:@"seatnum"]intValue];
            
            self.currentSeatNum = seats;
            
//            NSString *startaddr= [[roomInfo valueForKey:@"room"]valueForKey:@"startingtime"];
//            startTime = [AppUtility strFromDate:[AppUtility dateFromStr:startTime withFormate:@"yyyy-MM-dd HH:mm:ss"] withFormate:@"HH:mm"];
//            [startLable setText:startTime];
            
            [_roomInfoView setData:roomInfo];
            
        }
        
    } failure:^(NSError *error) {
        
    }];*/
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    [self performSelector:@selector(setMapAnonation) withObject:nil afterDelay:0.2];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"拼车人员名单";
    _editBtnState = NO;
    if (kDeviceVersion >= 7.0) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
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
    
    UIButton * backButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 20, 70, 44)];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_normal@2x"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed@2x"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backToGroupChat:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backButton];
    
    //当非房主登入后，编辑按钮不出现，只有房主才能编辑
    /*
    UIButton * editButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [editButton setFrame:CGRectMake(320- 70, 20, 70, 44)];
    [editButton setBackgroundColor:[UIColor clearColor]];
    [editButton setBackgroundImage:[UIImage imageNamed:@"btn_edit_normal@2x"] forState:UIControlStateNormal];
    [editButton setBackgroundImage:[UIImage imageNamed:@"btn_edit_pressed@2x"] forState:UIControlStateHighlighted];
    [editButton addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    editButton.hidden = !self.isroomMaster;
    [navBar addSubview:editButton];
     */
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, 200, 44)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:self.title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor appNavTitleColor]];
//    [titleLabel setTextColor:self.isroomMaster == NO?[UIColor appNavTitleBlueColor]:[UIColor appNavTitleGreenColor]];
    [titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [navBar addSubview:titleLabel];
    
    //导航栏下方的欢迎条
    UIImage * welcomeImage = [UIImage imageNamed:@"nav_hint@2x"];
    UIImageView * welcomeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 49)];
    [welcomeImgView setImage:welcomeImage];
    [mainView addSubview:welcomeImgView];
    
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 44)];
    [timeLabel setTag:kTimeLabelTag];
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    [timeLabel setTextColor:[UIColor whiteColor]];
    [timeLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [welcomeImgView addSubview:timeLabel];

    
    //导航栏下方的信息提示lable
    UILabel * messageWarnLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
    [messageWarnLable setTag:kMessageWarnLableTag];
    [messageWarnLable setBackgroundColor:[UIColor clearColor]];
    [messageWarnLable setText:@"分钟后出发,请准时到标志物接送小朋友"];
    [messageWarnLable setTextAlignment:NSTextAlignmentLeft];
    [messageWarnLable setTextColor:[UIColor whiteColor]];
    [messageWarnLable setFont:[UIFont appGreenWarnFont]];
    [welcomeImgView addSubview:messageWarnLable];
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+44, 320, SCREEN_HEIGHT - 65 - 44)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setAlwaysBounceVertical:YES];
    [mainView insertSubview:scrollView belowSubview:welcomeImgView];
    [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 190 + 240 + 20)];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
    [scrollView addSubview:headView];
    
    UIImageView * photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
    [photoImgView setTag:kSignPintImageTag];
    [photoImgView setBackgroundColor:[UIColor placeHoldColor]];
    [photoImgView setContentMode:UIViewContentModeScaleAspectFill];
    [photoImgView setContentScaleFactor:[UIScreen mainScreen].scale];
    [photoImgView setUserInteractionEnabled:YES];
    [headView addSubview:photoImgView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAddressImageView)];
    [photoImgView addGestureRecognizer:tapGesture];
    //    [scrollView addSubview:photoImgView];
    //    [photoImgView release];
    
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(12, 13+2, 106,106)];
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:BMKCoordinateRegionMake(self.mapView.userLocation.coordinate, BMKCoordinateSpanMake(0.02, 0.02))];
    [self.mapView setRegion:adjustedRegion animated:NO];
    [self.mapView.layer setCornerRadius:106/2.0];
    [self.mapView.layer setMasksToBounds:YES];
    [self.mapView setShowsUserLocation:NO];
    [self.mapView setOverlooking:0];
    //    [self.mapView setRotation:0];
    //    [self performSelector:@selector(setMapAnonation) withObject:nil afterDelay:0.2];
    [headView addSubview:self.mapView];
    
    UIButton *mapViewMask = [UIButton buttonWithType:UIButtonTypeCustom];
    [mapViewMask setTag:10003];
    [mapViewMask setFrame:CGRectMake(10, 13, 110, 110)];
    [mapViewMask setBackgroundImage:[UIImage imageNamed:@"bg_map@2x"] forState:UIControlStateNormal];
    [mapViewMask addTarget:self action:@selector(maptapAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:mapViewMask];
    
    UIView * photoBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 150-20, 320, 20)];
    [photoBlackView setBackgroundColor:[UIColor blackColor]];
    [photoBlackView setAlpha:0.6];
    [headView addSubview:photoBlackView];
    
    //位置标签
    UILabel * locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 20)];
    [locationLabel setTag:kSignPintLableTag];
    [locationLabel setBackgroundColor:[UIColor clearColor]];
    [locationLabel setTextAlignment:NSTextAlignmentLeft];
    [locationLabel setTextColor:[UIColor whiteColor]];
    [locationLabel setFont:[UIFont fontWithName:kFangZhengFont size:10]];
    [locationLabel setText:@"标志物:大望路向东方向京通快速路入口旁标志牌"];
    [photoBlackView addSubview:locationLabel];
    
    UIImageView * passBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 150, 320, 65)];
    [passBackView setBackgroundColor:[UIColor whiteColor]];
    [passBackView setUserInteractionEnabled:YES];
    //    [passBackView setImage:[UIImage imageNamed:@"DEMO_PIC1@2x.jpg"]];
    //    [passBackView.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    //    [passBackView.layer setShadowOffset:CGSizeMake(0, 1)];
    //    [passBackView.layer setShadowOpacity:0.8];
    [scrollView addSubview:passBackView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(42, 32.5, 236, 1)];
    [line setBackgroundColor:[UIColor appLightGrayColor]];
    [passBackView addSubview:line];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 64.5, 320, 0.5)];
    [lineView setBackgroundColor:[UIColor appLineDarkGrayColor]];
    [passBackView addSubview:lineView];
    
    UILabel * qidianNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 12, 80, 12)];
    [qidianNameLabel setTag:kStartaddrLableTag];
    [qidianNameLabel setBackgroundColor:[UIColor clearColor]];
    [qidianNameLabel setTextAlignment:NSTextAlignmentCenter];
    [qidianNameLabel setTextColor:[UIColor appDarkGrayColor]];
    [qidianNameLabel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [qidianNameLabel setText:@""];
    [passBackView addSubview:qidianNameLabel];
    
    UIImageView * qidianImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 28, 10, 10)];
    [qidianImageView setBackgroundColor:[UIColor clearColor]];
    [qidianImageView setImage:[UIImage imageNamed:@"btn_point@2x"]];
    [passBackView addSubview:qidianImageView];
    
    UILabel * qidianLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 45, 40, 10)];
    [qidianLabel setBackgroundColor:[UIColor clearColor]];
    [qidianLabel setTextAlignment:NSTextAlignmentCenter];
    [qidianLabel setTextColor:[UIColor textGrayColor]];
    [qidianLabel setFont:[UIFont fontWithName:kFangZhengFont size:10]];
    [qidianLabel setText:@"起点"];
    [passBackView addSubview:qidianLabel];
    
    UILabel * zhongdianNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(240-5, 12, 80, 12)];
    [zhongdianNameLabel setTag:kStopaddrLablekTag];
    [zhongdianNameLabel setBackgroundColor:[UIColor clearColor]];
    [zhongdianNameLabel setTextAlignment:NSTextAlignmentCenter];
    [zhongdianNameLabel setTextColor:[UIColor appDarkGrayColor]];
    [zhongdianNameLabel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [zhongdianNameLabel setText:@""];
    [passBackView addSubview:zhongdianNameLabel];
    
    UIImageView * zhongdianImageView = [[UIImageView alloc]initWithFrame:CGRectMake(270, 28, 10, 10)];
    [zhongdianImageView setBackgroundColor:[UIColor clearColor]];
    [zhongdianImageView setImage:[UIImage imageNamed:@"btn_point@2x"]];
    [passBackView addSubview:zhongdianImageView];
    
    UILabel * zhongdianLabel = [[UILabel alloc]initWithFrame:CGRectMake(290-35, 45, 40, 12)];
    [zhongdianLabel setBackgroundColor:[UIColor clearColor]];
    [zhongdianLabel setTextAlignment:NSTextAlignmentCenter];
    [zhongdianLabel setTextColor:[UIColor textGrayColor]];
    [zhongdianLabel setFont:[UIFont fontWithName:kFangZhengFont size:10]];
    [zhongdianLabel setText:@"终点"];
    [passBackView addSubview:zhongdianLabel];
    
//    UIButton * distancebutton = [[UIButton alloc]initWithFrame:CGRectMake((320-93)/2, 10, 93, 45)];
//    [distancebutton setBackgroundImage:[[UIImage imageNamed:@"btn_input_normal"] stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
//    [distancebutton setBackgroundImage:[[UIImage imageNamed:@"btn_input_pressed"] stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateHighlighted];
//    [distancebutton setImage:[UIImage imageNamed:@"ic_line_gray"] forState:UIControlStateNormal];
//    [distancebutton.imageView setFrame:CGRectMake(5, 5, 22, 22)];
//    [distancebutton setTitle:@"查看地图" forState:UIControlStateNormal];
//    [distancebutton.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
//    [distancebutton setTitleColor:[UIColor flatBlackColor] forState:UIControlStateNormal];
//    [distancebutton addTarget:self action:@selector(seeMapViewAction:) forControlEvents:UIControlEventTouchUpInside];
//    [passBackView addSubview:distancebutton];
//    [distancebutton release];
    
    UILabel * distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake((320-45)/2.0, 10, 45, 45)];
    [distanceLabel setTag:kDistanceLableTag];
    [distanceLabel setBackgroundColor:[UIColor whiteColor]];
    [distanceLabel setTextAlignment:NSTextAlignmentCenter];
    [distanceLabel setTextColor:[UIColor flatBlackColor]];
    [distanceLabel setFont:[UIFont fontWithName:kFangZhengFont size:10]];
    [distanceLabel.layer setBorderWidth:1.0];
    [distanceLabel.layer setBorderColor:[UIColor appLightGrayColor].CGColor];
    [distanceLabel.layer setCornerRadius:45.0/2.0];
    [distanceLabel.layer setMasksToBounds:YES];
    NSString *distance = [AppUtility LantitudeLongitudeDist:self.line.stoplongitude other_Lat:self.line.stoplatitude self_Lon:self.line.startlongitude self_Lat:self.line.startlatitude];
    [distanceLabel setText:distance];
    [passBackView addSubview:distanceLabel];
 /*
    //时间
    UILabel * departureLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 225, 100, 10)];
    [departureLabel setBackgroundColor:[UIColor clearColor]];
    [departureLabel setTextAlignment:NSTextAlignmentLeft];
    [departureLabel setTextColor:[UIColor textGrayColor]];
    [departureLabel setFont:[UIFont fontWithName:kFangZhengFont size:10]];
    [departureLabel setText:@"出发时间"];
    [scrollView addSubview:departureLabel];
    [departureLabel release];
  */
    
//    UIImage * btnBackImg = [UIImage imageNamed:@"btn_empty@2x"];
//    UIButton * timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [timeBtn setTag:1322];
//    [timeBtn setFrame:CGRectMake((320-233)/2, 250, 233, 45)];
//    [timeBtn setBackgroundColor:[UIColor clearColor]];
//    [timeBtn setBackgroundImage:btnBackImg forState:UIControlStateNormal];
//    [timeBtn setBackgroundImage:btnBackImg forState:UIControlStateHighlighted];
//    [timeBtn setShowsTouchWhenHighlighted:YES];
//    [timeBtn setTitle:@"今天18：30" forState:UIControlStateNormal];
//    [timeBtn setTitleColor:[UIColor colorWithRed:(float)119/255 green:(float)187/255 blue:(float)68/255 alpha:1] forState:UIControlStateNormal];
//    [timeBtn setTitleColor:[UIColor colorWithRed:(float)119/255 green:(float)187/255 blue:(float)68/255 alpha:1] forState:UIControlStateHighlighted];
//    [timeBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
//    [timeBtn addTarget:self action:@selector(timeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [scrollView addSubview:timeBtn];
    
    /*
    //日期点击
    DateSelectControl *dateSelectControl = [[DateSelectControl alloc]initWithFrame:CGRectMake((320-233)/2, 245, 233, 45)];
    //    dateSelectControl.selectDay = dayArray;
    //    dateSelectControl.selectTime = @"10:12";
    [dateSelectControl setCanEidt:NO];
    dateSelectControl.tag = kDateSelectControlTag;
    [dateSelectControl addTarget:self action:@selector(timeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:dateSelectControl];
    [dateSelectControl release];
    
    UIView *line2= [[UIView alloc]initWithFrame:CGRectMake(0, 300, 320, 0.5)];
    [line2 setBackgroundColor:[UIColor appLineDarkGrayColor]];
    [scrollView addSubview:line2];
    [line2 release];
     */
    
    /*
    //人员状态名单
    PListSettingView *pListSettingView = [[PListSettingView alloc]initWithFrame:CGRectMake(0, 310, 320, 80)];
    [pListSettingView setTag:pListSettingViewtag];
    pListSettingView.delegate = self;
    pListSettingView.canEdit = NO;
    [scrollView addSubview:pListSettingView];
    [pListSettingView release];
    
    //查看位置按钮
    UIImage * btnLocateBackImg = [UIImage imageNamed:@"btn_empty@2x"];
    UIButton * locateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [locateBtn setTag:1323];
    [locateBtn setFrame:CGRectMake((320-233)/2, 410, 233, 45)];
    [locateBtn setBackgroundColor:[UIColor clearColor]];
    [locateBtn setBackgroundImage:btnLocateBackImg forState:UIControlStateNormal];
    [locateBtn setBackgroundImage:btnLocateBackImg forState:UIControlStateHighlighted];
//    [locateBtn setImage:[UIImage imageNamed:@"ic_search@2x"] forState:UIControlStateNormal];
//    [locateBtn setImage:[UIImage imageNamed:@"ic_search@2x"] forState:UIControlStateHighlighted];
    [locateBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
    [locateBtn setShowsTouchWhenHighlighted:YES];
    [locateBtn setTitle:@"查看位置" forState:UIControlStateNormal];
    [locateBtn setTitleColor:[UIColor colorWithRed:(float)119/255 green:(float)187/255 blue:(float)68/255 alpha:1] forState:UIControlStateNormal];
    [locateBtn setTitleColor:[UIColor colorWithRed:(float)119/255 green:(float)187/255 blue:(float)68/255 alpha:1] forState:UIControlStateHighlighted];
    [locateBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [locateBtn addTarget:self action:@selector(locateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:locateBtn];
     */
    
    /*
    _dayArray = [[NSArray alloc]initWithObjects:@"今天",@"明天",@"后天",@"大后天", nil];
    
    _hourArray = [[NSArray alloc]initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",
                  @"07",@"08",@"09",@"10",@"11",@"12",@"13",
                  @"14",@"15",@"16",@"17",@"18",@"19",@"20",
                  @"21",@"22",@"23", nil];
    
    _minuteArray = [[NSArray alloc]initWithObjects:@"00",@"05",@"10",@"15",@"20",@"25",
                    @"30",@"35",@"40",@"45",@"50",@"55", nil];
     */
    
//    self.dayPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, SCREEN_HEIGHT, 320.0, 216.0)];
//    self.dayPicker.delegate = self;
//    self.dayPicker.dataSource = self;
//    self.dayPicker.showsSelectionIndicator = YES;
//    [self.dayPicker setBackgroundColor:[UIColor whiteColor]];
//    [mainView addSubview:self.dayPicker];
//    
//    self.timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, SCREEN_HEIGHT, 320.0, 216.0)];
//    self.timePicker.delegate = self;
//    self.timePicker.dataSource = self;
//    self.timePicker.showsSelectionIndicator = YES;
//    [self.timePicker setBackgroundColor:[UIColor whiteColor]];
//    [mainView addSubview:self.timePicker];
    
    _roomInfoView = [[RoomInfoView alloc]initWithFrame:CGRectMake(0, 190, 320, 240)];
    _roomInfoView.groupVC = self;
    [_roomInfoView setEnableTouchBg:NO];
    [scrollView addSubview:_roomInfoView];
    
    [self performSelector:@selector(refreshRoomInfo) withObject:nil];
}

-(void)setMapAnonation
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    BMKPointAnnotation* addPoint = [[BMKPointAnnotation alloc]init];
    [addPoint setTitle:self.line.startaddr];
    [addPoint setCoordinate:CLLocationCoordinate2DMake(self.line.startlatitude, self.line.startlongitude)];
    [self.mapView addAnnotation:addPoint];
}

-(void)maptapAction:(UIButton *)sender
{
    MapViewController *mapVC =  [[MapViewController alloc]init];
    mapVC.line = self.line;
    mapVC.mode = kMapViewModeLine;
    [mapVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.navigationController pushViewController:mapVC animated:YES];

    //    if (self.mode != 2) {
    //        [self showMapView:YES];
    //    }
    //    else
    //    {
    //        [self showMapView:NO];
    //    }
}

/*
 //显示地图 动画
 -(void)showMapView:(BOOL)state
 {
 UIView *mainView = [self.view viewWithTag:10000];
 UIImageView *photoView = (UIImageView *)[self.view viewWithTag:10001];
 UIButton *mapMaskView = (UIButton *)[self.view viewWithTag:10003];
 UINavigationBar *narbar = (UINavigationBar *)[self.view viewWithTag:10005];
 if (state) {
 [self.mapView removeFromSuperview];
 CGRect rec = [self.mapView convertRect:self.mapView.frame toView:mainView];
 [self.mapView setFrame:rec];
 [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
 [self.mapView.layer setCornerRadius:0.0];
 [self.mapView setFrame:self.tableView.frame];
 } completion:^(BOOL finished) {
 self.mode = 2;
 [mainView insertSubview:self.mapView belowSubview:narbar];
 UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
 [backBtn setFrame:CGRectMake(20, 10, 60, 34)];
 [backBtn setTag:20000];
 [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_shrink_normal@2x"] forState:UIControlStateNormal];
 [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_shrink_pressed@2x"] forState:UIControlStateHighlighted];
 [backBtn addTarget:self action:@selector(maptapAction:) forControlEvents:UIControlEventTouchUpInside];
 [self.mapView addSubview:backBtn];
 
 }];
 }
 else
 {
 [self.mapView removeFromSuperview];
 [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
 
 [self.mapView.layer setCornerRadius:106.0/2.0];
 [self.mapView.layer setMasksToBounds:YES];
 [self.mapView setFrame:CGRectMake(12, 13+2, 106,106)];
 
 } completion:^(BOOL finished) {
 self.mode = 1;
 UIButton *backBtn = (UIButton *)[self.mapView viewWithTag:20000];
 [backBtn removeFromSuperview];
 [photoView insertSubview:self.mapView belowSubview:mapMaskView];
 }];
 }
 
 }
 */

//显示图片
-(void)showAddressImageView
{
    AddressImageViewController *addressImageViewController = [[AddressImageViewController alloc]init];
    addressImageViewController.line = self.line;
    [addressImageViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:addressImageViewController animated:YES completion:^{}];
}

#pragma mark - bmkMapViewDelegate methods
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [self.mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
}

-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:BMKCoordinateRegionMake(self.mapView.userLocation.coordinate, BMKCoordinateSpanMake(0.02, 0.02))];
    [self.mapView setRegion:adjustedRegion animated:NO];
    //       self.locateSuccess = YES;
    //       self.location = userLocation.location.coordinate;
    //       self.locateState = NO;
    //       [self.search reverseGeocode:self.mapView.userLocation.location.coordinate];
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:NO];
}

-(void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapview viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		BMKAnnotationView* view = nil;
        view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_nodeAddress"];
        if (view == nil) {
            view = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"start_nodeAddress"];
            view.image = [UIImage imageNamed:@"tag_map@2x"];
            view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.0));
            view.canShowCallout = TRUE;
        }
        view.annotation = annotation;
        BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:BMKCoordinateRegionMake(annotation.coordinate, BMKCoordinateSpanMake(0.01, 0.01))];
        [self.mapView setRegion:adjustedRegion animated:NO];
        [self.mapView setCenterCoordinate:annotation.coordinate animated:NO];
        return view;
	}
	return nil;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.groupVC && [self.groupVC respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
    {
        [self.groupVC performSelector:@selector(alertView:clickedButtonAtIndex:) withObject:alertView withObject:(id)[NSNumber numberWithInt:buttonIndex]];
    }
    
    [self refreshRoomInfo];
}
/*
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([pickerView isEqual:self.dayPicker]) {
        return 1;
    }
    else if ([pickerView isEqual:self.timePicker])
    {
        return 2;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.dayPicker]) {
        return 3;
    }
    if ([pickerView isEqual:self.timePicker]) {
        if (component == 0) {
            return 24;
        }
        else{
            return 12;
        }
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.dayPicker]) {
        
        switch (row) {
            case 0:
                return @"今天";
                break;
            case 1:
                return @"明天";
                break;
            case 2:
                return @"后天";
                break;
            default:
                break;
        }
    }
    
    if ([pickerView isEqual:self.timePicker]) {
        
        if (component == 0) {
            return [NSString stringWithFormat:@"%d点",row];
        }
        else if (component == 1)
        {
            return [NSString stringWithFormat:@"%d分",row *5];
        }
    }
    return @" ";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.dayPicker]) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.4];//动画时间长度，单位秒，浮点数
        self.dayPicker.frame = CGRectMake(0.0, SCREEN_HEIGHT, 320.0, 216.0);
        [UIView commitAnimations];
        
        UIButton * dayBtn = (UIButton *)[self.view viewWithTag:1321];
        [dayBtn setTitle:(NSString *)[_dayArray objectAtIndex:row] forState:UIControlStateNormal];
        [dayBtn setTitle:(NSString *)[_dayArray objectAtIndex:row] forState:UIControlStateHighlighted];
    }
    
    if ([pickerView isEqual:self.timePicker]) {
        
        UIButton * timeBtn = (UIButton *)[self.view viewWithTag:1322];
        
        NSString * before = [[timeBtn.titleLabel.text componentsSeparatedByString:@"："]objectAtIndex:0];
        NSString * last = [[timeBtn.titleLabel.text componentsSeparatedByString:@"："]objectAtIndex:1];
        
        DLog(@"%@ --- %@",before,last);
        
        if (component == 0) {
            [timeBtn setTitle:[NSString stringWithFormat:@"%@：%@",[_hourArray objectAtIndex:row],last] forState:UIControlStateNormal];
            [timeBtn setTitle:[NSString stringWithFormat:@"%@：%@",[_hourArray objectAtIndex:row],last] forState:UIControlStateHighlighted];
        }
        else if (component == 1)
        {
            [timeBtn setTitle:[NSString stringWithFormat:@"%@：%@",before,[_minuteArray objectAtIndex:row]] forState:UIControlStateNormal];
            [timeBtn setTitle:[NSString stringWithFormat:@"%@：%@",before,[_minuteArray objectAtIndex:row]] forState:UIControlStateHighlighted];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.4];//动画时间长度，单位秒，浮点数
            self.timePicker.frame = CGRectMake(0.0, SCREEN_HEIGHT, 320.0, 216.0);
            [UIView commitAnimations];
        }
    }
}
*/

/*
-(void)timeBtnClicked:(UIButton *)sender
{
    //进入时间编辑 周期时间列表 功能保留
    EditTimeViewController *editTimeVC = [[EditTimeViewController alloc]init];
    editTimeVC.delegate = self;
    [self.navigationController pushViewController:editTimeVC animated:YES];
    [editTimeVC release];
}

-(void)editTimeViewController:(EditTimeViewController *)editTimeViewController select:(NSDictionary *)dateDic
{
    
    DateSelectControl*dateSelectControl = (DateSelectControl *)[self.view viewWithTag:kDateSelectControlTag];
    NSArray * dateArray = [NSArray arrayWithObject:[dateDic valueForKey:@"dd"]];
    NSString * timeString = [NSString stringWithFormat:@"%@:%@",[dateDic valueForKey:@"hh"],[dateDic valueForKey:@"mm"]];
    
    if ([[dateDic valueForKey:@"dd"] isEqualToString:@"今天"]) {
        NSDate *today = [NSDate date];
        self.selectDateStr = [[AppUtility strFromDate:today withFormate:@"yyyyMMdd"] stringByAppendingString:[NSString stringWithFormat:@"%@%@%@",[dateDic valueForKey:@"hh"],[dateDic valueForKey:@"mm"],@"00"]];
    }
    if ([[dateDic valueForKey:@"dd"] isEqualToString:@"明天"]) {
        NSTimeInterval secondsPerDay = 24*60*60;
        NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
        self.selectDateStr = [[AppUtility strFromDate:tomorrow withFormate:@"yyyyMMdd"] stringByAppendingString:[NSString stringWithFormat:@"%@%@%@",[dateDic valueForKey:@"hh"],[dateDic valueForKey:@"mm"],@"00"]];
        
    }
    if ([[dateDic valueForKey:@"dd"] isEqualToString:@"后天"]) {
        NSTimeInterval secondsPerDay = 24*60*60*2;
        NSDate *twoTomorrow = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
        self.selectDateStr = [[AppUtility strFromDate:twoTomorrow withFormate:@"yyyyMMdd"] stringByAppendingString:[NSString stringWithFormat:@"%@%@%@",[dateDic valueForKey:@"hh"],[dateDic valueForKey:@"mm"],@"00"]];
    }
    
    [NetWorkManager networkRoomMasterEditStartTime:[User shareInstance].userId roomid:self.roomid startingTime:self.selectDateStr success:^(BOOL flag, NSString *msg) {
        if (flag) {
           [dateSelectControl setSelectDay:dateArray andSelectTime:timeString];
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(groupRoomSettingVC:sanderMessageEvent:)])
            {
                [self.delegate groupRoomSettingVC:self sanderMessageEvent:kplistEventChangerTime];
            }
        }
        else
        {
            [UIAlertView showAlertViewWithTitle:@"错误" message:msg cancelTitle:@"确定"];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
 */

-(void)backToGroupChat:(UIButton *)sender
{
    DLog(@"返回群聊");
    [self.navigationController popViewControllerAnimated:YES];
}

/*
-(void)editBtnAction:(UIButton *)sender
{
    DLog(@"编辑房间");

    //编辑按钮事件
    _editBtnState = !_editBtnState;
    
    DateSelectControl *startTime = (DateSelectControl *)[self.view viewWithTag:kDateSelectControlTag];
    PListSettingView *plistview = (PListSettingView *)[self.view viewWithTag:pListSettingViewtag];
    
    [plistview setCanEdit:_editBtnState];
    [startTime setCanEidt:_editBtnState];

    if (!_editBtnState) {
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_edit_normal@2x"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_edit_pressed@2x"] forState:UIControlStateHighlighted];
    }
    else
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_confirm_normal@2x"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_confirm_pressed@2x"] forState:UIControlStateHighlighted];
    }

}*/

//-(void)timeBtnClicked:(UIButton *)sender
//{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.4];//动画时间长度，单位秒，浮点数
//    self.timePicker.frame = CGRectMake(0.0, SCREEN_HEIGHT - 216, 320.0, 216.0);
//    [UIView commitAnimations];
//}

/*
-(void)PListSettingViewDelegate:(PListSettingView *)plistSettingView index:(int)index event:(kPListEvent)event
{
    if (event == kPListEventNull) {
        [UIAlertView showAlertViewWithTitle:@"sorry!" message:@"当前人员已经准备,座位无法变更" cancelTitle:@"确定"];
    }
    if (event == kPListEventClose) {
        [UIAlertView showAlertViewWithTitle:@"是否关闭座位" tag:event cancelTitle:@"取消" ensureTitle:@"确定" delegate:self];
    }
    if (event == kPListEventOpened) {
        [UIAlertView showAlertViewWithTitle:@"是否开启座位" tag:event cancelTitle:@"取消" ensureTitle:@"确定" delegate:self];
    }
}
 */

/*
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag == kPListEventClose) {

            [NetWorkManager networkRoomMasterEditSeat:[User shareInstance].userId roomid:self.roomid seatnum:self.currentSeatNum-1 success:^(BOOL flag, NSString *msg) {
                
                if (flag) {
                    if(self.delegate && [self.delegate respondsToSelector:@selector(groupRoomSettingVC:sanderMessageEvent:)])
                    {
                        [self.delegate groupRoomSettingVC:self sanderMessageEvent:alertView.tag];
                    }
                    [self refreshRoomInfo];
                }
            } failure:^(NSError *error) {
                
            }];
        }
        if (alertView.tag == kPListEventOpened) {
            [NetWorkManager networkRoomMasterEditSeat:[User shareInstance].userId roomid:self.roomid seatnum:self.currentSeatNum+1 success:^(BOOL flag, NSString *msg) {
                if (flag) {
                    if(self.delegate && [self.delegate respondsToSelector:@selector(groupRoomSettingVC:sanderMessageEvent:)])
                    {
                        [self.delegate groupRoomSettingVC:self sanderMessageEvent:alertView.tag];
                    }
                    [self refreshRoomInfo];
                }
            } failure:^(NSError *error) {
                
            }];
        }

    }
}
*/

-(void)seeMapViewAction:(UIButton *)sender
{
    DLog(@"查看地图");
    MapViewController *mapVC =  [[MapViewController alloc]init];
    Line *line = [[Line alloc]initWithDic:[self.roomInfo valueForKey:@"line"]];
    mapVC.line = line;
    mapVC.mode = kMapViewModeLine;
    [self presentViewController:mapVC animated:YES completion:nil];
}

/*
-(void)locateBtnClicked:(UIButton *)sender
{
    DLog(@"查看位置");
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
