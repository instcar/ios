//
//  EditCompanyViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-15.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CommonViewController.h"

@interface EditCompanyViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@end
