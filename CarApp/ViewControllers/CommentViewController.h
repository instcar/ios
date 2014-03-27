//
//  CommentViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-4.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@interface CommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    BOOL _editBtnState;
}

@property (retain, nonatomic) Room *room;
@property (retain, nonatomic) PullingRefreshTableView * tableView;

@end
