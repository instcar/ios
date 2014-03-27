//
//  ProfileCompanyAddressViewController.h
//  CarApp
//
//  Created by 海龙 李 on 13-11-21.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeAddressDelegate;


@interface ProfileHomeAddressViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, assign) id<HomeAddressDelegate> delegate;


@end


@protocol HomeAddressDelegate <NSObject>

-(void)saveHomeAddress:(NSString *)address;

@end
