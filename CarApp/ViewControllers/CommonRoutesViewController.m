//
//  CommonRoutesViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-6.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CommonRoutesViewController.h"
#import "PullingRefreshTableView.h"
#import "MapViewController.h"

@interface CommonRoutesViewController ()<PullingRefreshTableViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (retain, nonatomic) PullingRefreshTableView *tableView;
@property (retain, nonatomic) WarnView *warnView;
@property (retain, nonatomic) NSMutableArray *tableData;

@end

@implementation CommonRoutesViewController

-(void)dealloc
{
    [SafetyRelease release:_tableView];
    [SafetyRelease release:_warnView];
    [SafetyRelease release:_tableData];
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _routepage = 1;
    _routeCanLoadMore = YES;
    self.tableData = [[[NSMutableArray alloc]init]autorelease];
    
    UIView * mainView = [[UIView alloc]initWithFrame:[AppUtility mainViewFrame]];
    [mainView setBackgroundColor:[UIColor appBackgroundColor]];
    [mainView setTag:10000];
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
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 27, 200, 30)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:self.myInfo.name];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor appNavTitleColor]];
    [titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [navBar addSubview:titleLabel];
    [titleLabel release];
    
    UIImage * welcomeImage = [UIImage imageNamed:@"nav_hint@2x"];
    //    welcomeImage = [welcomeImage stretchableImageWithLeftCapWidth:8 topCapHeight:10];
    //导航栏下方的欢迎条
    UIImageView * welcomeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 49)];
    [welcomeImgView setImage:welcomeImage];
    [mainView addSubview:welcomeImgView];
    [welcomeImgView release];
    
    UILabel * welcomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 310, 44)];
    [welcomeLabel setBackgroundColor:[UIColor clearColor]];
    [welcomeLabel setText:@"常用路线"];
    [welcomeLabel setTextAlignment:NSTextAlignmentLeft];
    [welcomeLabel setTextColor:[UIColor whiteColor]];
    [welcomeLabel setFont:[UIFont appGreenWarnFont]];
    [welcomeImgView addSubview:welcomeLabel];
    [welcomeLabel release];
    
    
    
    self.tableView = [[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 64+44, 320, SCREEN_HEIGHT - 64 - 50) pullingDelegate:self]autorelease];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setShowsHorizontalScrollIndicator:NO];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setEditing:NO animated:NO];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 2)];
    [self.tableView setTableFooterView:footerView];
    [mainView insertSubview:self.tableView belowSubview:welcomeImgView];
    
    self.warnView = [WarnView initWarnViewWithText:@"非常抱歉,暂无数据..." withView:_tableView height:120 withDelegate:nil];
    
    [self performSelector:@selector(requestTableDataFromServer:) withObject:[NSNumber numberWithInt:0] afterDelay:0.1];
}

//数据交互
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
            
        }];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"_commonRoutsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [cell setBackgroundColor:[UIColor whiteColor]];
    Line *line = (Line *)[self.tableData objectAtIndex:indexPath.row];
    
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [cell.textLabel setTextColor:[UIColor appBlackColor]];
    [cell.textLabel setText:line.name];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setClipsToBounds:NO];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //表单动画
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Line *line = (Line *)[self.tableData objectAtIndex:indexPath.row];
    //进入地图模式
    MapViewController *mapVC =  [[MapViewController alloc]init];
    mapVC.line = line;
    mapVC.mode = kMapViewModeLine;
    [mapVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.navigationController pushViewController:mapVC animated:YES];
    [mapVC release];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    //对tableModel进行判断
    _routepage = 1;
    [self requestTableDataFromServer:kRequestModeRefresh];
}

- (void) loadMoreDataToTable
{
    //对tableModel进行判断
    if (_routeCanLoadMore) {
        _routepage ++;
        [self requestTableDataFromServer:kRequestModeLoadmore];
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

-(void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
