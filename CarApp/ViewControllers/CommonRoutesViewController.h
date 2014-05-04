//
//  CommonRoutesViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-6.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "People.h"
#import "CommonViewController.h"

@interface CommonRoutesViewController : CommonViewController
{
    int _routepage;
    BOOL _routeCanLoadMore;
}

@property (strong, nonatomic) People *userInfo;

@end
