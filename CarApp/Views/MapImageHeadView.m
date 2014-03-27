//
//  MapImageHeadView.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-14.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "MapImageHeadView.h"
#import "UIButton+WebCache.h"

@implementation MapImageHeadView

-(void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setView];
    }
    return self;
}

-(void)willAppear
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

-(void)willDisAppear
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
}

- (void)setView
{
    UIButton * photoImgView = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoImgView setFrame:CGRectMake(0, 0, 320, 150)];
    [photoImgView setTag:10001];
    [photoImgView setContentMode:UIViewContentModeRedraw];
    [photoImgView setBackgroundColor:[UIColor placeHoldColor]];
    [photoImgView setClipsToBounds:YES];
    [photoImgView addTarget:self action:@selector(photoImgView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:photoImgView];
    [photoImgView release];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 149.5, 320, 0.5)];
    [lineView setBackgroundColor:[UIColor appLineDarkGrayColor]];
    [photoImgView addSubview:lineView];
    [lineView release];
    
    BMKMapView *mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(12, 13+2, 106,106)];
    BMKCoordinateRegion adjustedRegion = [mapView regionThatFits:BMKCoordinateRegionMake(mapView.userLocation.coordinate, BMKCoordinateSpanMake(0.02, 0.02))];
    [mapView setRegion:adjustedRegion animated:NO];
    [mapView.layer setCornerRadius:106/2.0];
    [mapView.layer setMasksToBounds:YES];
    [mapView setShowsUserLocation:NO];
    [mapView setOverlooking:0];
    [mapView setDelegate:self];
    [mapView setUserInteractionEnabled:NO];
    //    [self.mapView setRotation:0];
    //    [self performSelector:@selector(setMapAnonation) withObject:nil afterDelay:0.2];
    [self addSubview:mapView];
    _mapView = mapView;
    [mapView release];
    
    UIButton *mapViewMask = [UIButton buttonWithType:UIButtonTypeCustom];
    [mapViewMask setTag:10003];
    [mapViewMask setFrame:CGRectMake(10, 13, 110, 110)];
    [mapViewMask setBackgroundImage:[UIImage imageNamed:@"bg_map@2x"] forState:UIControlStateNormal];
    [mapViewMask addTarget:self action:@selector(maptapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mapViewMask];

}

-(void)setMapAnonation:(NSString *)address location:(CLLocationCoordinate2D)locate
{
    [_mapView removeAnnotations:_mapView.annotations];
    BMKPointAnnotation* addPoint = [[BMKPointAnnotation alloc]init];
    [addPoint setTitle:address];
    [addPoint setCoordinate:locate];
    [_mapView addAnnotation:addPoint];
    [addPoint release];
}

-(void)setImageWithURL:(NSURL *)imageUrl placeholderImage:(UIImage *)placeHolderImage
{
    UIButton * photoImgView = (UIButton *)[self viewWithTag:10001];
    [photoImgView setBackgroundImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:placeHolderImage];
}

- (void)maptapAction:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapImageHeadView:mapSelectAction:)]) {
        [self.delegate mapImageHeadView:self mapSelectAction:button];
    }
}

- (void)photoImgView:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapImageHeadView:photoSelectAction:)]) {
        [self.delegate mapImageHeadView:self photoSelectAction:button];
    }
}

#pragma mark - bmkMapViewDelegate methods
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
}

-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    BMKCoordinateRegion adjustedRegion = [mapView regionThatFits:BMKCoordinateRegionMake(mapView.userLocation.coordinate, BMKCoordinateSpanMake(0.02, 0.02))];
    [mapView setRegion:adjustedRegion animated:NO];
    //       self.locateSuccess = YES;
    //       self.location = userLocation.location.coordinate;
    //       self.locateState = NO;
    //       [self.search reverseGeocode:self.mapView.userLocation.location.coordinate];
//    [mapView setCenterCoordinate:mapView.userLocation.coordinate animated:NO];
    
    
}

-(void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		BMKAnnotationView* view = nil;
        view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"start_nodeAddress"];
        if (view == nil) {
            view = [[[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"start_nodeAddress"] autorelease];
            view.image = [UIImage imageNamed:@"tag_map@2x"];
            view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.0));
            view.canShowCallout = TRUE;
        }
        view.annotation = annotation;
        BMKCoordinateRegion adjustedRegion = [mapView regionThatFits:BMKCoordinateRegionMake(annotation.coordinate, BMKCoordinateSpanMake(0.01, 0.01))];
        [mapView setRegion:adjustedRegion animated:NO];
        [mapView setCenterCoordinate:annotation.coordinate animated:NO];
        return view;
	}
	return nil;
}


@end
