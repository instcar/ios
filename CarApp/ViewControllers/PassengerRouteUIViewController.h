//
//  PassengerRouteUIViewController.h
//  CarApp
//
//  Created by leno on 13-10-14.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PullingRefreshTableView.h"
#import "HZscrollerView.h"
#import "EnumCommon.h"

@interface PassengerRouteUIViewController : UIViewController<CLLocationManagerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,UIScrollViewDelegate>
{
    float _keyBoardOriginY;//键盘的高度
    
    int _tablePage;
    
    BOOL _tablerefreshing;
    BOOL _canTableLoadMore;
    kEnumRouteMode _currentMode;//当前模式用来做判断加载类型
    kEnumRouteMode _tableMode;//0表示分页显示 1表示tag搜索 2表示judianid搜索  3表示  4表示
    
    NSMutableArray *_lineArray;
    NSMutableArray *_judianArray;
    
    PullingRefreshTableView *_tableView;
    HZscrollerView *_hzScrollerView;
    
}

@property (nonatomic, assign) BOOL state; //state = 1 乘客 state = 2 添加乘客

@end
