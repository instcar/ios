//
//  ImageMessage.h
//  WPWProject
//
//  Created by Mr.Lu on 13-7-19.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import "CommonMessage.h"
#import "MessageProtocol.h"

@interface ImageMessage : CommonMessage
@property (retain, nonatomic)UIImage * image; //图片

-(CommonMessage *)transformToMessage;

-(ImageMessage *)confromFromMessage:(CommonMessage *)message;

+(void)imageManager:(CommonMessage *)message;

@end
