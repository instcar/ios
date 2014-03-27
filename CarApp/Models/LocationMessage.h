//
//  LocationMessage.h
//  WPWProject
//
//  Created by Mr.Lu on 13-7-19.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonMessage.h"
#import "MessageProtocol.h"

@interface LocationMessage : CommonMessage
@property (assign, nonatomic) CLLocationCoordinate2D location; //定位点信息
@property (copy, nonatomic) NSString * address; //地址信息
@property (retain, nonatomic) UIImage * locationImage; //定位点的图片
-(CommonMessage *)transformToMessage;
-(LocationMessage *)confromFromMessage:(CommonMessage *)message;
@end
