//
//  BaseViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-6.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BarButtonoffsetY (SYSTEM_VERSION_MORE_THAN(7.0)?(20+7):7)
#define BarButtonoffsetX 10.0

@interface BaseViewController : UIViewController

//数据交互
- (void)requestData;

@end
