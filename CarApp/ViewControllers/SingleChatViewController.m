//
//  SingleChatViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-1-20.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "SingleChatViewController.h"
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

#define kNavTitleViewTag 1988888

#define kEnsurePingcheTag 197777
#define kJojinPingcheTag 197776
#define kExitPingcheTag 197775

@interface SingleChatViewController ()<UIBubbleTableViewDataSource,UIBubbleTableViewDelegate,UIBubbleTableViewCellDelegate,FaceToolBarDelegate,ImageViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GroupRoomSettingVCDelegate>
{
    NSMutableArray *_bubbleArray;
    FaceToolBar *_faceToolBar;
    UIBubbleTableView *_bubbleTableView;
}

@property (retain, nonatomic) NSMutableArray *bubbleArray;
@property (assign, nonatomic) int currentPassengers;                         //当前乘客
@property (assign, nonatomic) int remainSeat;                                //剩余空位
@property (assign, nonatomic) int loadMoreNum; //载入更多的id
@property (assign, nonatomic) int canLoadMore; //能不能载入更多
@property (retain, nonatomic) NSMutableArray *currentImageArray;            //当前图片
@end

@implementation SingleChatViewController

-(void)dealloc
{
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
    
    //聊天数据代理绑定
    [[XmppManager sharedInstance] setChatDelegate:self];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //聊天数据代理绑定
    [[XmppManager sharedInstance] setChatDelegate:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bubbleArray = [[[NSMutableArray alloc]init]autorelease];
    self.currentImageArray = [[[NSMutableArray alloc]init]autorelease];
    self.loadMoreNum = 0;
    self.canLoadMore = 1;
    
    if (kDeviceVersion >= 7.0) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
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
    
    UIButton * backButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 20, 70, 44)];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_normal@2x"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed@2x"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backButton];
    
    UIButton * infoButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [infoButton setFrame:CGRectMake(320-70, 20, 70, 44)];
    [infoButton setBackgroundColor:[UIColor clearColor]];
    [infoButton setBackgroundImage:[UIImage imageNamed:@"btn_info_normal@2x"] forState:UIControlStateNormal];
    [infoButton setBackgroundImage:[UIImage imageNamed:@"btn_info_pressed@2x"] forState:UIControlStateHighlighted];
    [infoButton addTarget:self action:@selector(enterUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:infoButton];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, 200, 44)];
    [titleLabel setTag:kNavTitleViewTag];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:self.userName];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor appNavTitleColor]];
    [titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [navBar addSubview:titleLabel];
    [titleLabel release];
    
//    //导航栏下方的欢迎条
//    UIImage * welcomeImage = [UIImage imageNamed:@"nav_hint@2x"];
//    UIImageView * welcomeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 49)];
//    [welcomeImgView setImage:welcomeImage];
//    [mainView addSubview:welcomeImgView];
//    [welcomeImgView release];
//    
//    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 44)];
//    [timeLabel setTag:kTimeLabelTag];
//    [timeLabel setBackgroundColor:[UIColor clearColor]];
//    [timeLabel setTextColor:[UIColor whiteColor]];
//    [timeLabel setFont:[UIFont boldSystemFontOfSize:20]];
//    [welcomeImgView addSubview:timeLabel];
//    [timeLabel release];
//    
//    //导航栏下方的信息提示lable
//    UILabel * messageWarnLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
//    [messageWarnLable setTag:kMessageWarnLableTag];
//    [messageWarnLable setBackgroundColor:[UIColor clearColor]];
//    
//    //    [messageWarnLable setText:[NSString stringWithFormat:@"%@,欢迎来到易行",[[User shareInstance] userName]]];
    
    //聊天视图
    _bubbleTableView = [[UIBubbleTableView alloc]initWithFrame:CGRectMake(0, 64, 320, SCREEN_HEIGHT-64-44)];
    [_bubbleTableView setBackgroundColor:[UIColor clearColor]];
    [_bubbleTableView setBubbleDataSource:self];
    [_bubbleTableView setBubbleTableViewDelegate:self];
    [mainView insertSubview:_bubbleTableView belowSubview:navBar];
    [_bubbleTableView release];
    
    //聊天输入框/键盘
    _faceToolBar =[[FaceToolBar alloc]initWithFrame:CGRectMake(0.0f,SCREEN_HEIGHT - toolBarHeight-100,self.view.frame.size.width,toolBarHeight) superView:mainView];
    [_faceToolBar setFaceToolBarDelegate:self];
    
    
    //获取历史聊天记录
    [self getChatHistoryWithOrder:-1];
    
}

//获取跟多的历史
-(void)getChatHistoryWithOrder:(int)order
{
    //从数据库进性分页的查询数据库
    NSDictionary * messageDic = [MessageManager getCommonMessageWithUserID:self.userID withPerNum:20 withOrder:order];
    
    //读取记录
    NSMutableArray * messageDataArray = [NSMutableArray arrayWithArray:[messageDic objectForKey:@"message"]];
    self.loadMoreNum = [[messageDic objectForKey:@"lastId"]intValue]; //最后的id
    self.canLoadMore = [[messageDic objectForKey:@"canLoadMore"]intValue]; //显示是否还有数据
    
    //分条进行显示数据
    for (CommonMessage * mes in messageDataArray)
    {
        [self showHistoryMessage:mes];
    }
    
    //插入完之后刷新
    [_bubbleTableView reloadData];
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
        [self.currentImageArray addObject:message];
        sayBubble = [NSBubbleData dataWithImage:message.image date:message.date type:type contentType:BubbleContentImage];
    }
    
    //处理文本请求
    if ([mes isKindOfClass:[BaseTextMessage class]]) {
        BaseTextMessage * message = (BaseTextMessage *)mes;
        int type = mes.fid == [User shareInstance].userId?BubbleTypeMine:BubbleTypeSomeoneElse;
        sayBubble = [NSBubbleData dataWithText:message.content date:message.date type:type contentType:BubbleContentText];
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
    }
    sayBubble.uid = mes.fid;
    sayBubble.avatar = [PeopleManager getPeopleWithFriendID:mes.fid].headpic;
    
    //历史记录插入
    [self.bubbleArray insertObject:sayBubble atIndex:0];
    
}

#pragma mark - 获取用户详细信息
-(void)refreshUserInfo
{
    
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
    //    DLog(@"faceHeight:%f",height);
    //    DLog(@"BubbleContentHeight:%f",_bubbleTableView.contentSize.height);
    
    
    CGRect frame = _bubbleTableView.frame;
    
    
    //通过内容视图的高度来判断视图是适配高度还是适配位置
    if (_bubbleTableView.contentSize.height < SCREEN_HEIGHT-64-45) {
        frame.size.height = SCREEN_HEIGHT-64-45 + (height - SCREEN_HEIGHT+toolBarHeight);
        _bubbleTableView.frame = frame;
    }
    else
    {
        frame.size.height = SCREEN_HEIGHT-64-45;
        frame.origin.y = 64+(height-SCREEN_HEIGHT+toolBarHeight);
        _bubbleTableView.frame = frame;
    }
    
    
    if(SCREEN_HEIGHT-toolBarHeight == height)
    {
        [_bubbleTableView scrollerToBottomWithAnimation:NO];
    }
    else
    {
        //         if (_bubbleTableView.contentSize.height < SCREEN_HEIGHT-64-45-30-44)
        {
            [_bubbleTableView scrollerToBottomWithAnimation:YES];
        }
    }
    
}

-(void)sendTextAction:(NSString *)inputText
{
    DLog(@"sendtext");
    
    NSBubbleData *bubbleData = [NSBubbleData dataWithText:inputText date:[NSDate date] type:BubbleTypeMine contentType:BubbleContentText];
    bubbleData.avatar = [PeopleManager getPeopleWithFriendID:[User shareInstance].userId].headpic;
    BaseTextMessage *baseTextMessage = [[[BaseTextMessage alloc]init]autorelease];
    baseTextMessage.uid = [User shareInstance].userId;   //自己id
    baseTextMessage.fid = [User shareInstance].userId;   //用户id
    baseTextMessage.roomid = -1; //房间id
    baseTextMessage.content = inputText; //信息内容
    baseTextMessage.date = [NSDate date]; //日期时间
    baseTextMessage.type = 2; // 1 为接受 2为发送
    
    bubbleData.uid = baseTextMessage.fid;
    
    
    [MessageManager sendSigleMessage:[baseTextMessage transformToMessage]];
    
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
            imageMessage.roomid = -1; //房间id
            imageMessage.date = [NSDate date]; //日期时间
            imageMessage.type = 2;
            
            [MessageManager sendGroupMessage:[imageMessage transformToMessage]];
            [self.currentImageArray addObject:imageMessage];
            
            //            ImageViewCell *imageView = [[[ImageViewCell alloc]initWithImage:image]autorelease];
            //            NSBubbleData *bubbleData = [NSBubbleData dataWithView:imageView date:imageMessage.date type:BubbleTypeMine insets:UIEdgeInsetsMake(10, 10, 10, 10) contentType:BubbleContentImage];
            NSBubbleData *bubbleData = [NSBubbleData dataWithImage:imageMessage.image date:imageMessage.date type:BubbleTypeMine contentType:BubbleContentImage];
            bubbleData.avatar = [PeopleManager getPeopleWithFriendID:[User shareInstance].userId].headpic;
            bubbleData.uid = imageMessage.fid;
            [_bubbleArray addObject:bubbleData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
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
    else
    {
        DLog(@"取消");
    }
}

#pragma mark - 事件
-(void)headImageTapAction:(long)userid
{
    DLog(@"头像点击");
    if (userid == [User shareInstance].userId) {
        return;
    }
    ProfileViewController * profileVC = [[ProfileViewController alloc]init];
    profileVC.uid = userid;
    profileVC.state = 1;
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
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    int currentImage = -1;
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        UIImage *image= ((ImageMessage *)[self.currentImageArray objectAtIndex:i]).image;
        if (image == ((UIImageView *)data.view).image) {
            currentImage = i;
        }
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.image = image; // 图片路径
        photo.srcImageView = (UIImageView *)data.view; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = currentImage; // 弹出相册时显示的第一张图片是？
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
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    int myindex = [viewControllerArray indexOfObject:self];
    for (UIViewController *VC in viewControllerArray) {
         DLog(@"%@",NSStringFromClass([VC class]));
    }
    
    //如果父视图为群聊视图者返回
    if ([[viewControllerArray objectAtIndex:(myindex-2)] isKindOfClass:NSClassFromString(@"GroupChatViewController")]) {
        [self.navigationController popToViewController:[viewControllerArray objectAtIndex:(myindex-3)] animated:YES];
    }
    else
        [self.navigationController popToViewController:[viewControllerArray objectAtIndex:(myindex-2)] animated:YES];
}

-(void)BubbleTableViewDidScroll:(UIScrollView *)scrollView
{
    
}

-(void)groupRoomSettingVC:(GroupRoomSettingViewController *)groupRoomSettingVC sanderMessageEvent:(kPListEvent)event
{
    
}

-(void)enterUserInfo
{
    DLog(@"---进入用户详情---");

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
