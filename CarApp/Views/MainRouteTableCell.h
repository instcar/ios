//
//  MainRouteTableCell.h
//  CarApp
//
//  Created by 海龙 李 on 13-11-18.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainRouteTableCell : UITableViewCell

@property(strong,nonatomic)UIButton * backButton;
@property(strong,nonatomic)UIImageView * backImgView;
@property(strong,nonatomic)UILabel * routeTitleLabel;
@property(strong,nonatomic)UILabel * routeInfoLabel;
@property(strong,nonatomic)UILabel * routeTimeLabel;
@property(strong,nonatomic)UIImageView * routeAccessImgView;
@property(strong,nonatomic)UIButton *commentBtn;
@property(strong, nonatomic)UIView *lineView;

@end
