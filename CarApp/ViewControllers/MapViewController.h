//
//  ChatMapViewController.h
//  WPWProject
//
//  Created by Mr.Lu on 13-7-22.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "Line.h"

typedef enum
{
    kMapViewModeAddress,
    kMapViewModeLine
}kMapViewMode;

@protocol MapVCDelegate;

@interface MapViewController : UIViewController<BMKMapViewDelegate,BMKSearchDelegate>

@property (assign, nonatomic) id<MapVCDelegate> delegate;
@property (strong, nonatomic) Line *line;
@property (assign, nonatomic) kMapViewMode mode;

@end

@protocol MapVCDelegate <NSObject>
//-(void)mapVC:(MapViewController *)mapVC sendLocationAction:(LocationMessage *)locationMessage;
@end