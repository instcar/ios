//
//  GetRouteViewController.m
//  CarApp
//
//  Created by Leno on 13-9-12.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "GetRouteViewController.h"
#import "JSONKit.h"

#import "AutoLoadingRecogsizeCell.h"
#import "DriverRouteCell.h"
#import "EditRouteViewController.h"
#import "SearchResultViewController.h"
#import "HZscrollerView.h"
#import "CustomSearchBarControl.h"
#import "Line.h"
#import "Judian.h"

#import "RouteAnnotation.h"
#import "UIImage+InternalMethod.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface GetRouteViewController ()<HZscrollerViewDelegate,CustomSearchBarControlDelegate,CusLocateInputViewDelegate,BMKUserLocationDelegate>

@property (retain, nonatomic) NSMutableArray *lineArray;
@property (retain, nonatomic) NSMutableArray *judianArray;
@property (copy, nonatomic) NSString *searchConditionStr;
@property (assign, nonatomic) int selectJudianId;
@property (retain, nonatomic) WarnView *warnView;

@end

@implementation GetRouteViewController

-(void)dealloc
{
    
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
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _search.delegate = self;
    _bmklocation.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _search.delegate = nil;
    _bmklocation.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentMode = kEnumRouteModeLineListByTag;
    _tablerefreshing = NO;
    _canTableLoadMore = YES;
    _tablePage = 1;
    _searchConditionStr = @"";
    _locate = YES;
    
    [self setTitle:@"我有车"];
    
    _lineArray = [[NSMutableArray alloc]init];
    _judianArray = [[NSMutableArray alloc]init];
    
    
    //Table顶部
    //    CustomSearchBarControl *customSearchBarControl = [[CustomSearchBarControl alloc]initWithFrame:CGRectMake(0, 64+45, 320, 52) withStyle:kSearchBarStyleGreen];
    //    [customSearchBarControl setDelegate:self];
    //    [mainView insertSubview:customSearchBarControl belowSubview:navBar];
    
    //起点输入框
    _cusLocateInputView = [[CusLocateInputView alloc]initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, 45)];
    [_cusLocateInputView setDelegate:self];
    [self setMessageView:_cusLocateInputView];
    
    _cusVoiceInputView = [[CusVoiceInputView alloc]initWithFrame:CGRectMake(0, 45, APPLICATION_WIDTH, 160)];
    [self.view insertSubview:_cusVoiceInputView aboveSubview:_messageBgView];
    
    _tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 45, 320, APPLICATION_HEGHT -44-45) pullingDelegate:self];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setHidden:YES];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 2)];
    [_tableView setTableFooterView:footerView];
    [self.view insertSubview:_tableView belowSubview:_messageBgView];

    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 45, 320, APPLICATION_HEGHT - 44- 45)];
    [_mapView setOverlooking:0];
    [_mapView setDelegate:self];
    [_mapView setShowsUserLocation:YES];
//    [_mapView setUserTrackingMode:BMKUserTrackingModeFollow];
    //    [_mapView setShowsUserLocation:YES];
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc]init];
    param.isAccuracyCircleShow = NO;
    param.isRotateAngleValid = YES;
    param.locationViewImgName = @"bnavi_icon_location_fixed";
    [_mapView updateLocationViewWithParam:param];
    [self.view insertSubview:_mapView belowSubview:_cusVoiceInputView];
    
    _search = [[BMKSearch alloc]init];
    [_search setDelegate:self];
    
    _bmklocation = [[BMKUserLocation alloc]init];
    [_bmklocation setDelegate:self];
    
//    //添加对键盘高度的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    /*
    //加载数据
    [self loadDataMode:kEnumRouteModeLineListByTag tag:nil judianID:0 mode:kRequestModeRefresh];
    [self loadDataMode:kEnumRouteModeJudianListByCoorder tag:nil judianID:0 mode:kRequestModeRefresh];
    */
    
    self.warnView = [WarnView initWarnViewWithText:@"非常抱歉,暂无数据..." withView:_tableView height:100 withDelegate:nil];
    
}

//刷新定位信息
- (void)upDateLocateAction
{
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:BMKCoordinateRegionMake(_mapView.userLocation.coordinate, BMKCoordinateSpanMake(0.02, 0.02))];
    [_mapView setRegion:adjustedRegion animated:YES];
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
#pragma mark - CusLocateInputViewDelegate
-(void)locateBtnAction:(UIButton *)sender
{
    DLog(@"定位信息");
    [_bmklocation startUserLocationService];
}

-(void)inputModeChange:(int)type
{
    DLog(@"输入模式切换");
    if (type == 1) {
        CGRect frame = _messageBgView.frame;
        frame.size.height = 49;
        [_messageBgView setFrame:frame];
    }
    if (type == 2) {
        CGRect frame = _messageBgView.frame;
        frame.size.height = 69;
        [_messageBgView setFrame:frame];
    }
}

#pragma mark - BMKUserLocationDelegate
- (void)viewDidGetLocatingUser:(CLLocationCoordinate2D)userLoc
{
    //定位回归终点
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:BMKCoordinateRegionMake(userLoc, BMKCoordinateSpanMake(0.02, 0.02))];
    [_mapView setRegion:adjustedRegion animated:YES];
    [_bmklocation stopUserLocationService];
    
    //定位点解析
    BOOL flag = [_search reverseGeocode:userLoc];
	if (flag) {
		DLog(@"ReverseGeocode search success.");
	}
    else{
        DLog(@"ReverseGeocode search failed!");
    }

}

#pragma mark - baidu地图Delegate
- (NSString*)getMyBundlePath1:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil ;
}

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [_mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
}

-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    if (_locate) {
        _locate = !_locate;
       BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:BMKCoordinateRegionMake(userLocation.coordinate, BMKCoordinateSpanMake(0.02, 0.02))];
       [mapView setRegion:adjustedRegion animated:YES];
    //       self.locateSuccess = YES;
    //       self.location = userLocation.location.coordinate;
    //       self.locateState = NO;
    //       [self.search reverseGeocode:self.mapView.userLocation.location.coordinate];
    //   [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:NO];
    }
}

-(void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
}

-(void)mapStatusDidChanged:(BMKMapView *)mapView
{
//    [_mapView setUserTrackingMode:BMKUserTrackingModeFollow];
}

//编码问题
- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0)
    {
        DLog(@"%@%@%@%@%@",result.addressComponent.province,result.addressComponent.city,result.addressComponent.district,result.addressComponent.streetName,result.addressComponent.streetNumber);
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = result.geoPt;
		item.title = result.strAddr;
        //刷新数据
        [_cusLocateInputView setLocateAddress:result.strAddr];
        [_mapView addAnnotation:item];
	}
}

- (void)onGetDrivingRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
    if (result != nil) {
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array];
        
        // error 值的意义请参考BMKErrorCode
        if (error == BMKErrorOk) {
            BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
            
            // 添加起点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = result.startNode.pt;
            item.title = @"起点";
            item.type = 0;
            [_mapView addAnnotation:item];
            
            // 下面开始计算路线，并添加驾车提示点
            int index = 0;
            int size = [plan.routes count];
            for (int i = 0; i < 1; i++) {
                BMKRoute* route = [plan.routes objectAtIndex:i];
                for (int j = 0; j < route.pointsCount; j++) {
                    int len = [route getPointsNum:j];
                    index += len;
                }
            }
            
            BMKMapPoint* points = new BMKMapPoint[index];
            index = 0;
            for (int i = 0; i < 1; i++) {
                BMKRoute* route = [plan.routes objectAtIndex:i];
                for (int j = 0; j < route.pointsCount; j++) {
                    int len = [route getPointsNum:j];
                    BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
                    memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
                    index += len;
                }
                size = route.steps.count;
                for (int j = 0; j < size; j++) {
                    // 添加驾车关键点
                    BMKStep* step = [route.steps objectAtIndex:j];
                    item = [[RouteAnnotation alloc]init];
                    item.coordinate = step.pt;
                    item.title = step.content;
                    item.degree = step.degree * 30;
                    item.type = 4;
                    [_mapView addAnnotation:item];
                }
                
            }
            
            // 添加终点
            item = [[RouteAnnotation alloc]init];
            item.coordinate = result.endNode.pt;
            item.type = 1;
            item.title = @"终点";
            [_mapView addAnnotation:item];
            
            // 添加途经点
            if (result.wayNodes) {
                for (BMKPlanNode* tempNode in result.wayNodes) {
                    item = [[RouteAnnotation alloc]init];
                    item.coordinate = tempNode.pt;
                    item.type = 5;
                    item.title = tempNode.name;
                    [_mapView addAnnotation:item];
                }
            }
            
            // 根究计算的点，构造并添加路线覆盖物
            BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
            [_mapView addOverlay:polyLine];
            delete []points;
            
            [_mapView setCenterCoordinate:result.startNode.pt animated:YES];
        }
    }
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation *)routeAnnotation
{
	BMKAnnotationView* view = nil;
    
    //线路
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKPinAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                //                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.image = [UIImage imageNamed:@"tag_map@2x"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
                [((BMKPinAnnotationView *)view)setAnimatesDrop:YES];
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKPinAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                //                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.image = [UIImage imageNamed:@"bg_locate_normal@2x"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
                [((BMKPinAnnotationView *)view)setAnimatesDrop:YES];
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            //            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            //            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            //            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            //            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
	return view;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapview viewForAnnotation:(id <BMKAnnotation>)annotation
{
    BMKPinAnnotationView* view = nil;
    //起点
//    if (self.mode == kMapViewModeAddress) {
        if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
            
            view = (BMKPinAnnotationView *)[mapview dequeueReusableAnnotationViewWithIdentifier:@"start_nodeAddress"];
            if (view == nil) {
                view = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"start_nodeAddress"];
                view.image = [UIImage imageNamed:@"tag_map@2x"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
                [view setAnimatesDrop:YES];
            }
            view.annotation = annotation;
            BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:BMKCoordinateRegionMake(annotation.coordinate, BMKCoordinateSpanMake(0.007, 0.007))];
            [_mapView setRegion:adjustedRegion animated:YES];
            [_mapView setCenterCoordinate:annotation.coordinate animated:NO];
            return view;
        }
//    }
//    if (self.mode == kMapViewModeLine) {
//        
//        if ([annotation isKindOfClass:[RouteAnnotation class]]) {
//            return [self getRouteAnnotationView:mapview viewForAnnotation:(RouteAnnotation*)annotation];
//        }
//    }
	return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor flatBlueColor] colorWithAlphaComponent:1.0];
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
	return nil;
}

- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
{
    BOOL flag = [_search reverseGeocode:coordinate];
	if (flag) {
		DLog(@"ReverseGeocode search success.");
	}
    else{
        DLog(@"ReverseGeocode search failed!");
    }
}

#pragma mark - 数据交互
/*
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
            [_tableView setReachedTheEnd:!hasnextpage];
//            [_tableView setHeaderOnly:!hasnextpage];
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

}*/

#pragma mark - CustomSearchBarDelegate
-(void)customSearchBarControl:(CustomSearchBarControl *)customSearchBarControl result:(NSString *)result
{
    //搜索
    _tablePage = 1;
    self.searchConditionStr = result;
    
//    [self loadDataMode:kEnumRouteModeLineListByTag tag:result judianID:0 mode:kRequestModeRefresh];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    //对tableModel进行判断
    _tablePage = 1;
    
    if (_currentMode == kEnumRouteModeLineListByTag) {
//        [self loadDataMode:kEnumRouteModeLineListByTag tag:self.searchConditionStr judianID:0 mode:kRequestModeRefresh];
    }
    if (_currentMode == kEnumRouteModeLineListByJudianID) {
//        [self loadDataMode:kEnumRouteModeLineListByJudianID tag:nil judianID:self.selectJudianId mode:kRequestModeRefresh];
    }
}

- (void) loadMoreDataToTable
{
    //对tableModel进行判断
    if (_canTableLoadMore) {
        _tablePage ++;
        if (_currentMode == kEnumRouteModeLineListByTag) {
//            [self loadDataMode:kEnumRouteModeLineListByTag tag:self.searchConditionStr judianID:0 mode:kRequestModeLoadmore];
        }
        if (_currentMode == kEnumRouteModeLineListByJudianID) {
//            [self loadDataMode:kEnumRouteModeLineListByJudianID tag:nil judianID:self.selectJudianId mode:kRequestModeLoadmore];
        }
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


- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    return [NSDate date];
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
            cell = [[DriverRouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        if(kDeviceVersion >= 7.0)
        {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
         Line *line = [self.lineArray objectAtIndex:indexPath.row];
         
        [cell.roundImgView setHidden:NO];
        [cell.numberLabel setHidden:NO];
        [cell.routeLabel setHidden:NO];
        [cell.addressLabel setHidden:NO];
    
        [cell.numberLabel setText:[NSString stringWithFormat:@"%d",indexPath.row +1]];
        
        [cell.routeLabel setText:line.name];
        [cell.addressLabel setText:[NSString stringWithFormat:@"接客地址:%@",line.startaddr]];
    
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.accessoryView setBackgroundColor:[UIColor whiteColor]];
         return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EditRouteViewController * editRouteVC = [[EditRouteViewController alloc]init];
    editRouteVC.line = [self.lineArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:editRouteVC animated:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
