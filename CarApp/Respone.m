//
//  Respone.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-6.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "Respone.h"

@implementation Respone

- (Respone *)initWithStatus:(kEnumServerState)status data:(NSObject *)data msg:(NSString *)msg
{
    self = [super init];
    if (self) {
        _status = status;
        _data = data;
        _msg = msg;
    }
    return self;
}

- (NSString *)description
{
    return  [NSString stringWithFormat:@"status=%d,data=%@,msg=%@",self.status,self.data,self.msg];
}

@end
