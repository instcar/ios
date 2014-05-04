//
//  FaceAllView.m
//  PRJ_MrLu_GroupChat
//
//  Created by MacPro-Mr.Lu on 13-11-22.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import "FaceAllView.h"
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
@implementation FaceAllView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setView];
    }
    return self;
}

-(void)setView
{
    //创建表情键盘
    if (_emojiScrollView==nil) {
        _emojiScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        [_emojiScrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"EmotionPanelBkg"]]];
        [_emojiScrollView setBackgroundColor:[UIColor flatWhiteColor]];
        for (int i=0; i<9; i++) {
            FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(12+320*i, 15, facialViewWidth, facialViewHeight)];
            [fview setBackgroundColor:[UIColor clearColor]];
            [fview loadFacialView:i size:CGSizeMake(42.5, 43) row:3 column:7];
            fview.delegate=self;
            [_emojiScrollView addSubview:fview];
        }
    }
    
    [_emojiScrollView setShowsVerticalScrollIndicator:NO];
    [_emojiScrollView setShowsHorizontalScrollIndicator:NO];
    _emojiScrollView.contentSize=CGSizeMake(320*9, self.frame.size.height);
    _emojiScrollView.pagingEnabled=YES;
    _emojiScrollView.delegate=self;
    [self addSubview:_emojiScrollView];
    
    _emojiPageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(98, self.frame.size.height-80, 150, 30)];
    [_emojiPageControl setCurrentPage:0];
    if (kDeviceVersion >= 7.0) {
        [_emojiPageControl setTintColor:[UIColor darkGrayColor]];
    }
//    _emojiPageControl.pageIndicatorTintColor=RGBACOLOR(195, 179, 163, 1);
//    _emojiPageControl.currentPageIndicatorTintColor=RGBACOLOR(132, 104, 77, 1);
    _emojiPageControl.numberOfPages = 9;//指定页面个数
    [_emojiPageControl setBackgroundColor:[UIColor clearColor]];
//    _emojiPageControl.hidden=YES;
    [_emojiPageControl addTarget:self action:@selector(changeEmojiPage:)forControlEvents:UIControlEventValueChanged];
    [self addSubview:_emojiPageControl];
    
    UIToolbar *tabbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.frame.size.height-44, 320, 44)];
    tabbar.translucent = NO;
    tabbar.tintColor = [UIColor lightGrayColor];
    [self addSubview:tabbar];
    
    UIButton *emijiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [emijiBtn setBackgroundImage:[UIImage imageNamed:@"EmotionsBagTabBg@2x"] forState:UIControlStateNormal];
//    [emijiBtn setBackgroundImage:[UIImage imageNamed:@"EmotionsBagTabBgFocus@2x"] forState:UIControlStateHighlighted];
//    [emijiBtn setImage:[UIImage imageNamed:@"EmotionsEmojiHL@2x"] forState:UIControlStateNormal];
    [emijiBtn setFrame:CGRectMake(0, 0, 60, 44)];
    [emijiBtn setTintColor:[UIColor lightGrayColor]];
    [emijiBtn setTitle:@"emoji" forState:UIControlStateNormal];
    [emijiBtn addTarget:self action:@selector(emojiBtnAction:) forControlEvents:UIControlEventTouchDown];
//    UIBarButtonItem * emojiBarBtn = [[UIBarButtonItem alloc]initWithCustomView:emijiBtn];
    UIBarButtonItem *emojiBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"emoji" style:UIBarButtonItemStyleBordered target:self action:@selector(emojiBtnAction:)];
    
    emojiBarBtn.width = 60.0;
//    [emojiBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor],UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    UIButton *extendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [extendBtn setBackgroundImage:[UIImage imageNamed:@"EmotionsBagTabBg@2x"] forState:UIControlStateNormal];
//    [extendBtn setBackgroundImage:[UIImage imageNamed:@"EmotionsBagTabBgFocus@2x"] forState:UIControlStateHighlighted];
    [extendBtn setFrame:CGRectMake(0, 0, 60, 44)];
    [extendBtn setTintColor:[UIColor lightGrayColor]];
    [extendBtn setTitle:@"更多" forState:UIControlStateNormal];
//    [extendBtn setImage:[UIImage imageNamed:@"EmotionsBagAdd@2x"] forState:UIControlStateNormal];
    [extendBtn addTarget:self action:@selector(extendBtnAction:) forControlEvents:UIControlEventTouchDown];
    
//    UIBarButtonItem * extendBarBtn = [[UIBarButtonItem alloc]initWithCustomView:extendBtn];
     UIBarButtonItem * extendBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStyleBordered target:self action:@selector(extendBtnAction:)];
    extendBarBtn.width = 60.0;
//    [emojiBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor],UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem * spaceBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 44)];
//    [sendBtn setBackgroundImage:[UIImage imageNamed:@"EmotionsSendBtnBlue@2x"] forState:UIControlStateNormal];
//    [sendBtn setBackgroundImage:[UIImage imageNamed:@"EmotionsSendBtnBlueHL@2x"] forState:UIControlStateHighlighted];
    [sendBtn setTintColor:[UIColor lightGrayColor]];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchDown];
    
//    UIBarButtonItem * sendBarBtn = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    UIBarButtonItem * sendBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(sendBtnAction:)];
    sendBarBtn.width = 70.0;
//    [emojiBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor],UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    [tabbar setItems:[NSArray arrayWithObjects:emojiBarBtn,extendBarBtn,spaceBtn,sendBarBtn, nil] animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = _emojiScrollView.contentOffset.x / 320;//通过滚动的偏移量来判断目前页面所对应的小白点
    _emojiPageControl.currentPage = page;//pagecontroll响应值的变化
}


- (void)changeEmojiPage:(id)sender {
    int page = _emojiPageControl.currentPage;//获取当前pagecontroll的值
    [_emojiScrollView setContentOffset:CGPointMake(320 * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)selectedFacialView:(NSString *)str
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedFacialView:)]) {
        [self.delegate selectedFacialView:str];
    }
}

-(void)emojiBtnAction:(UIBarButtonItem *)sender
{
    DLog(@"emojiBtn");
}

-(void)extendBtnAction:(UIBarButtonItem *)sender
{
    DLog(@"extendBtn");
}

-(void)sendBtnAction:(UIBarButtonItem *)sender
{
    DLog(@"send");
    if (self.delegate && [self.delegate respondsToSelector:@selector(faceAllView:sendAction:)]) {
        [self.delegate faceAllView:self sendAction:sender];
    }
}

@end
