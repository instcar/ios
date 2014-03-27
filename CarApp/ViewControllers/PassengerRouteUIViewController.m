//
//  GetRouteViewController.m
//  CarApp
//
//  Created by Leno on 13-9-12.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "PassengerRouteUIViewController.h"

#import "JSONKit.h"

#import "AutoLoadingRecogsizeCell.h"
#import "DriverRouteCell.h"
#import "PassgerEditRouteViewController.h"
#import "SearchResultViewController.h"
#import "HZscrollerView.h"
#import "BDVoiceRecognitionClient.h"
#import "CustomSearchBarControl.h"

#define kLinePerPageNum 10
#define kjudianPerPageNum 1000
#define KResultsTableTag 10000
#define kBannerScrollViewTag 10001

@interface PassengerRouteUIViewController ()<HZscrollerViewDelegate,CustomSearchBarControlDelegate>

@property (retain, nonatomic) NSMutableArray *lineArray;
@property (retain, nonatomic) NSMutableArray *judianArray;
@property (copy, nonatomic) NSString *searchConditionStr;
@property (assign, nonatomic) int selectJudianId;
@property (retain, nonatomic) WarnView *warnView;

@end

@implementation PassengerRouteUIViewController

-(void)dealloc
{
    [InstantCarRelease safeRelease:_lineArray];
    [InstantCarRelease safeRelease:_judianArray];
    [InstantCarRelease safeRelease:_warnView];
    [InstantCarRelease safeRelease:_searchConditionStr];
    
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentMode = kEnumRouteModeLineListByTag;
    _tablerefreshing = NO;
    _canTableLoadMore = YES;
    _tablePage = 1;
    _searchConditionStr = @"";
    if (kDeviceVersion >= 7.0) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
    self.lineArray = [[[NSMutableArray alloc]init]autorelease];
    self.judianArray = [[[NSMutableArray alloc]init]autorelease];
    
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
    
    UIButton * backButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 20, 70, 44)];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_normal@2x"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed@2x"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backButton];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 27, 120, 30)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"选择出发路线"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor appNavTitleColor]];
    [titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [navBar addSubview:titleLabel];
    [titleLabel release];
    
    _tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 64+45+52, 320, SCREEN_HEIGHT -64-45-52) pullingDelegate:self];
    [_tableView setTag:KResultsTableTag];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 2)];
    [_tableView setTableFooterView:footerView];
    [footerView release];
//    [_tableView setBackgroundView:Nil];
    [mainView insertSubview:_tableView belowSubview:navBar];
    [_tableView release];
    
    CustomSearchBarControl *customSearchBarControl = [[CustomSearchBarControl alloc]initWithFrame:CGRectMake(0, 64+45, 320, 52) withStyle:kSearchBarStyleBlue];
    [customSearchBarControl setDelegate:self];
    [mainView insertSubview:customSearchBarControl belowSubview:navBar];
    
    UIImage * bannerImage = [UIImage imageNamed:@"nav_hint@2x"];
    bannerImage = [bannerImage stretchableImageWithLeftCapWidth:8 topCapHeight:10];
    //导航栏下方的显示周边的Banner条
    UIImageView * bannerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 49)];
    bannerImageView.userInteractionEnabled = YES;
    [bannerImageView setImage:bannerImage];
    [mainView addSubview:bannerImageView];
    [bannerImageView release];

    //据点滚动视图
    _hzScrollerView = [[HZscrollerView alloc]initWithFrame:CGRectMake(0, 0, 320, 45) withType:2];
    _hzScrollerView.delegate = self;
    _hzScrollerView.data = self.judianArray;
    [bannerImageView addSubview:_hzScrollerView];
    [_hzScrollerView release];
    
    //    //添加对键盘高度的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    //加载数据
    [self loadDataMode:kEnumRouteModeLineListByTag tag:@"" judianID:0 mode:kRequestModeRefresh];
    [self loadDataMode:kEnumRouteModeJudianListByCoorder tag:nil judianID:0 mode:kRequestModeRefresh];
    
    self.warnView = [WarnView initWarnViewWithText:@"非常抱歉,暂无数据..." withView:_tableView height:100 withDelegate:nil];
}


- (void)keyboardWasChange:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGRect kbFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    _keyBoardOriginY = kbFrame.origin.y;
}

-(void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 数据交互
//type 为 请求类型 mode为 请求方式 mode tag/judianID参数
-(void)loadDataMode:(kEnumRouteMode)mode tag:(NSString *)tag judianID:(int)judian mode:(kRequestMode)requestMode{
    
    if(mode == kEnumRouteModeLineListByTag)
    {
        //标签搜索
        [NetWorkManager networkGetLineListByTag:tag page:_tablePage rows:kLinePerPageNum success:^(BOOL flag, BOOL hasnextpage, NSArray *lineArray, NSString *msg) {
            if (flag) {
                if (requestMode == kRequestModeRefresh) {
                    [self.lineArray removeAllObjects];
                }
                _currentMode = kEnumRouteModeLineListByTag;
                _canTableLoadMore = hasnextpage;
                for(int i = 0; i < [lineArray count]; i++)
                {
                    [self.lineArray addObject:[lineArray objectAtIndex:i]];
                }
                [_tableView tableViewDidFinishedLoading];
                [_tableView setReachedTheEnd:hasnextpage==YES?NO:YES];

                [_tableView reloadData];

            }
            else
            {
                [UIAlertView showAlertViewWithTitle:@"失败" message:msg cancelTitle:@"确定"];
            }
            if ([self.lineArray count]>0) {
                [self.warnView dismiss];
            }
            else
            {
                [self.warnView show:kenumWarnViewTypeNullData];
            }
        } failure:^(NSError *error) {
            [_tableView tableViewDidFinishedLoading];
            [_tableView reloadData];

        }];
    }
    
    if (mode == kEnumRouteModeLineListByJudianID) {
        
        //据点搜索
        [NetWorkManager networkGetLineListByJudianId:judian page:_tablePage rows:kLinePerPageNum success:^(BOOL flag, BOOL hasnextpage, NSArray *lineArray, NSString *msg) {
            if (flag) {
                
                if (requestMode == kRequestModeRefresh) {
                    [self.lineArray removeAllObjects];
                }
                
                _currentMode = kEnumRouteModeLineListByJudianID;
                _canTableLoadMore = hasnextpage;
                for(int i = 0; i < [lineArray count]; i++)
                {
                    [self.lineArray addObject:[lineArray objectAtIndex:i]];
                }
                [_tableView tableViewDidFinishedLoading];
                [_tableView setReachedTheEnd:!hasnextpage];
//                [_tableView setHeaderOnly:!hasnextpage];
                [_tableView reloadData];
            }
            else
            {
                [UIAlertView showAlertViewWithTitle:@"失败" message:msg cancelTitle:@"确定"];
            }
            if ([self.lineArray count]>0) {
                [self.warnView dismiss];
            }
            else
            {
                [self.warnView show:kenumWarnViewTypeNullData];
            }
        } failure:^(NSError *error) {
            [_tableView tableViewDidFinishedLoading];
            [_tableView reloadData];
        }];
    }
    
    if (mode == kEnumRouteModeJudianListByCoorder) {
        
        //用户数据
        User *user = [User shareInstance];
        //我的据点
        [NetWorkManager networkGetJuDianListPage:1 rows:kjudianPerPageNum lng:user.lon lat:user.lat success:^(BOOL flag, BOOL hasnextpage, NSArray *judianArray, NSString *msg) {
            if (flag) {
                if (requestMode == kRequestModeRefresh) {
                    [self.judianArray removeAllObjects];
                }
                
                for(int i = 0; i < [judianArray count]; i++)
                {
                    [self.judianArray addObject:[judianArray objectAtIndex:i]];
                }
                _hzScrollerView.data = self.judianArray;
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}


#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    
    /*
     
     Code to actually refresh goes here.
     
     */
    //对tableModel进行判断
    _tablePage = 1;
    
    if (_currentMode == kEnumRouteModeLineListByTag) {
        [self loadDataMode:kEnumRouteModeLineListByTag tag:self.searchConditionStr judianID:0 mode:kRequestModeRefresh];
    }
    if (_currentMode == kEnumRouteModeLineListByJudianID) {
        [self loadDataMode:kEnumRouteModeLineListByJudianID tag:nil judianID:self.selectJudianId mode:kRequestModeRefresh];
    }
}

- (void) loadMoreDataToTable
{
    
    /*
     
     Code to actually load more data goes here.
     
     */
    //对tableModel进行判断
    if (_canTableLoadMore) {
        _tablePage ++;
        if (_currentMode == kEnumRouteModeLineListByTag) {
            [self loadDataMode:kEnumRouteModeLineListByTag tag:self.searchConditionStr judianID:0 mode:kRequestModeLoadmore];
        }
        if (_currentMode == kEnumRouteModeLineListByJudianID) {
            [self loadDataMode:kEnumRouteModeLineListByJudianID tag:nil judianID:self.selectJudianId mode:kRequestModeLoadmore];
        }
    }
    else
    {
        
    }
}

#pragma mark - CustomSearchBarDelegate
-(void)customSearchBarControl:(CustomSearchBarControl *)customSearchBarControl result:(NSString *)result
{
    //搜索
    _tablePage = 1;
    self.searchConditionStr = result;
    [self loadDataMode:kEnumRouteModeLineListByTag tag:result judianID:0 mode:kRequestModeRefresh];
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.f];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.f];
}

#pragma mark - tableViewDelegate/tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lineArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ResultsTable";
    DriverRouteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[DriverRouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    if (kDeviceVersion >= 7.0) {
       [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    Line *line = [self.lineArray objectAtIndex:indexPath.row];
    
    [cell.roundImgView setHidden:NO];
    [cell.numberLabel setHidden:NO];
    [cell.routeLabel setHidden:NO];
    [cell.addressLabel setHidden:NO];
    [cell.numberLabel setText:[NSString stringWithFormat:@"%d",indexPath.row +1]];
    
    [cell.routeLabel setText:line.name];
    [cell.addressLabel setTextColor:[UIColor colorWithRed:(float)21/255 green:(float)191/255 blue:(float)211/255 alpha:1]];
    [cell.addressLabel setText:[NSString stringWithFormat:@"上车地址:%@",line.startaddr]];

    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.accessoryView setBackgroundColor:[UIColor whiteColor]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Line *line = (Line *)[self.lineArray objectAtIndex:indexPath.row];
    if (self.state == 1) {
        PassgerEditRouteViewController * editRouteVC = [[PassgerEditRouteViewController alloc]init];
        editRouteVC.line = [self.lineArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:editRouteVC animated:YES];
        [editRouteVC release];
    }
    if (self.state == 2) {
        [NetWorkManager networkAddUserfavlineWithUid:[[User shareInstance] userId] lineID:line.ID success:^(BOOL flag, NSString *msg) {
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            
        }];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //表单动画
    /*
    // 1. 配置CATransform3D的内容
    CATransform3D transform;
    transform = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //键盘事件
    if (_keyBoardOriginY < SCREEN_HEIGHT) {
        UITextField * txf = (UITextField *)[self.view viewWithTag:8080];
        [txf resignFirstResponder];
    }
}

#pragma mark - hzscrollerView
- (void)HZScrollerView:(HZscrollerView *)hzscrollerView select:(int)index
{
    UITextField * txf = (UITextField *)[self.view viewWithTag:8080];
    [txf setText:@""];
    [txf resignFirstResponder];
    self.searchConditionStr = @"";
    
    if (index == 0) {
        _tablePage = 1;
        [self loadDataMode:kEnumRouteModeLineListByTag tag:@"" judianID:0 mode:kRequestModeRefresh];
    }
    else
    {
        //视图选择
        Judian *judian = [self.judianArray objectAtIndex:index-1];
        
        _tablePage = 1;
        self.selectJudianId = judian.ID;
        [self loadDataMode:kEnumRouteModeLineListByJudianID tag:nil judianID:judian.ID mode:kRequestModeRefresh];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
