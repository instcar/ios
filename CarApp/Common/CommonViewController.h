//
//  CommonViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-17.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "BaseViewController.h"

#define KOFFSETY (45.0)

@interface CommonViewController :BaseViewController
{
    UIImageView *_messageBgView;
    UILabel *_titleLabel;
    UILabel *_desLable;
    UIImageView *_headerImgView;
    
    UIBarButtonItem *_editBtnItem;
    UIBarButtonItem * _backButtonItem;
    UIBarButtonItem * _leftButtonItem;
    UIBarButtonItem * _rightButtonItem;
}

@property (strong, nonatomic) UIButton *leftBtn;     //定制按钮
@property (strong, nonatomic) UIButton *rightBtn;    //定制按钮
@property (strong, nonatomic) UIView *messageView;
@property (copy, nonatomic) NSString *messageText;

@property(assign, nonatomic) BOOL enableEditing;    //编辑按钮 - 显示编辑按钮
@property(assign, nonatomic) BOOL enableMessage;       //显示messageView - 默认显示
@property(assign, nonatomic) BOOL enableBackButton;   //启用自定义返回按钮

- (void)backAction:(UIButton *)sender;
- (void)editBtnAction:(UIButton *)sender;

@end
