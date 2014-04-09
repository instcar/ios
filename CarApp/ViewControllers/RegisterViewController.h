//
//  RegisterViewController.h
//  CarApp
//
//  Created by 海龙 李 on 13-11-6.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GDInputView.h"

@interface RegisterViewController : BaseViewController<UITextFieldDelegate>
{
    NSString *_smsid;                               //smsid码
    NSString *_phoneNum;                            //电话号码
    
    NSTimer * _countTimer;
    int _leftSeconds;
    
    GDInputView *_inputView;                        //手机号输入框
    UIButton *_authBtn;                             //获取验证码
    GDInputView *_authInputView;                    //输入验证码
    GDInputView *_passInputView;                    //输入密码
    UIButton *_confirmBtn;                          //提交按钮
}

@property (retain, nonatomic) NSMutableDictionary *registerDic;//保存流程传递的数据

@end
