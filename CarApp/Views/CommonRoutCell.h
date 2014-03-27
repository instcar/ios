//
//  CommonRoutCell.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-2.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CommonLable:UIView

@property (copy, nonatomic) NSString *startStr;
@property (copy, nonatomic) NSString *startAddStr;
@property (copy, nonatomic) NSString *desAddStr;

@end

@interface CommonRoutCell : UITableViewCell

@property (retain, nonatomic) Line *data;
@property (retain, nonatomic) UIViewController *mainVC;

@end
