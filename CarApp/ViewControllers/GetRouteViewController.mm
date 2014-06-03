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
#import "LinePoint.h"
#import "Judian.h"
#import "CustomActionAnnotation.h"
#import "RouteAnnotation.h"
#import "UIImage+InternalMethod.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]
#define CLCOORDINATE_EPSILON 0.005f
#define CLCOORDINATES_EQUAL2( coord1, coord2 ) (fabs(coord1.latitude - coord2.latitude) < CLCOORDINATE_EPSILON && fabs(coord1.longitude - coord2.longitude) < CLCOORDINATE_EPSILON)
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
    [self updateMapviewVisibleRegion];
    if(_cusLocateInputView)
    {
        [_cusLocateInputView startLocate];
    }
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
    _drivingRoteRecord = [[NSMutableArray alloc] initWithCapacity:0];
    _currentMode = kEnumRouteModeLineListByTag;
    _tablerefreshing = NO;
    _canTableLoadMore = YES;
    _tablePage = 1;
    _searchConditionStr = @"";
    _locate = YES;
    _isLongClick = NO;
    _lineArray = [[NSMutableArray alloc]init];
    _judianArray = [[NSMutableArray alloc]init];
    
    [self setTitle:@"我有车"];
    //保存按钮
    UIButton * configButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [configButton setFrame:CGRectMake(0, 0, 40, 30)];
    [configButton setBackgroundImage:[UIImage imageNamed:@"btn_confirm_empty@2x.png"] forState:UIControlStateDisabled];
    [configButton setBackgroundImage:[UIImage imageNamed:@"btn_confirm_normal@2x.png"] forState:UIControlStateNormal];
    [configButton setBackgroundImage:[UIImage imageNamed:@"btn_confirm_pressed@2x.png"] forState:UIControlStateHighlighted];
    [configButton addTarget:self action:@selector(confirmBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self setRightBtn:configButton];
    [self.rightBtn setEnabled:NO];
    //Table顶部
    //    CustomSearchBarControl *customSearchBarControl = [[CustomSearchBarControl alloc]initWithFrame:CGRectMake(0, 64+45, 320, 52) withStyle:kSearchBarStyleGreen];
    //    [customSearchBarControl setDelegate:self];
    //    [mainView insertSubview:customSearchBarControl belowSubview:navBar];
    
    //起点输入框
    _cusLocateInputView = [[CusLocateInputView alloc]initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, 45)];
    [_cusLocateInputView.startLable  setText:@"起点:"];
    [_cusLocateInputView.startInputView setReturnKeyType:UIReturnKeyNext];
    [_cusLocateInputView setDelegate:self];
    [self setMessageView:_cusLocateInputView];
    /*
     * 终点输入框
     * UI设计更改，添加控件 by Liang Zhao
     */
    _cusDestinationInputView = [[CusLocateInputView alloc]initWithFrame:CGRectMake(0, self.messageView.frame.origin.y+self.messageView.frame.size.height, APPLICATION_WIDTH, 45)];
    [_cusDestinationInputView setDelegate:self];

    [_cusDestinationInputView.startLable  setText:@"终点:"];
    [_cusDestinationInputView.startLable setTextColor:[UIColor blackColor]];
    [_cusDestinationInputView.startInputView setReturnKeyType:UIReturnKeySearch];
    [_cusDestinationInputView.startInputView setTextColor:[UIColor blackColor]];
    [self.view insertSubview:_cusDestinationInputView belowSubview:_messageBgView];
    
    /*
     * UI设计更改，取消控件 by Liang Zhao
     */
    /*
    _cusVoiceInputView = [[CusVoiceInputView alloc]initWithFrame:CGRectMake(0, 45, APPLICATION_WIDTH, 160)];
    [self.view insertSubview:_cusVoiceInputView aboveSubview:_messageBgView];
    
    _tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 45, 320, APPLICATION_HEGHT -44-45) pullingDelegate:self];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setHidden:YES];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 2)];
    [_tableView setTableFooterView:footerView];
    [self.view insertSubview:_tableView belowSubview:_messageBgView];*/
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, _cusDestinationInputView.frame.origin.y+_cusDestinationInputView.frame.size.height, 320, APPLICATION_HEGHT - 44-_cusDestinationInputView.frame.origin.y-_cusDestinationInputView.frame.size.height)];
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
    [self.view addSubview:_mapView];
    
    [self customMapView];
    
    /*
     *
     * UI设计更改，添加控件 by Liang Zhao
     */
    _tipView = [[CustomLineTipView alloc] initWithFrame:_mapView.frame];
    _tipView.delegate = self;
    [self.view addSubview:_tipView];
 
    
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
- (void)showSearchRecord
{
    //删除路线缓存
    [_drivingRoteRecord removeAllObjects];
    //删除所有注释
    [self deleteAnnotations];
    //删除所有路线
    [self deleteOverlays];
       //子线程调用接口
    [self getSomeLine];
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
-(void)confirmBtnPressed
{
    EditRouteViewController * editRouteVC = [[EditRouteViewController alloc]init];
    editRouteVC.line = [_lineArray objectAtIndex:_selectedIndex];
    [self.navigationController pushViewController:editRouteVC animated:YES];
 
}
#pragma mark - Reponse 
- (void) getAllJudian
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [APIClient networkGetPointListWithPage:1 rows:10 success:^(Respone *respone) {
            if (respone.status == kEnumServerStateSuccess)
            {
                _judianArray = [Judian arrayWithArrayDic:[respone.data valueForKey:@"list"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    for(Judian *jd in _judianArray)
                    {
                        RouteAnnotation* item = [[RouteAnnotation alloc]init];
                        item.coordinate = CLLocationCoordinate2DMake(jd.lat, jd.lng);
                        item.type = 7;
                        item.title = jd.name;
                        [_mapView addAnnotation:item];
                    }
                    [self updateMapviewVisibleRegion];
                });
                
            }
        } failure:^(NSError *error) {
        }];
    });
}
- (void) getSomeLine
{
    __block typeof(self) bSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [APIClient networkGetLineListByTag:_cusDestinationInputView.startInputView.text page:1 rows:10 all:1 success:^(Respone *respone) {
            if (respone.status == kEnumServerStateSuccess)
            {
                _lineArray = [Line arrayWithArrayDic:[respone.data valueForKey:@"list"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    if (!_lineTableView)
                    {
                        _lineTableView = [[CustomLineTableView alloc] initWithFrame:CGRectMake(0, _cusDestinationInputView.frame.origin.y+_cusDestinationInputView.frame.size.height, APPLICATION_WIDTH, 152)];
                        _lineTableView.delegate = self;
                        [bSelf.view addSubview:_lineTableView];
                    }
                    _lineTableView.record = _lineArray;
                    int i=0;
                    for(Line *line in _lineArray)
                    {
                        LinePoint *startPt = [line.list objectAtIndex:0];
                        Judian *startJD = startPt.geo;
                        LinePoint *desPt= [line.list lastObject];
                        Judian *desJD = desPt.geo;
                        
                        BMKPlanNode *startNode = [self getPlanResult:startJD];
                        BMKPlanNode *desNode = [self getPlanResult:desJD];
                        NSDictionary *delayDic = @{@"startNode":startNode,@"endNode":desNode};
                        [bSelf performSelector:@selector(delaySearch:) withObject:delayDic afterDelay:0.4*i];
                        i++;
                    }
                });
            }
        } failure:^(NSError *error) {
            
        }];
    });
}
#pragma mark - Inter
- (void)deleteAnnotations
{
    if ([_mapView.annotations count] != 0)
    {
        NSArray *annotationMArray = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:annotationMArray];
    }

}
- (void)deleteOverlays
{
    if ([_mapView.overlays count] != 0)
    {
        NSArray *overlayArray = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:overlayArray];
    }
}
- (BMKPlanNode *)getPlanResult:(Judian *) jd
{
    double lat = jd.lat;
    double lng = jd.lng;
    BMKPlanNode *node = [[BMKPlanNode alloc] init];
    node.pt = CLLocationCoordinate2DMake(lat, lng);
    return node;
}
#pragma mark - CustomLineTableViewDelegate

- (void)lineDidSelectedAtrowIndex:(NSInteger)index
{
    _selectedIndex = index;
    [self.rightBtn setEnabled:YES];
    //删除所有注释
    [self deleteAnnotations];
    //删除所有路线
    [self deleteOverlays];
    //添加某一个路线
    if ([_drivingRoteRecord count] != 0 && index <_drivingRoteRecord.count)
    {
        [self drawDrivingRouteWithResult:[_drivingRoteRecord objectAtIndex:index]];
    }
}
- (void)lineTableViewDidAnimate:(BOOL)isFold
{
    if (isFold)
    {
        [_tipView hideTipView];
        if (!_lineTableView.isConfirm)
        {
            /*
             * 画所有路线
             */
        }
    }
    else
    {
        [_tipView showTipView];
        [self.rightBtn setEnabled:NO];
    }
}
#pragma mark - CusLocateInputViewDelegate
-(void)locateBtnAction:(UIButton *)sender
{
    DLog(@"定位信息");
    [_bmklocation startUserLocationService];
}
- (void)inputViewShouldReturn:(CusLocateInputView *)inputView
{
    if (inputView == _cusDestinationInputView)
    {
        if (_tipView.hidden)
        {
            [_tipView showTipView];
        }
        [self showSearchRecord];
    }
    else
    {
        [_cusDestinationInputView.startInputView becomeFirstResponder];
    }
}
- (void)inputViewTextChanged:(CusLocateInputView *)inputView WithText:(NSString *)text
{
    if (inputView == _cusDestinationInputView)
    {
        if (text.length == 0 && !_lineTableView)
        {
            [_tipView showTagBtn];
        }
        else
        {
            [_tipView hideTagBtn:NO];
        }
    }
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
#pragma mark - CustomActionAnnotationViewDelegate
- (void)selectStart:(RouteAnnotation *)ann
{
    [_cusLocateInputView.startInputView setText:ann.title];
    [_cusLocateInputView.startInputView becomeFirstResponder];
    [_mapView deselectAnnotation:ann animated:YES];
    [_mapView removeAnnotation:ann];
}
- (void)selectDestination:(RouteAnnotation *)ann
{
    [_cusDestinationInputView.startInputView setText:ann.title];
    [_cusDestinationInputView.startInputView becomeFirstResponder];
    [_mapView deselectAnnotation:ann animated:YES];
    [_mapView removeAnnotation:ann];
}
#pragma mark - CustomTipViewDelegate
- (void)tagBtnPressed:(UIButton *)tagBtn WithTagName:(NSString *)tagName
{
    [_cusDestinationInputView.startInputView setText:tagName];
    [_cusDestinationInputView.startInputView becomeFirstResponder];
    [_tipView hideTagBtn:YES];
}
- (void)tipViewDisapper
{
    [self getAllJudian];
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
#pragma mark - BMK Function
- (BOOL)isContainsPoint:(RouteAnnotation *)ann
{
    for (RouteAnnotation *_ann in _mapView.annotations)
    {
        if (CLCOORDINATES_EQUAL2(ann.coordinate, _ann.coordinate))
        {
            return YES;
        }
    }
    return NO;
}
- (void)delaySearch:(NSDictionary *)dic
{
    BMKPlanNode *startNode = [dic objectForKey:@"startNode"];
    BMKPlanNode *endNode = [dic objectForKey:@"endNode"];
    [_search drivingSearch:nil startNode:startNode endCity:nil endNode:endNode];
}
- (void)showCallout:(RouteAnnotation *) annotation {
    
    [_mapView selectAnnotation:annotation animated:YES];
    
}


- (void)locateBtnPressed:(UIButton *)sender
{
    [_bmklocation startUserLocationService];
}
- (void)zoomInBtnPressed:(UIButton *)sender
{
    [_mapView zoomIn];
    [_zoomOutBtn setEnabled:YES];
    if (_mapView.zoomLevel == 19)
    {
        [sender setEnabled:NO];
    }
}
- (void)zoomOutBtnPressed:(UIButton *)sender
{
    [_mapView zoomOut];
    [_zoomInBtn setEnabled:YES];
    if (_mapView.zoomLevel == 3)
    {
        [sender setEnabled:NO];
    }
}

- (void)customMapView
{
    UIImageView *locationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, self.view.current_h-125, 55, 55)];
    [locationImgView setImage:[[UIImage imageNamed:@"bg_lucency@2x.png"] stretchableImageWithLeftCapWidth:55/2 topCapHeight:0]];
    [locationImgView setUserInteractionEnabled:YES];
    [self.view addSubview:locationImgView];
    
    UIButton *locateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locateBtn setFrame:CGRectMake(locationImgView.current_w/2-9, locationImgView.current_h/2-9, 18, 18)];
    [locateBtn setImage:[UIImage imageNamed:@"ic_location@2x.png"] forState:UIControlStateNormal];
    [locateBtn setImage:[UIImage imageNamed:@"ic_location@2x.png"] forState:UIControlStateHighlighted];
    [locateBtn addTarget:self action:@selector(locateBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [locationImgView addSubview:locateBtn];
    
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.current_w-5-135, self.view.current_h-125, 135, 55)];
    //[backgroundView setBackgroundColor:[UIColor redColor]];
    [backgroundView setImage:[[UIImage imageNamed:@"bg_lucency@2x.png"] stretchableImageWithLeftCapWidth:55/2 topCapHeight:0]];
    [backgroundView setUserInteractionEnabled:YES];
    [self.view addSubview:backgroundView];
    
    
    _zoomOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_zoomOutBtn setFrame:CGRectMake(18, 18, 18, 18)];
    [_zoomOutBtn setImage:[UIImage imageNamed:@"ic_shrink@2x.png"] forState:UIControlStateNormal];
    [_zoomOutBtn setImage:[UIImage imageNamed:@"ic_shrink@2x.png"] forState:UIControlStateHighlighted];
    [_zoomOutBtn addTarget:self action:@selector(zoomOutBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:_zoomOutBtn];
    
    _zoomInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_zoomInBtn setFrame:CGRectMake(backgroundView.current_w-36, 18, 18, 18)];
    [_zoomInBtn setImage:[UIImage imageNamed:@"ic_magnify@2x.png"] forState:UIControlStateNormal];
    [_zoomInBtn setImage:[UIImage imageNamed:@"ic_magnify@2x.png"] forState:UIControlStateHighlighted];
    [_zoomInBtn addTarget:self action:@selector(zoomInBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:_zoomInBtn];
    
    
    
}
- (void)drawDrivingRouteWithResult:(BMKPlanResult*)result
{
    BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
    
    // 添加起点
    RouteAnnotation* item = [[RouteAnnotation alloc]init];
    item.coordinate = result.startNode.pt;
    item.subTitle = @"起点";
    item.type = 0;
    if (![self isContainsPoint:item])
    {
        [_mapView addAnnotation:item];
    }
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
    item.subTitle = [NSString stringWithFormat:@"%d",[_drivingRoteRecord indexOfObject:result]+1];
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
    [self updateMapviewVisibleRegion];
}
- (void)updateMapviewVisibleRegion {
    
    BMKMapRect zoomRect = BMKMapRectNull;
    for (id <BMKAnnotation> annotation in _mapView.annotations) {
        BMKMapPoint annotationPoint = BMKMapPointForCoordinate(annotation.coordinate);
        BMKMapRect pointRect = BMKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (BMKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = BMKMapRectUnion(zoomRect, pointRect);
        }
    }
    zoomRect = [_mapView mapRectThatFits:zoomRect edgePadding:UIEdgeInsetsMake(100, 0, 100, 0)];

    [_mapView setVisibleMapRect:zoomRect animated:YES];
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
-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    [_mapView removeAnnotation:view.annotation];
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
        if (!_isLongClick)
        {
            DLog(@"%@%@%@%@%@",result.addressComponent.province,result.addressComponent.city,result.addressComponent.district,result.addressComponent.streetName,result.addressComponent.streetNumber);
            
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = result.geoPt;
            item.type = 0;
            item.title = result.strAddr;
            item.subTitle =@"起点";
            //刷新数据
            [_cusLocateInputView setLocateAddress:result.strAddr];
            if (![_mapView.annotations containsObject:item])
            {
                RouteAnnotation *deleteItem;
                for(RouteAnnotation *ann in _mapView.annotations)
                {
                    if (ann.type == 0)
                    {
                        deleteItem = ann;
                    }
                }
                [_mapView removeAnnotation:deleteItem];
                [_mapView addAnnotation:item];
            }

        }
        else
        {
            _isLongClick = NO;
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = result.geoPt;
            item.type = 6;
            item.title = result.strAddr;
            if (![_mapView.annotations containsObject:item])
            {
                RouteAnnotation *deleteItem;
                for(RouteAnnotation *ann in _mapView.annotations)
                {
                    if (ann.type == 6)
                    {
                        deleteItem = ann;
                    }
                }
                [_mapView removeAnnotation:deleteItem];
                [_mapView addAnnotation:item];
            }

        }
        [self updateMapviewVisibleRegion];
    }
}

- (void)onGetDrivingRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
    if (result != nil) {
        
        // error 值的意义请参考BMKErrorCode
        if (error == BMKErrorOk) {
            [_drivingRoteRecord addObject:result];
            [self drawDrivingRouteWithResult:result];
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
                view.image = [UIImage imageNamed:@"pt_green@2x.png"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = YES;
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(4, 10, 28, 13)];
                [label setTag:888888];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setFont:[UIFont systemFontOfSize:13]];
                [label setTextColor:[UIColor whiteColor]];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setText:routeAnnotation.subTitle];
                [view addSubview:label];
            }
            else
            {
                UILabel *label = (UILabel *)[view viewWithTag:888888];
                if (label)
                {
                    [label setText:routeAnnotation.subTitle];
                }
                [view setNeedsDisplay];
            }
            view.annotation = routeAnnotation;
            [(BMKPinAnnotationView *)view setAnimatesDrop:NO];
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKPinAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageNamed:@"pt_yellow@2x.png"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = YES;
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(4, 12, 28, 12)];
                [label setTag:999999];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setFont:[UIFont systemFontOfSize:13]];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setText:routeAnnotation.subTitle];
                [view addSubview:label];
            }
            else
            {
                /*
                 *  重用的时候，重新赋值文本
                 */
                UILabel *label = (UILabel *)[view viewWithTag:999999];
                if (label)
                {
                    [label setText:routeAnnotation.subTitle];
                }
                [view setNeedsDisplay];
            }
            view.annotation = routeAnnotation;
            [(BMKPinAnnotationView *)view setAnimatesDrop:NO];

        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = YES;
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
                view.canShowCallout = YES;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = YES;
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
        case 6:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"custom_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"custom_node"];
                view.image = [UIImage imageNamed:@"tag_map@2x"];
                
            } else {
                [view setNeedsDisplay];
            }
            CustomActionAnnotation *customPaoPaoView = [[CustomActionAnnotation alloc]initWithFrame:CGRectMake(0, 0, 240, 140) WithAnnotation:routeAnnotation WithType:0];
            customPaoPaoView.delegate = self;
            view.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:customPaoPaoView];
            view.annotation = routeAnnotation;
            //自动显示
            [self performSelector:@selector(showCallout:) withObject:routeAnnotation afterDelay:0.1];
        }
            break;
            case 7:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"custom_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"custom_node"];
                view.image = [UIImage imageNamed:@"tag_map@2x"];
                
            } else {
                [view setNeedsDisplay];
            }
            CustomActionAnnotation *customPaoPaoView = [[CustomActionAnnotation alloc]initWithFrame:CGRectMake(0, 0, 240, 140) WithAnnotation:routeAnnotation WithType:0];
            customPaoPaoView.delegate = self;
            view.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:customPaoPaoView];
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
    /*
     * 注释代码 by Liang Zhao
     */
    /*
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
    }*/
    /*
     * 采用代码 by Liang Zhao
     */
    if ([annotation isKindOfClass:[RouteAnnotation class]])
    {
        return [self getRouteAnnotationView:mapview viewForAnnotation:(RouteAnnotation*)annotation];
    }
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
       // [self updateMapviewVisibleRegion];
        return polylineView;
    }
	return nil;
}

- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
{
    //定位点解析
    _isLongClick = YES;
    BOOL flag = [_search reverseGeocode:coordinate];
    /*
    BOOL flag = [_search reverseGeocode:coordinate];
	if (flag) {
		DLog(@"ReverseGeocode search success.");
	}
    else{
        DLog(@"ReverseGeocode search failed!");
    }*/
    
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
