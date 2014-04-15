//
//  ProFileEditTableViewCell.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-15.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProFileEditTableViewCell : UITableViewCell
{
    UILabel * _titleLabel;
    UILabel * _infoLabel;
}

@property (copy,nonatomic) NSString *titleStr;
@property (copy, nonatomic) NSString *infoStr;


@end
