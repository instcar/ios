//
//  Respone.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-6.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kEnumServerStateSuccess = 200,
    kEnumServerStateNoLogin = 401,
    kEnumServerStateFalse = 500,
}kEnumServerState;

@interface Respone : NSObject

@property (assign, nonatomic) kEnumServerState status;
@property (strong, nonatomic) NSObject *data;
@property (strong, nonatomic) NSString *msg;

- (Respone *)initWithStatus:(kEnumServerState)status data:(NSObject *)data msg:(NSString *)msg;

- (NSString *)description;

@end
