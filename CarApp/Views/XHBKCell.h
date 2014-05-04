//
//  XHBKCell.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-17.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBKCell : UITableViewCell


@property (strong, nonatomic) UIButton * backButton;
@property (strong, nonatomic) UILabel * contentTextLable;
@property (strong, nonatomic) UIImageView * contentImageView;


@property (strong, nonatomic) NSDictionary * celldata;

@end
