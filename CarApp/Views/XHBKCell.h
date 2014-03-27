//
//  XHBKCell.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-17.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBKCell : UITableViewCell


@property (retain, nonatomic) UIButton * backButton;
@property (retain, nonatomic) UILabel * contentTextLable;
@property (retain, nonatomic) UIImageView * contentImageView;


@property (retain, nonatomic) NSDictionary * celldata;

@end
