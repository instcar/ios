//
//  MainSecondView.h
//  CarApp
//
//  Created by Leno on 13-9-27.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PullingRefreshTableView.h"

@interface MainSecondView : UIView<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,UIAlertViewDelegate>
{
    BOOL _editBtnState;
    int _myroompage;
    BOOL _myroomCanLoadMore;
}

@property (strong, nonatomic) PullingRefreshTableView * tableView;
@property (strong, nonatomic) UIViewController *mainVC;

-(void)autoRefreshTable;

@end

