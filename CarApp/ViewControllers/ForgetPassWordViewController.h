//
//  ForgetPassWordViewController.h
//  CarApp
//
//  Created by 海龙 李 on 13-11-10.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "CommonViewController.h"
#import "GDInputView.h"

@interface ForgetPassWordViewController :CommonViewController <UITextFieldDelegate,GDInputDelegate>

{
    bool _inputCode;
    NSString *_phoneNum;                            //通过验证的手机号
    NSString *_authCode;                            //获取的验证码
    NSString *_sequenceNo;                          //验证码对应的序列号
    
    UIButton *_authBtn;
    UIButton * _confirmBtn;
    GDInputView *_inputView;
    GDInputView *_authInputView;
    
    NSTimer * _countTimer;
    int _leftSeconds;
}

@end
