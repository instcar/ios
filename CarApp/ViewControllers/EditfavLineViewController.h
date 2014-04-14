//
//  EditfavLineViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-15.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CommonViewController.h"
#import "PullingRefreshTableView.h"

@interface EditfavLineViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    int _routepage;
    BOOL _routeCanLoadMore;
}

@end
