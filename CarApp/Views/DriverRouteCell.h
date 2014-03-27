//
//  DriverRouteCell.h
//  CarApp
//
//  Created by leno on 13-10-9.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriverRouteCell : UITableViewCell

@property(retain, nonatomic) UIImageView * roundImgView; //数字背景的圆形图标
@property(retain, nonatomic) UILabel * numberLabel; // 数字标识
@property(retain, nonatomic) UILabel * routeLabel;  //  路线名字
@property(retain, nonatomic) UILabel * addressLabel;  //  接客地址

@end
