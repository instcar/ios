//
//  ForgetPassWordViewController.h
//  CarApp
//
//  Created by 海龙 李 on 13-11-10.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPassWordViewController : UIViewController<UITextFieldDelegate>

{
    bool _inputCode;
    NSString *_phoneNum;                            //通过验证的手机号
    NSString *_authCode;                            //获取的验证码
    NSString *_sequenceNo;                          //验证码对应的序列号
    
    NSTimer * _countTimer;
    int _leftSeconds;
}

@end
