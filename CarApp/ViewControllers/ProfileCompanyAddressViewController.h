//
//  ProfileCompanyAddressViewController.h
//  CarApp
//
//  Created by 海龙 李 on 13-11-21.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CompanyAddressDelegate;

@interface ProfileCompanyAddressViewController : UIViewController

@property (nonatomic, assign) id<CompanyAddressDelegate> delegate;

//@property(retain,nonatomic)NSString * companyAddress;

@end

@protocol CompanyAddressDelegate <NSObject>

-(void)saveCompanyAddrress:(NSString *)address;

@end
