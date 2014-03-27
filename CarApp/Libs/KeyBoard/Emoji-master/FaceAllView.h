//
//  FaceAllView.h
//  PRJ_MrLu_GroupChat
//
//  Created by MacPro-Mr.Lu on 13-11-22.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacialView.h"

#define  keyboardHeight 216
#define  facialViewWidth 300
#define facialViewHeight 170

@protocol FaceAllViewDelegate;

@interface FaceAllView : UIView<UIScrollViewDelegate,facialViewDelegate>
{
    UIScrollView *_emojiScrollView;
    UIPageControl *_emojiPageControl;
    UITabBar *_tabBar;
}

@property (assign, nonatomic)id<facialViewDelegate,FaceAllViewDelegate> delegate;

@end

@protocol FaceAllViewDelegate <NSObject>

-(void)faceAllView:(FaceAllView *)faceAllView sendAction:(UIBarButtonItem *)sender;

@end