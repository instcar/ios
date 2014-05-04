//
//  EditRouteViewController.m
//  CarApp
//
//  Created by leno on 13-10-13.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "EditRouteViewController.h"
#import "GroupChatViewController.h"
#import "PassengerControl.h"
#import "DateSelectControl.h"
#import "XmppManager.h"
#import "MapViewController.h"
#import "AddressImageViewController.h"

#define kDateSelectControlTag 50000
#define kPassengerControlTag 60000
#define kInfoTxvTag 70000
#define kScrollViewTag 80000
#define kmainViewTag 90000

@interface EditRouteViewController ()<UIScrollViewDelegate>

@property (copy ,nonatomic) NSString *selectDateStr;
@property (retain, nonatomic) BMKMapView *mapView;

@end

@implementation EditRouteViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    

}


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
    
    if (kDeviceVersion >= 7.0) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
    
    _boolll = YES;
    
    UIView * mainView = [[UIView alloc]initWithFrame:[AppUtility mainViewFrame]];
    [mainView setTag:kmainViewTag];
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
    [backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backButton];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 27, 200, 30)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:self.line.name];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor appNavTitleColor]];
    [titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [navBar addSubview:titleLabel];
    
    UIImage * welcomeImage = [UIImage imageNamed:@"nav_hint@2x"];
    //    welcomeImage = [welcomeImage stretchableImageWithLeftCapWidth:8 topCapHeight:10];
    //导航栏下方的欢迎条
    UIImageView * welcomeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 49)];
    [welcomeImgView setImage:welcomeImage];
    [mainView addSubview:welcomeImgView];
    
    UILabel * warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
    [warnLabel setBackgroundColor:[UIColor clearColor]];
    [warnLabel setText:@"为了您和司机的方便，请到标志物等候上车"];
    [warnLabel setTextAlignment:NSTextAlignmentCenter];
    [warnLabel setTextColor:[UIColor whiteColor]];
    [warnLabel setFont:[UIFont appGreenWarnFont]];
    [welcomeImgView addSubview:warnLabel];
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+44, 320, SCREEN_HEIGHT - 44-64)];
    [scrollView setTag:kScrollViewTag];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setContentSize:CGSizeMake(320, 320+154 -64 +240)];
    [scrollView setDelegate:self];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [mainView insertSubview:scrollView belowSubview:navBar];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
    [scrollView addSubview:headView];
    
    UIImageView * photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
    [photoImgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    photoImgView.contentMode =  UIViewContentModeScaleAspectFill;
    [photoImgView setClipsToBounds:YES];
    [photoImgView setTag:60001];
    [photoImgView setImageWithURL:[NSURL URLWithString:self.line.img] placeholderImage:[UIImage imageNamed:@"delt_pic_b"]];
    [photoImgView setUserInteractionEnabled:YES];
    [photoImgView setBackgroundColor:[UIColor placeHoldColor]];
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
    [self.mapView setDelegate:self];
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
    
    UILabel * locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 20)];
    [locationLabel setBackgroundColor:[UIColor clearColor]];
    [locationLabel setTextAlignment:NSTextAlignmentLeft];
    [locationLabel setTextColor:[UIColor whiteColor]];
    [locationLabel setFont:[UIFont fontWithName:kFangZhengFont size:10]];
    [locationLabel setText:[NSString stringWithFormat:@"%@",self.line.description]];
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
    
    UILabel * qidianNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 12, 80, 12)];
    [qidianNameLabel setBackgroundColor:[UIColor clearColor]];
    [qidianNameLabel setTextAlignment:NSTextAlignmentCenter];
    [qidianNameLabel setTextColor:[UIColor appDarkGrayColor]];
    [qidianNameLabel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [qidianNameLabel setText:self.line.startaddr];
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
    [zhongdianNameLabel setBackgroundColor:[UIColor clearColor]];
    [zhongdianNameLabel setTextAlignment:NSTextAlignmentCenter];
    [zhongdianNameLabel setTextColor:[UIColor appDarkGrayColor]];
    [zhongdianNameLabel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [zhongdianNameLabel setText:self.line.stopaddr];
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
    

    UILabel * departureLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 225, 100, 20)];
    [departureLabel setBackgroundColor:[UIColor clearColor]];
    [departureLabel setTextAlignment:NSTextAlignmentLeft];
    [departureLabel setTextColor:[UIColor textGrayColor]];
    [departureLabel setFont:[UIFont fontWithName:kFangZhengFont size:10]];
    [departureLabel setText:@"出发时间"];
    [scrollView addSubview:departureLabel];

    //日期点击
    DateSelectControl *dateSelectControl = [[DateSelectControl alloc]initWithFrame:CGRectMake((320-233)/2, 250, 233, 45)];
    dateSelectControl.tag = kDateSelectControlTag;
    [dateSelectControl addTarget:self action:@selector(timeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [dateSelectControl setDate:[NSDate date]];
    [scrollView addSubview:dateSelectControl];

    
    UILabel * seatsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 305, 100, 20)];
    [seatsLabel setBackgroundColor:[UIColor clearColor]];
    [seatsLabel setTextAlignment:NSTextAlignmentLeft];
    [seatsLabel setTextColor:[UIColor textGrayColor]];
    [seatsLabel setFont:[UIFont fontWithName:kFangZhengFont size:10]];
    [seatsLabel setText:@"空余车位"];
    [scrollView addSubview:seatsLabel];

    
    //乘客数
    PassengerControl *passengerControl = [[PassengerControl alloc]initWithFrame:CGRectMake((320-233)/2, 330, 233, 45) NormalImage:[UIImage imageNamed:@"ic_seat_none@2x"] SelectImage:[UIImage imageNamed:@"ic_seat@2x"] indexs:4 size:CGSizeMake(20, 30)];
    passengerControl.tag = kPassengerControlTag;
    passengerControl.currentNum = 4;
    [scrollView addSubview:passengerControl];
    
    UILabel * infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 380, 100, 20)];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [infoLabel setTextAlignment:NSTextAlignmentLeft];
    [infoLabel setTextColor:[UIColor textGrayColor]];
    [infoLabel setFont:[UIFont fontWithName:kFangZhengFont size:10]];
    [infoLabel setText:@"附加信息"];
    [scrollView addSubview:infoLabel];
    
    UIImageView *infoBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 320+154 -64, 300, 80)];
    [infoBgImageView setImage:[[UIImage imageNamed:@"ipt_message"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    [scrollView addSubview:infoBgImageView];
    
    
    UIView *toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 39)];
    [toolBar setBackgroundColor:[UIColor clearColor]];
    
    UIButton * confirmKeyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmKeyBtn setTag:50006];
    [confirmKeyBtn setFrame:CGRectMake(320-63, 0, 63, 39)];
    [confirmKeyBtn setBackgroundColor:[UIColor clearColor]];
    [confirmKeyBtn setBackgroundImage:[UIImage imageNamed:@"btn_key_down@2x"] forState:UIControlStateNormal];
    //        [confirmKeyBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmKeyBtn addTarget:self action:@selector(hideKeyBorad:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:confirmKeyBtn];
    
    UITextView * infoTxv = [[UITextView alloc]initWithFrame:CGRectMake(10, 320+154 -64, 300, 80)];
    [infoTxv setTag:kInfoTxvTag];
    [infoTxv setEditable:YES];
    [infoTxv setBackgroundColor:[UIColor clearColor]];
    [infoTxv setFont:[UIFont fontWithName:kFangZhengFont size:16]];
    [infoTxv setText:@"10块钱一个,不讲价,欢迎光临~"];
    [infoTxv setTextColor:[UIColor appDarkGrayColor]];
    [infoTxv setInputAccessoryView:toolBar];

//    [infoTxv.layer setShadowColor:[UIColor lightGrayColor].CGColor];
//    [infoTxv.layer setShadowOffset:CGSizeMake(0, 2)];
//    [infoTxv.layer setShadowOpacity:0.8];
    [scrollView addSubview:infoTxv];
        
//    UIView * backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, _windowHeight)];
//    backGroundView.userInteractionEnabled =YES;
//    [backGroundView setTag:1099];
//    [backGroundView setBackgroundColor:[UIColor blackColor]];
//    [backGroundView setAlpha:0.8];
//    [backGroundView setHidden:YES];
//    [mainView addSubview:backGroundView];
//    [backGroundView release];
    
    
    UIButton * routeBtnBg = [UIButton buttonWithType:UIButtonTypeCustom];
    [routeBtnBg setFrame:CGRectMake((320-233)/2, 320+252 -64-4.5, 240, 40)];
    [routeBtnBg setBackgroundColor:[UIColor clearColor]];
//    [routeBtnBg.layer setBorderWidth:1.0];
//    [routeBtnBg.layer setBorderColor:[UIColor appLightGrayColor].CGColor];
//    [routeBtnBg.layer setCornerRadius:45.0/2.0];
//    [routeBtnBg.layer setMasksToBounds:YES];
    [routeBtnBg setBackgroundImage:[UIImage imageNamed:@"add_line_no@2x"] forState:UIControlStateNormal];
    [routeBtnBg setBackgroundImage:[UIImage imageNamed:@"add_line_ok"] forState:UIControlStateSelected];
    [routeBtnBg setSelected:YES];
//    [routeBtnBg setTitle:@"将此路线增加到为常用" forState:UIControlStateNormal];
//    [routeBtnBg setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [routeBtnBg.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:15]];
    [routeBtnBg addTarget:self action:@selector(routtt:) forControlEvents:UIControlEventTouchUpInside];
    [routeBtnBg setUserInteractionEnabled:YES];
    [scrollView addSubview:routeBtnBg];
    
//    UIButton * routeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [routeBtn setFrame:CGRectMake((320-233)/2 + 5, 320+252 -64-4.5 + 5 ,35.0, 35.0)];
//    [routeBtn setBackgroundColor:[UIColor whiteColor]];
//    [routeBtn setBackgroundImage:[UIImage imageNamed:@"btn_empty@2x"] forState:UIControlStateNormal];
//    [routeBtn.layer setBorderWidth:1.0];
//    [routeBtn.layer setBorderColor:[UIColor appLightGrayColor].CGColor];
//    [routeBtn.layer setCornerRadius:35.0/2.0];
//    [routeBtn.layer setMasksToBounds:YES];
//    [routeBtn setImage:[UIImage imageNamed:@"ic_arrow@2x"] forState:UIControlStateNormal];
//    [routeBtn setContentMode:UIViewContentModeCenter];
//    [routeBtn addTarget:self action:@selector(routtt:) forControlEvents:UIControlEventTouchUpInside];
//    [scrollView addSubview:routeBtn];
    
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setFrame:CGRectMake((320-233)/2, 320+316 -64, 233, 38)];
    [confirmBtn setBackgroundColor:[UIColor clearColor]];
    [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_fillet_green_normal"] stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_fillet_green_pressed"] stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateHighlighted];
    [confirmBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:15]];
    [confirmBtn setTitle:@"确认发布" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmmm) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:confirmBtn];
    
    //给键盘注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewWillBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewdDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self setMapAnonation];
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
    [self performSelector:@selector(setMapAnonation) withObject:nil afterDelay:0.1];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

-(void)routtt:(UIButton *)sender
{
    _boolll = !_boolll;
    [sender setSelected:_boolll];
}

-(void)confirmmm
{

    long uid = [User shareInstance].userId;
    long lineid = self.line.ID;
    NSString *startingtime = self.selectDateStr;
    if (!startingtime) {
        [UIAlertView showAlertViewWithTitle:@"错误" message:@"时间必须大于当前时间" cancelTitle:@"确定"];
        return;
    }
    else
    {
        NSDate *date = [AppUtility dateFromStr:startingtime withFormate:@"yyyyMMddHHmmss"];
        if ([date compare:[NSDate date]] == NSOrderedAscending) {
            [UIAlertView showAlertViewWithTitle:@"错误" message:@"时间必须大于当前时间" cancelTitle:@"确定"];
            return;
        }
    }
    
    PassengerControl *passengerControl = (PassengerControl *)[self.view viewWithTag:kPassengerControlTag];
    int seatNum = passengerControl.currentNum;
    UITextView *textView = (UITextView *)[self.view viewWithTag:kInfoTxvTag];
    
    if (seatNum == 0) {
        [UIAlertView showAlertViewWithTitle:@"拼车发布信息有误" message:@"发布空位不能为0" cancelTitle:@"取消"];
        return;
    }
    /*
    //请求创建房间
    [NetWorkManager networkCreateRoomWithID:uid lineID:lineid startingTime:startingtime seatnum:seatNum description:textView.text addtofav:_boolll success:^(BOOL flag, long roomID, NSString *msg) {
        if (flag) {
            //连接xmpp进入房间
//            [[XmppManager sharedInstance] createGroup:[NSString stringWithFormat:@"%ld",roomID]];
            [SVProgressHUD showSuccessWithStatus:@"拼车发布成功.."];
            //进入房间前等待2.0s确保已经加入到房间
            [self performSelector:@selector(enterChatRoom:) withObject:[NSNumber numberWithLong:roomID] afterDelay:0.1];
            
        }
        else
        {
            [UIAlertView showAlertViewWithTitle:@"失败" message:msg cancelTitle:@"确定"];
        }
        
    } failure:^(NSError *error) {
        
    }];*/
}

-(void)enterChatRoom:(NSNumber *)roomidNum
{
    PassengerControl *passengerControl = (PassengerControl *)[self.view viewWithTag:kPassengerControlTag];
    int seatNum = passengerControl.currentNum;
//    [SVProgressHUD showSuccessWithStatus:@"配置成功"];
    //确认房间配置
//    [[XmppManager sharedInstance] configuration:[XmppRoomManager affirmRoomConfiguration:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:seatNum],@"roomMaxNum",[NSString stringWithFormat:@"%@%ld",KRoomNamePrdFix,[roomidNum longValue]],@"roomName",[NSString stringWithFormat:@"%@%ld",KRoomNamePrdFix,[roomidNum longValue]],@"roomSubName",nil]]];
    
    NSXMLElement *roomConfiguration = [XmppRoomManager affirmRoomConfiguration:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:seatNum],@"roomMaxNum",[NSString stringWithFormat:@"%@%ld",KRoomNamePrdFix,[roomidNum longValue]],@"roomName",[NSString stringWithFormat:@"%@%ld",KRoomNamePrdFix,[roomidNum longValue]],@"roomSubName",nil]];
    
    //创建成功进入聊天室
    GroupChatViewController * gVC = [[GroupChatViewController alloc]init];
    gVC.isRoomMaster = YES;
    gVC.roomID = [roomidNum longValue];
    gVC.roomConfiguration = roomConfiguration;
    gVC.userState = 2;
    [self.navigationController pushViewController:gVC animated:YES];
}

-(void)timeBtnClicked:(UIButton *)sender
{
    
}

-(void)seeMapViewAction:(UIButton *)sender
{
    MapViewController *mapVC =  [[MapViewController alloc]init];
    mapVC.line = self.line;
    mapVC.mode = kMapViewModeLine;
    [self presentViewController:mapVC animated:YES completion:nil];
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
    [self.mapView setDelegate:nil];
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

#pragma mark - keybord
-(void)hideKeyBorad:(UITapGestureRecognizer *)tappp
{
    [self downKeyBoard];
}

-(void)downKeyBoard
{
    UITextView * textView = (UITextView *)[self.view viewWithTag:kInfoTxvTag];
    [textView resignFirstResponder];
}

#pragma mark 监听键盘的显示与隐藏
-(void)inputKeyboardWillShow:(NSNotification *)notification{
    
    //键盘显示，设置toolbar的frame跟随键盘的frame
    
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    
    double keyboardTransitionDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];
    
    UITextView *textView = (UITextView *)[self.view viewWithTag:kInfoTxvTag];
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:kScrollViewTag];
//    DLog(@"contentPoint %@",NSStringFromCGRect(textView.frame));

    CGRect actalPoint = textView.frame;
    actalPoint.origin.y =actalPoint.origin.y - scrollView.contentOffset.y + scrollView.frame.origin.y;
//    DLog(@"actalPoint %@",NSStringFromCGRect(actalPoint));
    
    if (actalPoint.origin.y > self.view.frame.size.height - keyboardEndFrameWindow.size.height - textView.frame.size.height) {
        UIViewAnimationCurve keyboardTransitionAnimationCurve;
        [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardTransitionAnimationCurve];
        [UIView beginAnimations:@"keyboardShow" context:nil];
        [UIView setAnimationDuration:keyboardTransitionDuration];
        [UIView setAnimationCurve:keyboardTransitionAnimationCurve];
        [UIView setAnimationBeginsFromCurrentState:YES];
        scrollView.frame = CGRectMake(0, (64+44  - keyboardEndFrameWindow.size.height+39), 320, SCREEN_HEIGHT - 44-64);
        [UIView commitAnimations];
    }

}

-(void)inputKeyboardWillHide:(NSNotification *)notification{
 
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    
    double keyboardTransitionDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];
//    keyboardHideTransitionDuration = keyboardTransitionDuration;
    
    UIViewAnimationCurve keyboardTransitionAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardTransitionAnimationCurve];
//    keyboardTransitionHideAnimationCurve = keyboardTransitionAnimationCurve;
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:kScrollViewTag];
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardTransitionAnimationCurve];
    
    [UIView beginAnimations:@"keyboardhide" context:nil];
    [UIView setAnimationDuration:keyboardTransitionDuration];
    [UIView setAnimationCurve:keyboardTransitionAnimationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    scrollView.frame = CGRectMake(0, 64+44 , 320, SCREEN_HEIGHT - 44-64);
    [UIView commitAnimations];
}

-(void)backToMain
{
  
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
