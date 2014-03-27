//
//  RoomInfoView.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-2-22.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PListSettingView.h"

@interface RoomInfoView : UIView

@property (retain, nonatomic) UIButton *headImgView;
@property (retain, nonatomic) UILabel *nameLable;
@property (retain, nonatomic) UILabel *masterLable;
@property (retain, nonatomic) PListSettingView *pListSettingView;
@property (retain, nonatomic) UIButton *ensureBtn;
@property (assign, nonatomic) BOOL enableTouchBg;
@property (retain, nonatomic) NSDictionary *data;
@property (retain, nonatomic) UIViewController *groupVC;

-(void)show;

-(void)hide:(BOOL)animated;

@end
