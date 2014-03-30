//
//  CommentViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-4.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "CommentViewController.h"
#import "WarnView.h"
#import "CommentCell.h"
#import "CommentDetailViewController.h"

@interface CommentViewController ()<UIAlertViewDelegate>

@property (retain, nonatomic) WarnView *warnView;
@property (retain, nonatomic) NSMutableArray *userArray;
@property (assign, nonatomic) long currentCommentuid;

@end

@implementation CommentViewController

-(void)dealloc
{
    //    [self.homeAddress release];
    [SafetyRelease release:_warnView];
    [SafetyRelease release:_userArray];
    [SafetyRelease release:_room];
    [SafetyRelease release:_tableView];
    [_tableView setDelegate:nil];
    [_tableView setDataSource:nil];
    [_tableView setPullingDelegate:nil];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _editBtnState = NO;
    self.userArray = [[NSMutableArray alloc]initWithCapacity:20];
    
    if (kDeviceVersion >= 7.0) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
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
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 120, 44)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"评论"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor appNavTitleColor]];
    [titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [navBar addSubview:titleLabel];
    [titleLabel release];
    
    //当非房主登入后，编辑按钮不出现，只有房主才能编辑
//    UIButton * editButton = [UIButton buttonWithType: UIButtonTypeCustom];
//    [editButton setFrame:CGRectMake(320- 62, 25, 60, 34)];
//    [editButton setBackgroundColor:[UIColor clearColor]];
//    [editButton setBackgroundImage:[UIImage imageNamed:@"btn_confirm_normal@2x"] forState:UIControlStateNormal];
//    [editButton setBackgroundImage:[UIImage imageNamed:@"btn_confirm_pressed@2x"] forState:UIControlStateHighlighted];
//    [editButton addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [navBar addSubview:editButton];
    
    
    UIImage * welcomeImage = [UIImage imageNamed:@"nav_hint@2x"];
    //    welcomeImage = [welcomeImage stretchableImageWithLeftCapWidth:8 topCapHeight:10];
    //导航栏下方的欢迎条
    UIImageView * welcomeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 49)];
    [welcomeImgView setImage:welcomeImage];
    [mainView addSubview:welcomeImgView];
    [welcomeImgView release];
    
    UILabel * timerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
    [timerLabel setTag:22222];
    [timerLabel setBackgroundColor:[UIColor clearColor]];
    [timerLabel setText:@"时间:"];
    [timerLabel setTextAlignment:NSTextAlignmentLeft];
    [timerLabel setTextColor:[UIColor whiteColor]];
    [timerLabel setFont:[UIFont appGreenWarnFont]];
    [welcomeImgView addSubview:timerLabel];
    [timerLabel release];

    UILabel * pnumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
    [pnumLabel setTag:33333];
    [pnumLabel setBackgroundColor:[UIColor clearColor]];
    [pnumLabel setText:@"可评论人数:0人"];
    [pnumLabel setTextAlignment:NSTextAlignmentRight];
    [pnumLabel setTextColor:[UIColor whiteColor]];
    [pnumLabel setFont:[UIFont appGreenWarnFont]];
    [welcomeImgView addSubview:pnumLabel];
    [pnumLabel release];
    
    self.tableView = [[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 64+44, 320, SCREEN_HEIGHT -64-44) pullingDelegate:self]autorelease];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setShowsHorizontalScrollIndicator:NO];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
    [self.tableView setHeaderOnly:YES];
    [mainView insertSubview:self.tableView aboveSubview:navBar];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 60)];
    [self.tableView setTableFooterView:footerView];
    [footerView release];
    
//    UIImageView *footerBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
//    [footerBackgroundView setImage:[UIImage imageNamed:@"bg_function_normal@2x"]];
//    [footerView addSubview:footerBackgroundView];
//    [footerBackgroundView release];

    self.warnView = [WarnView initWarnViewWithText:@"非常抱歉,暂无数据..." withView:_tableView height:120 withDelegate:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView launchRefreshing];
}

-(void)getUserListfromServer
{
    UILabel *timerLable = (UILabel *)[self.view viewWithTag:22222];
    UILabel *pnumLabel = (UILabel *)[self.view viewWithTag:33333];
    
    NSString *startDate = [AppUtility strFromDate:self.room.startingtime withFormate:@"yyyy年MM月dd HH:mm"];
    
    [timerLable setText:[NSString stringWithFormat:@"时间:%@",startDate]];
    
    [NetWorkManager networkGetRoomCommentWithuid:[User shareInstance].userId roomid:self.room.ID success:^(BOOL flag, NSArray *userArray, NSDictionary *room, NSString *msg) {
        if (flag) {
            for(int i = 0; i < [userArray count]; i++)
            {
                [self.userArray addObject:[userArray objectAtIndex:i]];
            }
            [pnumLabel setText:[NSString stringWithFormat:@"可评论人数:%d人",[self.userArray count]]];
            [_tableView setReachedTheEnd:YES];
            [_tableView tableViewDidFinishedLoading];
            [_tableView reloadData];
        }
        else
        {
            [UIAlertView showAlertViewWithTitle:@"失败" message:msg cancelTitle:@"确定"];
        }
        if ([self.userArray count]>0) {
            [self.warnView dismiss];
        }
        else
        {
            [self.warnView show:kenumWarnViewTypeNullData];
            [_tableView tableViewDidFinishedLoading];
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.warnView show:kenumWarnViewTypeServeError];
        [_tableView tableViewDidFinishedLoading];
    }];
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if (range.location>=50)
//    {
//        return  NO;
//    }
//    else
//    {
//        return YES;
//    }
//}


//-(void)editBtnAction:(UIButton *)sender
//{
//    NSLog(@"评论");
//    
//    UITextView *textView  = (UITextView *)[self.view viewWithTag:91001];
//    UITextField *textfield  = (UITextField *)[self.view viewWithTag:92002];
//    int scores = [textfield.text intValue];
//    //编辑按钮事件
//    _editBtnState = !_editBtnState;
//    [NetWorkManager networkCommemtWithRoomID:self.room.ID uid:[User shareInstance].userId touid:self.room.userid content:textView.text scores:scores success:^(BOOL flag, NSString *msg) {
//        if (flag) {
//          [SVProgressHUD showSuccessWithStatus:@"评论成功"];
//          [self.navigationController popViewControllerAnimated:YES];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [self.tableData count];
    if ([self.userArray count]>0&&self.userArray) {
        return [self.userArray count];
    }
    else
    {
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"commentCellTag";
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }

    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    if (kDeviceVersion >= 7.0) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    NSDictionary *user = (NSDictionary *)[self.userArray objectAtIndex:indexPath.row];
    [cell.imagerView setImageWithURL:[NSURL URLWithString:[user valueForKey:@"HEADPIC"]] placeholderImage:[UIImage imageNamed:@"delt_user_s"]];
    [cell.nameLable setText:[user valueForKey:@"USERNAME"]];
    [cell.typeLable setText:@"乘客"];
    if (![[user valueForKey:@"hisflag"]boolValue]&&[[user valueForKey:@"myflag"]boolValue]) {
        [cell.desLable setText:@"我已评价"];
    }
    if ([[user valueForKey:@"hisflag"]boolValue]&&![[user valueForKey:@"myflag"]boolValue]) {
        [cell.desLable setText:@"对方已评"];
    }
    if ([[user valueForKey:@"hisflag"]boolValue]&&[[user valueForKey:@"myflag"]boolValue])
    {
        [cell.desLable setText:@"双方已评"];
    }
    if (![[user valueForKey:@"hisflag"]boolValue]&&![[user valueForKey:@"myflag"]boolValue])
    {
        [cell.desLable setText:@"双方未评"];
    }
    
    //    //没有状态数据 房间的返回参数是 1为等待 2为进行 3为结束
//    if(room.status == 1 || room.status == 2)
//    {
//        [cell.routeTimeLabel setHidden:NO];
//        [cell.commentBtn setHidden:YES];
//    }
//    if(room.status == 3)
//    {
//        [cell.routeTimeLabel setHidden:YES];
//        [cell.commentBtn setHidden:NO];
//    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[[UIView alloc] init] autorelease];
   
    return myView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.currentCommentuid = [[((NSDictionary *)[self.userArray objectAtIndex:indexPath.row]) valueForKey:@"UID"]longValue];
    
    NSDictionary *user = (NSDictionary *)[self.userArray objectAtIndex:indexPath.row];
    
    if ([[user valueForKey:@"myflag"] boolValue] ) {
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"他已经上车",@"他没有来",@"我有事没去接", nil];
    [alertView setTag:30001];
    [alertView show];
    [alertView release];
    
//    //评价某人
//    CommentDetailViewController *commentDetailVC = [[CommentDetailViewController alloc]init];
//    commentDetailVC.room = self.room;
////        commentDetailVC.userid = 
//    [self.navigationController pushViewController:commentDetailVC animated:YES];
//    [commentDetailVC release];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //乘客登入
    if (alertView.tag == 30001) {
        if (buttonIndex == 1) {
            //他已经上车
            if (!self.currentCommentuid) {
                return;
            }
            CommentDetailViewController *commentDetailVC = [[CommentDetailViewController alloc]init];
            commentDetailVC.room = self.room;
            commentDetailVC.userid = self.currentCommentuid;
            [self.navigationController pushViewController:commentDetailVC animated:YES];
            [commentDetailVC release];
        }
        if (buttonIndex == 2) {
            //他没来 乘客失约+1
            if (!self.currentCommentuid) {
                return;
            }
            [NetWorkManager networkCommemtWithRoomID:self.room.ID uid:[User shareInstance].userId touid:self.currentCommentuid content:@"" commentLever:1 userstatus:2 yeyxstar:0 jzwmstar:0 rxttstar:0 ownertatus:0 success:^(BOOL flag, NSString *msg) {
                if (flag) {
                    [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                    [alertView dismissWithClickedButtonIndex:0 animated:YES];
                }
                [self refreshTable];//更新数据
            } failure:^(NSError *error) {
                
            }];
            
        }
        if (buttonIndex == 3) {
            //我有事没去接 房主失约+1
            if (!self.currentCommentuid) {
                return;
            }
            [NetWorkManager networkCommemtWithRoomID:self.room.ID uid:[User shareInstance].userId touid:self.currentCommentuid content:@"" commentLever:1 userstatus:0 yeyxstar:0 jzwmstar:0 rxttstar:0 ownertatus:3 success:^(BOOL flag, NSString *msg) {
                if (flag) {
                    [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                    [alertView dismissWithClickedButtonIndex:0 animated:YES];
                }
                [self refreshTable];//更新数据
            } failure:^(NSError *error) {
                
            }];
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            
        }
        if (buttonIndex == 0) {
            //取消
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    /*
     Code to actually refresh goes here.
     */
    //对tableModel进行判断
    
    [self.userArray removeAllObjects];
    [self getUserListfromServer];
    
}

- (void) loadMoreDataToTable
{
    /*
     Code to actually load more data goes here.
     */
    //对tableModel进行判断
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.f];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.f];
}


- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    return [NSDate date];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_tableView tableViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_tableView tableViewDidEndDragging:scrollView];
}

-(void)backToMain
{
//    UITextView *textView  = (UITextView *)[self.view viewWithTag:91001];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
