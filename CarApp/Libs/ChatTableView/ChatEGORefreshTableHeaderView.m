//
//  ChatEGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "ChatEGORefreshTableHeaderView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.05f


@interface ChatEGORefreshTableHeaderView (Private)
- (void)setState:(ChatEGOPullRefreshState)aState;
@end

@implementation ChatEGORefreshTableHeaderView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 10.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:9.0f];
		label.textColor = [UIColor whiteColor];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 10;
        label.layer.masksToBounds = YES;
        label.hidden = YES;
		[self addSubview:label];
		_statusLabel=label;
		
        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2 - 18, frame.size.height - 20.0f, 30.0f, 30.0f)];
//        view.layer.cornerRadius = 10;//设置那个圆角的有多圆
//        view.layer.masksToBounds = NO;//设为NO去试试
//        [view.layer setBorderWidth:2];
//        [view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//        view.backgroundColor = [UIColor colorWithRed:50/250.0 green:50/250.0 blue:50/250.0 alpha:1.0];
//        view.alpha = 0.5;
//        view.tag = 106;

		UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activeView.frame = CGRectMake(frame.size.width/2 - 8, frame.size.height + 0.0f, 10.0f, 10.0f);
		_activityView = activeView;
		[self addSubview:activeView];
		[self setState:ChatEGOOPullRefreshNormal];
		
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame  {
  return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters


- (void)setState:(ChatEGOPullRefreshState)aState{
	
	switch (aState) {
		case ChatEGOOPullRefreshPulling:
			_statusLabel.text = NSLocalizedString(@"释放加载", @"Release to refresh status");
            [_activityView setHidden:NO];
            [_activityView startAnimating];
			break;
		case ChatEGOOPullRefreshNormal:
			
			_statusLabel.text = NSLocalizedString(@"下拉加载更多", @"Pull down to refresh status");
            [_activityView setHidden:NO];
			[_activityView stopAnimating];
			
			break;
		case ChatEGOOPullRefreshLoading:
			
			_statusLabel.text = NSLocalizedString(@"加载中", @"Loading Status");
			[_activityView startAnimating];
			break;
        case ChatEGOOPullRefreshHitTheEnd:
            _statusLabel.text = NSLocalizedString(@"没有聊天记录了", @"Loading Status");
            [_activityView setHidden:YES];
			[_activityView stopAnimating];
			break;
            
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == ChatEGOOPullRefreshLoading) {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 35);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	}
    else
        if (scrollView.isDragging)
        {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == ChatEGOOPullRefreshPulling && scrollView.contentOffset.y > - 40.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:ChatEGOOPullRefreshNormal];
		} else if (_state == ChatEGOOPullRefreshNormal && scrollView.contentOffset.y < - 40.0f && !_loading) {
			[self setState:ChatEGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
//			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 35.0f && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:ChatEGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.05];
		scrollView.contentInset = UIEdgeInsetsMake(35.0f, 0.0f, 0.0f, 0.0f);
//        scrollView.contentInset = UIEdgeInsetsZero;
		[UIView commitAnimations];
		
	}
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.05f];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	[self setState:ChatEGOOPullRefreshNormal];

}

-(void)pullViewReachEnd
{
    [self setState:ChatEGOOPullRefreshHitTheEnd];
//    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
}


@end
