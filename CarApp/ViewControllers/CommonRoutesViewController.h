//
//  CommonRoutesViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-6.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "People.h"

@interface CommonRoutesViewController : UIViewController
{
    int _routepage;
    BOOL _routeCanLoadMore;
}

@property (retain, nonatomic) People *myInfo;

@end
