//
//  EditAddressViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-15.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CommonViewController.h"

@interface EditAddressViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (assign, nonatomic) int type; //type = 1 公司 type = 2 家庭

@end
