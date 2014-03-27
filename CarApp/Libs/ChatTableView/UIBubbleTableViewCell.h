//
//  UIBubbleTableViewCell.h
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <UIKit/UIKit.h>
#import "NSBubbleData.h"

@protocol UIBubbleTableViewCellDelegate;

@interface UIBubbleTableViewCell : UITableViewCell

@property (nonatomic, retain) NSBubbleData *data;
@property (nonatomic) BOOL showAvatar;
@property (assign, nonatomic)id<UIBubbleTableViewCellDelegate> delegate;
@property (nonatomic, retain) UIButton *avatarImage;

@end

@protocol UIBubbleTableViewCellDelegate <NSObject>

@optional

-(void)headImageTapAction:(long)userid;
-(void)cellTouchAction:(NSBubbleData *)data;

@end