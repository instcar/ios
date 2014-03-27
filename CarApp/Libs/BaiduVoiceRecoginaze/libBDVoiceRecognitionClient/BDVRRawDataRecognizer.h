//
//  BDVRRawDataRecognizer.h
//  BDVoiceRecognitionClient
//
//  Created by Baidu on 13-11-13.
//  Copyright (c) 2013年 Baidu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDVoiceRecognitionClient.h"

@interface BDVRRawDataRecognizer : NSObject

@property (nonatomic) BOOL isStarted;
@property (nonatomic) int sampleRate;
@property (nonatomic) int mode;
@property (nonatomic, assign) id<MVoiceRecognitionClientDelegate> delegate;

/**
 * @brief 初始化识别器
 *
 * @param filePath 文件路径
 *
 * @param sampleRate 采样率
 *
 * @param mode 识别模式
 */
- (id)initRecognizerWithSampleRate:(int)rate mode:(int)mode delegate:(id<MVoiceRecognitionClientDelegate>)delegate;

/**
 * @brief 开始识别
 *
 * @return 状态码，同[BDVoiceRecognitionClient startVoiceRecognition]
 */
- (int)startDataRecognition;

/**
 * @brief 向识别器发送数据
 *
 * @param data 发送的数据
 */
- (void)sendDataToRecognizer:(NSData *)data;

/**
 * @brief 数据发送完成
 */
- (void)allDataHasSent;

@end
