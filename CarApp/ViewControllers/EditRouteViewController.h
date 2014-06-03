//
//  EditRouteViewController.h
//  CarApp
//
//  Created by leno on 13-10-13.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Line.h"
#import "MGConferenceDatePicker.h"
#import "SelectPassengerNumPicker.h"
@interface EditRouteViewController : CommonViewController<BMKMapViewDelegate>
{
    int _currentPeople;
    BOOL _boolll;
    MGConferenceDatePicker *_datePicker;
    SelectPassengerNumPicker *_peoplePicker;

}

@property(strong, nonatomic)Line *line;
@property (assign, nonatomic) int currentPeople;

@end
