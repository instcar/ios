//
//  ProfileCell.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-4.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckLable.h"

@interface ProfileCell : UITableViewCell

@property(retain,nonatomic)UILabel * titleLabel;
@property(retain,nonatomic)UILabel * infoLabel;
@property(retain,nonatomic)CheckLable *checkLable;

@end
