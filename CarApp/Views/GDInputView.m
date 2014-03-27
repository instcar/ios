//
//  GDInputView.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-6.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "GDInputView.h"

@implementation GDInputView

-(void)dealloc
{
    [SafetyRelease release:_backGtextImgView];
    [SafetyRelease release:_arrowImgView];
    [SafetyRelease release:_textfield];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImage * txfBackImg = [UIImage imageNamed:@"input_white_normal"];
        txfBackImg = [txfBackImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        
        UIImage * txfBackSelectedImg = [UIImage imageNamed:@"input_white_pressed"];
        txfBackSelectedImg = [txfBackSelectedImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        
        self.backGtextImgView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)]autorelease];
        [self.backGtextImgView  setImage:txfBackImg];
        [self addSubview:self.backGtextImgView];
        
        self.arrowImgView = [[[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width - 22, self.bounds.size.height/2.0-6, 12, 12)]autorelease];
        [self.arrowImgView setImage:[UIImage imageNamed:@"ic_start_empty"]];
        [self.arrowImgView setHidden:NO];
        [self addSubview:self.arrowImgView];
        
        UIView *toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 39)];
        [toolBar setBackgroundColor:[UIColor clearColor]];
        
        UIButton * confirmKeyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmKeyBtn setTag:50006];
        [confirmKeyBtn setFrame:CGRectMake(320-63, 0, 63, 39)];
        [confirmKeyBtn setBackgroundColor:[UIColor clearColor]];
        [confirmKeyBtn setBackgroundImage:[UIImage imageNamed:@"btn_key_down@2x"] forState:UIControlStateNormal];
//        [confirmKeyBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmKeyBtn addTarget:self action:@selector(hideKeyBorad:) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:confirmKeyBtn];
        
        self.textfield = [[[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.bounds.size.width-30, self.bounds.size.height)]autorelease];
        [self.textfield setFont:[UIFont fontWithName:kFangZhengFont size:16]];
        [self.textfield setTextColor:UIColorFromRGB(0x2D2D2D)];
        [self.textfield setTextAlignment:0];
        [self.textfield setTag:30001];
        [self.textfield setDelegate:self];
        [self.textfield setBackgroundColor:[UIColor clearColor]];
        [self.textfield setBorderStyle:UITextBorderStyleNone];
        [self.textfield setPlaceholder:@""];
         self.textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.textfield setInputAccessoryView:toolBar];
        [toolBar release];
        
        [self.textfield setClearButtonMode:UITextFieldViewModeUnlessEditing];
        
        [self addSubview:self.textfield];

    }
    return self;
}

-(void)setResult:(kGDInputViewStatus)status
{
    UIImage * txfBackImg = [UIImage imageNamed:@"input_white_normal"];
    txfBackImg = [txfBackImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    UIImage * txfBackSelectedImg = [UIImage imageNamed:@"input_white_pressed"];
    txfBackSelectedImg = [txfBackSelectedImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    UIImage * txfBackErrImg = [UIImage imageNamed:@"input_error"];
    txfBackErrImg = [txfBackErrImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];

    
    switch (status) {
        case kGDInputViewStatusDisable:
        {
            [self.backGtextImgView setImage:txfBackImg];
            [self.arrowImgView setImage:[UIImage imageNamed:@"ic_start_empty"]];
        }
            break;
        case kGDInputViewStatusNomal:
        {
            [self.backGtextImgView setImage:txfBackSelectedImg];
            [self.arrowImgView setImage:[UIImage imageNamed:@"ic_start_empty"]];
        }
            break;
        case kGDInputViewStatusTure:
        {
            [self.backGtextImgView setImage:txfBackSelectedImg];
            [self.arrowImgView setImage:[UIImage imageNamed:@"ic_start_ture"]];
        }
            break;
        case kGDInputViewStatusError:
        {
            [self.backGtextImgView setImage:txfBackErrImg];
            [self.arrowImgView setImage:[UIImage imageNamed:@"ic_start_false@2x"]];
        }
            break;
        case kGDInputViewStatusNull:
        {
            [self.backGtextImgView setImage:txfBackImg];
            [self.arrowImgView setImage:[UIImage imageNamed:@"ic_start_empty@2x"]];
        }
            break;

        default:
            break;
    }
}

#pragma mark - keybord
-(void)hideKeyBorad:(UITapGestureRecognizer *)tappp
{
    [self downKeyBoard];
}

-(void)downKeyBoard
{
    [self.textfield resignFirstResponder];
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
