//
//  CusLocateInputView.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-5-3.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CusLocateInputView.h"

@implementation CusLocateInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //起点输入
        UILabel *startLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, 25)];
        [startLable setText:@"起点:"];
        [startLable setBackgroundColor:[UIColor clearColor]];
        [startLable setFont:AppFont(14)];
        [startLable setTextColor:[UIColor whiteColor]];
        [self addSubview:startLable];
        
        //定位显示坐标
//        UILabel *startLocateLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 200, 25)];
//        [startLocateLable setText:@""];
//        [startLocateLable setBackgroundColor:[UIColor clearColor]];
//        [startLocateLable setFont:AppFont(14)];
//        [startLocateLable setTextColor:[UIColor whiteColor]];
//        [self addSubview:startLocateLable];
//        _startLocateLable = startLocateLable;
        
        _activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_activity setHidesWhenStopped:YES];
        
        UIView *toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 39)];
        [toolBar setBackgroundColor:[UIColor clearColor]];
        
        UIButton * confirmKeyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmKeyBtn setTag:50006];
        [confirmKeyBtn setFrame:CGRectMake(320-63, 0, 63, 39)];
        [confirmKeyBtn setBackgroundColor:[UIColor clearColor]];
        [confirmKeyBtn setBackgroundImage:[UIImage imageNamed:@"btn_key_down@2x"] forState:UIControlStateNormal];
        [confirmKeyBtn addTarget:self action:@selector(hideKeyBorad:) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:confirmKeyBtn];
        
        //手动输入label
        UITextField *startInputView = [[UITextField alloc]initWithFrame:CGRectMake(50, 10, 200, 25)];
        [startInputView setBorderStyle:UITextBorderStyleNone];
        [startInputView setBackgroundColor:[UIColor clearColor]];
        [startInputView setFont:AppFont(14)];
        [startInputView setTextColor:[UIColor whiteColor]];
        [startInputView setDelegate:self];
        [startInputView setLeftViewMode:UITextFieldViewModeUnlessEditing];
        [startInputView setAdjustsFontSizeToFitWidth:YES];
        _startInputView = startInputView;
        [_startInputView setInputAccessoryView:toolBar];
        [self addSubview:startInputView];
        
        //定位按钮
        _locateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locateBtn setFrame:CGRectMake(self.frame.size.width - 60, 5, 35, 35)];
        [_locateBtn setBackgroundColor:[UIColor redColor]];
        [_locateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_locateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [_locateBtn addTarget:self action:@selector(locateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_locateBtn];
        
    }
    return self;
}

- (void)locateBtnAction:(UIButton *)sender
{
    [_startInputView setLeftView:_activity];
//    [_startLocateLable setText:@""];
    [_activity startAnimating];
    if(self.delegate && [self.delegate respondsToSelector:@selector(locateBtnAction:)])
    {
        [self.delegate locateBtnAction:sender];
    }
}

- (void)inputModeChange:(int)type
{
    [UIView beginAnimations:@"inputViewAnimation" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    if (type == 1) {
        [_startInputView setFont:AppFont(14)];
        [_startInputView setFrame:CGRectMake(50, 10, 200, 25)];
    }
    if (type == 2) {
        [_startInputView setFont:AppFont(16)];
        [_startInputView setFrame:CGRectMake(30, 35, 240, 20)];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(inputModeChange:)])
    {
        [self.delegate inputModeChange:type];
    }
    
    [UIView commitAnimations];
    

}

- (void)setLocateAddress:(NSString *)locateAddress
{
    [_activity stopAnimating];
    [_startInputView setLeftView:nil];
    //刷新定位位置
    [_startInputView setText:locateAddress];
    [_startInputView setLeftViewMode:UITextFieldViewModeUnlessEditing];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self inputModeChange:2];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self inputModeChange:1];
}

#pragma mark - keybord
-(void)hideKeyBorad:(UITapGestureRecognizer *)tappp
{
    [self downKeyBoard];
    
}

-(void)downKeyBoard
{
    [_startInputView resignFirstResponder];
}

@end
