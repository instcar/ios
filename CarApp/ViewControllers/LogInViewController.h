//
//  LogInViewController.h
//  CarApp
//
//  Created by leno on 13-10-14.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDInputView.h"

@interface LogInViewController : UIViewController<UITextFieldDelegate>
{
    UIImageView *_bottomView;
    UIView *_inputView;
    UILabel *_errorWarnLable;
    GDInputView *_userInputView;
    GDInputView *_codeInputView;
    UIButton *_loginBtn;
    UIButton *_registerBtn;
    UIButton *_forgetBtn;
    UIScrollView *_mainScrollView;
}
@end
