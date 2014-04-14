//
//  SelectCarBrandViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-11.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CommonViewController.h"

@interface SelectCarBrandViewController :CommonViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@end
