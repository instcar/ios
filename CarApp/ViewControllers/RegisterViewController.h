//
//  RegisterViewController.h
//  CarApp
//
//  Created by 海龙 李 on 13-11-6.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate>
{
    bool _inputCode;
    NSString *_phoneNum;                            //电话号码
    NSString *_authCode;                            //获取的验证码
    NSString *_sequenceNo;                          //验证码对应的序列号
    
    NSTimer * _countTimer;
    int _leftSeconds;
}

@property (retain, nonatomic) NSMutableDictionary *registerDic;//保存流程传递的数据

@end
