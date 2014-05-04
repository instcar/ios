//
//  SelectCarTypeViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-13.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CommonViewController.h"
#import "CarD.h"
@interface SelectCarTypeViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}

@property (strong, nonatomic) CarD *car;  //汽车别名

@end
