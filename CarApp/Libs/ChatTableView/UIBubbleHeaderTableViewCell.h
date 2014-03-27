//
//  UIBubbleHeaderTableViewCell.h
//  UIBubbleTableViewExample
//
//  Created by MacPro-Mr.Lu on 13-11-21.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NSBubbleData.h"

/**
 *	记录前显示时间戳和定位信息
 */
@interface UIBubbleHeaderTableViewCell : UITableViewCell

+ (CGFloat)height;

@property (nonatomic, retain) NSDate					*date;	// 时间信息
//@property (nonatomic, assign) CLLocationCoordinate2D	locate;	// 位置信息

@end

