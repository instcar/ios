//
//  BDVRCustomRecognitonViewController.h
//  BDVRClientSample
//
//  Created by Baidu on 13-9-25
//  Copyright 2013 Baidu Inc. All rights reserved.
//

// 头文件
#import <UIKit/UIKit.h>
#import "BDVoiceRecognitionClient.h"
#import <AVFoundation/AVFoundation.h>

// 前向声明
@class BDVRViewController;

// @class - BDVRCustomRecognitonViewController
// @brief - 语音搜索界面的实现类

@protocol BDVRCustomRecognitonViewControllerDelegate;

@interface BDVRCustomRecognitonViewController : UIViewController<MVoiceRecognitionClientDelegate>
{
	UIImageView *_dialog;
    BDVRViewController *clientSampleViewController;
    
    NSTimer *_voiceLevelMeterTimer; // 获取语音音量界别定时器
    AVAudioPlayer *_audioPlayer;
}

// 属性
@property (nonatomic, retain) UIImageView *dialog;
@property (nonatomic, assign) id<BDVRCustomRecognitonViewControllerDelegate> delegate;
@property (nonatomic, retain) NSTimer *voiceLevelMeterTimer;

// 方法
- (void)cancel:(id)sender;

@end // BDVRCustomRecognitonViewController

@protocol BDVRCustomRecognitonViewControllerDelegate <NSObject>

@required
-(void)BDBRCustomRecognitonViewController:(BDVRCustomRecognitonViewController *)bdVRCustomRecognitonViewController result:(NSString *)result;

@optional
-(void)BDBRCustomRecognitonViewController:(BDVRCustomRecognitonViewController *)bdVRCustomRecognitonViewController logCatInfo:(NSString *)info;
-(void)BDBRCustomRecognitonViewController:(BDVRCustomRecognitonViewController *)bdVRCustomRecognitonViewController errorResult:(NSString *)result;

@end
