 //
//  UIBubbleTableView.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import "UIBubbleTableView.h"
#import "NSBubbleData.h"
#import "UIBubbleHeaderTableViewCell.h"
#import "UIBubbleTypingTableViewCell.h"

#define kCellDefaultHeight 40.

@interface UIBubbleTableView ()

@property (nonatomic, retain) NSMutableArray *bubbleSection;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end

@implementation UIBubbleTableView


- (void)dealloc
{
    [_bubbleSection release];
	_bubbleSection = nil;
	_bubbleDataSource = nil;
    [super dealloc];
}

#pragma mark - Initializators

- (void)initializator
{
    // UITableView properties
    
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    assert(self.style == UITableViewStylePlain);
    
    self.delegate = self;
    self.dataSource = self;
    
    self.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    
    // UIBubbleTableView default properties
    self.snapInterval = 120; //设置时间间隔，用来显示聊天的时间
    self.typingBubble = NSBubbleTypingTypeNobody;
    self.showAvatars = YES;
    self.clipsToBounds = YES;
//    self.editing = YES;
    
    if (_refreshHeaderView == nil) {
        
        ChatEGORefreshTableHeaderView *view1 = [[ChatEGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,-self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
        
        view1.delegate = self;
        
        [self addSubview:view1];
        
        _refreshHeaderView = view1;
        
        [view1 release];
        
    }
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self)
    {
      [self initializator];
    }
    return self;
}

#pragma mark - Override

- (void)reloadData
{
    self.showsVerticalScrollIndicator = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.scrollIndicatorInsets = UIEdgeInsetsMake(28, 0, 0, 0);
    // Cleaning up
	self.bubbleSection = nil;
    
    // Loading new data
    int count = 0;
    
    self.bubbleSection = [[[NSMutableArray alloc] init] autorelease];
    
    if (self.bubbleDataSource && (count = [self.bubbleDataSource rowsForBubbleTable:self]) > 0)
    {
        NSMutableArray *bubbleData = [[[NSMutableArray alloc] initWithCapacity:count] autorelease];
        
        for (int i = 0; i < count; i++)
        {
            NSObject *object = [self.bubbleDataSource bubbleTableView:self dataForRow:i];
            assert([object isKindOfClass:[NSBubbleData class]]);
            [bubbleData addObject:object];
        }
        
        NSDate *last = [NSDate dateWithTimeIntervalSince1970:0];
        NSMutableArray *currentSection = nil;
        
        for (int i = 0; i < count; i++)
        {
            NSBubbleData *data = (NSBubbleData *)[bubbleData objectAtIndex:i];
            
            if ( fabs([data.date timeIntervalSinceDate:last]) > self.snapInterval || data.type == BubbleTypeSystem)
            {
                currentSection = [[[NSMutableArray alloc] init] autorelease];
                [self.bubbleSection addObject:currentSection];
            }
            
            [currentSection addObject:data];
            last = data.date;
        }
    }
    [super reloadData];
}

-(void)scrollerToBottomWithAnimation:(BOOL)animated
{
    if ([self.bubbleDataSource rowsForBubbleTable:self] > 0)
    {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self numberOfRowsInSection:[self.bubbleSection count]-1]-1 inSection:[self.bubbleSection count]-1] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

#pragma mark - UITableViewDelegate implementation

#pragma mark - UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int result = [self.bubbleSection count];
    if (self.typingBubble != NSBubbleTypingTypeNobody) result++;
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // This is for now typing bubble
	if (section >= [self.bubbleSection count]) return 1;
    
    return [[self.bubbleSection objectAtIndex:section] count] + 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Now typing
	if (indexPath.section >= [self.bubbleSection count])
    {
        return MAX([UIBubbleTypingTableViewCell height]+10, self.showAvatars ? kCellDefaultHeight : 0);
    }
    
    // Header
    if (indexPath.row == 0)
    {
        return [UIBubbleHeaderTableViewCell height];
    }
    
    NSBubbleData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
    return MAX(data.insets.top + data.view.frame.size.height + data.insets.bottom, self.showAvatars ? kCellDefaultHeight : 0)+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Now typing
	if (indexPath.section >= [self.bubbleSection count])
    {
        static NSString *KBubbleTypingCell = @"tblBubbleTypingCell";
        UIBubbleTypingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KBubbleTypingCell];
        
        if (cell == nil)
        {
           cell = [[[UIBubbleTypingTableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease];
        }

        cell.type = self.typingBubble;
        cell.showAvatar = self.showAvatars;
        
        return cell;
    }

    // Header with date and time
    if (indexPath.row == 0)
    {
        static NSString * kBubbleHeaderCell = @"tblBubbleHeaderCell";
        UIBubbleHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBubbleHeaderCell];
        NSBubbleData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:0];
        
        if (cell == nil)
        {
            cell = [[[UIBubbleHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease];
        }
        cell.date = data.date;
        
        //处理位置信息
//        if (data.type == BubbleTypeMine && self.someOneLocate.latitude && self.someOneLocate.longitude) {
//            cell.locate = self.someOneLocate;
//        }
//        else
//        {
//            cell.locate = data.locate;
//        }
       
        return cell;
    }
    
    // Standard bubble    
    static NSString *kBubbleCell = @"tblBubbleCell";
    UIBubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBubbleCell];
    NSBubbleData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
    
    if (cell == nil)
    {
        cell = [[[UIBubbleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease];
    }
    
    cell.delegate = self.bubbleTableViewDelegate;
    cell.data = data;
    cell.showAvatar = self.showAvatars;
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleInsert;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
//        //        获取选中删除行索引值
//        NSInteger row = [indexPath row];
//        //        通过获取的索引值删除数组中的值
//        [self.listData removeObjectAtIndex:row];
//        //        删除单元格的某一行时，在用动画效果实现删除过程
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if(editingStyle==UITableViewCellEditingStyleInsert)
    {
        
//        i=i+1;
//        NSInteger row = [indexPath row];
//        NSArray *insertIndexPath = [NSArray arrayWithObjects:indexPath, nil];
//        NSString *mes = [NSString stringWithFormat:@"添加的第%d行",i];
//        //        添加单元行的设置的标题
//        [self.listData insertObject:mes atIndex:row];
//        [tableView insertRowsAtIndexPaths:insertIndexPath withRowAnimation:UITableViewRowAnimationRight];
    }
}

#pragma mark –
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    _reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    
    _reloading = NO;
    
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    
    if (self.bubbleTableViewDelegate && [self.bubbleTableViewDelegate respondsToSelector:@selector(BubbleTableViewLoadMoreHistory:)]) {
        [self.bubbleTableViewDelegate BubbleTableViewLoadMoreHistory:self];
    }
}

#pragma mark –

#pragma mark EGORefreshTableHeaderDelegate Methods

//确实开始刷新

- (void)egoRefreshTableHeaderDidTriggerRefresh:(ChatEGORefreshTableHeaderView*)view{
    
    
    [self reloadTableViewDataSource];
    
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.05];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(ChatEGORefreshTableHeaderView*)view{
    
    return _reloading;
}

#pragma mark 处理视图滚动事件

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.bubbleTableViewDelegate && [self.bubbleTableViewDelegate respondsToSelector:@selector(BubbleTableViewHandleTouchEvent)]) {
        [self.bubbleTableViewDelegate BubbleTableViewHandleTouchEvent];
    }
}

-(BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return YES;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

}

#pragma mark –

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.bubbleTableViewDelegate && [self.bubbleTableViewDelegate respondsToSelector:@selector(BubbleTableViewHandleTouchEvent)]) {
        [self.bubbleTableViewDelegate BubbleTableViewHandleTouchEvent];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
     [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    if (self.bubbleTableViewDelegate && [self.bubbleTableViewDelegate respondsToSelector:@selector(BubbleTableViewDidScroll:)]) {
        [self.bubbleTableViewDelegate BubbleTableViewDidScroll:scrollView];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

@end
