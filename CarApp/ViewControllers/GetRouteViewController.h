//
//  GetRouteViewController.h
//  CarApp
//
//  Created by Leno on 13-9-12.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "CommonViewController.h"
#import "PullingRefreshTableView.h"
#import "HZscrollerView.h"
#import "EnumCommon.h"
#import "BMapKit.h"
#import "CusLocateInputView.h"
#import "CusVoiceInputView.h"
#import "CustomLineTableView.h"
#import "CustomLineTipView.h"
#import "CustomActionAnnotation.h"

@interface GetRouteViewController : CommonViewController<CLLocationManagerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,BMKMapViewDelegate,BMKSearchDelegate,CustomLineTableViewDelegate,CustomLineTipViewDelegate,CustomActionAnnotationDelegate>
{
    float _keyBoardOriginY;//键盘的高度
    int _selectedIndex;
    int _tablePage;
    
    BOOL _tablerefreshing;
    BOOL _canTableLoadMore;
    BOOL _isLongClick;
    BOOL _locate;    //定位
    
    kEnumRouteMode _currentMode;//当前模式用来做判断加载类型
    kEnumRouteMode _tableMode;//0表示分页显示 1表示tag搜索 2表示judianid搜索  3表示  4表示

    NSMutableArray *_drivingRoteRecord;//缓存路线
    NSMutableArray *_lineArray;
    NSMutableArray *_judianArray;
    
    PullingRefreshTableView *_tableView;
    CustomLineTableView *_lineTableView;
    CustomLineTipView *_tipView;
    BMKMapView *_mapView;
    BMKSearch *_search;
    BMKUserLocation *_bmklocation;
    CusLocateInputView *_cusLocateInputView;
    CusLocateInputView *_cusDestinationInputView;
    CusVoiceInputView *_cusVoiceInputView;
    UIButton *_zoomInBtn;
    UIButton *_zoomOutBtn;
}

@end
