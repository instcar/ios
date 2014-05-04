//
//  CarLogoTableViewCell.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-5-1.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarD.h"

@interface CarLogoTableViewCell : UITableViewCell
{
     UIImageView *_iconImgView;     //logo
     UILabel *_nameLabel;           //name
}

@property (strong, nonatomic) CarD *data;                   //数据

@end
