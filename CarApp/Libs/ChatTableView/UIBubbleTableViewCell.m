//
//  UIBubbleTableViewCell.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <QuartzCore/QuartzCore.h>
#import "UIBubbleTableViewCell.h"
#import "NSBubbleData.h"
#import "UIButton+WebCache.h"

#define kAvterImageHeight 40.

@interface UIBubbleTableViewCell ()

@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UIButton *bubbleImage;

- (void) setupInternalData;

@end

@implementation UIBubbleTableViewCell

@synthesize data = _data;
@synthesize customView = _customView;
@synthesize bubbleImage = _bubbleImage;
@synthesize showAvatar = _showAvatar;
@synthesize avatarImage = _avatarImage;

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
	[self setupInternalData];
}

- (void) dealloc
{
    self.data = nil;
    self.customView = nil;
    self.bubbleImage = nil;
    self.avatarImage = nil;
    [super dealloc];
}

- (void)setDataInternal:(NSBubbleData *)value
{
	self.data = value;
	[self setupInternalData];
}

- (void) setupInternalData
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.bubbleImage)
    {
        self.bubbleImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bubbleImage setBackgroundColor:[UIColor clearColor]];
        [self.bubbleImage addTarget:self action:@selector(cellAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    NSBubbleType type = self.data.type;
    
    CGFloat width = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;

    CGFloat x = (type == BubbleTypeSomeoneElse) ? 0 : self.frame.size.width - width - self.data.insets.left - self.data.insets.right;
    CGFloat y = 0;
    
    // 设置聊天头像
    if (self.showAvatar)
    {
        [self.avatarImage removeFromSuperview];

        self.avatarImage = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([self.data.avatar hasPrefix:@"http://"]) {
           [self.avatarImage setImageWithURL:[NSURL URLWithString:self.data.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"delt_user_s"]];
        }
        else
        {
//            [self.avatarImage setImage:[UIImage imageNamed:self.data.avatar] forState:UIControlStateNormal];
            [self.avatarImage setImage:[UIImage imageNamed:@"delt_user_s"] forState:UIControlStateNormal];
        }
        //系统消息取消头像
        if (type == BubbleTypeSystem) {
            self.avatarImage.hidden = YES;
        }
        else
        {
            self.avatarImage.hidden = NO;
        }
        
        [self.avatarImage addTarget:self action:@selector(headImageTapAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //头像样式
        self.avatarImage.layer.cornerRadius = 20.0;
        self.avatarImage.layer.masksToBounds = YES;
        self.avatarImage.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        self.avatarImage.layer.borderWidth = 1.0;
        
        CGFloat avatarX = (type == BubbleTypeSomeoneElse) ? 4 : self.frame.size.width - 44;
//        CGFloat avatarY = self.frame.size.height - 40;//处于下方
        CGFloat avatarY = 8.0;//处于上方
        self.avatarImage.frame = CGRectMake(avatarX, avatarY, 40, 40); //设置头像的大小
        [self.contentView addSubview:self.avatarImage];
        
        CGFloat delta = self.frame.size.height - (self.data.insets.top + self.data.insets.bottom + self.data.view.frame.size.height);
        if (delta > 0) y = delta;
        if (type == BubbleTypeSomeoneElse) x += 54;
        if (type == BubbleTypeMine) x -= 54;
    }

    //显示内容视图
    [self.customView removeFromSuperview];
    self.customView = self.data.view;
    self.customView.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top, width, height);
    [self.customView setUserInteractionEnabled:NO];
    [self.contentView addSubview:self.customView];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    //设置接受的消息的背景
    if (type == BubbleTypeSystem) {
        [self.bubbleImage setBackgroundImage:[[UIImage imageNamed:@""] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        self.bubbleImage.frame = CGRectMake(x, y-3, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom+2);
        self.bubbleImage.center = self.contentView.center;
        self.bubbleImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.bubbleImage.layer.borderWidth = 1.0;
        self.bubbleImage.layer.cornerRadius = 4.0;
        self.customView.center = self.contentView.center;
    }
    else
    {
        if (type == BubbleTypeSomeoneElse)
        {
            self.avatarImage.tag = 1; //对方为1 自己为2
            [self.bubbleImage setBackgroundImage:[[UIImage imageNamed:@"bg_receive"] stretchableImageWithLeftCapWidth:10 topCapHeight:25] forState:UIControlStateNormal];
        }
        else {

            self.avatarImage.tag = 2; //对方为1 自己为2
            [self.bubbleImage setBackgroundImage:[[UIImage imageNamed:@"bg_send"] stretchableImageWithLeftCapWidth:10 topCapHeight:25] forState:UIControlStateNormal];

        }
        self.bubbleImage.frame = CGRectMake(x, y-3, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom+2);
    }
    [self.contentView insertSubview:self.bubbleImage belowSubview:self.customView];
    [self.bubbleImage setOpaque:YES];
    [self.avatarImage setOpaque:YES];
    [self.customView setOpaque:YES];
}

-(void)headImageTapAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headImageTapAction:)])
    {
        [self.delegate headImageTapAction:self.data.uid];
    }
}

-(void)cellAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellTouchAction:)]) {
        [self.delegate cellTouchAction:self.data];
    }
}

@end
