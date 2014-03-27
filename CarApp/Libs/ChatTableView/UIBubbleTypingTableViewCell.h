//
//  UIBubbleTypingTableCell.h
//  UIBubbleTableViewExample
//
//  Created by MacPro-Mr.Lu on 13-11-21.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableView.h"


@interface UIBubbleTypingTableViewCell : UITableViewCell

+ (CGFloat)height;

@property (nonatomic) NSBubbleTypingType type;
@property (nonatomic) BOOL showAvatar;

@end
