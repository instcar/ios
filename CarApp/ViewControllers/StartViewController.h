//
//  StartViewController.h
//  CarApp
//
//  Created by Leno on 13-9-27.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface StartViewController :BaseViewController <UITextFieldDelegate,UIScrollViewDelegate>
{
    UIButton *_loginBtn;            //登入按钮
    UIButton *_registerBtn;         //注册按钮
    UIImageView *_bottomView;       //底部注册\登入bar
    UIScrollView *_mainScrollView;  //滑动视图
}


@end
