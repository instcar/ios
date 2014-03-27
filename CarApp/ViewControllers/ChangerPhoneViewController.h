//
//  ChangerPhoneViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-5.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangerPhoneViewControllerDelegate;

@interface ChangerPhoneViewController : UIViewController<UITextFieldDelegate>
{
    NSTimer * _countTimer;
    int _leftSeconds;
}

@property (retain, nonatomic) id<ChangerPhoneViewControllerDelegate> delegate;

@end

@protocol ChangerPhoneViewControllerDelegate <NSObject>

-(void)savePhoneNum:(NSString *)phonenum;

@end