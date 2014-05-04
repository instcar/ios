//
//  GDCustomAlertView.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-6.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "GDCustomAlertView.h"

@interface GDCustomAlertView ()

@property(nonatomic, strong) NSMutableArray *buttonArrays;
@property(nonatomic, assign) CGRect frame;
@end

@implementation GDCustomAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithImage:(UIImage *)image frame:(CGRect)frame contentImage:(UIImage *)content{
    if (self = [super init]) {
        
        self.backgroundImage = image;
        self.contentImage = content;
        self.buttonArrays = [NSMutableArray arrayWithCapacity:4];
        self.frame = frame;
    }
    return self;
}

-(void) addButtonWithUIButton:(UIButton *) btn
{
    [_buttonArrays addObject:btn];
}


- (void)drawRect:(CGRect)rect {
    CGSize imageSize = self.backgroundImage.size;
    [self.backgroundImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
//    [self.backgroundImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    
}

- (void) layoutSubviews {
    //屏蔽系统的ImageView 和 UIButton
    for (UIView *v in [self subviews]) {
        if ([v class] == [UIImageView class]){
            [v setHidden:YES];
        }
        
        if ([v isKindOfClass:[UIButton class]] ||
            [v isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {
            [v setHidden:YES];
        }
    }
    
    for (int i=0;i<[_buttonArrays count]; i++) {
        UIButton *btn = [_buttonArrays objectAtIndex:i];
        btn.tag = i;
        [self addSubview:btn];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (_contentImage) {
        
        UIImageView *contentview = [[UIImageView alloc] initWithImage:self.contentImage];
//        contentview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        contentview.frame = CGRectMake(0, 0, _backgroundImage.size.width, _backgroundImage.size.height);
        [self addSubview:contentview];
    }
}

-(void) buttonClicked:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    
    if (_GDdelegate) {
        if ([_GDdelegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)])
        {
            [_GDdelegate customAlertView:self clickedButtonAtIndex:btn.tag];
        }
    }
    
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) show {
    
    [super show];
    
    CGSize imageSize = self.backgroundImage.size;
     self.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
//    self.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}


- (void)dealloc {
    [_buttonArrays removeAllObjects];

    if (_contentImage) {
        _contentImage = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
