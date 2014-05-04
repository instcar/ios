//
//  CommentDetailViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-11.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"

@interface CommentDetailViewController : UIViewController
@property (strong, nonatomic)Room *room;//房间信息
@property (assign, nonatomic)long userid;//评论用户id
@end
