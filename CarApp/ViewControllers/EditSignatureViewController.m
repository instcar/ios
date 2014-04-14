//
//  EditSignatureViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-14.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "EditSignatureViewController.h"

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
    [self setCtitle:@"编辑签名"];
    [self setDesText:@"签名最大字数不超过40字"];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KOFFSETY, SCREEN_WIDTH, SCREEN_HEIGHT - KOFFSETY)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setScrollEnabled:YES];
    [_scrollView setAlwaysBounceVertical:YES];
    [self.view addSubview:_scrollView];
    [_scrollView release];

    UIImage * txfBackImg = [UIImage imageNamed:@"input_white_normal"];
    txfBackImg = [txfBackImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    UIImage * txfBackSelectedImg = [UIImage imageNamed:@"input_white_pressed"];
    txfBackSelectedImg = [txfBackSelectedImg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    //        UIImage * txfBackErrImg = [UIImage imageNamed:@"input_error@2x"];
    //        txfBackSelectedImg = [txfBackSelectedImg stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
    UIImageView *backGtextImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10,  15, 300, 105)];
    [backGtextImgView setImage:txfBackImg];
    [_scrollView addSubview:backGtextImgView];
    [backGtextImgView release];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(25, 25, 270, 85)];
    [textView  setBackgroundColor:[UIColor whiteColor]];
    [textView  setTextAlignment:NSTextAlignmentLeft];
    [textView  setTextColor:[UIColor colorWithRed:(float)63/255 green:(float)63/255 blue:(float)63/255 alpha:1.0]];
    [textView  setFont:[UIFont fontWithName:kFangZhengFont size:16]];
    [_scrollView addSubview:textView];
    [textView release];
    
    _lastWordLable = [[UILabel alloc]initWithFrame:CGRectMake(300 - 100, backGtextImgView.bounds.size.height - 20, 90, 15)];
    [_lastWordLable setFont:AppFont(12)];
    [_lastWordLable setText:@"剩余40个字"];
    [_lastWordLable setTextColor:[UIColor lightTextColor]];
    [backGtextImgView addSubview:_lastWordLable];
    [_lastWordLable release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
