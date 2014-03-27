//
//  BDVRCustomRecognitonViewController.m
//  BDVRClientSample
//
//  Created by Baidu on 13-9-25
//  Copyright 2013 Baidu Inc. All rights reserved.
//

// 头文件
#import "BDVRCustomRecognitonViewController.h"
#import "BDVRClientUIManager.h"
#import "PulsingHaloLayer.h"
#import "PulsingHaloLayerStyle2.h"
#import "JSONKit.h"

#define VOICE_LEVEL_INTERVAL 0.05 // 音量监听频率为1秒中10次
#define khaloviewtag 3333

// 私有方法分类
@interface BDVRCustomRecognitonViewController ()

- (void)createInitView; // 创建初始化界面，播放提示音时会用到
- (void)createRecordView;  // 创建录音界面
- (void)createRecognitionView; // 创建识别界面
- (void)createErrorViewWithErrorType:(int)aStatus; // 在识别view中显示详细错误信息
- (void)createRunLogWithStatus:(int)aStatus; // 在状态view中显示详细状态信息

- (void)finishRecord:(id)sender; // 用户点击完成动作
- (void)cancel:(id)sender; // 用户点击取消动作

- (void)startVoiceLevelMeterTimer;
- (void)freeVoiceLevelMeterTimerTimer;

@end// VoiceRecognitonViewController

// 类实现
@implementation BDVRCustomRecognitonViewController
@synthesize dialog = _dialog;
@synthesize voiceLevelMeterTimer = _voiceLevelMeterTimer;

#pragma mark - init & dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
        // 
    }
    
    return self;
}

- (void)dealloc 
{
    [self freeVoiceLevelMeterTimerTimer];
    if (_audioPlayer) {
        [_audioPlayer release];
    }
	[_dialog release];
    [super dealloc];
}

#pragma mark - views lifestyle

- (void)loadView 
{
	UIView *tmpView = [[UIView alloc] initWithFrame:[[BDVRClientUIManager sharedInstance] VRBackgroundFrame]];
    tmpView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [tmpView setOpaque:YES];
	self.view = tmpView;
	[tmpView release];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    // 开始语音识别功能，之前必须实现MVoiceRecognitionClientDelegate协议中的VoiceRecognitionClientWorkStatus:obj方法
    int startStatus = -1;
	startStatus = [[BDVoiceRecognitionClient sharedInstance] startVoiceRecognition:self];
	if (startStatus != EVoiceRecognitionStartWorking) // 创建失败则报告错误
	{
		NSString *statusString = [NSString stringWithFormat:@"%d",startStatus];
		[self performSelector:@selector(firstStartError:) withObject:statusString afterDelay:0.3];  // 延迟0.3秒，以便能在出错时正常删除view
        return;
	}
    
    // 是否需要播放开始说话提示音，如果是，则提示用户不要说话，在播放完成后再开始说话, 也就是收到EVoiceRecognitionClientWorkStatusStartWorkIng通知后再开始说话。
    if (YES)
    {
        [self createInitView];
    }
    else 
    {
        [self createRecordView];
    }
    
    self.view.alpha = 0.0f;
    
    [UIView beginAnimations:@"show" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.view.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning 
{
	[self cancel:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(BDBRCustomRecognitonViewController:logCatInfo:)]) {
        [self.delegate BDBRCustomRecognitonViewController:self logCatInfo:@"内存警告，停止本次识别"];
    }
    // 发生内存警告时，停止语音识别，避免出现崩溃
    [super didReceiveMemoryWarning];
}

#pragma mark - button action methods
- (void)finishRecord:(id)sender 
{
    [[BDVoiceRecognitionClient sharedInstance] speakFinish];
}

- (void)cancel:(id)sender 
{
	[[BDVoiceRecognitionClient sharedInstance] stopVoiceRecognition];
    if (self.view.superview)
    {
        [self.view removeFromSuperview];
    }
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
    [soundUrl release];
    [player play];
}

-(void)removeAllView
{
    if (self.view.superview)
    {
        [self.view removeFromSuperview];
    }
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
                    [self.delegate BDBRCustomRecognitonViewController:self logCatInfo:text];
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
                    [self.delegate BDBRCustomRecognitonViewController:self result:rawText];
                }
                [tmpString release];
            }
            else
            {
                NSString *tmpString = [self composeInputModeResult:aObj];
                if (self.delegate && [self.delegate respondsToSelector:@selector(BDBRCustomRecognitonViewController:result:)]) {
                    [self.delegate BDBRCustomRecognitonViewController:self result:tmpString];
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
                [self.delegate BDBRCustomRecognitonViewController:self logCatInfo:tmpString];
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
            
            if (self.view.superview) 
            {
                [self.view removeFromSuperview];
            }
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
    
    return [tmpString autorelease];
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
    if (self.view.superview) 
    {
        [self.view removeFromSuperview];
    }
    
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
            [alertView release];
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
        [self.delegate BDBRCustomRecognitonViewController:self errorResult:errorMsg];
       
    }
}

#pragma mark - voice search views

- (void)createInitView
{
    if (_dialog && _dialog.superview) 
        [_dialog removeFromSuperview];
    
    UIImageView *tmpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 225) ];
    [tmpImageView setImage:[[UIImage imageNamed:@"bg_sound"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    tmpImageView.userInteractionEnabled = YES;
//    tmpImageView.alpha = 0.6; /* He Liqiang, TAG-130729 */
    [tmpImageView setOpaque:YES];
    self.dialog = tmpImageView;
    _dialog.backgroundColor = [UIColor clearColor];
    _dialog.center = self.view.center;
    [tmpImageView release];
    [self.view addSubview:_dialog];
    
    tmpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_sound@2x"]];
    [tmpImageView setFrame:CGRectMake(0, 0, 60, 60)];
    tmpImageView.center = [[BDVRClientUIManager sharedInstance] VRRecordBackgroundCenter];
    [_dialog addSubview:tmpImageView];
    [tmpImageView release];
    
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:[[BDVRClientUIManager sharedInstance] VRRecordTintWordFrame]];
    tmpLabel.backgroundColor = [UIColor clearColor];
    tmpLabel.font = [UIFont fontWithName:kFangZhengFont size:18.0f];
    tmpLabel.textColor = UIColorFromRGB(0x666666);
    tmpLabel.text = @"初始化";
    tmpLabel.textAlignment = NSTextAlignmentCenter;
    tmpLabel.center = [[BDVRClientUIManager sharedInstance] VRTintWordCenter];
    [_dialog addSubview:tmpLabel];
    [tmpLabel release];
    
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpButton.frame = [[BDVRClientUIManager sharedInstance] VRCenterButtonFrame];
    tmpButton.center = [[BDVRClientUIManager sharedInstance] VRCenterButtonCenter];
    tmpButton.backgroundColor = [UIColor clearColor];
    tmpButton.titleLabel.font = [UIFont fontWithName:kFangZhengFont size:18];
    tmpButton.titleLabel.textColor = UIColorFromRGB(0x666666);
    [tmpButton setTitle:@"取消" forState:UIControlStateNormal];
    [tmpButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [_dialog addSubview:tmpButton];
    [tmpButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    tmpButton.showsTouchWhenHighlighted = YES;
}

- (void)createRecordView
{
    if (_dialog && _dialog.superview) 
        [_dialog removeFromSuperview];
    
    UIImageView *tmpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 225) ];
    [tmpImageView setImage:[[UIImage imageNamed:@"bg_sound"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
    tmpImageView.userInteractionEnabled = YES;
//    tmpImageView.alpha = 0.6; /* He Liqiang, TAG-130729 */
    [tmpImageView setOpaque:YES];
    self.dialog = tmpImageView;
    _dialog.backgroundColor = [UIColor clearColor];
    _dialog.center = self.view.center;
    [tmpImageView release];
    [self.view addSubview:_dialog];
    
    UIView *haloView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 225-60) ];
    [haloView setTag:khaloviewtag];
    [tmpImageView addSubview:haloView];
    [haloView setClipsToBounds:YES];
    [haloView release];
    
    tmpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_sound@2x"]];
    [tmpImageView setFrame:CGRectMake(0, 0, 60, 60)];
    tmpImageView.center = [[BDVRClientUIManager sharedInstance] VRRecordBackgroundCenter];
    [_dialog addSubview:tmpImageView];
    [tmpImageView release];
    
    PulsingHaloLayer *halo = [PulsingHaloLayer layer];
    halo.position = tmpImageView.center;
    [halo setAnimationDuration:1.2];
    [halo setRadius:120];
    [haloView.layer addSublayer:halo];
    
    PulsingHaloLayerStyle2 *halo2 = [PulsingHaloLayerStyle2 layer];
    halo2.position = tmpImageView.center;
    halo2.animationDuration = 0.3;
    [halo2 setRadius:150];
    
    [haloView.layer addSublayer:halo2];
    
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:[[BDVRClientUIManager sharedInstance] VRRecordTintWordFrame]];
    tmpLabel.backgroundColor = [UIColor clearColor];
    tmpLabel.font = [UIFont fontWithName:kFangZhengFont size:18.0f];
    tmpLabel.textColor = UIColorFromRGB(0x666666);
    tmpLabel.text = @"请说话";
    tmpLabel.textAlignment = NSTextAlignmentCenter;
    tmpLabel.center = [[BDVRClientUIManager sharedInstance] VRTintWordCenter];
    [_dialog addSubview:tmpLabel];
    [tmpLabel release];
    
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpButton.frame = [[BDVRClientUIManager sharedInstance] VRLeftButtonFrame];
    tmpButton.backgroundColor = [UIColor clearColor];
    [tmpButton setBackgroundImage:[UIImage imageNamed:@"btn_canel_normal@2x"] forState:UIControlStateNormal];
    [tmpButton setBackgroundImage:[UIImage imageNamed:@"btn_canel_pressed@2x"] forState:UIControlStateHighlighted];
//    [tmpButton setTitle:@"取消" forState:UIControlStateNormal];
    tmpButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    tmpButton.titleLabel.textColor = [UIColor whiteColor];
    [_dialog addSubview:tmpButton];
    [tmpButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    tmpButton.showsTouchWhenHighlighted = YES;
    
    tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpButton.frame = [[BDVRClientUIManager sharedInstance] VRRightButtonFrame];
    [tmpButton setBackgroundImage:[UIImage imageNamed:@"btn_complete_normal@2x"] forState:UIControlStateNormal];
    [tmpButton setBackgroundImage:[UIImage imageNamed:@"btn_complete_pressed@2x"] forState:UIControlStateHighlighted];
//    [tmpButton setTitle:@"完成" forState:UIControlStateNormal];
    tmpButton.titleLabel.textColor = [UIColor whiteColor];
    tmpButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [_dialog addSubview:tmpButton];
    [tmpButton addTarget:self action:@selector(finishRecord:) forControlEvents:UIControlEventTouchUpInside];
    tmpButton.showsTouchWhenHighlighted = YES;
    
}

- (void)createRecognitionView
{
    if (_dialog && _dialog.superview) 
        [_dialog removeFromSuperview];
    
    UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg_sound"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
    [tmpImageView setFrame:CGRectMake(0, 0, 300, 225)];
    tmpImageView.userInteractionEnabled = YES;
//    tmpImageView.alpha = 0.6; /* He Liqiang, TAG-130729 */
    [tmpImageView setOpaque:YES];
    self.dialog = tmpImageView;
    [tmpImageView release];
    _dialog.center = self.view.center;
    [self.view addSubview:_dialog];
    
    UIImageView *circle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sound_loading@2x"]];
    [circle setFrame:CGRectMake(0, 0, 68, 68)];
	circle.center = [[BDVRClientUIManager sharedInstance] VRRecognizeBackgroundCenter];
	[_dialog addSubview:circle];
	[circle release];

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
    
    tmpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_sound@2x"]];
    [tmpImageView setFrame:CGRectMake(0, 0, 60, 60)];
	tmpImageView.center = [[BDVRClientUIManager sharedInstance] VRRecognizeBackgroundCenter];
	[_dialog addSubview:tmpImageView];
	[tmpImageView release];
    
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:[[BDVRClientUIManager sharedInstance] VRRecognizeTintWordFrame]];
    tmpLabel.backgroundColor = [UIColor clearColor];
    tmpLabel.font = [UIFont fontWithName:kFangZhengFont size:18];
    tmpLabel.textColor = UIColorFromRGB(0x666666);
    tmpLabel.text = @"正在识别";
    tmpLabel.textAlignment = NSTextAlignmentCenter;
    tmpLabel.center = [[BDVRClientUIManager sharedInstance] VRTintWordCenter];
    [_dialog addSubview:tmpLabel];
    [tmpLabel release];
    
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpButton.frame = [[BDVRClientUIManager sharedInstance] VRCenterButtonFrame];
    tmpButton.center = [[BDVRClientUIManager sharedInstance] VRCenterButtonCenter];
    tmpButton.backgroundColor = [UIColor clearColor];
    tmpButton.titleLabel.font = [UIFont fontWithName:kFangZhengFont size:18];
    tmpButton.titleLabel.textColor = UIColorFromRGB(0x666666);
    [tmpButton setTitle:@"取消" forState:UIControlStateNormal];
    [tmpButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [_dialog addSubview:tmpButton];
    [tmpButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    tmpButton.showsTouchWhenHighlighted = YES;
    
}

-(void)createErrorView:(NSString *)errorInfo
{
    if (_dialog && _dialog.superview)
        [_dialog removeFromSuperview];
    
    UIImageView *tmpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 225) ];
    [tmpImageView setImage:[[UIImage imageNamed:@"bg_sound"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    tmpImageView.userInteractionEnabled = YES;
    //    tmpImageView.alpha = 0.6; /* He Liqiang, TAG-130729 */
    [tmpImageView setOpaque:YES];
    self.dialog = tmpImageView;
    _dialog.backgroundColor = [UIColor clearColor];
    _dialog.center = self.view.center;
    [tmpImageView release];
    [self.view addSubview:_dialog];
    
    UIButton *soundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [soundBtn setFrame:CGRectMake(0, 0, 60, 60)];
    [soundBtn setBackgroundImage:[UIImage imageNamed:@"pic_sound"] forState:UIControlStateNormal];
    soundBtn.center = [[BDVRClientUIManager sharedInstance] VRRecordBackgroundCenter];
    [soundBtn addTarget:self action:@selector(restartRecogniton:) forControlEvents:UIControlEventTouchUpInside];
    [_dialog addSubview:soundBtn];
    
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:[[BDVRClientUIManager sharedInstance] VRRecordTintWordFrame]];
    tmpLabel.backgroundColor = [UIColor clearColor];
    tmpLabel.font = [UIFont fontWithName:kFangZhengFont size:18.0f];
    tmpLabel.textColor = UIColorFromRGB(0x666666);
    tmpLabel.text = errorInfo;
    tmpLabel.textAlignment = NSTextAlignmentCenter;
    tmpLabel.center = [[BDVRClientUIManager sharedInstance] VRTintWordCenter];
    [_dialog addSubview:tmpLabel];
    [tmpLabel release];
    
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpButton.frame = [[BDVRClientUIManager sharedInstance] VRCenterButtonFrame];
    tmpButton.center = [[BDVRClientUIManager sharedInstance] VRCenterButtonCenter];
    tmpButton.backgroundColor = [UIColor clearColor];
    tmpButton.titleLabel.font = [UIFont fontWithName:kFangZhengFont size:18];
    tmpButton.titleLabel.textColor = UIColorFromRGB(0x666666);
    [tmpButton setTitle:@"取消" forState:UIControlStateNormal];
    [tmpButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [_dialog addSubview:tmpButton];
    [tmpButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    tmpButton.showsTouchWhenHighlighted = YES;
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
    [self createRecordView];
    
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
            [self.delegate BDBRCustomRecognitonViewController:self logCatInfo:statusMsg];
        }
	}
}

#pragma mark - VoiceLevelMeterTimer methods

- (void)startVoiceLevelMeterTimer
{
    [self freeVoiceLevelMeterTimerTimer];

    NSDate *tmpDate = [[NSDate alloc] initWithTimeIntervalSinceNow:VOICE_LEVEL_INTERVAL];
    NSTimer *tmpTimer = [[NSTimer alloc] initWithFireDate:tmpDate interval:VOICE_LEVEL_INTERVAL target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [tmpDate release];
    self.voiceLevelMeterTimer = tmpTimer;
    [tmpTimer release];
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
    UIView *haloview = (UIView *)[self.dialog viewWithTag:khaloviewtag];
    PulsingHaloLayerStyle2 *haloLayer = (PulsingHaloLayerStyle2 *)[[haloview.layer sublayers] lastObject];
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

@end // BDVRCustomRecognitonViewController
