//
//  SingleChatViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-1-20.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XmppManager.h"

@interface SingleChatViewController : UIViewController<ChatDelegate,UIAlertViewDelegate>

@property (assign, nonatomic) long userID;
@property (copy, nonatomic) NSString *userName;

@end
