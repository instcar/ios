//
//  CustomLineTableViewCell.h
//  CarApp
//
//  Created by Mac_ZL on 14-6-1.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLineTableViewCell : UITableViewCell
{
    UILabel *_nameLabel;
    UILabel *_indexLabel;
    UIView *_lineView;
}
@property (assign,nonatomic) int index;
@property (strong,nonatomic) NSString *name;
@property (nonatomic) BOOL isHideBottomLine;
@end
