//
//  GroupChatViewController.m
//  CarApp
//
//  Created by leno on 13-10-13.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "GroupChatViewController.h"
#import "UIBubbleTableView.h"
#import "FaceToolBar.h"
#import "GroupRoomSettingViewController.h"
#import "MessageManager.h"
#import "PeopleManager.h"
#import "ImageViewCell.h"
#import "PhotoSelectManager.h"
#import "ProfileViewController.h"
#import "AMBlurView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "RoomInfoView.h"

#import "FlowHelpView.h"

#define kNavTitleViewTag 988888
#define kStartTimeLableTag 988887
#define kCurrentPassengerLableTag 988886
#define kLeftNullSeatTag 988885
#define kTimeLabelTag 988884

#define kEnsureViewTag 999999
#define kEnsureBtnTag 999998
#define kMessageWarnLableTag 90000

#define kEnsurePingcheTag 97777
#define kJojinPingcheTag 97776
#define kExitPingcheTag 97775

#define pListSettingViewtag 100006

@interface GroupChatViewController ()<UIBubbleTableViewDataSource,UIBubbleTableViewDelegate,UIBubbleTableViewCellDelegate,FaceToolBarDelegate,ImageViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GroupRoomSettingVCDelegate>
{
    NSMutableArray *_bubbleArray;
    FaceToolBar *_faceToolBar;
    UIBubbleTableView *_bubbleTableView;
    NSTimer *_timer;
    UIView *_groupDesView;
    RoomInfoView *_roomInfoView;
}

@property (retain, nonatomic) FlowHelpView *flowHelpView;
@property (retain, nonatomic) NSMutableArray *bubbleArray;
@property (assign, nonatomic) int currentPassengers;                         //当前乘客
@property (assign, nonatomic) int remainSeat;                                //剩余空位
@property (assign, nonatomic) int loadMoreNum; //载入更多的id
@property (assign, nonatomic) int canLoadMore; //能不能载入更多
@property (retain, nonatomic) NSMutableArray *currentImageArray;            //当前图片
@property (retain, nonatomic) NSDictionary *roomInfo;

@end

@implementation GroupChatViewController

-(void)dealloc
{
    [InstantCarRelease safeRelease:_bubbleArray];
    [InstantCarRelease safeRelease:_currentImageArray];
    [InstantCarRelease safeRelease:_roomInfo];
    [InstantCarRelease safeRelease:_flowHelpView];
    [InstantCarRelease safeRelease:_roomConfiguration];
    [self removeObserver:self forKeyPath:@"remainSeat"];
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
    [super viewWillAppear:animated];
    
    [[XmppManager sharedInstance] connect];
    
    //聊天数据代理绑定
    [[XmppManager sharedInstance] setChatDelegate:self];
    
    //刷新房间信息
    [self refreshRoomInfo];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    
//    [self performSelector:@selector(connectRoom) withObject:nil afterDelay:0.1];
}

- (void)UIApplicationbecomeActivity
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectRoom) name:@"XmppStreamConnected" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //聊天数据代理绑定
    [[XmppManager sharedInstance] setChatDelegate:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentPassengers = 0;
    self.remainSeat = 4;
    self.bubbleArray = [[[NSMutableArray alloc]init]autorelease];
    self.currentImageArray = [[[NSMutableArray alloc]init]autorelease];
    self.loadMoreNum = 0;
    self.canLoadMore = 1;
    
    if (kDeviceVersion >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    UIView * mainView = [[UIView alloc]initWithFrame:[AppUtility mainViewFrame]];
    [mainView setBackgroundColor:[UIColor flatWhiteColor]];
    [mainView setTag:1000];
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
    
    UIButton * backButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 20, 70, 44)];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_normal@2x"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed@2x"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backButton];
    
    UIButton * groupButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [groupButton setFrame:CGRectMake(320-70, 20, 70, 44)];
    [groupButton setBackgroundColor:[UIColor clearColor]];
    [groupButton setBackgroundImage:[UIImage imageNamed:@"btn_info_normal@2x"] forState:UIControlStateNormal];
    [groupButton setBackgroundImage:[UIImage imageNamed:@"btn_info_pressed@2x"] forState:UIControlStateHighlighted];
    [groupButton addTarget:self action:@selector(enterGroupManager) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:groupButton];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, 200, 44)];
    [titleLabel setTag:kNavTitleViewTag];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"大望路-潮白人家"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor appNavTitleColor]];
//    [titleLabel setTextColor:self.isRoomMaster == NO?[UIColor appNavTitleBlueColor]:[UIColor appNavTitleGreenColor]];
    [titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [navBar addSubview:titleLabel];
    [titleLabel release];
    
//    UILabel * numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 40, 240, 30)];
//    [numberLabel setBackgroundColor:[UIColor clearColor]];
//    [numberLabel setText:@"编号:BJDC201310100520"];
//    [numberLabel setTextAlignment:NSTextAlignmentCenter];
//    [numberLabel setTextColor:[UIColor lightGrayColor]];
//    [numberLabel setFont:[UIFont boldSystemFontOfSize:13]];
//    [navBar addSubview:numberLabel];
//    [numberLabel release];
    
    //导航栏下方的欢迎条
    UIImage * welcomeImage = [UIImage imageNamed:@"nav_hint@2x"];
    UIImageView * welcomeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 49)];
    [welcomeImgView setImage:welcomeImage];
    [welcomeImgView setTag:1001];
    [mainView addSubview:welcomeImgView];
    [welcomeImgView release];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 44)];
    [timeLabel setTag:kTimeLabelTag];
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    [timeLabel setTextColor:[UIColor whiteColor]];
    [timeLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [welcomeImgView addSubview:timeLabel];
    [timeLabel release];
    
    //导航栏下方的信息提示lable
    UILabel * messageWarnLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
    [messageWarnLable setTag:kMessageWarnLableTag];
    [messageWarnLable setBackgroundColor:[UIColor clearColor]];
    
//    [messageWarnLable setText:[NSString stringWithFormat:@"%@,欢迎来到易行",[[User shareInstance] userName]]];
    
    NSString *warnText = (self.isRoomMaster == YES?@"分钟后出发,请准时到标志物接送小朋友":@"分钟后出发,请准时到标志物等待车主");
    [messageWarnLable setText:warnText];
    [messageWarnLable setTextAlignment:NSTextAlignmentLeft];
    [messageWarnLable setTextColor:[UIColor whiteColor]];
    [messageWarnLable setFont:[UIFont appGreenWarnFont]];
    [welcomeImgView addSubview:messageWarnLable];
    [messageWarnLable release];

    //----begin-- 欢迎条下方房间状态视图
    _groupDesView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 28)];
    _groupDesView.backgroundColor = [UIColor whiteColor];
//    [mainView insertSubview:_groupDesView belowSubview:welcomeImgView];
    
    UILabel *startTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 1.5, 55, 25)];
    [startTimeLable setBackgroundColor:[UIColor clearColor]];
    [startTimeLable setTextColor:[UIColor lightGrayColor]];
    [startTimeLable setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [startTimeLable setText:@"出发时间:"];
    [_groupDesView addSubview:startTimeLable];
    [startTimeLable release];
    
    UILabel *startTimeValeLable = [[UILabel alloc]initWithFrame:CGRectMake(10+55+5, 1.5, 40, 25)];
    [startTimeValeLable setTag:kStartTimeLableTag];
    [startTimeValeLable setBackgroundColor:[UIColor clearColor]];
    [startTimeValeLable setTextColor:[UIColor appNavTitleBlueColor]];
    [startTimeValeLable setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [startTimeValeLable setText:@""];
//    [startTimeValeLable setText:@"18:30"];
    [_groupDesView addSubview:startTimeValeLable];
    [startTimeValeLable release];
    
    UILabel *peoNumLable = [[UILabel alloc]initWithFrame:CGRectMake(10+55+5+40+10, 1.5, 55, 25)];
    [peoNumLable setBackgroundColor:[UIColor clearColor]];
    [peoNumLable setTextColor:[UIColor lightGrayColor]];
    [peoNumLable setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [peoNumLable setText:@"目前人数:"];
    [_groupDesView addSubview:peoNumLable];
    [peoNumLable release];
    
    UILabel *peoNumValeLable = [[UILabel alloc]initWithFrame:CGRectMake(10+55+5+40+10+55+5, 1.5, 40, 25)];
    [peoNumValeLable setTag:kCurrentPassengerLableTag];
    [peoNumValeLable setBackgroundColor:[UIColor clearColor]];
    [peoNumValeLable setTextColor:[UIColor appNavTitleBlueColor]];
    [peoNumValeLable setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [peoNumValeLable setText:@""];
//        [peoNumValeLable setText:[NSString stringWithFormat:@"%d人",4]];
    [_groupDesView addSubview:peoNumValeLable];
    [peoNumValeLable release];
    
    UILabel *nullSeatLable = [[UILabel alloc]initWithFrame:CGRectMake(10+55+5+40+10+55+5+40+10, 1.5, 55, 25)];
    [nullSeatLable setBackgroundColor:[UIColor clearColor]];
    [nullSeatLable setTextColor:[UIColor lightGrayColor]];
    [nullSeatLable setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [nullSeatLable setText:@"剩余空位:"];
    [_groupDesView addSubview:nullSeatLable];
    [nullSeatLable release];
    
    UILabel *nullSeatValeLable = [[UILabel alloc]initWithFrame:CGRectMake(10+55+5+40+10+55+5+40+10+55+5, 1.5, 40, 25)];
    [nullSeatValeLable setTag:kLeftNullSeatTag];
    [nullSeatValeLable setBackgroundColor:[UIColor clearColor]];
    [nullSeatValeLable setTextColor:[UIColor appNavTitleBlueColor]];
    [nullSeatValeLable setFont:[UIFont fontWithName:kFangZhengFont size:12]];
//    [nullSeatValeLable setText:[NSString stringWithFormat:@"%d个",0]];
    [_groupDesView addSubview:nullSeatValeLable];
    [nullSeatValeLable release];
    //----end-- 欢迎条下方房间状态视图

    //聊天视图
    _bubbleTableView = [[UIBubbleTableView alloc]initWithFrame:CGRectMake(0, 64+44, 320, SCREEN_HEIGHT-64-44-44)];
    [_bubbleTableView setBackgroundColor:[UIColor clearColor]];
    [_bubbleTableView setBubbleDataSource:self];
    [_bubbleTableView setBubbleTableViewDelegate:self];
    [_bubbleTableView setTableHeaderView:_groupDesView];
    [mainView insertSubview:_bubbleTableView belowSubview:navBar];
    [_bubbleTableView release];
    
    //测试数据
    //    NSBubbleData *bubbleData = [NSBubbleData dataWithText:@"hellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohello" date:[NSDate date] type:BubbleTypeMine contentType:BubbleContentText];
    //    NSBubbleData *bubbleData1 = [NSBubbleData dataWithText:@"你好你好你好你" date:[NSDate date] type:BubbleTypeSomeoneElse contentType:BubbleContentText];
    //    NSBubbleData *bubbleData2 = [NSBubbleData dataWithText:@"你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好" date:[NSDate date] type:BubbleTypeMine contentType:BubbleContentText];
    //    NSBubbleData *bubbleData3 = [NSBubbleData dataWithText:@"***加入到房间中" date:[NSDate date] type:BubbleTypeSystem contentType:BubbleContentSystem];
    //    [_bubbleArray addObjectsFromArray: [NSArray arrayWithObjects:bubbleData,bubbleData1,bubbleData2,bubbleData3,nil]];
    
    //聊天输入框/键盘
    _faceToolBar =[[FaceToolBar alloc]initWithFrame:CGRectMake(0.0f,SCREEN_HEIGHT - toolBarHeight-100,self.view.frame.size.width,toolBarHeight) superView:mainView];
    [_faceToolBar setFaceToolBarDelegate:self];
    
    _roomInfoView = [[RoomInfoView alloc]initWithFrame:CGRectMake(0, 64+44+30, 320, SCREEN_HEIGHT - 44 - 64 - 30)];
    _roomInfoView.groupVC = self;
    [mainView addSubview:_roomInfoView];
    [_roomInfoView hide:NO];
    self.isRoomMaster?[_roomInfoView hide:NO]:[_roomInfoView show];
    
    [self addObserver:self forKeyPath:@"remainSeat" options:NSKeyValueObservingOptionNew context:nil];
    
    //获取历史聊天记录
    [self getChatHistoryWithOrder:-1];
    
    FlowHelpView *flowHelpView = [FlowHelpView shareInstance];
    [flowHelpView setNormalImage:[UIImage imageNamed:@"bg_number@2x"]];
    [flowHelpView addTarget:self action:@selector(showInfoView) forControlEvents:UIControlEventTouchDown];
    [flowHelpView setGroupVC:self];
    [flowHelpView showWithInView:mainView];
    self.flowHelpView = flowHelpView;
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UIApplicationbecomeActivity) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectRoom) name:@"XmppStreamConnected" object:nil];
}

-(void)connectRoom
{
    if (![[XmppManager sharedInstance].xmppStream isConnected]) {
        [SVProgressHUD showErrorWithStatus:@"房间连接错误"];
    }
    
    if ([[XmppManager sharedInstance].xmppRoom isJoined]) {
        return;
    }
    
    [[XmppManager sharedInstance]joinGroup:self.openfireRoomName result:^(bool state) {
        if (state) {
            DLog(@"登入房间成功");
            if (self.roomConfiguration && self.roomConfiguration != nil) {
               [ [XmppManager sharedInstance] configuration:self.roomConfiguration result:^(bool state) {
                    if (state) {
                        
                    }
                    else
                    {
                        [SVProgressHUD showErrorWithStatus:@"配置房间失败"];
                    }
               }];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"登入房间失败"];
        }
    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"remainSeat"]) {
//        if ( [[change objectForKey:@"new"]intValue] == 0 )
//        {
//        }
    }
}

//获取跟多的历史
-(void)getChatHistoryWithOrder:(int)order
{
    //从数据库进性分页的查询数据库
    NSDictionary * messageDic = [MessageManager getCommonMessageWithRoomID:self.roomID withPerNum:20 withOrder:order];
    
    //读取记录
    NSMutableArray * messageDataArray = [NSMutableArray arrayWithArray:[messageDic objectForKey:@"message"]];
    self.loadMoreNum = [[messageDic objectForKey:@"lastId"]intValue]; //最后的id
    self.canLoadMore = [[messageDic objectForKey:@"canLoadMore"]intValue]; //显示是否还有数据
    
    if([messageDataArray count] > 0)
    {
        //分条进行显示数据
        for (CommonMessage * mes in messageDataArray)
        {
            [self showHistoryMessage:mes];
        }
        
        //插入完之后刷新
        [_bubbleTableView reloadData];
    }
}

//视图显示信息 mes  flag 表示显示的类型是历史还是 实时聊天信息 0为实时的聊天 1为历史
-(void)showHistoryMessage:(CommonMessage *)mes
{
    NSBubbleData * sayBubble = nil;

    //处理图片请求
    if([mes isKindOfClass:[ImageMessage class]])
    {
        ImageMessage * message = (ImageMessage *)mes;
        
//        ImageViewCell * imageCell = [[ImageViewCell alloc]initWithImage:message.image];
//        imageCell.delegate = self;
    
        int type = mes.fid == [User shareInstance].userId?BubbleTypeMine:BubbleTypeSomeoneElse;
//        sayBubble = [NSBubbleData dataWithView:imageCell date:message.date type:type insets:UIEdgeInsetsZero contentType:BubbleContentImage];
        sayBubble = [NSBubbleData dataWithImage:message.image date:message.date type:type contentType:BubbleContentImage];
        sayBubble.message = message;
        [self.currentImageArray addObject:sayBubble];
    }

    //处理文本请求
    if ([mes isKindOfClass:[BaseTextMessage class]]) {
        BaseTextMessage * message = (BaseTextMessage *)mes;
        int type = mes.fid == [User shareInstance].userId?BubbleTypeMine:BubbleTypeSomeoneElse;
        sayBubble = [NSBubbleData dataWithText:message.content date:message.date type:type contentType:BubbleContentText];
        sayBubble.message = message;
    }
    
    //处理文本请求
    if ([mes isKindOfClass:[SystemTextMessage class]]) {
        SystemTextMessage * systemMessage = (SystemTextMessage *)mes;
        
        NSString *inputText = @"";
        switch (systemMessage.comandtype) {
            case SystemCommendTypeJOINCAR:
            {
                inputText = @"加入了拼车";
                break;
            }
            case SystemCommendTypeEXITCAR:
            {
                inputText = @"退出了拼车";
                break;
            }
            case SystemCommendTypeCloseSeat:
            {
                inputText = @"关闭了一个座位";
                break;
            }
            case SystemCommendTypeOpenSeat:
            {
                inputText = @"开启了一个座位";
                break;
            }
            case SystemCommendTypeChangeTime:
            {
                inputText = @"修改了发车时间";
                break;
            }
    
            default:
                break;
        }
        
        NSString *showText = [NSString stringWithFormat:@"%@,%@",[PeopleManager getPeopleWithFriendID:systemMessage.fid].name,inputText]; //谁，干嘛了
    
        sayBubble = [NSBubbleData dataWithText:showText date:systemMessage.date type:BubbleTypeSystem contentType:BubbleContentSystem];
        sayBubble.message = systemMessage;
    }
    sayBubble.uid = mes.fid;
    sayBubble.avatar = [PeopleManager getPeopleWithFriendID:mes.fid].headpic;
    
    //历史记录插入
    [self.bubbleArray insertObject:sayBubble atIndex:0];

}

#pragma mark - 刷新房间信息
-(void)refreshRoomInfo
{
    UILabel *timerLabe = (UILabel *)[self.view viewWithTag:kTimeLabelTag];
    UILabel *messLable = (UILabel *)[self.view viewWithTag:kMessageWarnLableTag];
    UILabel *navLable = (UILabel *)[self.view viewWithTag:kNavTitleViewTag];
    UILabel *startLable = (UILabel *)[self.view viewWithTag:kStartTimeLableTag];
    UILabel *currentPassengerLable = (UILabel *)[self.view viewWithTag:kCurrentPassengerLableTag];
    UILabel *leftNullLable = (UILabel *)[self.view viewWithTag:kLeftNullSeatTag];
    
    //刷新房间信息
    [NetWorkManager networkGetRoomInfoWithRoomID:self.roomID success:^(BOOL flag, NSDictionary *roomInfo, NSString *msg) {
        
        if (flag) {
            self.roomInfo = roomInfo;
            Room *room = [[Room alloc]initWithDic:[roomInfo valueForKey:@"room"]];
            NSArray *userArray = (NSArray *)[roomInfo valueForKey:@"users"];
            NSString *startTime = [AppUtility strFromDate:room.startingtime withFormate:@"HH:mm"];
            [startLable setText:startTime];
            NSString *timer = [NSString stringWithFormat:@"%.0f",[room.startingtime timeIntervalSinceDate:[NSDate date] ]/60];
            [timerLabe setText:timer];
            CGSize size = [timer sizeWithFont:timerLabe.font constrainedToSize:CGSizeMake(MAXFLOAT, timerLabe.frame.size.height)];
            [timerLabe setFrame:CGRectMake(10, 0, size.width, 44)];
            [messLable setFrame:CGRectMake(12+size.width, 0, 300, 44)];
            
            if(room.status == 2 || room.status == 3)
            {
                if (room.status == 2) {
                    [UIAlertView showAlertViewWithTitle:@"房主已经确认,拼车进行中.." tag:10 cancelTitle:@"确定" ensureTitle:nil delegate:self];
                }
                if (room.status == 3) {
                    [UIAlertView showAlertViewWithTitle:@"拼车以完成.." tag:11 cancelTitle:@"确定" ensureTitle:nil delegate:self];
                }
                return;
            }
            
            if ([userArray count]>=room.seatnum) {
                BOOL isRoomMenber = NO;
                for (NSDictionary *user in userArray) {
                    if ([[user valueForKey:@"id"]longValue] == [User shareInstance].userId) {
                        isRoomMenber = YES;
                    }
                }
                if (!isRoomMenber) {
                    [UIAlertView showAlertViewWithTitle:@"该拼车人员已满.." tag:12 cancelTitle:@"确定" ensureTitle:nil delegate:self];
                    return;
                }
                else
                {
                    UIButton *sender = (UIButton *)[self.view viewWithTag:kEnsureBtnTag];
                    [sender setTitle:@"取消准备" forState:UIControlStateNormal];
                }
            }
            
            NSString *navTitle = [[roomInfo valueForKey:@"line"]valueForKey:@"name"];
            [navLable setText:navTitle];
            
            int currentPassengers = [((NSArray *)[roomInfo valueForKey:@"users"]) count];
            [currentPassengerLable setText:[NSString stringWithFormat:@"%d人",currentPassengers]];
            self.currentPassengers = currentPassengers;
            
             int leftNullSeats = room.seatnum-currentPassengers;
            [leftNullLable setText:[NSString stringWithFormat:@"%d个",leftNullSeats]];
            self.remainSeat = leftNullSeats;
            
            //刷新成员数据
            [_roomInfoView setData:roomInfo];
            [roomInfo release];
            
            //刷新数据
            [self.flowHelpView setData:roomInfo];
            [roomInfo release];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)showInfoView
{
    FlowHelpView *flowHelpView = [FlowHelpView shareInstance];
    DLog(@"tapState:%d",flowHelpView.tapState);
    flowHelpView.tapState?[_roomInfoView show]:[_roomInfoView hide:YES];
}


#pragma mark - UIBubbleTableViewDataSource
-(NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [_bubbleArray count];
}

-(NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [_bubbleArray objectAtIndex:row];
}

#pragma mark - UIBubbleTableViewDelegate
-(void)BubbleTableViewLoadMoreHistory:(UIBubbleTableView *)bubbleTableView
{
    [self getChatHistoryWithOrder:self.loadMoreNum];
}

-(void)BubbleTableViewHandleTouchEvent
{
    [_faceToolBar dismissKeyBoard];
}

#pragma mark -- faceToolBarDelegate
-(void)faceToolbarOrgYChangered:(FaceToolBar *)faceToolbar withHeight:(float)height
{
//    DLog(@"faceToolBar:%f",faceToolbar.frame.origin.y);
    height = self.view.frame.size.height - height - 44;
    DLog(@"faceHeight:%f",height);
//    DLog(@"BubbleContentHeight:%f",_bubbleTableView.contentSize.height);
    UIEdgeInsets edgesInsets = UIEdgeInsetsZero;
    DLog(@"tableView ContentInsert:%@",NSStringFromUIEdgeInsets(_bubbleTableView.contentInset));
    edgesInsets.bottom = edgesInsets.bottom + height;
    _bubbleTableView.contentInset = edgesInsets;
    [_bubbleTableView scrollerToBottomWithAnimation:YES];
    /*
    CGRect frame = _bubbleTableView.frame;
    //通过内容视图的高度来判断视图是适配高度还是适配位置
    if (_bubbleTableView.contentSize.height < SCREEN_HEIGHT-64-45-44) {
        frame.size.height = SCREEN_HEIGHT-64-45-44 + (height - SCREEN_HEIGHT+toolBarHeight);
        _bubbleTableView.frame = frame;
    }
    else
    {
        frame.size.height = SCREEN_HEIGHT-64-45-44;
        frame.origin.y = 64+45+(height-SCREEN_HEIGHT+toolBarHeight);
        _bubbleTableView.frame = frame;
    }
    DLog(@"_bubbleTableViewFrame:%@",NSStringFromCGRect(_bubbleTableView.frame));
    [_bubbleTableView scrollerToBottomWithAnimation:YES];
    if(SCREEN_HEIGHT-toolBarHeight == height)
    {
//        [_bubbleTableView scrollerToBottomWithAnimation:NO];
    }
    else
    {
//         if (_bubbleTableView.contentSize.height < SCREEN_HEIGHT-64-45-30-44)
//         {
//            [_bubbleTableView scrollerToBottomWithAnimation:YES];
//         }
    }
    */
}

-(void)sendTextAction:(NSString *)inputText
{
    DLog(@"sendtext");
    
    NSBubbleData *bubbleData = [NSBubbleData dataWithText:inputText date:[NSDate date] type:BubbleTypeMine contentType:BubbleContentText];
    bubbleData.avatar = [PeopleManager getPeopleWithFriendID:[User shareInstance].userId].headpic;
    
    BaseTextMessage *baseTextMessage = [[[BaseTextMessage alloc]init]autorelease];
    baseTextMessage.uid = [User shareInstance].userId;   //自己id
    baseTextMessage.fid = [User shareInstance].userId;   //用户id
    baseTextMessage.roomid = self.roomID; //房间id
    baseTextMessage.content = inputText; //信息内容
    baseTextMessage.date = [NSDate date]; //日期时间
    baseTextMessage.type = 2; // 1 为接受 2为发送
    bubbleData.uid = baseTextMessage.fid;
    bubbleData.message = baseTextMessage;
    
    [MessageManager sendGroupMessage:[baseTextMessage transformToMessage]];
    
    [_bubbleArray addObject:bubbleData];
    [_bubbleTableView reloadData];
    [_bubbleTableView scrollerToBottomWithAnimation:YES];
}

-(void)extendViewselectedExtendView:(int)index
{
    //照片
    if (index == 0) {
        [PhotoSelectManager selectPhotoFromPhotoWithDelegate:self withVC:self withEdit:NO];
    }
    //拍摄
    if (index == 1) {
        [PhotoSelectManager selectPhotoFromCamreWithDelegate:self withVC:self withEdit:NO];
    }
}

#pragma mark - 发送和接受方法
-(void)getNewRoomMessage:(CommonMessage *)message
{
    if ([message isKindOfClass:[BaseTextMessage class]]) {
        BaseTextMessage * baseTextMessage = (BaseTextMessage *)message;
        NSString *inputText = baseTextMessage.content;
        NSBubbleData *bubbleData = [NSBubbleData dataWithText:inputText date:[NSDate date] type:BubbleTypeSomeoneElse contentType:BubbleContentText];
        bubbleData.avatar = [PeopleManager getPeopleWithFriendID:message.fid].headpic;
        bubbleData.uid = message.fid;
        [_bubbleArray addObject:bubbleData];
    }
    
    if ([message isKindOfClass:[SystemTextMessage class]]) {
        SystemTextMessage * systemMessage = (SystemTextMessage *)message;
        NSString *inputText = @"";
        switch (systemMessage.comandtype) {
            case SystemCommendTypeJOINCAR:
            {
                inputText = @"加入了拼车";
                break;
            }
            case SystemCommendTypeEXITCAR:
            {
                inputText = @"退出了拼车";
                break;
            }
            case SystemCommendTypeCloseSeat:
            {
                inputText = @"关闭了一个座位";
                break;
            }
            case SystemCommendTypeOpenSeat:
            {
                inputText = @"开启了一个座位";
                break;
            }
            case SystemCommendTypeChangeTime:
            {
                inputText = @"修改了发车时间";
                break;
            }

            default:
                break;
        }
        
        NSString *showText = [NSString stringWithFormat:@"%@,%@",[PeopleManager getPeopleWithFriendID:systemMessage.fid].name,inputText]; //谁，干嘛了
        NSBubbleData *bubbleData = [NSBubbleData dataWithText:showText date:[NSDate date] type:BubbleTypeSystem contentType:BubbleContentSystem];
        bubbleData.avatar = [PeopleManager getPeopleWithFriendID:systemMessage.fid].headpic;
        [_bubbleArray addObject:bubbleData];
    }
    
    if ([message isKindOfClass:[ImageMessage class]]) {
        ImageMessage * imageMessage = (ImageMessage *)message;
//        ImageViewCell * imageCell = [[ImageViewCell alloc]initWithImage:imageMessage.image];
//        NSBubbleData *bubbleData = [NSBubbleData dataWithView:imageCell date:message.date type:BubbleTypeSomeoneElse insets:UIEdgeInsetsZero contentType:BubbleContentImage];
        NSBubbleData *bubbleData = [NSBubbleData dataWithImage:imageMessage.image date:imageMessage.date type:BubbleTypeSomeoneElse contentType:BubbleContentImage];
        bubbleData.avatar = [PeopleManager getPeopleWithFriendID:message.fid].headpic;
        bubbleData.uid = message.fid;
        bubbleData.message = imageMessage;
        [self.currentImageArray addObject:bubbleData];
        [_bubbleArray addObject:bubbleData];
    }
    
    [_bubbleTableView reloadData];
    [_bubbleTableView scrollerToBottomWithAnimation:YES];
}

#pragma mark -- UIImagePickerDelegate
//图片选择取消
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade]; //隐藏工具栏
        [self dismissViewControllerAnimated:YES completion:^{}];
}

//图片选择成功
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade]; //隐藏工具栏
    [self dismissViewControllerAnimated:YES completion:^{}];

    UIImage *image = [[info objectForKey:UIImagePickerControllerOriginalImage] retain];
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    if (image) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
            ImageMessage * imageMessage = [[[ImageMessage alloc]init]autorelease];
            imageMessage.image = image;
            imageMessage.uid = [User shareInstance].userId;   //自己id
            imageMessage.fid = [User shareInstance].userId;   //用户id
            imageMessage.roomid = self.roomID; //房间id
            imageMessage.date = [NSDate date]; //日期时间
            imageMessage.type = 2;
    
            [MessageManager sendGroupMessage:[imageMessage transformToMessage]];
            
    
//            ImageViewCell *imageView = [[[ImageViewCell alloc]initWithImage:image]autorelease];
//            NSBubbleData *bubbleData = [NSBubbleData dataWithView:imageView date:imageMessage.date type:BubbleTypeMine insets:UIEdgeInsetsMake(10, 10, 10, 10) contentType:BubbleContentImage];


            dispatch_async(dispatch_get_main_queue(), ^{
                NSBubbleData *bubbleData = [NSBubbleData dataWithImage:imageMessage.image date:imageMessage.date type:BubbleTypeMine contentType:BubbleContentImage];
                bubbleData.message = imageMessage;
                bubbleData.avatar = [PeopleManager getPeopleWithFriendID:[User shareInstance].userId].headpic;
                bubbleData.uid = imageMessage.fid;
                [self.currentImageArray addObject:bubbleData];
                [_bubbleArray addObject:bubbleData];
                
                [_bubbleTableView reloadData];
                [_bubbleTableView scrollerToBottomWithAnimation:YES];
            });
        });
    }
}

#pragma mark - 按钮确认事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10 ||alertView.tag == 11 || alertView.tag == 12) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (buttonIndex == 1) {
        if (alertView.tag == kEnsurePingcheTag) {
            [NetWorkManager networkRoomMasterEnsureuid:[User shareInstance].userId roomid:self.roomID success:^(BOOL flag, NSString *msg) {
                if (flag) {

                    UIButton *sender = (UIButton *)[self.view viewWithTag:kEnsureBtnTag];
                    [sender setTitle:@"取消准备" forState:UIControlStateNormal];
                    NSBubbleData *bubbleData = [NSBubbleData dataWithText:[NSString stringWithFormat:@"加入到当前拼车"] date:[NSDate date] type:BubbleTypeSystem contentType:BubbleContentText];
                    bubbleData.avatar = [PeopleManager getPeopleWithFriendID:[User shareInstance].userId].headpic;
                    
                    SystemTextMessage *systemTextMessage = [[SystemTextMessage alloc]init];
                    systemTextMessage.uid = [User shareInstance].userId;   //自己id
                    systemTextMessage.fid = [User shareInstance].userId;   //用户id
                    systemTextMessage.roomid = self.roomID; //房间id
                    systemTextMessage.comandtype = SystemCommendTypeJOINCAR;//加入拼车命令
                    systemTextMessage.content = @""; //信息内容
                    systemTextMessage.date = [NSDate date]; //日期时间
                    systemTextMessage.type = 2; // 1 为接受 2为发送
                    
                    [MessageManager sendGroupMessage:[systemTextMessage transformToMessage]];
                    [_bubbleArray addObject:bubbleData];
                    [_bubbleTableView reloadData];
                    [_bubbleTableView scrollerToBottomWithAnimation:YES];
                    
                }
                else
                {
                    [UIAlertView showAlertViewWithTitle:@"错误" message:msg cancelTitle:@"确定"];
                }
                
                [self refreshRoomInfo];
            } failure:^(NSError *error) {
                
            }];

        }
        if (alertView.tag == kJojinPingcheTag) {
            
                [NetWorkManager networkJoinRoomWithID:[User shareInstance].userId roomID:self.roomID success:^(BOOL flag, NSString *msg) {
                    if (flag) {
                        UIView * ensureView = [(UIView *)self.view viewWithTag:kEnsureViewTag];
                        [ensureView setHidden:YES];
                        self.userState = 2;
                        UIButton *sender = (UIButton *)[self.view viewWithTag:kEnsureBtnTag];
                        [sender setTitle:@"取消准备" forState:UIControlStateNormal];
                        NSBubbleData *bubbleData = [NSBubbleData dataWithText:[NSString stringWithFormat:@"加入到当前拼车"] date:[NSDate date] type:BubbleTypeSystem contentType:BubbleContentText];
                        bubbleData.avatar = [PeopleManager getPeopleWithFriendID:[User shareInstance].userId].headpic;
                        
                        SystemTextMessage *systemTextMessage = [[SystemTextMessage alloc]init];
                        systemTextMessage.uid = [User shareInstance].userId;   //自己id
                        systemTextMessage.fid = [User shareInstance].userId;   //用户id
                        systemTextMessage.roomid = self.roomID; //房间id
                        systemTextMessage.comandtype = SystemCommendTypeJOINCAR;//加入拼车命令
                        systemTextMessage.content = @""; //信息内容
                        systemTextMessage.date = [NSDate date]; //日期时间
                        systemTextMessage.type = 2; // 1 为接受 2为发送
                        
                        [MessageManager sendGroupMessage:[systemTextMessage transformToMessage]];
                        
                        [_bubbleArray addObject:bubbleData];
                        [_bubbleTableView reloadData];
                        [_bubbleTableView scrollerToBottomWithAnimation:YES];
                    }
                    else
                    {
                        [UIAlertView showAlertViewWithTitle:@"错误" message:msg cancelTitle:@"确定"];
                    }
                    [self refreshRoomInfo];
                } failure:^(NSError *error) {
                    
                }];
            }

        if (alertView.tag == kExitPingcheTag) {
            
            [NetWorkManager networkExitRoomWithID:[User shareInstance].userId roomID:self.roomID success:^(BOOL flag, NSString *msg) {
                if (flag) {
                    self.userState = 1;
                    UIButton *sender = (UIButton *)[self.view viewWithTag:kEnsureBtnTag];
                    [sender setTitle:@"我准备好了" forState:UIControlStateNormal];
                    NSBubbleData *bubbleData = [NSBubbleData dataWithText:[NSString stringWithFormat:@"退出了当前拼车"] date:[NSDate date] type:BubbleTypeSystem contentType:BubbleContentText];
                    bubbleData.avatar = [PeopleManager getPeopleWithFriendID:[User shareInstance].userId].headpic;
                    
                    SystemTextMessage *systemTextMessage = [[SystemTextMessage alloc]init];
                    systemTextMessage.uid = [User shareInstance].userId;   //自己id
                    systemTextMessage.fid = [User shareInstance].userId;   //用户id
                    systemTextMessage.roomid = self.roomID; //房间id
                    systemTextMessage.comandtype = SystemCommendTypeEXITCAR;//加入拼车命令
                    systemTextMessage.content = @""; //信息内容
                    systemTextMessage.date = [NSDate date]; //日期时间
                    systemTextMessage.type = 2; // 1 为接受 2为发送
                    
                    [MessageManager sendGroupMessage:[systemTextMessage transformToMessage]];
                    
                    [_bubbleArray addObject:bubbleData];
                    [_bubbleTableView reloadData];
                    [_bubbleTableView scrollerToBottomWithAnimation:YES];
                }
                else
                {
                    [UIAlertView showAlertViewWithTitle:@"错误" message:msg cancelTitle:@"确定"];
                }
                [self refreshRoomInfo];
            } failure:^(NSError *error) {
                
            }];
        }
        /*
        Room *room = [[Room alloc]initWithDic:[self.roomInfo valueForKey:@"room"]];
        NSArray *userArray = (NSArray *)[self.roomInfo valueForKey:@"users"];
        NSDictionary *owner = (NSDictionary *)[((NSArray *)[self.roomInfo objectForKey:@"owener"]) objectAtIndex:0];
        NSString *usersStr = @"";
        
        if ([[owner valueForKey:@"id"]longValue] != [User shareInstance].userId ) {
            usersStr = [usersStr stringByAppendingFormat:@"instcar%ld,",[[owner valueForKey:@"id"]longValue]];
        }

        for (int i = 0; i < [userArray count]; i++) {
            NSDictionary * user = [userArray objectAtIndex:i];
            if ([[user valueForKey:@"id"] longValue] == [User shareInstance].userId) {
                continue;
            }
            usersStr = [usersStr stringByAppendingFormat:@"instcar%ld,",[[user valueForKey:@"id"] longValue]];
        }

        usersStr = [usersStr substringToIndex:[usersStr length]-1];
        
        NSString *title = [NSString stringWithFormat:@"来自:%@",room.linename];
        NSString *content = @"";
        if (alertView.tag == kJojinPingcheTag) {
            content = [NSString stringWithFormat:@"%@ 加入拼车",[User shareInstance].userName];
        }
        if (alertView.tag == kExitPingcheTag) {
            content = [NSString stringWithFormat:@"%@ 退出拼车",[User shareInstance].userName];
        }
        if (alertView.tag == kEnsurePingcheTag) {
            content = [NSString stringWithFormat:@"房主%@ 确认拼车",[User shareInstance].userName];
        }
        
        
        [NetWorkManager networkJpushSendNotification:usersStr title:title content:content success:^(BOOL flag, NSString *msg) {
            if (flag) {
                
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"消息发送失败"];
            }
        } failure:^(NSError *error) {
            
        }];
         */
    }
    else
    {
        DLog(@"取消");
    }

}

#pragma mark - 事件
-(void)headImageTapAction:(long)userid
{
    DLog(@"头像点击");
//    if (userid == [User shareInstance].userId) {
//        return;
//    }
    ProfileViewController * profileVC = [[ProfileViewController alloc]init];
    profileVC.uid = userid;
    profileVC.state = 1;
//    if (userid == [User shareInstance].userId) {
//        profileVC.state = 2;
//    }
    [self.navigationController pushViewController:profileVC animated:YES];
    [profileVC release];
}

-(void)cellTouchAction:(NSBubbleData *)data
{
    DLog(@"cell点击事件");
    if (data.contentType == BubbleContentImage) {
        //图片点击动作
        [self showAlbum:data];
    }
}

-(void)showAlbum:(NSBubbleData *)data
{
    //显示相册
    int count = self.currentImageArray.count;
    
    //1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    int currentImage = -1;
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSBubbleData *bubbleData = (NSBubbleData *)[self.currentImageArray objectAtIndex:i];
        CommonMessage *message = bubbleData.message;
        if ([message isKindOfClass:[ImageMessage class]]) {
            UIImage *image= ((ImageMessage *)message).image;
            if ([data isEqual:bubbleData]) {
                currentImage = i;
            }
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.image = image; // 图片路径
            photo.srcImageView = (UIImageView *)bubbleData.view; // 来源于哪个UIImageView
            [photos addObject:photo];
            [photo release];
        }
        else
        {
            NSAssert(1, @"message is not a ImageMessage");
        }
    }
    
    //2.显示相册
    MJPhotoBrowser *browser = [[[MJPhotoBrowser alloc] init]autorelease];
    browser.currentPhotoIndex = currentImage; //弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    browser.photoDics = self.currentImageArray;
    [browser show];
}

-(void)ImageViewCell:(ImageViewCell *)imageViewCell ImageViewtapAction:(id)sender
{
    DLog(@"图片点击");
}

-(void)backToMain
{
    DLog(@"返回");
    [[XmppManager sharedInstance] setChatDelegate:nil];
    
    //退出房间
    [[XmppManager sharedInstance] leaveRoom];
    //如果用户准备了，返回到主界面当前状态
    if (self.isRoomMaster == YES) {
        [[AppDelegate shareDelegate].mainVC.mainScrollView setContentOffset:CGPointMake(320, 0) animated:NO];
        [self.navigationController popToViewController:[AppDelegate shareDelegate].mainVC animated:YES];
//        [[AppDelegate shareDelegate].mainVC showRouteView];
    }
    else
    if (self.userState == 2 ) {
        [[AppDelegate shareDelegate].mainVC.mainScrollView setContentOffset:CGPointMake(320, 0) animated:NO];
        [self.navigationController popToViewController:[AppDelegate shareDelegate].mainVC animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)enterGroupManager
{
    DLog(@"----进入群人员名单---");
    GroupRoomSettingViewController *groupRoomSettingVC = [[GroupRoomSettingViewController alloc]init];
    groupRoomSettingVC.roomid = self.roomID;
    groupRoomSettingVC.isroomMaster = self.isRoomMaster;
    groupRoomSettingVC.delegate = self;
    groupRoomSettingVC.groupVC = self;
    [self.navigationController pushViewController:groupRoomSettingVC animated:YES];
    [groupRoomSettingVC release];
}

-(void)groupRoomSettingVC:(GroupRoomSettingViewController *)groupRoomSettingVC sanderMessageEvent:(kPListEvent)event
{
    //刷新房间信息
    [self refreshRoomInfo];
    //发送系统信息
    if (event == kPListEventOpened) {
    
        NSBubbleData *bubbleData = [NSBubbleData dataWithText:[NSString stringWithFormat:@"开启了一个座位"] date:[NSDate date] type:BubbleTypeSystem contentType:BubbleContentText];
        bubbleData.avatar = [PeopleManager getPeopleWithFriendID:[User shareInstance].userId].headpic;
        
        SystemTextMessage *systemTextMessage = [[SystemTextMessage alloc]init];
        systemTextMessage.uid = [User shareInstance].userId;   //自己id
        systemTextMessage.fid = [User shareInstance].userId;   //用户id
        systemTextMessage.roomid = self.roomID; //房间id
        systemTextMessage.comandtype = SystemCommendTypeOpenSeat;//加入拼车命令
        systemTextMessage.content = @""; //信息内容
        systemTextMessage.date = [NSDate date]; //日期时间
        systemTextMessage.type = 2; // 1 为接受 2为发送
        
        [MessageManager sendGroupMessage:[systemTextMessage transformToMessage]];
        
        [_bubbleArray addObject:bubbleData];
        [_bubbleTableView reloadData];
        [_bubbleTableView scrollerToBottomWithAnimation:YES];
    }
    if (event == kPListEventClose) {
        
        NSBubbleData *bubbleData = [NSBubbleData dataWithText:[NSString stringWithFormat:@"关闭了一个座位"] date:[NSDate date] type:BubbleTypeSystem contentType:BubbleContentText];
        bubbleData.avatar = [PeopleManager getPeopleWithFriendID:[User shareInstance].userId].headpic;
        
        SystemTextMessage *systemTextMessage = [[SystemTextMessage alloc]init];
        systemTextMessage.uid = [User shareInstance].userId;   //自己id
        systemTextMessage.fid = [User shareInstance].userId;   //用户id
        systemTextMessage.roomid = self.roomID; //房间id
        systemTextMessage.comandtype = SystemCommendTypeCloseSeat;//关闭房间
        systemTextMessage.content = @""; //信息内容
        systemTextMessage.date = [NSDate date]; //日期时间
        systemTextMessage.type = 2; // 1 为接受 2为发送
        
        [MessageManager sendGroupMessage:[systemTextMessage transformToMessage]];
        
        [_bubbleArray addObject:bubbleData];
        [_bubbleTableView reloadData];
        [_bubbleTableView scrollerToBottomWithAnimation:YES];
    }
    if (event == kplistEventChangerTime) {
        
        NSBubbleData *bubbleData = [NSBubbleData dataWithText:[NSString stringWithFormat:@"修改了出发时间"] date:[NSDate date] type:BubbleTypeSystem contentType:BubbleContentText];
        bubbleData.avatar = [PeopleManager getPeopleWithFriendID:[User shareInstance].userId].headpic;
        
        SystemTextMessage *systemTextMessage = [[SystemTextMessage alloc]init];
        systemTextMessage.uid = [User shareInstance].userId;   //自己id
        systemTextMessage.fid = [User shareInstance].userId;   //用户id
        systemTextMessage.roomid = self.roomID; //房间id
        systemTextMessage.comandtype = SystemCommendTypeChangeTime;//关闭房间
        systemTextMessage.content = @""; //信息内容
        systemTextMessage.date = [NSDate date]; //日期时间
        systemTextMessage.type = 2; // 1 为接受 2为发送
        
        [MessageManager sendGroupMessage:[systemTextMessage transformToMessage]];
        
        [_bubbleArray addObject:bubbleData];
        [_bubbleTableView reloadData];
        [_bubbleTableView scrollerToBottomWithAnimation:YES];
    }
}

- (void)BubbleTableViewDidScroll:(UIScrollView *)scrollView
{
    UIImageView *welcomeImgView = (UIImageView *)[self.view viewWithTag:1001];
    UIView *mainView = (UIView *)[self.view viewWithTag:1000];
    if (scrollView.contentOffset.y > 0) {
        [_groupDesView setFrame:CGRectMake(0, 0, 320, 28)];
        [_bubbleTableView  setTableHeaderView:_groupDesView];
//        CGRect frame = _bubbleTableView.frame;
//        frame.origin.y = 64+44;
//        frame.size.height = + 28;
//        [_bubbleTableView setFrame:frame];
    }
    else
        if (scrollView.contentOffset.y < 0)
        {
            [_bubbleTableView setTableHeaderView:[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 28)]autorelease]];
            [_groupDesView setFrame:CGRectMake(0, 64+44, 320, 28)];
            [mainView insertSubview:_groupDesView belowSubview:welcomeImgView];
//            [_bubbleTableView setFrame:CGRectMake(0, 64+44+28, 320, SCREEN_HEIGHT-64-44-28-44)];
        }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
