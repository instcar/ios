//
//  CarInfoTableViewCell.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-10.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarInfoTableViewCell : UITableViewCell
{
    UIImageView *_bg; //线框背景
    UIImageView *_carLogoImageView; //车辆标志
    UILabel *_carName; //车辆名字
    UILabel *_carModel; //车辆型号
    UIButton *_carImageView1; //车辆照片1
    UIButton *_carImageView2; //车辆照片2
    UIImageView *_checkState; //检测状态标识
    UILabel *_checkLable; //检测状态
    UIView *_modifyView; //修改视图
}

@property (retain, nonatomic) NSDictionary *data;

@end
