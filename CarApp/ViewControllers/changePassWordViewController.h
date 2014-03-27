//
//  changePassWordViewController.h
//  CarApp
//
//  Created by 海龙 李 on 13-11-12.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface changePassWordViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property (copy, nonatomic) NSString *phoneNum;
@end
