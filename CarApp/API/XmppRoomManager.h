//
//  XmppRoomManager.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-29.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSXMLElement+XMPP.h"

#define KRoomNamePrdFix @"room"
#define KRoomPass @"instcar123456"
#define KRoomMaxNum 4
#define KRoomLiveLong 1

@interface XmppRoomManager : NSObject

+(NSXMLElement *)affirmRoomConfiguration:(NSDictionary *)configurationDic;

@end
