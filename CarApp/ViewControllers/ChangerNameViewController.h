//
//  ChangerNameViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-7.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangerNameDelegate;

@interface ChangerNameViewController : UIViewController

@property (nonatomic, assign) id<ChangerNameDelegate> delegate;


@end


@protocol ChangerNameDelegate <NSObject>

-(void)saveNickName:(NSString *)name;

@end

