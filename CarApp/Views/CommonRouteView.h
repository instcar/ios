//
//  CommonRouteView.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-2.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@interface CommonRouteView : UIView<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    int _routepage;
    BOOL _routeCanLoadMore;
}

@property (retain, nonatomic) UIViewController *mainVC;

- (void)autoRefreshTable;

@end
