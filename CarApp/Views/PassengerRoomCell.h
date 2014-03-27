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

@property (retain, nonatomic) UIButton *imagerView;
@property (retain, nonatomic) UILabel *nameLable;
//@property (retain, nonatomic) UILabel *dayLable;
@property (retain, nonatomic) UILabel *timeLable;
@property (retain, nonatomic) UITextView *desLable;
@property (retain, nonatomic) UILabel *pubTimeLable;
@property (retain, nonatomic) UILabel *lastSeatLable;



@end
