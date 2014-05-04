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

@property (strong, nonatomic) UIButton *headImgView;
@property (strong, nonatomic) UILabel *nameLable;
@property (strong, nonatomic) UILabel *masterLable;
@property (strong, nonatomic) PListSettingView *pListSettingView;
@property (strong, nonatomic) UIButton *ensureBtn;
@property (assign, nonatomic) BOOL enableTouchBg;
@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) UIViewController *groupVC;

-(void)show;

-(void)hide:(BOOL)animated;

@end
