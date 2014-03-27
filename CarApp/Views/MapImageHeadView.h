//
//  MapImageHeadView.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-14.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@protocol MapImageHeadViewDelegate;

@interface MapImageHeadView : UIView<BMKMapViewDelegate>
{
    BMKMapView *_mapView;
}
@property (assign, nonatomic) id<MapImageHeadViewDelegate> delegate;

-(void)setImageWithURL:(NSURL *)imageUrl placeholderImage:(UIImage *)placeHolderImage;
-(void)willAppear;
-(void)willDisAppear;
-(void)setMapAnonation:(NSString *)address location:(CLLocationCoordinate2D)locate;

@end

@protocol MapImageHeadViewDelegate <NSObject>

- (void)mapImageHeadView:(MapImageHeadView *)mapImageHeadView photoSelectAction:(UIButton *)sender;
- (void)mapImageHeadView:(MapImageHeadView *)mapImageHeadView mapSelectAction:(UIButton *)sender;
@end