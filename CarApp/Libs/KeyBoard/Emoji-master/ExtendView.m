//
//  ExtendView.m
//  PRJ_MrLu_GroupChat
//
//  Created by MacPro-Mr.Lu on 13-11-22.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import "ExtendView.h"

@implementation ExtendView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"EmotionPanelBkg"]]];
    }
    return self;
}

-(void)loadExtendView:(int)page size:(CGSize)size row:(int)row column:(int)column
{
    _btnTitleArray = [NSArray arrayWithObjects:@"照片",@"拍摄",nil];
    _btnImageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"sharemore_pic@2x"],[UIImage imageNamed:@"sharemore_video@2x"],nil];
    //row number
	for (int i=0; i<row; i++) {
		//column numer
		for (int y=0; y<column; y++) {
            
            if ((i*column+y)+1>[_btnTitleArray count]) {
                return;
            }
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(y*size.width, i*self.frame.size.height/row, self.frame.size.width/column, self.frame.size.height/row)];
            view.backgroundColor = [UIColor clearColor];
            [self addSubview:view];
            
			UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button.layer setBorderColor:[UIColor blackColor].CGColor];
            [button.layer setCornerRadius:5.0];
            [button.layer setMasksToBounds:YES];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setFrame:CGRectMake(15, 10, size.width-30, size.height-30)];
//            button.center = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -110, 0)];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//            [button setTitle:[NSString stringWithFormat:@"%@",[_btnTitleArray objectAtIndex:(i*column+y)]] forState:UIControlStateNormal];
            [button setBackgroundImage:[_btnImageArray objectAtIndex:(i*column+y)] forState:UIControlStateNormal];
            [button setShowsTouchWhenHighlighted:YES];
             button.tag = i*column+y+((page-1)*row*column);
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
			[button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
			[view addSubview:button];
            
            UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, size.height-20, size.width, 15)];
            [title setTextColor:[UIColor appBlackColor]];
            [title setBackgroundColor:[UIColor clearColor]];
            [title setTextAlignment:NSTextAlignmentCenter];
            [title setFont:[UIFont fontWithName:kFangZhengFont size:14]];
            [title setText:[NSString stringWithFormat:@"%@",[_btnTitleArray objectAtIndex:(i*column+y)]]];
            [view addSubview:title];
		}
	}
}

-(void)selected:(UIButton*)btn
{
    DLog(@"selectExtendBtn %d",btn.tag);
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedExtendView:)]) {
        [self.delegate selectedExtendView:btn.tag];
    }
}



@end
