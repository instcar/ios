//
//  CommentViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-4.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "Room.h"

@interface CommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    BOOL _editBtnState;
}

@property (strong, nonatomic) Room *room;
@property (strong, nonatomic) PullingRefreshTableView * tableView;

@end
