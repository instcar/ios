//
//  EditRouteViewController.h
//  CarApp
//
//  Created by leno on 13-10-13.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Line.h"

@interface EditRouteViewController : UIViewController<BMKMapViewDelegate>
{
    int _currentPeople;
    BOOL _boolll;

}

@property(strong, nonatomic)Line *line;
@property (assign, nonatomic) int currentPeople;

@end
