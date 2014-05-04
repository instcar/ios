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
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImage * txfBackImg = [UIImage imageNamed:@"input_normal"];
        txfBackImg = [txfBackImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        
        UIImage * txfBackSelectedImg = [UIImage imageNamed:@"input_pressed"];
        txfBackSelectedImg = [txfBackSelectedImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        
        _backGtextImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [_backGtextImgView  setImage:txfBackImg];
        [self addSubview:_backGtextImgView];
        
        _arrowImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width - 24, self.bounds.size.height/2.0-8, 16, 16)];
        [_arrowImgView setImage:[UIImage imageNamed:@"ic_agree_no"]];
        [_arrowImgView setHidden:NO];
        [self addSubview:_arrowImgView];
        
        UIView *toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 39)];
        [toolBar setBackgroundColor:[UIColor clearColor]];
        
        UIButton * confirmKeyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmKeyBtn setTag:50006];
        [confirmKeyBtn setFrame:CGRectMake(320-63, 0, 63, 39)];
        [confirmKeyBtn setBackgroundColor:[UIColor clearColor]];
        [confirmKeyBtn setBackgroundImage:[UIImage imageNamed:@"btn_key_down@2x"] forState:UIControlStateNormal];
        [confirmKeyBtn addTarget:self action:@selector(hideKeyBorad:) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:confirmKeyBtn];
        
        _textfield = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.bounds.size.width-30, self.bounds.size.height)];
        [_textfield setFont:[UIFont fontWithName:kFangZhengFont size:16]];
        [_textfield setTextColor:UIColorFromRGB(0x2D2D2D)];
        [_textfield setTextAlignment:0];
        [_textfield setTag:30001];
        [_textfield setClearsOnBeginEditing:YES];
        [_textfield setDelegate:self];
        [_textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_textfield setBackgroundColor:[UIColor clearColor]];
        [_textfield setBorderStyle:UITextBorderStyleNone];
        [_textfield setPlaceholder:@""];
         _textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_textfield setInputAccessoryView:toolBar];
        
        [self addSubview:_textfield];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];

    }
    return self;
}

-(void)setResult:(kGDInputViewStatus)status
{
    UIImage * txfBackImg = [UIImage imageNamed:@"input_normal"];
    txfBackImg = [txfBackImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    UIImage * txfBackSelectedImg = [UIImage imageNamed:@"input_selected"];
    txfBackSelectedImg = [txfBackSelectedImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    UIImage * txfBackErrImg = [UIImage imageNamed:@"input_error"];
    txfBackErrImg = [txfBackErrImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];

    switch (status) {
        case kGDInputViewStatusDisable:
        {
            [_backGtextImgView setImage:txfBackImg];
            [_arrowImgView setImage:[UIImage imageNamed:@"ic_agree_no"]];
        }
            break;
        case kGDInputViewStatusNomal:
        {
//            [_backGtextImgView setImage:txfBackSelectedImg];
            [_arrowImgView setImage:[UIImage imageNamed:@"ic_agree_no"]];
        }
            break;
        case kGDInputViewStatusTure:
        {
//            [_backGtextImgView setImage:txfBackSelectedImg];
            [_arrowImgView setImage:[UIImage imageNamed:@"ic_agree_ok"]];
        }
            break;
        case kGDInputViewStatusError:
        {
            [_backGtextImgView setImage:txfBackErrImg];
            [_arrowImgView setImage:[UIImage imageNamed:@"ic_error"]];
        }
            break;
        case kGDInputViewStatusNull:
        {
            [_backGtextImgView setImage:txfBackImg];
            [_arrowImgView setImage:[UIImage imageNamed:@"ic_agree_no"]];
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

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidChanged:(UITextField *)textField
{
    if (self.gdInputDelegate && [self.gdInputDelegate respondsToSelector:@selector(textFieldDidChanged:)]) {
        [self.gdInputDelegate textFieldDidChanged:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UIImage * txfBackImg = [UIImage imageNamed:@"input_normal"];
    txfBackImg = [txfBackImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    [_backGtextImgView setImage:txfBackImg];
    
    if ([textField.text length] > 0) {
        [self setResult:kGDInputViewStatusTure];
    }
    else
    {
        [self setResult:kGDInputViewStatusNomal];
    }
    
    if (self.gdInputDelegate && [self.gdInputDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.gdInputDelegate textFieldDidEndEditing:textField];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    UIImage * txfBackSelectedImg = [UIImage imageNamed:@"input_selected"];
    txfBackSelectedImg = [txfBackSelectedImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    [_backGtextImgView setImage:txfBackSelectedImg];
//    [_arrowImgView setImage:[UIImage imageNamed:@"ic_agree_no"]];
    [self setResult:kGDInputViewStatusNomal];
    
    if (self.gdInputDelegate && [self.gdInputDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.gdInputDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //    if (textField.tag == kCodeTextFieldTag) {
    //        [_codeInputView setResult:kGDInputViewStatusNomal];
    //    }
    //    if (textField.tag == kUseTextFieldTag) {
    //        [_userInputView setResult:kGDInputViewStatusNomal];
    //    }
    
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    
    if (self.gdInputDelegate && [self.gdInputDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        [self.gdInputDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

@end
