//
//  HZscrollerView.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-27.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "HZscrollerView.h"
#import "Judian.h"
#define kBannerScrollViewTag 10001

@implementation HZscrollerView
- (id)initWithFrame:(CGRect)frame withType:(int)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        UIScrollView * bannerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
        bannerScrollView.tag = kBannerScrollViewTag;
        [bannerScrollView setDelegate:self];
        [bannerScrollView setBackgroundColor:[UIColor clearColor]];
        [bannerScrollView setContentSize:CGSizeMake(320, 45)];
        [bannerScrollView setShowsHorizontalScrollIndicator:NO];
        [bannerScrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:bannerScrollView];
        
        [self reloadView];
    }
    return self;
}

-(void)reloadView
{
    UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:kBannerScrollViewTag];
    
    //清空容器
    for (UIView *sub in scrollView.subviews) {
        if([sub isKindOfClass:[UIButton class]])
        {
            [sub removeFromSuperview];
        }
    }
    
    //我的位置
    UIButton * infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    infoBtn.tag = 10;
    [infoBtn setFrame:CGRectMake(5, 7, 80, 32)];
    if (self.currentSelectIndex == 0)
    {
        [infoBtn setBackgroundColor:[UIColor colorWithRed:(float)255/255 green:(float)255/255 blue:(float)255/255 alpha:1]];
        if (_type==2) {
            [infoBtn setTitleColor:[UIColor appNavTitleBlueColor] forState:UIControlStateNormal];
        }
        else
        {
            [infoBtn setTitleColor:[UIColor appNavTitleGreenColor] forState:UIControlStateNormal];
        }
    }
    else
    {
        [infoBtn setBackgroundColor:[UIColor colorWithRed:(float)105/255 green:(float)156/255 blue:(float)65/255 alpha:1]];
        [infoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    infoBtn.layer.cornerRadius = 16;
    [infoBtn setTitle:@"离我最近" forState:UIControlStateNormal];
    [infoBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:13]];
    [infoBtn addTarget:self action:@selector(buttonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:infoBtn];

    float xoffset = 90.0;
    
    //数据
    for (int i = 0; i < [_data count]; i ++) {

        UIButton * infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [infoBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:13]];
        Judian *judian = [_data objectAtIndex:i];
        [infoBtn setTitle:judian.name forState:UIControlStateNormal];
        
        float width = [AppUtility widthForRect:CGRectMake(0, 0, 80, 32) WithText:judian.name font:[UIFont fontWithName:kFangZhengFont size:13]] + 10;
        
        [infoBtn setFrame:CGRectMake(xoffset, 7, width, 32)];
        xoffset = xoffset + width + 5;
        
        if (i+1 == self.currentSelectIndex)
        {
            [infoBtn setBackgroundColor:[UIColor colorWithRed:(float)255/255 green:(float)255/255 blue:(float)255/255 alpha:1]];
            if (_type == 2) {
                [infoBtn setTitleColor:[UIColor appNavTitleBlueColor] forState:UIControlStateNormal];
            }
            else
            {
                [infoBtn setTitleColor:[UIColor appNavTitleGreenColor] forState:UIControlStateNormal];
            }
        }
        else
        {
            [infoBtn setBackgroundColor:[UIColor colorWithRed:(float)105/255 green:(float)156/255 blue:(float)65/255 alpha:1]];
            [infoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        infoBtn.layer.cornerRadius = 16;
        infoBtn.tag = 10+i+1;
        
        [infoBtn addTarget:self action:@selector(buttonSelect:) forControlEvents:UIControlEventTouchUpInside];
        [infoBtn setShowsTouchWhenHighlighted:YES];
//        [infoBtn setTitle:[NSString stringWithFormat:@"btn:%d",i] forState:UIControlStateNormal];
        [scrollView addSubview:infoBtn];
    }
    CGSize size = scrollView.contentSize;
    size.width = xoffset;
    [scrollView setContentSize:size];
    
}

-(void)refleshView
{
    UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:kBannerScrollViewTag];
    for(int i = 0; i < [self.data count]+1; i++)
    {
        if ([[scrollView viewWithTag:10+i] isKindOfClass:[UIButton class]]) {
           UIButton *infoBtn = (UIButton *)[scrollView viewWithTag:10+i];
            if (i == self.currentSelectIndex)
            {
                [infoBtn setBackgroundColor:[UIColor colorWithRed:(float)255/255 green:(float)255/255 blue:(float)255/255 alpha:1]];
                if (_type == 2) {
                    [infoBtn setTitleColor:[UIColor appNavTitleBlueColor] forState:UIControlStateNormal];
                }
                else
                {
                    [infoBtn setTitleColor:[UIColor appNavTitleGreenColor] forState:UIControlStateNormal];
                }
            }
            else
            {
                [infoBtn setBackgroundColor:[UIColor colorWithRed:(float)105/255 green:(float)156/255 blue:(float)65/255 alpha:1]];
                [infoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
}

-(void)buttonSelect:(UIButton *)sender
{
    _currentSelectIndex = sender.tag-10;
    if (self.delegate && [self.delegate respondsToSelector:@selector(HZScrollerView:select:)]) {
        [self.delegate HZScrollerView:self select:sender.tag-10];
    }
    [self refleshView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
//    if (scrollView.contentOffset.y > scrollView.contentSize.width - 100) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(HZScrollerViewLoadmoreData)]) {
//            [self.delegate HZScrollerViewLoadmoreData];
//        }
//    }
//    else
//    {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(HZScrollerViewRefreshData)]) {
//            [self.delegate HZScrollerViewRefreshData];
//        }
//    }
}

-(void)setData:(NSArray *)data
{
    if (data) {
        _data = data;
    }
    [self reloadView];
}

-(void)setInitSelectIndex:(int)initSelectIndex
{
    if (initSelectIndex) {
        _initSelectIndex = initSelectIndex;
    }
    _currentSelectIndex = _initSelectIndex;
    [self refleshView];
}

-(int)currentSelectIndex
{
    return _currentSelectIndex;
}


@end
