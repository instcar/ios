//
//  EditRouteViewController.h
//  CarApp
//
//  Created by leno on 13-10-13.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTimeViewController.h"

@interface EditRouteViewController : UIViewController<EditTimeViewControllerDelegate,BMKMapViewDelegate>
{
    int _currentPeople;
    BOOL _boolll;

}

@property(retain, nonatomic)Line *line;
@property (assign, nonatomic) int currentPeople;

@end
