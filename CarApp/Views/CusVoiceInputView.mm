//
//  CusVoiceInputView.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-5-3.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CusVoiceInputView.h"
#import "PulsingHaloLayer.h"
#import "PulsingHaloLayerStyle2.h"
#import "JSONKit.h"
#import "UIColor+utils.h"

#define VOICE_LEVEL_INTERVAL 0.05 // 音量监听频率为1秒中10次
#define API_KEY @"8MAxI5o7VjKSZOKeBzS4XtxO"
#define SECRET_KEY @"Ge5GXVdGQpaxOmLzc8fOM8309ATCz9Ha"

@interface CusVoiceInputView()

- (void)createInitView; // 创建初始化界面，播放提示音时会用到
- (void)createRecordView;  // 创建录音界面
- (void)createRecognitionView; // 创建识别界面
- (void)createErrorViewWithErrorType:(int)aStatus; // 在识别view中显示详细错误信息
- (void)createRunLogWithStatus:(int)aStatus; // 在状态view中显示详细状态信息

- (void)finishRecord:(id)sender; // 用户点击完成动作
- (void)cancel:(id)sender; // 用户点击取消动作

- (void)startVoiceLevelMeterTimer;
- (void)freeVoiceLevelMeterTimerTimer;

@end

@implementation CusVoiceInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置百度语音识别
        [self setRecognizeConfig];
        
        [self setUpView];
    }
    return self;
}

- (void)setRecognizeConfig
{
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

}

- (void)setBaiDuRecognition
{
    // 开始语音识别功能，之前必须实现MVoiceRecognitionClientDelegate协议中的VoiceRecognitionClientWorkStatus:obj方法
    int startStatus = -1;
    startStatus = [[BDVoiceRecognitionClient sharedInstance] startVoiceRecognition:self];
    if (startStatus != EVoiceRecognitionStartWorking) // 创建失败则报告错误
    {
        NSString *statusString = [NSString stringWithFormat:@"%d",startStatus];
        [self performSelector:@selector(firstStartError:) withObject:statusString afterDelay:0.3];  // 延迟0.3秒，以便能在出错时正常删除view
        return;
    }
}

- (void)setUpView
{
    self.backgroundColor = [UIColor whiteColor];
    //起点输入
    UILabel *startLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, 25)];
    [startLable setText:@"终点:"];
    [startLable setBackgroundColor:[UIColor clearColor]];
    [startLable setFont:AppFont(14)];
    [startLable setTextColor:[UIColor lightGrayColor]];
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
    [self createInitView];
}

- (void)locateBtnAction:(UIButton *)sender
{
    [_startInputView setLeftView:_activity];
    //    [_startLocateLable setText:@""];
    [_activity startAnimating];
    if(self.delegate && [self.delegate respondsToSelector:@selector(locateBtnAction:)])
    {
//        [self.delegate locateBtnAction:sender];
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
//        [self.delegate inputModeChange:type];
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


#pragma mark - button action methods
- (void)finishRecord:(id)sender
{
    [[BDVoiceRecognitionClient sharedInstance] speakFinish];
}

- (void)cancel:(id)sender
{
	[[BDVoiceRecognitionClient sharedInstance] stopVoiceRecognition];
    [self removeAllView];
}

#pragma mark - AVfunction 声音播放
-(void)playSound:(NSString *)soundName type:(NSString *)soundType
{
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:soundName ofType:soundType];
    if (!soundPath) {
        return;
    }
    NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath];
    //    _audioPlayer = nil;
    AVAudioPlayer *player=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [player prepareToPlay];
    [player play];
}

-(void)removeAllView
{
//    if (self.view.superview)
//    {
//        [self.view removeFromSuperview];
//    }
}

#pragma mark - MVoiceRecognitionClientDelegate
- (void)VoiceRecognitionClientErrorStatus:(int) aStatus subStatus:(int)aSubStatus
{
    [self playSound:@"record_fail" type:@"caf"];
    // 为了更加具体的显示错误信息，此处没有使用aStatus参数
    [self createErrorViewWithErrorType:aSubStatus];
}

- (void)VoiceRecognitionClientWorkStatus:(int)aStatus obj:(id)aObj
{
    switch (aStatus)
    {
        case EVoiceRecognitionClientWorkStatusFlushData: // 连续上屏中间结果
        {
            NSString *text = [aObj objectAtIndex:0];
            
            if ([text length] > 0)
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(BDBRCustomRecognitonViewController:logCatInfo:)]) {
                    [self.delegate CusVoiceInputView:self logCatInfo:text];
                }
            }
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusFinish: // 识别正常完成并获得结果
        {
			[self createRunLogWithStatus:aStatus];
            [self playSound:@"record_success" type:@"caf"];
            if ([[BDVoiceRecognitionClient sharedInstance] getCurrentVoiceRecognitionMode] == EVoiceRecognitionModeSearch)
            {
                //  搜索模式下的结果为数组，示例为
                // ["公园", "公元"]
                NSMutableArray *audioResultData = (NSMutableArray *)aObj;
                NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
                
                for (int i=0; i < [audioResultData count]; i++)
                {
                    [tmpString appendFormat:@"%@\r\n",[audioResultData objectAtIndex:i]];
                }
                
                NSDictionary *json_res = [[[tmpString objectFromJSONString]valueForKey:@"json_res"] objectFromJSONString];
                NSString *rawText = [json_res valueForKey:@"raw_text"];
                //        NSString *parsed_text = [json_res valueForKey:@"parsed_text"];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(BDBRCustomRecognitonViewController:result:)]) {
                    [self.delegate CusVoiceInputView:self result:rawText];
                }
            }
            else
            {
                NSString *tmpString = [self composeInputModeResult:aObj];
                if (self.delegate && [self.delegate respondsToSelector:@selector(BDBRCustomRecognitonViewController:result:)]) {
                    [self.delegate CusVoiceInputView:self result:tmpString];
                }
            }
            
            [self performSelector:@selector(removeAllView) withObject:nil afterDelay:0.5];
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusReceiveData:
        {
            // 此状态只有在输入模式下使用
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
            
            NSString *tmpString = [self composeInputModeResult:aObj];
            if (self.delegate && [self.delegate respondsToSelector:@selector(BDBRCustomRecognitonViewController:logCatInfo:)]) {
                [self.delegate CusVoiceInputView:self logCatInfo:tmpString];
            }
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusEnd: // 用户说话完成，等待服务器返回识别结果
        {
			[self createRunLogWithStatus:aStatus];
            if (YES)
            {
                [self freeVoiceLevelMeterTimerTimer];
            }
			
            [self createRecognitionView];
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusCancel:
        {
            [self playSound:@"record_cancel" type:@"caf"];
            if (YES)
            {
                [self freeVoiceLevelMeterTimerTimer];
            }
            
			[self createRunLogWithStatus:aStatus];
            
//            if (self.view.superview)
//            {
//                [self.view removeFromSuperview];
//            }
            break;
        }
        case EVoiceRecognitionClientWorkStatusStartWorkIng: // 识别库开始识别工作，用户可以说话
        {
            if (YES) // 如果播放了提示音，此时再给用户提示可以说话
            {
                [self createRecordView];
            }
            
            if (YES)  // 开启语音音量监听
            {
                [self startVoiceLevelMeterTimer];
            }
            
			[self createRunLogWithStatus:aStatus];
            
            break;
        }
		case EVoiceRecognitionClientWorkStatusNone:
		case EVoiceRecognitionClientWorkPlayStartTone:
		case EVoiceRecognitionClientWorkPlayStartToneFinish:
		case EVoiceRecognitionClientWorkStatusStart:
		case EVoiceRecognitionClientWorkPlayEndToneFinish:
		case EVoiceRecognitionClientWorkPlayEndTone:
		{
			[self createRunLogWithStatus:aStatus];
			break;
		}
        case EVoiceRecognitionClientWorkStatusNewRecordData:
        {
            break;
        }
        default:
        {
			[self createRunLogWithStatus:aStatus];
            if (YES)
            {
                [self freeVoiceLevelMeterTimerTimer];
            }
            
            //            [self performSelector:@selector(removeAllView) withObject:nil afterDelay:1.0];
            break;
        }
    }
}

- (NSString *)composeInputModeResult:(id)aObj
{
    NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
    for (NSArray *result in aObj)
    {
        NSDictionary *dic = [result objectAtIndex:0];
        NSString *candidateWord = [[dic allKeys] objectAtIndex:0];
        [tmpString appendString:candidateWord];
    }
    
    return tmpString;
}

- (void)VoiceRecognitionClientNetWorkStatus:(int) aStatus
{
    switch (aStatus)
    {
        case EVoiceRecognitionClientNetWorkStatusStart:
        {
			[self createRunLogWithStatus:aStatus];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            break;
        }
        case EVoiceRecognitionClientNetWorkStatusEnd:
        {
			[self createRunLogWithStatus:aStatus];
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;
        }
    }
}

#pragma mark - voice search error result
- (void)firstStartError:(NSString *)statusString
{
    [self removeAllView];
	[self createErrorViewWithErrorType:[statusString intValue]];
}

- (void)createErrorViewWithErrorType:(int)aStatus
{
    NSString *errorMsg = @"";
    
    switch (aStatus)
    {
        case EVoiceRecognitionClientErrorStatusIntrerruption:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonInterruptRecord", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusChangeNotAvailable:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonChangeNotAvailable", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusUnKnow:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonStatusError", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusNoSpeech:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoSpeech", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusShort:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoShort", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusException:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonException", nil);
            break;
        }
        case EVoiceRecognitionClientErrorNetWorkStatusError:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNetWorkError", nil);
            break;
        }
        case EVoiceRecognitionClientErrorNetWorkStatusUnusable:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoNetWork", nil);
            break;
        }
        case EVoiceRecognitionClientErrorNetWorkStatusTimeOut:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNetWorkTimeOut", nil);
            break;
        }
        case EVoiceRecognitionClientErrorNetWorkStatusParseError:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonParseError", nil);
            break;
        }
		case EVoiceRecognitionStartWorkNoAPIKEY:
		{
			errorMsg = NSLocalizedString(@"StringAudioSearchNoAPIKEY", nil);
            break;
		}
        case EVoiceRecognitionStartWorkGetAccessTokenFailed:
        {
            errorMsg = NSLocalizedString(@"StringAudioSearchGetTokenFailed", nil);
            break;
        }
		case EVoiceRecognitionStartWorkDelegateInvaild:
		{
			errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoDelegateMethods", nil);
            break;
		}
		case EVoiceRecognitionStartWorkNetUnusable:
		{
			errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoNetWork", nil);
            break;
		}
		case EVoiceRecognitionStartWorkRecorderUnusable:
		{
			errorMsg = NSLocalizedString(@"StringVoiceRecognitonCantRecord", nil);
            break;
		}
        case EVoiceRecognitionStartWorkNOMicrophonePermission:
		{
            errorMsg = NSLocalizedString(@"StringAudioSearchNOMicrophonePermission", nil);
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误" message:errorMsg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            break;
		}
            //服务器返回错误
        case EVoiceRecognitionClientErrorNetWorkStatusServerNoFindResult:     //没有找到匹配结果
        case EVoiceRecognitionClientErrorNetWorkStatusServerSpeechQualityProblem:    //声音过小
            
        case EVoiceRecognitionClientErrorNetWorkStatusServerParamError:       //协议参数错误
        case EVoiceRecognitionClientErrorNetWorkStatusServerRecognError:      //识别过程出错
        case EVoiceRecognitionClientErrorNetWorkStatusServerAppNameUnknownError: //appName验证错误
        case EVoiceRecognitionClientErrorNetWorkStatusServerUnknownError:      //未知错误
        {
			errorMsg = [NSString stringWithFormat:@"%@-%d",NSLocalizedString(@"StringVoiceRecognitonServerError", nil),aStatus] ;
            break;
        }
        default:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonDefaultError", nil);
            break;
        }
    }
    DLog(@"error info %@",errorMsg);
    [self createErrorView:errorMsg];
    if (self.delegate && [self.delegate respondsToSelector:@selector(BDBRCustomRecognitonViewController:errorResult:)]) {
        [self.delegate CusVoiceInputView:self errorResult:errorMsg];
        
    }
}

#pragma mark - voice search views

- (void)createInitView
{
    _btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [_btnView setCenter:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0)];
    [_btnView setBackgroundColor:[UIColor redColor]];
    [_btnView setClipsToBounds:NO];
    [self addSubview:_btnView];
    
    _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_voiceBtn setFrame:CGRectMake(0, 0, 100, 100)];
    _voiceBtn.center = CGPointMake(_btnView.bounds.size.width/2.0, _btnView.bounds.size.height/2.0);
    _voiceBtn.backgroundColor = [UIColor clearColor];
    _voiceBtn.titleLabel.font = AppFont(18);
    [_voiceBtn setBackgroundImage:[UIImage imageNamed:@"bg_circle"] forState:UIControlStateNormal];
    [_voiceBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
    [_voiceBtn setImage:[UIImage imageNamed:@"pic_sound"] forState:UIControlStateNormal];
    [_voiceBtn setTitleEdgeInsets:UIEdgeInsetsMake(80, 0, 0, 0)];
    [_voiceBtn setTitle:@"我要去" forState:UIControlStateNormal];
    [_voiceBtn setTitleColor:[UIColor colorWithHexStr:0x666666 alpha:1.0] forState:UIControlStateNormal];
    [_btnView addSubview:_voiceBtn];
    [_voiceBtn addTarget:self action:@selector(setBaiDuRecognition) forControlEvents:UIControlEventTouchUpInside];
    _voiceBtn.showsTouchWhenHighlighted = YES;
}

- (void)createRecordView
{
    [_voiceBtn removeFromSuperview];
    
    UIView *haloView = [[UIImageView alloc]initWithFrame:self.bounds];
    [haloView setCenter:CGPointMake(_btnView.bounds.size.width/2.0, _btnView.bounds.size.height/2.0)];
    [_btnView addSubview:haloView];
    [haloView setClipsToBounds:YES];
    
    _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_voiceBtn setFrame:CGRectMake(0, 0, 60, 60)];
    _voiceBtn.center = CGPointMake(_btnView.bounds.size.width/2.0, _btnView.bounds.size.height/2.0);
    _voiceBtn.backgroundColor = [UIColor clearColor];
    [_voiceBtn setImage:[UIImage imageNamed:@"pic_sound"] forState:UIControlStateNormal];
    [_voiceBtn setTitle:@"" forState:UIControlStateNormal];
    [_btnView addSubview:_voiceBtn];
    [_voiceBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    _voiceBtn.showsTouchWhenHighlighted = YES;
    
    PulsingHaloLayerStyle2 *halo2 = [PulsingHaloLayerStyle2 layer];
    halo2.position = haloView.center;
    halo2.animationDuration = 0.3;
    [halo2 setRadius:150];
    
    [haloView.layer addSublayer:halo2];
    
}

- (void)createRecognitionView
{
    [_voiceBtn removeFromSuperview];
    
    UIImageView *circle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sound_loading@2x"]];
    [circle setFrame:CGRectMake(0, 0, 68, 68)];
	circle.center = CGPointMake(_btnView.bounds.size.width/2.0, _btnView.bounds.size.height/2.0);
	[_btnView addSubview:circle];
    
    CAAnimationGroup *animationGroup =[[CAAnimationGroup alloc]init];
    [animationGroup setDuration:1.0];
    [animationGroup setFillMode:kCAFillModeForwards];
    [animationGroup setRemovedOnCompletion:NO];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * -2];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 2;
    [rotationAnimation setAutoreverses:NO];
    //    [rotationAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [rotationAnimation setFillMode:kCAFillModeForwards];
    [rotationAnimation setRemovedOnCompletion:NO];
    [rotationAnimation setBeginTime:0.0];
    
    CABasicAnimation *alphaAnimation;
    alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.0];
    alphaAnimation.duration = 0.25;
    [alphaAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [alphaAnimation setFillMode:kCAFillModeForwards];
    [alphaAnimation setRemovedOnCompletion:NO];
    [alphaAnimation setBeginTime:0.75];
    
    [animationGroup setAnimations:[NSArray arrayWithObjects:rotationAnimation,alphaAnimation,nil]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [circle.layer addAnimation:animationGroup forKey:@"cirleAnimation"];
        });
    });
    
    _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_voiceBtn setFrame:CGRectMake(0, 0, 60, 60)];
    _voiceBtn.center = CGPointMake(_btnView.bounds.size.width/2.0, _btnView.bounds.size.height/2.0);
    _voiceBtn.backgroundColor = [UIColor clearColor];
    [_voiceBtn setImage:[UIImage imageNamed:@"pic_sound"] forState:UIControlStateNormal];
    [_voiceBtn setTitle:@"" forState:UIControlStateNormal];
    [_btnView addSubview:_voiceBtn];
    [_voiceBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    _voiceBtn.showsTouchWhenHighlighted = YES;
}

-(void)createErrorView:(NSString *)errorInfo
{
    [_voiceBtn removeFromSuperview];
    
    _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_voiceBtn setFrame:CGRectMake(0, 0, 60, 60)];
    _voiceBtn.center = CGPointMake(_btnView.bounds.size.width/2.0, _btnView.bounds.size.height/2.0);
    _voiceBtn.backgroundColor = [UIColor clearColor];
    [_voiceBtn setImage:[UIImage imageNamed:@"pic_sound"] forState:UIControlStateNormal];
    [_voiceBtn setTitle:@"" forState:UIControlStateNormal];
    [_btnView addSubview:_voiceBtn];
    [_voiceBtn addTarget:self action:@selector(restartRecogniton:) forControlEvents:UIControlEventTouchUpInside];
    _voiceBtn.showsTouchWhenHighlighted = YES;
}


-(void)restartRecogniton:(UIButton *)button
{
    int startStatus = -1;
	startStatus = [[BDVoiceRecognitionClient sharedInstance] startVoiceRecognition:self];
	if (startStatus != EVoiceRecognitionStartWorking) // 创建失败则报告错误
	{
		NSString *statusString = [NSString stringWithFormat:@"%d",startStatus];
		[self performSelector:@selector(firstStartError:) withObject:statusString afterDelay:0.3];  // 延迟0.3秒，以便能在出错时正常删除view
        return;
	}
    
    // 是否需要播放开始说话提示音，如果是，则提示用户不要说话，在播放完成后再开始说话, 也就是收到EVoiceRecognitionClientWorkStatusStartWorkIng通知后再开始说话。
//    [self createRecordView];
    
}

#pragma mark - voice search log

- (void)createRunLogWithStatus:(int)aStatus
{
    NSString *statusMsg = nil;
	switch (aStatus)
	{
		case EVoiceRecognitionClientWorkStatusNone: //空闲
		{
			statusMsg = NSLocalizedString(@"StringLogStatusNone", nil);
			break;
		}
		case EVoiceRecognitionClientWorkPlayStartTone:  //播放开始提示音
		{
			statusMsg = NSLocalizedString(@"StringLogStatusPlayStartTone", nil);
			break;
		}
		case EVoiceRecognitionClientWorkPlayStartToneFinish: //播放开始提示音完成
		{
			statusMsg = NSLocalizedString(@"StringLogStatusPlayStartToneFinish", nil);
			break;
		}
		case EVoiceRecognitionClientWorkStatusStartWorkIng: //识别工作开始，开始采集及处理数据
		{
			statusMsg = NSLocalizedString(@"StringLogStatusStartWorkIng", nil);
			break;
		}
		case EVoiceRecognitionClientWorkStatusStart: //检测到用户开始说话
		{
			statusMsg = NSLocalizedString(@"StringLogStatusStart", nil);
			break;
		}
		case EVoiceRecognitionClientWorkPlayEndTone: //播放结束提示音
		{
			statusMsg = NSLocalizedString(@"StringLogStatusPlayEndTone", nil);
			break;
		}
		case EVoiceRecognitionClientWorkPlayEndToneFinish: //播放结束提示音完成
		{
			statusMsg = NSLocalizedString(@"StringLogStatusPlayEndToneFinish", nil);
			break;
		}
        case EVoiceRecognitionClientWorkStatusReceiveData: //语音识别功能完成，服务器返回正确结果
        {
			statusMsg = NSLocalizedString(@"StringLogStatusSentenceFinish", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusFinish: //语音识别功能完成，服务器返回正确结果
        {
			statusMsg = NSLocalizedString(@"StringLogStatusFinish", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusEnd: //本地声音采集结束结束，等待识别结果返回并结束录音
        {
			statusMsg = NSLocalizedString(@"StringLogStatusEnd", nil);
			break;
		}
		case EVoiceRecognitionClientNetWorkStatusStart: //网络开始工作
        {
			statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusStart", nil);
            break;
        }
        case EVoiceRecognitionClientNetWorkStatusEnd:  //网络工作完成
        {
			statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusEnd", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusCancel:  // 用户取消
        {
            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusCancel", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusError: // 出现错误
        {
            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusErorr", nil);
            break;
        }
		default:
		{
			statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusDefaultErorr", nil);
			break;
		}
	}
	
    DLog(@"statusMsg:%@",statusMsg);
	if (statusMsg)
	{
        if (self.delegate && [self.delegate respondsToSelector:@selector(BDBRCustomRecognitonViewController:logCatInfo:)]) {
            [self.delegate CusVoiceInputView:self logCatInfo:statusMsg];
        }
	}
}

#pragma mark - VoiceLevelMeterTimer methods

- (void)startVoiceLevelMeterTimer
{
    [self freeVoiceLevelMeterTimerTimer];
    
    NSDate *tmpDate = [[NSDate alloc] initWithTimeIntervalSinceNow:VOICE_LEVEL_INTERVAL];
    NSTimer *tmpTimer = [[NSTimer alloc] initWithFireDate:tmpDate interval:VOICE_LEVEL_INTERVAL target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    self.voiceLevelMeterTimer = tmpTimer;
    [[NSRunLoop currentRunLoop] addTimer:_voiceLevelMeterTimer forMode:NSDefaultRunLoopMode];
}

- (void)freeVoiceLevelMeterTimerTimer
{
	if(_voiceLevelMeterTimer)
	{
		if([_voiceLevelMeterTimer isValid])
			[_voiceLevelMeterTimer invalidate];
		self.voiceLevelMeterTimer = nil;
	}
}

- (void)timerFired:(id)sender
{
    // 获取语音音量级别
    int voiceLevel = [[BDVoiceRecognitionClient sharedInstance] getCurrentDBLevelMeter];
    
    //设置音波

    PulsingHaloLayerStyle2 *haloLayer = (PulsingHaloLayerStyle2 *)[[_haloView.layer sublayers] lastObject];
    [haloLayer setVoiceValue:voiceLevel];
    
    //    NSString *statusMsg = [NSLocalizedString(@"StringLogVoiceLevel", nil) stringByAppendingFormat:@": %d", voiceLevel];
    DLog(@"voiceLevel:%d",voiceLevel);
    //    if (self.delegate && [self.delegate respondsToSelector:@selector(BDBRCustomRecognitonViewController:logCatInfo:)]) {
    //        [self.delegate BDBRCustomRecognitonViewController:self logCatInfo:statusMsg];
    //    }
}

#pragma mark - animation finish

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    // 
}



@end
