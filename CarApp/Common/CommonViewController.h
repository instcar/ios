//
//  CommonViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-17.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "BaseViewController.h"

#define KOFFSETY ((kDeviceVersion >= 7.0?64:44)+45.0)

@interface CommonViewController :BaseViewController
{
    UINavigationBar *_navBar;
    UIImageView *_messageBgView;
    UILabel *_titleLabel;
    UILabel *_desLable;
    UIImageView *_headerImgView;
}

@property (copy, nonatomic) NSString *ctitle;
@property (copy, nonatomic) NSString *desText;
@property (retain, nonatomic) UIButton *leftBtn;
@property (retain, nonatomic) UIButton *rightBtn;
@property (retain, nonatomic) UIView *messageView;

@end
