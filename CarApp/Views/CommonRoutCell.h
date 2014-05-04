//
//  CommonRoutCell.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-2.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Line.h"
@interface CommonLable:UIView

@property (copy, nonatomic) NSString *startStr;
@property (copy, nonatomic) NSString *startAddStr;
@property (copy, nonatomic) NSString *desAddStr;

@end

@interface CommonRoutCell : UITableViewCell

@property (strong, nonatomic) Line *data;
@property (strong, nonatomic) UIViewController *mainVC;

@end
