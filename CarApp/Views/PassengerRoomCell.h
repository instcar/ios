//
//  PassengerRoomCell.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-29.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"

@interface PassengerRoomCell : UITableViewCell

@property (strong, nonatomic) UIButton *imagerView;
@property (strong, nonatomic) UILabel *nameLable;
//@property (strong, nonatomic) UILabel *dayLable;
@property (strong, nonatomic) UILabel *timeLable;
@property (strong, nonatomic) UITextView *desLable;
@property (strong, nonatomic) UILabel *pubTimeLable;
@property (strong, nonatomic) UILabel *lastSeatLable;



@end
