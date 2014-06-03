//
//  CustomLineTipView.h
//  CarApp
//
//  Created by Mac_ZL on 14-5-24.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLineTableView.h"
@protocol CustomLineTipViewDelegate;
@interface CustomLineTipView : UIView
{
    UIView *_tagView;
    BOOL _isHideBtn;
    BOOL _isEnableTouch;
}
@property(weak,nonatomic) id<CustomLineTipViewDelegate> delegate;
- (void)showTipView;
- (void)hideTipView;
- (void)showTagBtn;
- (void)hideTagBtn:(BOOL) isEnableTouch;
@end
@protocol CustomLineTipViewDelegate <NSObject>

@optional
- (void) tagBtnPressed:(UIButton *) tagBtn WithTagName:(NSString *) tagName;
- (void) tipViewDisapper;
@end