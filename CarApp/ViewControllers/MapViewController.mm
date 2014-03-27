//
//  ChatMapViewController.m
//  WPWProject
//
//  Created by Mr.Lu on 13-7-22.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import "MapViewController.h"
#import "SVProgressHUD.h"

#define kMapViewTag 2222

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface RouteAnnotation : BMKPointAnnotation
{
	int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
	int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
	CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	return newImage;
}

@end

@interface MapViewController ()

@property (assign, nonatomic) BOOL firstLocate;
@property (retain, nonatomic) BMKMapView *mapView;
@property (retain, nonatomic) BMKSearch *search;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.search.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.search.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstLocate = YES;
    if (kDeviceVersion >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
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
    
    UIButton * backButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 20, 70, 44)];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_normal@2x"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed@2x"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backButton];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 27, 200, 30)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    if (self.mode == kMapViewModeAddress) {
        [titleLabel setText:@"上车地点"];
    }
    if (self.mode == kMapViewModeLine) {
        [titleLabel setText:@"地图模式"];
    }
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
    
    UILabel * warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
    [warnLabel setBackgroundColor:[UIColor clearColor]];
    if (self.mode == kMapViewModeAddress) {
        [warnLabel setText:[self.line.description stringByAppendingString:@"标志牌上车"]];
    }
    if (self.mode == kMapViewModeLine) {
        [warnLabel setText:@"为了您和司机的方便，请到标志物等候上车"];
    }
    
    [warnLabel setTextAlignment:NSTextAlignmentCenter];
    [warnLabel setTextColor:[UIColor whiteColor]];
    [warnLabel setFont:[UIFont appGreenWarnFont]];
    [welcomeImgView addSubview:warnLabel];
    [warnLabel release];
    
    self.mapView = [[[BMKMapView alloc]initWithFrame:CGRectMake(0, 64+44, 320, SCREEN_HEIGHT - 44-64)]autorelease];
    [self.mapView setTag:kMapViewTag];
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:BMKCoordinateRegionMake(self.mapView.userLocation.coordinate, BMKCoordinateSpanMake(0.02, 0.02))];
    [self.mapView setRegion:adjustedRegion animated:NO];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setOverlooking:0];
    [self.mapView setDelegate:self];
    
//    [self.mapView setRotation:0];
    [mainView insertSubview:self.mapView belowSubview:navBar];
    
    self.search = [[[BMKSearch alloc]init]autorelease];
    [self.search setDelegate:self];
    
    CLLocationDegrees latitudeDelta  = self.line.startlatitude - self.line.stoplatitude;
    CLLocationDegrees longitudeDelta = self.line.startlongitude - self.line.stoplongitude;
    CLLocationCoordinate2D startlocate = CLLocationCoordinate2DMake(self.line.startlatitude, self.line.startlongitude);
    
    //改变显示范围
    BMKCoordinateRegion regin = [self.mapView regionThatFits:BMKCoordinateRegionMake(startlocate, BMKCoordinateSpanMake(latitudeDelta, longitudeDelta))];
   [self.mapView setRegion:regin animated:NO];
    
    [self performSelector:@selector(setdisplayerMode) withObject:nil afterDelay:0.1];
}

-(void)setdisplayerMode
{
    if (_mode == kMapViewModeLine) {
        [self routeSearch];
    }
    if (_mode == kMapViewModeAddress) {
        [self setMapAnonation];
    }
}

-(void)setMapAnonation
{
    BMKPointAnnotation* addPoint = [[BMKPointAnnotation alloc]init];
    [addPoint setTitle:self.line.startaddr];
    [addPoint setCoordinate:CLLocationCoordinate2DMake(self.line.startlatitude, self.line.startlongitude)];
    [self.mapView addAnnotation:addPoint];
    [addPoint release];
}

-(void)routeSearch
{
//    NSMutableArray * array = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
//    BMKPlanNode* wayPointItem1 = [[[BMKPlanNode alloc]init] autorelease];
//    wayPointItem1.cityName = @"北京";
//    wayPointItem1.name = _wayPointAddrText.text;
//    [array addObject:wayPointItem1];
    
    BMKPlanNode* start = [[[BMKPlanNode alloc]init] autorelease];
	start.pt = CLLocationCoordinate2DMake(self.line.startlatitude, self.line.startlongitude);
    start.name = self.line.startaddr;
	BMKPlanNode* end = [[[BMKPlanNode alloc]init] autorelease];
	end.pt = CLLocationCoordinate2DMake(self.line.stoplatitude, self.line.stoplongitude);
    end.name = self.line.stopaddr;
    
	BOOL flag = [_search drivingSearch:@"" startNode:start endCity:@"" endNode:end];
//   	BOOL flag = [_search drivingSearch:@"" startNode:start endCity:@"" endNode:end throughWayPoints:array];
	if (flag) {
		DLog(@"search success.");
	}
    else{
        DLog(@"search failed!");
    }
}

-(void)backToMain
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString*)getMyBundlePath1:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil ;
}

#pragma mark - baidu地图Delegate

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [self.mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
}

-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
//   BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:BMKCoordinateRegionMake(self.mapView.userLocation.coordinate, BMKCoordinateSpanMake(0.02, 0.02))];
//   [self.mapView setRegion:adjustedRegion animated:NO];
//       self.locateSuccess = YES;
//       self.location = userLocation.location.coordinate;
//       self.locateState = NO;
//       [self.search reverseGeocode:self.mapView.userLocation.location.coordinate];
//   [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:NO];
}

-(void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
}

//编码问题
- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
//	if (error == 0)
//    {
//		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
//		item.coordinate = result.geoPt;
//		item.title = result.strAddr;
//        item.subtitle = result.strAddr;
//        self.locationStr = result.strAddr;
//        if (self.otherlocation.latitude != 0.0f && self.otherlocation.longitude != 0.0f) {
//            [self.mapView addAnnotation:item];
//            [item release];
//        }
//	}
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
            [item release];
            
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
                    [item release];
                }
                
            }
            
            // 添加终点
            item = [[RouteAnnotation alloc]init];
            item.coordinate = result.endNode.pt;
            item.type = 1;
            item.title = @"终点";
            [_mapView addAnnotation:item];
            [item release];
            
            // 添加途经点
            if (result.wayNodes) {
                for (BMKPlanNode* tempNode in result.wayNodes) {
                    item = [[RouteAnnotation alloc]init];
                    item.coordinate = tempNode.pt;
                    item.type = 5;
                    item.title = tempNode.name;
                    [_mapView addAnnotation:item];
                    [item release];
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
                view = [[[BMKPinAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"] autorelease];
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
                view = [[[BMKPinAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"] autorelease];
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
                view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"] autorelease];
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
                view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"] autorelease];
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
                view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"] autorelease];
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
                view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"] autorelease];
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
    if (self.mode == kMapViewModeAddress) {
        if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
            
            view = (BMKPinAnnotationView *)[mapview dequeueReusableAnnotationViewWithIdentifier:@"start_nodeAddress"];
            if (view == nil) {
                view = [[[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"start_nodeAddress"] autorelease];
                view.image = [UIImage imageNamed:@"tag_map@2x"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
                [view setAnimatesDrop:YES];
            }
            view.annotation = annotation;
            BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:BMKCoordinateRegionMake(annotation.coordinate, BMKCoordinateSpanMake(0.007, 0.007))];
            [self.mapView setRegion:adjustedRegion animated:YES];
            [self.mapView setCenterCoordinate:annotation.coordinate animated:NO];
            return view;
        }
    }
    if (self.mode == kMapViewModeLine) {
    
        if ([annotation isKindOfClass:[RouteAnnotation class]]) {
            return [self getRouteAnnotationView:mapview viewForAnnotation:(RouteAnnotation*)annotation];
        }
    }
	return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[[BMKPolylineView alloc] initWithOverlay:overlay] autorelease];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor flatBlueColor] colorWithAlphaComponent:1.0];
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
	return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _mapView.delegate = nil;
    [_mapView release];
    _mapView = nil;
    _search.delegate = nil;
    [_search release];
    _search = nil;
    [_line release];
    _line = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end
