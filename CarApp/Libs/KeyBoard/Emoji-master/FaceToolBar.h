//
//  FaceToolBar.h
//  TestKeyboard
//
//  Created by wangjianle on 13-2-26.
//  Copyright (c) 2013年 wangjianle. All rights reserved.
//
#define Time  0.25
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//#define  keyboardHeight 216
#define  toolBarHeight 45
#define  choiceBarHeight 35
//#define  facialViewWidth 300
//#define facialViewHeight 170
#define  buttonWh 30
#import <UIKit/UIKit.h>
#import "FacialView.h"
#import "UIExpandingTextView.h"
#import "FaceAllView.h"
#import "ExtendView.h"

@protocol FaceToolBarDelegate;
@interface FaceToolBar : UIToolbar<facialViewDelegate,UIExpandingTextViewDelegate,UIScrollViewDelegate,FaceAllViewDelegate,ExtendViewDelegate>
{
    UIToolbar *toolBar;//工具栏
    UIExpandingTextView *textView;//文本输入框
    UIButton *faceButton ;
    UIButton *voiceButton;
    UIButton *addButton;
    
    BOOL keyboardIsShow;//键盘是否显示
    BOOL faceboardIsShow;//表情是否显示
    BOOL extendboardIsShow;//额外键盘是否显示
    
    UIScrollView *scrollView;//表情滚动视图
    FaceAllView *faceAllView;//表情有关视图
    ExtendView *extendView;//格外的键盘
    
    UIPageControl *pageControl;
    
    UIView *theSuperView;

    NSObject <FaceToolBarDelegate> *delegate;
    
    double keyboardHideTransitionDuration;
    UIViewAnimationCurve keyboardTransitionHideAnimationCurve;
    
}
@property(nonatomic,retain)UIView *theSuperView;
@property (retain,nonatomic) id<FaceToolBarDelegate> faceToolBarDelegate;
-(void)dismissKeyBoard;
-(id)initWithFrame:(CGRect)frame superView:(UIView *)superView;
@end

@protocol FaceToolBarDelegate <NSObject>
-(void)sendTextAction:(NSString *)inputText;
-(void)faceToolbarOrgYChangered:(FaceToolBar *)faceToolbar withHeight:(float)height;
-(void)extendViewselectedExtendView:(int)index;

@end
