//
//  CustomSearchBarControl.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-14.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CustomSearchBarControl.h"
#import "BDVoiceRecognitionClient.h"
#import "BDVRCustomRecognitonViewController.h"
#import "JSONKit.h"

#define API_KEY @"8MAxI5o7VjKSZOKeBzS4XtxO"
#define SECRET_KEY @"Ge5GXVdGQpaxOmLzc8fOM8309ATCz9Ha"

@interface CustomSearchBarControl()

@property (nonatomic, retain) BDVRCustomRecognitonViewController *recognizerViewController;
@property (nonatomic, retain) BDVRRawDataRecognizer *rawDataRecognizer;
@property (nonatomic, retain) BDVRFileRecognizer *fileRecognizer;

@end

@implementation CustomSearchBarControl

-(void)dealloc
{
    [SafetyRelease release:_recognizerViewController];
    [SafetyRelease release:_rawDataRecognizer];
    [SafetyRelease release:_fileRecognizer];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y,  320, 52)];
        _searchBarstyle = kSearchBarStyleGreen;
        [self setView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withStyle:(kSearchBarStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        _searchBarstyle = style;
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y,  320, 52)];
        [self setView];
    }
    return self;
}

- (void)setView
{
    UIImageView * searchBackGroundImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 52)];
    [searchBackGroundImgView setTag:7080];
    [searchBackGroundImgView setUserInteractionEnabled:YES];
    [searchBackGroundImgView setBackgroundColor:[UIColor colorWithRed:(float)243/255 green:(float)243/255 blue:(float)243/255 alpha:1]];
    searchBackGroundImgView.clipsToBounds = NO;
    [self addSubview:searchBackGroundImgView];
    [searchBackGroundImgView release];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 51.5, 320, 0.5)];
    [lineView setBackgroundColor:[UIColor appLineDarkGrayColor]];
    [searchBackGroundImgView addSubview:lineView];
    [lineView release];
    
    UIImageView * searchBarImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 300, 32)];
    [searchBarImgView setUserInteractionEnabled:YES];
    [searchBarImgView setBackgroundColor:[UIColor clearColor]];
    [searchBarImgView setImage:[[UIImage imageNamed:@"bg_search_pressed"] stretchableImageWithLeftCapWidth:15 topCapHeight:5]];
    [searchBackGroundImgView addSubview:searchBarImgView];
    [searchBarImgView release];
    
    UIImageView *searchIconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_search"]];
    searchIconView.frame = CGRectMake(20, (52-15)/2, 15, 15);
    [searchBackGroundImgView addSubview:searchIconView];
    [searchIconView release];
    
    UILabel * placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 6, 50, 20)];
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [placeholderLabel setText:@"我要去:"];
    [placeholderLabel setTextAlignment:NSTextAlignmentLeft];
    [placeholderLabel setTextColor:[UIColor appDarkGrayColor]];
    [placeholderLabel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [searchBarImgView addSubview:placeholderLabel];
    [placeholderLabel release];
    
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
    
    
    UITextField * searchTxF = [[UITextField alloc]initWithFrame:CGRectMake(70, 6, 176, 20)];
    [searchTxF setTag:8080];
    [searchTxF setBackgroundColor:[UIColor clearColor]];
    [searchTxF setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [searchTxF setDelegate:self];
    [searchTxF setReturnKeyType:UIReturnKeySearch];
    [searchTxF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchTxF setInputAccessoryView:toolBar];
    [searchBarImgView addSubview:searchTxF];
    [searchTxF release];
    
    UIButton * speechSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [speechSearchBtn setFrame:CGRectMake(250, 11, 60, 32)];
    speechSearchBtn.showsTouchWhenHighlighted = YES;
    if (_searchBarstyle == kSearchBarStyleGreen) {
        [speechSearchBtn setBackgroundImage:[UIImage imageNamed:@"btn_voice_normal@2x"] forState:UIControlStateNormal];
        [speechSearchBtn setBackgroundImage:[UIImage imageNamed:@"btn_voice_pressed@2x"] forState:UIControlStateHighlighted];
    }
    if (_searchBarstyle == kSearchBarStyleBlue) {
        [speechSearchBtn setBackgroundImage:[UIImage imageNamed:@"btn_voice_blue_normal@2x"] forState:UIControlStateNormal];
        [speechSearchBtn setBackgroundImage:[UIImage imageNamed:@"btn_voice_blue_pressed@2x"] forState:UIControlStateHighlighted];
    }

    [speechSearchBtn addTarget:self action:@selector(speechSearchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [searchBackGroundImgView addSubview:speechSearchBtn];

}

-(void)speechSearchBtnClicked:(UIButton *)sender
{
    //发起语音搜索
    DLog(@"发起语音搜索");
    UITextField * txf = (UITextField *)[self viewWithTag:8080];
    [txf resignFirstResponder];
    [self showSdkUIRecognitionAction];
}

#pragma mark - 语音识别
- (void)showSdkUIRecognitionAction
{
    //    // 创建识别控件
    //    BDRecognizerViewController *tmpRecognizerViewController = [[BDRecognizerViewController alloc] initWithOrigin:CGPointMake(9, 128) withTheme:[BDTheme lightBlueTheme]];
    //    tmpRecognizerViewController.delegate = self;
    //    self.recognizerViewController = tmpRecognizerViewController;
    //    [tmpRecognizerViewController release];
    //
    //    // 设置识别参数
    //    BDRecognizerViewParamsObject *paramsObject = [[BDRecognizerViewParamsObject alloc] init];
    //
    //    // 开发者信息
    //    paramsObject.apiKey = API_KEY;
    //    paramsObject.secretKey = SECRET_KEY;
    //
    //    // 设置是否需要语义理解，只在搜索模式有效
    //    paramsObject.isNeedNLU = YES;
    //
    //    // 设置识别模式，分为搜索和输入
    //    paramsObject.recognitionMode = BDRecognizerRecognitionModeSearch;
    //
    //    // 设置显示效果，是否开启连续上屏
    //    paramsObject.resultShowMode = BDRecognizerResultShowModeContinuousShow;
    //
    //    // 设置提示音开关，是否打开，默认打开
    //    paramsObject.recordPlayTones = EBDRecognizerPlayTonesRecordPlay;
    //
    //    [_recognizerViewController startWithParams:paramsObject];
    //    [paramsObject release];
    
    // 设置开发者信息
    [[BDVoiceRecognitionClient sharedInstance] setApiKey:API_KEY withSecretKey:SECRET_KEY];
    
    // 设置语音识别模式，默认是搜索模式, 请在设置服务器地址之前进行设置，避免服务器地址设置出错
    [[BDVoiceRecognitionClient sharedInstance] setCurrentVoiceRecognitionMode:BDRecognizerRecognitionModeSearch];
    
    // 设置是否需要语义理解，只在搜索模式有效
    [[BDVoiceRecognitionClient sharedInstance] setConfig:@"nlu" withFlag:YES];
    
    // 是否打开语音音量监听功能，可选
    if (YES)
    {
        BOOL res = [[BDVoiceRecognitionClient sharedInstance] listenCurrentDBLevelMeter];
        
        if (res == NO)  // 如果监听失败，则恢复开关值
        {
            DLog(@"音量监听失败");
        }
    }
    else
    {
        [[BDVoiceRecognitionClient sharedInstance] cancelListenCurrentDBLevelMeter];
    }
    
    // 设置播放开始说话提示音开关，可选
    [[BDVoiceRecognitionClient sharedInstance] setPlayTone:EVoiceRecognitionPlayTonesRecStart isPlay:YES];
    // 设置播放结束说话提示音开关，可选
    [[BDVoiceRecognitionClient sharedInstance] setPlayTone:EVoiceRecognitionPlayTonesRecEnd isPlay:YES];
    
    // 创建语音识别界面，在其viewdidload方法中启动语音识别
    BDVRCustomRecognitonViewController *tmpAudioViewController = [[BDVRCustomRecognitonViewController alloc] initWithNibName:nil bundle:nil];
    tmpAudioViewController.delegate = self;
    self.recognizerViewController = tmpAudioViewController;
    [tmpAudioViewController release];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_recognizerViewController.view];
    
}

-(void)BDBRCustomRecognitonViewController:(BDVRCustomRecognitonViewController *)bdVRCustomRecognitonViewController result:(NSString *)result
{
    DLog(@"result______________ %@",result);
    
    //结果显示
    UITextField * txf = (UITextField *)[self viewWithTag:8080];
    [txf resignFirstResponder];
    [txf setText:result];
    
    //搜索
    if (self.delegate && [self.delegate respondsToSelector:@selector(customSearchBarControl:result:)]) {
        [self.delegate customSearchBarControl:self result:txf.text];
    }
}

//标准UI代理
#pragma mark -- BDRecognizerViewDelegate
- (void)onEndWithViews:(BDRecognizerViewController *)aBDRecognizerView withResults:(NSArray *)aResults
{
    /*
    //    resultView.text = nil;
    
    if ([[BDVoiceRecognitionClient sharedInstance] getCurrentVoiceRecognitionMode] == EVoiceRecognitionModeSearch)
    {
        // 搜索模式下的结果为数组，示例为
        // ["公园", "公元"]
        NSMutableArray *audioResultData = (NSMutableArray *)aResults;
        NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
        
        for (int i=0; i < [audioResultData count]; i++)
        {
            [tmpString appendFormat:@"%@\r\n",[audioResultData objectAtIndex:i]];
        }
        
        Dlog(@"语音识别结果: %@",tmpString);
        //        resultView.text = [resultView.text stringByAppendingString:tmpString];
        //        resultView.text = [resultView.text stringByAppendingString:@"\n"];
        
        //结果显示
        UITextField * txf = (UITextField *)[self viewWithTag:8080];
        [txf resignFirstResponder];
        NSDictionary *json_res = [[[tmpString objectFromJSONString]valueForKey:@"json_res"] objectFromJSONString];
        //        NSString *rawText = [json_res valueForKey:@"raw_text"];
        NSString *parsed_text = [json_res valueForKey:@"parsed_text"];
        [txf setText:parsed_text];
        
        //搜索
//        _tablePage = 1;
//        self.searchConditionStr = txf.text;
//        [self loadDataMode:kEnumRouteModeLineListByTag tag:parsed_text judianID:0 mode:kRequestModeRefresh];
//        
//        [tmpString release];
    }
    else
    {
        // 输入模式下的结果为带置信度的结果，示例如下：
        //  [
        //      [
        //         {
        //             "百度" = "0.6055192947387695";
        //         },
        //         {
        //             "摆渡" = "0.3625582158565521";
        //         },
        //      ]
        //      [
        //         {
        //             "一下" = "0.7665404081344604";
        //         }
        //      ],
        //   ]
        NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
        for (NSArray *result in aResults)
        {
            NSDictionary *dic = [result objectAtIndex:0];
            NSString *candidateWord = [[dic allKeys] objectAtIndex:0];
            [tmpString appendString:candidateWord];
        }
        
        Dlog(@"语音识别结果: %@",tmpString);
        //        resultView.text = [resultView.text stringByAppendingString:tmpString];
        //        resultView.text = [resultView.text stringByAppendingString:@"\n"];
        [tmpString release];
    }
     */
}

- (void)hideKeyBorad:(UIButton *)sender
{
    UITextField * txf = (UITextField *)[self viewWithTag:8080];
    [txf resignFirstResponder];
}

- (void)textFieldDidChange:(UITextField*)textField{
    //输入就搜索
    if (self.delegate && [self.delegate respondsToSelector:@selector(customSearchBarControl:result:)]) {
        [self.delegate customSearchBarControl:self result:textField.text];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

//点击搜索键
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField * txf = (UITextField *)[self viewWithTag:8080];
    [txf resignFirstResponder];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(customSearchBarControl:result:)]) {
        [self.delegate customSearchBarControl:self result:txf.text];
    }
    
    return YES;
}


@end
