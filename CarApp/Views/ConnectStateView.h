//
//  ConnectStateView.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-17.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectStateView : UIView
{
    UIActivityIndicatorView *_activityIndicatorView;
    UILabel *_stateLable;
}

- (void)showActivity;

- (void)showStateLable:(NSString *)stateStr hidden:(BOOL)hidden;

- (void)connectStateViewAppeared; // 可选

- (void)connectStateViewDisAppeared; // 可选
@end
