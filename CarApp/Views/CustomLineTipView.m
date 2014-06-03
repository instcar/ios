//
//  CustomLineTipView.m
//  CarApp
//
//  Created by Mac_ZL on 14-5-24.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CustomLineTipView.h"
#define TAG_TEXT_COLOR [UIColor colorWithRed:0 green:172 blue:0 alpha:1.0]
@interface CustomLineTipView()
@property(strong, nonatomic) NSMutableArray *recordArray;
@end
@implementation CustomLineTipView
@synthesize delegate;
- (void)dealloc
{
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isEnableTouch = YES;
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        //子线程调用接口
        __block typeof(self) bSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            [APIClient networkGetFavoriteLineListByPage:1 rows:3 success:^(Respone *respone) {
                //测试数据
                NSArray *tmpArray = @[@"回龙观西大街",@"燕郊",@"上地九街"];
                bSelf.recordArray = [NSMutableArray  arrayWithArray:tmpArray];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    [bSelf showTagBtn];
                });
            } failure:^(NSError *error) {
                
            }];
            
        });

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark - Inter
- (void)btnPressed:(UIButton *) sender
{
    if ([delegate respondsToSelector:@selector(tagBtnPressed:WithTagName:)])
    {
        [delegate tagBtnPressed:sender WithTagName:[sender titleForState:UIControlStateNormal]];
    }
}
#pragma mark - Function
- (void)showTagBtn
{
    int i = 0;
    _isHideBtn = NO;
    _isEnableTouch = YES;
    [self showTipView];
    for (NSString *name in _recordArray)
    {
        
        CGSize size = [name sizeWithFont:[UIFont fontWithName:kFangZhengFont size:14]];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(20, 10+60*i, size.width+30, 55)];
        [btn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:14]];
        [btn setBackgroundImage:[[UIImage imageNamed:@"bg_lucency@2x.png"] stretchableImageWithLeftCapWidth:55/2 topCapHeight:0]forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[[UIImage imageNamed:@"bg_lucency@2x.png"] stretchableImageWithLeftCapWidth:55/2 topCapHeight:0]forState:UIControlStateHighlighted];
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setTitle:name  forState:UIControlStateHighlighted];
        [btn setTitleColor:TAG_TEXT_COLOR forState:UIControlStateNormal];
        [btn setTitleColor:TAG_TEXT_COLOR forState:UIControlStateHighlighted];
        [self addSubview:btn];
        i++;
    }
}
- (void)hideTagBtn:(BOOL) isEnableTouch
{
    if (!_isHideBtn)
    {
        for (UIView *view in [self subviews])
        {
            [view removeFromSuperview];
        }
        _isHideBtn = YES;
    }
    _isEnableTouch = isEnableTouch;
   
}
- (void)showTipView
{
    [self setHidden:NO];
}
- (void)hideTipView
{
    [self hideTagBtn:NO];
    //父视图强制取消键盘
    [[self superview] endEditing:YES];
    [self setHidden:YES];
}
#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isEnableTouch) {
        [self hideTipView];
        if ([delegate respondsToSelector:@selector(tipViewDisapper)]) {
            [delegate tipViewDisapper];
        }
    }
}
   
@end
