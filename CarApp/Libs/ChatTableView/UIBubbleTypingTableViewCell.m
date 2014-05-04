//
//  UIBubbleTypingTableCell.m
//  UIBubbleTableViewExample
//
//  Created by MacPro-Mr.Lu on 13-11-21.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import "UIBubbleTypingTableViewCell.h"

@interface UIBubbleTypingTableViewCell ()

@property (nonatomic, retain) UIImageView *typingImageView;

@end

@implementation UIBubbleTypingTableViewCell

+ (CGFloat)height
{
    return 40.0;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _typingImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_typingImageView];
    }
    return self;
}

/**
 *	设置显示默认在联系
 *
 *	@param	value	谁在输入
 */
- (void)setType:(NSBubbleTypingType)value
{
    if (value) {
        _type = value;
    }
    UIImage *bubbleImage = nil;
    CGFloat x = 0;
    
    if (value == NSBubbleTypingTypeMe)
    {
        bubbleImage = [UIImage imageNamed:@"typingMine.png"]; 
        x = self.frame.size.width - bubbleImage.size.width;
    }
    else
    {
        bubbleImage = [UIImage imageNamed:@"typingSomeone.png"]; 
        x = 0;
    }
    
    self.typingImageView.image = bubbleImage;
    self.typingImageView.frame = CGRectMake(x, 4, 73, 31);
}

@end
