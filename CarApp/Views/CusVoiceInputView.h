//
//  CusVoiceInputView.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-5-3.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDVoiceRecognitionClient.h"
#import "BDRecognizerViewParamsObject.h"
#import <AVFoundation/AVFoundation.h>

// 前向声明
@class BDVRViewController;

@protocol CusVoiceInputViewDelegate;

@interface CusVoiceInputView : UIView<UITextFieldDelegate,MVoiceRecognitionClientDelegate>
{
    UILabel *_startLocateLable;
    UITextField *_startInputView;

    UIActivityIndicatorView *_activity;
    
    UIView *_btnView;                    //放置btn的容器
    UIView *_haloView;                   //光晕视图
    UIButton *_voiceBtn;                 //按钮
    
    UIImageView *_dialog;
    BDVRViewController *clientSampleViewController;
    
    NSTimer *_voiceLevelMeterTimer; // 获取语音音量界别定时器
    AVAudioPlayer *_audioPlayer;
}

@property (assign, nonatomic) id<CusVoiceInputViewDelegate>delegate;
@property (assign, nonatomic) int type; //当前状态 1，定位 2手动输入
@property (copy, nonatomic) NSString *locateAddress;//定位的信息

@property (nonatomic, retain) NSTimer *voiceLevelMeterTimer;

// 方法
- (void)cancel:(id)sender;

@end

@protocol CusVoiceInputViewDelegate <NSObject>

@required
-(void)CusVoiceInputView:(CusVoiceInputView *)cusVoiceInputView result:(NSString *)result;

@optional
-(void)CusVoiceInputView:(CusVoiceInputView *)cusVoiceInputView logCatInfo:(NSString *)info;
-(void)CusVoiceInputView:(CusVoiceInputView *)cusVoiceInputView errorResult:(NSString *)result;

@end
