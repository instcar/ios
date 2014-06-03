//
//  MainSecondView.m
//  CarApp
//
//  Created by Leno on 13-9-27.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "MainSecondView.h"
#import "MainRouteTableCell.h"
#import "WarnView.h"

#import "GroupChatViewController.h"
#import "CommentViewController.h"
#import "CommentDetailViewController.h"

#define kMyRoomCellNum 10

@interface MainSecondView()

@property (strong, nonatomic) NSMutableArray *myAllArray;
@property (strong, nonatomic) NSMutableArray *MyRoomArray;
@property (strong, nonatomic) NSMutableArray *MyJoinRoomArray;
@property (strong, nonatomic) Room *currentCommentRoom;//当前评论房间
@property (strong, nonatomic) WarnView *warnView;

@end

@implementation MainSecondView

@synthesize tableView = _tableView;

-(void)dealloc
{

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _editBtnState = NO;
        
        PullingRefreshTableView *tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(10, 0, frame.size.width-20, frame.size.height) pullingDelegate:self];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView setBackgroundView:nil];
        [tableView setBackgroundColor:[UIColor clearColor]];
        [tableView setShowsHorizontalScrollIndicator:NO];
        [tableView setShowsVerticalScrollIndicator:NO];
        [tableView setSeparatorColor:[UIColor lightGrayColor]];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableView setEditing:NO animated:NO];
        [self addSubview:tableView];
        [self setTableView:tableView];

        _MyRoomArray = [[NSMutableArray alloc]init];
        _MyJoinRoomArray = [[NSMutableArray alloc]init];
        _myAllArray = [[NSMutableArray alloc]init];
        
        self.userInteractionEnabled = YES;
        
        self.warnView = [WarnView initWarnViewWithText:@"非常抱歉,暂无数据..." withView:_tableView height:120 withDelegate:nil];
    }
    return self;
}

-(void)setTableData:(NSMutableArray *)array
{
    User * user = [User shareInstance];
//    self.secondTableData = array;
    
    [self.MyJoinRoomArray removeAllObjects];
    [self.MyRoomArray removeAllObjects];
    
    /* 除去编辑按钮
    if ([array count]>0) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 60)];
        [self.tableView setTableFooterView:footerView];
        [footerView release];
        
        UIImageView *footerBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -2, 320, 64)];
        [footerBackgroundView setImage:[UIImage imageNamed:@"bg_function_normal@2x"]];
        [footerView addSubview:footerBackgroundView];
        [footerBackgroundView release];
        
        UIButton * editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [editBtn setFrame:CGRectMake(130, 25, 60, 34)];
        [editBtn setCenter:footerBackgroundView.center];
        [editBtn setBackgroundImage:[UIImage imageNamed:@"btn_his_confirm_normal@2x"] forState:UIControlStateNormal];
        [editBtn setBackgroundImage:[UIImage imageNamed:@"btn_his_confirm_pressed@2x"] forState:UIControlStateHighlighted];
        [editBtn addTarget:self action:@selector(mainSecondViewEditAction:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:editBtn];
    }
    else
    {
        [self.tableView setTableFooterView:nil];
    }*/
    
    for (int i = 0; i < [self.myAllArray count]; i++) {
        Room *room = [self.myAllArray objectAtIndex:i];
        if (room.user_id == user.userId) {
            [self.MyRoomArray addObject:room];
        }
        else
        {
            [self.MyJoinRoomArray addObject:room];
        }
    }
    
    if ([self.myAllArray count]>0) {
        [self.warnView dismiss];
    }
    else
    {
        [self.warnView show:kenumWarnViewTypeNullData];
    }
    
    [self.tableView reloadData];
}
/*
//数据交互
-(void)requestSecondTableDataFromServer:(kRequestMode)mode
{
    
    User *user = [User shareInstance];
    
    //标签搜索
    [NetWorkManager networkGetRoomsWithID:user.userId page:_myroompage rows:kMyRoomCellNum success:^(BOOL flag, BOOL hasnextpage, NSArray *roomArray, NSString *msg) {
        if (mode == kRequestModeRefresh) {
            [self.myAllArray removeAllObjects];
        }
        if (flag) {
            _myroomCanLoadMore = hasnextpage;
            [self.myAllArray addObjectsFromArray:roomArray];
            [self setTableData:self.myAllArray];
            [self.tableView tableViewDidFinishedLoading];
            [self.tableView setReachedTheEnd:!hasnextpage];
        }
        else
        {
            [UIAlertView showAlertViewWithTitle:@"错误" message:msg cancelTitle:@"忽略"];
        }
    } failure:^(NSError *error) {
        [self.tableView tableViewDidFinishedLoading];
        [self.tableView setReachedTheEnd:YES];
    }];
}
*/
#pragma mark - Refresh and load more methods

- (void)autoRefreshTable
{
    if ([self.myAllArray count] > 0) {
        [self refreshTable];
    }
    else
        [self.tableView launchRefreshing];

}

- (void) refreshTable
{
    //对tableModel进行判断
    _myroompage = 1;
//    [self requestSecondTableDataFromServer:kRequestModeRefresh];
    
}

- (void) loadMoreDataToTable
{
    //对tableModel进行判断
    if (_myroomCanLoadMore) {
        _myroompage ++;
//        [self requestSecondTableDataFromServer:kRequestModeLoadmore];
    }
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.f];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.f];
}


#pragma mark- MainSecondDelegate
//进入显示线路详情
-(void)secondTableDidClicked:(Room *)room
{
    if (!self.mainVC) {
        return;
    }
    //    Room * room = (Room *)[self.myroomArray objectAtIndex:index];
    User * user = [User shareInstance];
//    //进入房间
//    [[XmppManager sharedInstance] createGroup:[NSString stringWithFormat:@"%ld",room.ID]];
    
    //创建成功进入聊天室
    GroupChatViewController * gVC = [[GroupChatViewController alloc]init];
    gVC.roomID = room.ID;
    gVC.isRoomMaster = room.user_id == user.userId?YES:NO;
    gVC.userState = 2;
    [self.mainVC.navigationController pushViewController:gVC animated:YES];
}

-(void)secondTableCommemtAction:(Room *)room
{
    User *masterUser = [User shareInstance];
    
    self.currentCommentRoom = room;
    
    //判断是否为房主
    if (room.user_id == masterUser.userId)
    {   //是房主
        CommentViewController *commentVC = [[CommentViewController alloc]init];
        commentVC.room = room;
        [self.mainVC.navigationController pushViewController:commentVC animated:YES];
    }
    else
    {   //不是房主
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我已经上车",@"车主没来",@"我有事没去", nil];
        [alertView setTag:30001];
        [alertView show];
    }
}

-(void)secondTableDeleteCellAtRoom:(Room *)room
{
    int index = 0;
    for (int i = 0; i < [self.myAllArray count]; i++) {
        Room *proom = [self.myAllArray objectAtIndex:i];
        if (proom.ID == room.ID) {
            index = i;
            break;
        }
    }
    //    [self.myroomArray removeObjectAtIndex:index];
    if (room.user_id != [User shareInstance].userId) {
        _myroompage = 1;
//        
//        [NetWorkManager networkExitRoomWithID:[User shareInstance].userId roomID:room.ID success:^(BOOL flag, NSString *msg) {
//            if (flag) {
//                
//            }
//            else
//            {
//                [UIAlertView showAlertViewWithTitle:@"错误" message:@"退出拼车失败" cancelTitle:@"确定"];
//            }
////            [self mainSecondViewreflushData];
//        } failure:^(NSError *error) {
//            
//        }];
    }
    else
    {
        _myroompage = 1;
//        [NetWorkManager networkCloseRoomWithID:[User shareInstance].userId roomID:room.ID success:^(BOOL flag, NSString *msg) {
//            if (flag) {
//                //                [[XmppManager sharedInstance] destoryRoom];
//            }
//            else
//            {
//                [UIAlertView showAlertViewWithTitle:@"错误" message:@"删除房间失败" cancelTitle:@"确定"];
//            }
////            [self mainSecondViewreflushData];
//        } failure:^(NSError *error) {
//            
//        }];
    }
}

#pragma mark - tableViewDelegate
//设置表格的索引数组
/*
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [NSArray arrayWithObjects:@"我发起的拼车",@"我加入的拼车",nil];
}
*/

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if ([self.MyJoinRoomArray count]>0 && [self.MyRoomArray count]>0) {
//        return 2;
//    }
//    if ([self.MyJoinRoomArray count]>0 || [self.MyRoomArray count]>0) {
//        return 1;
//    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.MyRoomArray count];
    }
    return [self.MyJoinRoomArray count];
//    return [self.secondTableData count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MainRouteTableCell";
    
    MainRouteTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MainRouteTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    [cell.lineView setHidden:NO];
//    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    if (indexPath.row == 0 && [tableView numberOfRowsInSection:indexPath.section] > 1) {
        [cell.backButton setFrame:CGRectMake(10, 0, 300, 60+5)];
    }
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1 && [tableView numberOfRowsInSection:indexPath.section] > 1) {
        [cell.backButton setFrame:CGRectMake(10, -5, 300, 60)];
        [cell.lineView setHidden:YES];
    }
    
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1 && [tableView numberOfRowsInSection:indexPath.section] == 1) {
        [cell.backButton setFrame:CGRectMake(10, 0, 300, 60)];
        [cell.lineView setHidden:YES];
    }
    
    if (indexPath.row != [tableView numberOfRowsInSection:indexPath.section]-1 && indexPath.row != 0) {
        [cell.backButton setFrame:CGRectMake(10, -5, 300, 60+10)];
    }
    
//    [cell setBackgroundColor:[UIColor clearColor]];
//    [cell.backButton setBackgroundImage:[UIImage imageNamed:@"bg_function_normal"] forState:UIControlStateNormal];
//    [cell.backButton setBackgroundImage:[UIImage imageNamed:@"bg_function_pressed"] forState:UIControlStateHighlighted];
    
    if (indexPath.section == 0) {
        [cell.backButton setTag:8800 +indexPath.row];
    }
    if (indexPath.section == 1) {
        [cell.backButton setTag:9900 +indexPath.row];
    }
    [cell.backButton addTarget:self action:@selector(sendRouteIndex:) forControlEvents:UIControlEventTouchUpInside];
    
    Room *room = nil;
    if (indexPath.section == 0) {
        room = [self.MyRoomArray objectAtIndex:indexPath.row];
    }
    if (indexPath.section == 1) {
        room = [self.MyJoinRoomArray objectAtIndex:indexPath.row];
    }
//    Room *room = [_secondTableData objectAtIndex:indexPath.row];
    
    [cell.routeTitleLabel setText:room.description];
    
    NSString *ddStr = [AppUtility dayStrTimeDate:room.start_time];
//    NSString *timeStr = [AppUtility strFromDate:room.startingtime withFormate:@"HH:mm"];

    [cell.routeInfoLabel setText:[NSString stringWithFormat:@"%@",ddStr]];
    if ([ddStr isEqualToString:@"未知"]) {
        [cell.routeInfoLabel setText:[NSString stringWithFormat:@"%@",[AppUtility strFromDate:room.start_time withFormate:@"yyyy年MM月dd日 hh:mm"]]];
    }
    
    NSString *startDate = [AppUtility strFromDate:room.start_time withFormate:@"HH:mm"];
    [cell.routeTimeLabel setText:startDate];
    
    [cell.routeTimeLabel setTextColor:room.user_id == [User shareInstance].userId?[UIColor appNavTitleGreenColor]:[UIColor appNavTitleBlueColor]];
    
    [cell.commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.section == 0) {
        [cell.commentBtn setTag:8800 +indexPath.row];
    }
    if (indexPath.section == 1) {
        [cell.commentBtn setTag:9900 +indexPath.row];
    }
    [cell.commentBtn setEnabled:YES];
//    //没有状态数据 房间的返回参数是 1为等待 2为进行 3为结束  0为完成？
    if(room.status == 1)
    {
        [cell.routeTimeLabel setHidden:NO];
        [cell.commentBtn setHidden:YES];
    }
    if(room.status == 2 || room.status == 3)
    {
        [cell.routeTimeLabel setHidden:YES];
        [cell.commentBtn setHidden:NO];
    }
    if (room.status == 0) {
        [cell.routeTimeLabel setHidden:YES];
        [cell.commentBtn setHidden:NO];
        [cell.commentBtn setEnabled:NO];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)]autorelease];
//}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"我发起的拼车";
    }
    if (section == 1) {
        return @"我加入的拼车";
    }
    return @"";
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView tableViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableView tableViewDidEndDragging:scrollView];
    
}

/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[[UIView alloc] init] autorelease];
//    myView.backgroundColor = [UIColor colorWithWhite:255.0 alpha:0.8];
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 22)];
//    titleLabel.textColor=[UIColor flatBlackColor];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    NSString *sectionStr = @"";
//    if (section == 0) {
//        sectionStr = @"我的拼车";
//    }
//    if (section == 1) {
//        sectionStr = @"我加入的拼车";
//    }
//    titleLabel.text = sectionStr;
//    [myView addSubview:titleLabel];
//    [titleLabel release];
    return myView;
}*/

#pragma mark - scrollViewDelegate
//去掉UItableview headerview黏性(sticky)
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = self.tableView.sectionHeaderHeight;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
*/

#pragma mark - tableViewEditDelegate
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    return _editBtnState;
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 0) {
            
            Room *room = [self.MyRoomArray objectAtIndex:indexPath.row];
            if(self.mainVC && [self respondsToSelector:@selector(secondTableDeleteCellAtRoom:)]) {
                [self secondTableDeleteCellAtRoom:room];
            }
            //数据删除
            [self.MyRoomArray removeObjectAtIndex:indexPath.row];
            //视图删除
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        if (indexPath.section == 1) {
            
            Room *room = [self.MyJoinRoomArray objectAtIndex:indexPath.row];
            
            if(self.mainVC && [self respondsToSelector:@selector(secondTableDeleteCellAtRoom:)]) {
                [self secondTableDeleteCellAtRoom:room];
            }
            //数据删除
            [self.MyJoinRoomArray removeObjectAtIndex:indexPath.row];
            
            //            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            //视图删除
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return @"删除";
    }
    else
    {
        //        Room *room = [self.MyJoinRoomArray objectAtIndex:indexPath.row];
        //        if (room.status == 3) {
        //            return @"删除";
        //        }
        //        else
        return @"退出";
    }
}


-(void)sendRouteIndex:(UIButton *)sender
{
    Room *room = nil;
    if (sender.tag >= 9900) {
        int routeIndex = sender.tag - 9900;
        room = [self.MyJoinRoomArray objectAtIndex:routeIndex];
    }
    if (sender.tag >= 8800 && sender.tag <9900) {
        int routeIndex = sender.tag - 8800;
        room = [self.MyRoomArray objectAtIndex:routeIndex];
    }
    int status = room.status;
    //status 1为等待状态 2为进行中 3为完成
    if (status != 3 && status !=2 && status != 0) {
        [self secondTableDidClicked:room];
    }
    else
    {
        DLog(@"房间状态为评价阶段/已完成评价阶段。无法进入房间聊天");
    }
}

-(void)commentAction:(UIButton *)sender
{
    Room *room = nil;
    if (sender.tag >= 9900) {
        int routeIndex = sender.tag - 9900;
        room = [self.MyJoinRoomArray objectAtIndex:routeIndex];
    }
    if (sender.tag >= 8800 && sender.tag < 9900) {
        int routeIndex = sender.tag - 8800;
        room = [self.MyRoomArray objectAtIndex:routeIndex];
    }
    if (self.mainVC && [self respondsToSelector:@selector(secondTableCommemtAction:)]) {
        [self secondTableCommemtAction:room];
    }
}

/*编辑暂时不使用
- (void)mainSecondViewEditAction:(UIButton *)sender
{
    //编辑按钮事件
    _editBtnState = !_editBtnState;
    [self.tableView setEditing:_editBtnState animated:YES];
    if (!_editBtnState) {
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_his_edit_normal@2x"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_His_edit_pressed@2x"] forState:UIControlStateHighlighted];
    }
    else
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_his_confirm_normal@2x"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_his_confirm_pressed@2x"] forState:UIControlStateHighlighted];
    }
}*/

#pragma mark - UIAleartViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //乘客登入
    if (alertView.tag == 30001) {
        if (buttonIndex == 1) {
            //我已经上车
            if (!self.currentCommentRoom && !self.mainVC) {
                return;
            }
            CommentDetailViewController *commentDetailVC = [[CommentDetailViewController alloc]init];
            commentDetailVC.room = self.currentCommentRoom;
            commentDetailVC.userid = self.currentCommentRoom.user_id;
            [self.mainVC.navigationController pushViewController:commentDetailVC animated:YES];
        }
        if (buttonIndex == 2) {
            //车主没来 房主失约+1
            if (!self.currentCommentRoom) {
                return;
            }
//            [NetWorkManager networkCommemtWithRoomID:self.currentCommentRoom.ID uid:[User shareInstance].userId touid:self.currentCommentRoom.userid content:@"" commentLever:1 userstatus:0 yeyxstar:0 jzwmstar:0 rxttstar:0 ownertatus:2 success:^(BOOL flag, NSString *msg) {
//                if (flag) {
//                    [SVProgressHUD showSuccessWithStatus:@"评论成功"];
//                    [alertView dismissWithClickedButtonIndex:0 animated:YES];
//                }
//                //更新表单
//                [self refreshTable];
//            } failure:^(NSError *error) {
//                
//            }];
            
        }
        if (buttonIndex == 3) {
            //我有事没去 乘客失约+1
            if (!self.currentCommentRoom) {
                return;
            }
//            [NetWorkManager networkCommemtWithRoomID:self.currentCommentRoom.ID uid:[User shareInstance].userId touid:self.currentCommentRoom.userid content:@"" commentLever:1 userstatus:0 yeyxstar:0 jzwmstar:0 rxttstar:0 ownertatus:3 success:^(BOOL flag, NSString *msg) {
//                if (flag) {
//                    [SVProgressHUD showSuccessWithStatus:@"评论成功"];
//                    [alertView dismissWithClickedButtonIndex:0 animated:YES];
//                }
//                //更新表单
//                [self refreshTable];
//            } failure:^(NSError *error) {
//                
//            }];
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            
        }
        if (buttonIndex == 0) {
            //取消
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}

@end
