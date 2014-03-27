//
//  PassgerEditRouteViewController.h
//  CarApp
//
//  Created by leno on 13-10-14.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "BMapKit.h"

@interface PassgerEditRouteViewController : UIViewController<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate>
{
    
    int _tablePage;
    
    BOOL _tablerefreshing;
    BOOL _canTableLoadMore;
    
    PullingRefreshTableView *_tableView;
    NSMutableArray *_roomArray;

}

@property(retain,nonatomic)Line *line;

@end
