//
//  EditfavLineViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-15.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "EditfavLineViewController.h"
#import "CommonRoutCell.h"

@interface EditfavLineViewController ()<PullingRefreshTableViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (retain, nonatomic) PullingRefreshTableView *tableView;
@property (retain, nonatomic) WarnView *warnView;
@property (retain, nonatomic) NSMutableArray *tableData;

@end

@implementation EditfavLineViewController

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
    
    [self setTitle:@"常用路线"];
    [self setMessageText:@"可增加删除常用路线"];
    
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, KOFFSETY, SCREEN_WIDTH, SCREEN_HEIGHT - KOFFSETY) pullingDelegate:self];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setShowsHorizontalScrollIndicator:NO];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.tableView];

    UIButton *addCommonLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addCommonLineBtn setBackgroundImage:[UIImage imageNamed:@"add_line"] forState:UIControlStateNormal];
    [addCommonLineBtn setFrame:CGRectMake(0, 0, 300, 40)];
    [addCommonLineBtn addTarget:self action:@selector(addCommonLineBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView setTableFooterView:addCommonLineBtn];
    
    self.warnView = [WarnView initWarnViewWithText:@"非常抱歉,暂无数据..." withView:_tableView height:120 withDelegate:nil];
    
}
/*
-(void)requestTableDataFromServer:(kRequestMode)mode
{
    User *user = [User shareInstance];
    [NetWorkManager networkGetUserfavlineListWithUid:user.userId page:_routepage rows:20 success:^(BOOL flag, BOOL hasnextpage, NSArray *favArray, NSString *msg) {
        if (mode==kRequestModeRefresh) {
            [self.tableData removeAllObjects];
        }
        if (flag) {
            _routeCanLoadMore = hasnextpage;
            NSArray *array = [Line arrayWithArrayDic:favArray];
            [self.tableData addObjectsFromArray:array];
            if ([self.tableData count]>0) {
                [self.warnView dismiss];
            }
            else
            {
                [self.warnView show:kenumWarnViewTypeNullData];
            }
            
            [self.tableView reloadData];
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
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"_CommonRoutCell";
    
    CommonRoutCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CommonRoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    Line *line = (Line *)[self.tableData objectAtIndex:indexPath.row];
//    cell.mainVC = self.mainVC;
    [cell setData:line];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //表单动画
    /*
     if (indexPath.row == 0 || indexPath.row == [tableView numberOfRowsInSection:0]-1) {
     return;
     }
     // 1. 配置CATransform3D的内容
     CATransform3D transform;
     //    transform = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
     if (self.tableView.direction==kScrollerDirectionUp) {
     transform = CATransform3DMakeTranslation(0, cell.frame.size.height/5, 0);
     }
     else
     transform = CATransform3DMakeTranslation(0, -cell.frame.size.height/5, 0);
     transform.m34 = 1.0/ -600;
     
     // 2. 定义cell的初始状态
     cell.layer.shadowColor = [[UIColor blackColor]CGColor];
     cell.layer.shadowOffset = CGSizeMake(10, 10);
     cell.alpha = 0;
     
     cell.layer.transform = transform;
     cell.layer.anchorPoint = CGPointMake(0, 0.5);
     
     // 3. 定义cell的最终状态，并提交动画
     [UIView beginAnimations:@"transform" context:NULL];
     [UIView setAnimationDuration:0.5];
     cell.layer.transform = CATransform3DIdentity;
     cell.alpha = 1;
     cell.layer.shadowOffset = CGSizeMake(0, 0);
     cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
     [UIView commitAnimations];
     */
}

- (void)addCommonLineBtn:(UIButton *)sender
{
    //进入添加常用路线
//    if (self.mainVC) {
//        PassengerRouteUIViewController * pVC = [[PassengerRouteUIViewController alloc]init];
//        pVC.state = 2;
//        [self.mainVC.navigationController pushViewController:pVC animated:YES];
//        [pVC release];
//    }
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    //对tableModel进行判断
    _routepage = 1;
//    [self requestTableDataFromServer:kRequestModeRefresh];
}

- (void) loadMoreDataToTable
{
    //对tableModel进行判断
    if (_routeCanLoadMore) {
        _routepage ++;
//        [self requestTableDataFromServer:kRequestModeLoadmore];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
