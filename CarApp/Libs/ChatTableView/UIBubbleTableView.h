//
//  UIBubbleTableView.h
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <UIKit/UIKit.h>

#import "UIBubbleTableViewDataSource.h"
#import "UIBubbleTableViewCell.h"
#import "ChatEGORefreshTableHeaderView.h"

typedef enum _NSBubbleTypingType
{
    NSBubbleTypingTypeNobody = 0,
    NSBubbleTypingTypeMe = 1,
    NSBubbleTypingTypeSomebody = 2
} NSBubbleTypingType;

@protocol UIBubbleTableViewDelegate;

@interface UIBubbleTableView : UITableView <UITableViewDelegate, UITableViewDataSource,UIBubbleTableViewCellDelegate,ChatEGORefreshTableHeaderDelegate>
{
    ChatEGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (nonatomic) NSTimeInterval snapInterval; //时间戳时间间隔
@property (nonatomic) NSBubbleTypingType typingBubble;
@property (nonatomic) BOOL showAvatars; //消失头像
//@property (nonatomic) CLLocationCoordinate2D someOneLocate;

@property (nonatomic, assign) id<UIBubbleTableViewDataSource> bubbleDataSource;
@property (assign, nonatomic)id<UIBubbleTableViewDelegate,UIBubbleTableViewCellDelegate,UIBubbleTableViewCellDelegate> bubbleTableViewDelegate;

-(void)scrollerToBottomWithAnimation:(BOOL)animated;

@end

@protocol UIBubbleTableViewDelegate <NSObject>

-(void)BubbleTableViewLoadMoreHistory:(UIBubbleTableView *)bubbleTableView;
-(void)BubbleTableViewHandleTouchEvent;
- (void)BubbleTableViewDidScroll:(UIScrollView *)scrollView;

@end

