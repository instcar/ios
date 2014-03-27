//
//  BaseTextMessage.h
//  WPWProject
//
//  Created by Mr.Lu on 13-7-20.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import "CommonMessage.h"

@interface BaseTextMessage : CommonMessage

-(CommonMessage *)transformToMessage;

-(BaseTextMessage *)confromFromMessage:(CommonMessage *)message;

+(void)baseTextManager:(CommonMessage *)message;

@end
