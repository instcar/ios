//
//  MainRouteTableCell.h
//  CarApp
//
//  Created by 海龙 李 on 13-11-18.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainRouteTableCell : UITableViewCell

@property(retain,nonatomic)UIButton * backButton;
@property(retain,nonatomic)UIImageView * backImgView;
@property(retain,nonatomic)UILabel * routeTitleLabel;
@property(retain,nonatomic)UILabel * routeInfoLabel;
@property(retain,nonatomic)UILabel * routeTimeLabel;
@property(retain,nonatomic)UIImageView * routeAccessImgView;
@property(retain,nonatomic)UIButton *commentBtn;
@property(retain, nonatomic)UIView *lineView;

@end
