//
//  SystemTextMessage.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-2.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonMessage.h"

typedef enum
{
    SystemCommendTypeJOINCAR = 1,
    SystemCommendTypeEXITCAR = 2,
    SystemCommendTypeOpenSeat = 3,
    SystemCommendTypeCloseSeat = 4,
    SystemCommendTypeChangeTime = 5,
    SystemCommendTypeOTHER = 6,
}SystemCommendType;

@interface SystemTextMessage : CommonMessage

@property (assign, nonatomic) SystemCommendType comandtype; //系统命令类型

-(CommonMessage *)transformToMessage;

-(SystemTextMessage *)confromFromMessage:(CommonMessage *)message;

+(void)baseTextManager:(CommonMessage *)message;

@end
