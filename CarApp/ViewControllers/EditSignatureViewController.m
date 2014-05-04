//
//  EditSignatureViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-14.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "EditSignatureViewController.h"
#import "MBProgressHUD+Add.h"
#import "ProfileViewController.h"

@interface EditSignatureViewController ()

@end

@implementation EditSignatureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"编辑签名"];
    [self setMessageText:@"签名最大字数不超过40字"];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KOFFSETY, SCREEN_WIDTH, SCREEN_HEIGHT - KOFFSETY-44)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setScrollEnabled:YES];
    [_scrollView setAlwaysBounceVertical:YES];
    [self.view addSubview:_scrollView];

    UIImage * txfBackImg = [UIImage imageNamed:@"input_white_normal"];
    txfBackImg = [txfBackImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    UIImage * txfBackSelectedImg = [UIImage imageNamed:@"input_white_pressed"];
    txfBackSelectedImg = [txfBackSelectedImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    //        UIImage * txfBackErrImg = [UIImage imageNamed:@"input_error@2x"];
    //        txfBackSelectedImg = [txfBackSelectedImg stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
    UIImageView *backGtextImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10,  15, 300, 105)];
    [backGtextImgView setImage:txfBackImg];
    [backGtextImgView setUserInteractionEnabled:YES];
    [_scrollView addSubview:backGtextImgView];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, 290, 75)];
    [_textView setBackgroundColor:[UIColor clearColor]];
    [_textView setTextAlignment:NSTextAlignmentLeft];
    [_textView setDelegate:self];
    [_textView setTextColor:[UIColor colorWithRed:(float)63/255 green:(float)63/255 blue:(float)63/255 alpha:1.0]];
    if ([self.parentVC.formData valueForKey:@"signature"]) {
        [_textView setText:[self.parentVC.formData valueForKey:@"signature"]];
    }
    else
        [_textView setText:self.peopleInfo.detail.signature];
    [_textView  setFont:[UIFont fontWithName:kFangZhengFont size:14]];
    [backGtextImgView addSubview:_textView];
    
    _lastWordLable = [[UILabel alloc]initWithFrame:CGRectMake(300 - 90, backGtextImgView.bounds.size.height - 20, 80, 15)];
    [_lastWordLable setFont:AppFont(12)];
    [_lastWordLable setText:@"剩余40个字"];
    [_lastWordLable setTextColor:[UIColor lightGrayColor]];
    [_lastWordLable setBackgroundColor:[UIColor clearColor]];
    [backGtextImgView addSubview:_lastWordLable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] > 80) {
        [MBProgressHUD showError:@"字数不能超过40字" toView:self.view];
        return NO;
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    DLog(@"长度%d",[textView.text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]/2);
    if ([textView.text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] > 80) {
        [MBProgressHUD showError:@"字数不能超过40字" toView:self.view];
    }
    else
    {
        [_lastWordLable setText:[NSString stringWithFormat:@"剩余%d个字",40 -([textView.text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]/2)]];
    }

}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)backAction:(UIButton *)sender
{
    if (![_textView.text isEqualToString:self.peopleInfo.detail.signature] || ![self.parentVC.formData valueForKey:@"signature"]) {
        [self.parentVC.formData setValue:_textView.text forKey:@"signature"];
    }
    
    [super backAction:sender];
}

@end
