//
//  XmppRoomManager.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-29.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "XmppRoomManager.h"
#import "NSDictionary+Utility.h"

@implementation XmppRoomManager

+(NSXMLElement *)affirmRoomConfiguration:(NSDictionary *)configurationDic
{
    //configurationDic
    NSString *roomName = [configurationDic configurationDicDefaultValue:[NSString stringWithFormat:@"%@%ld",KRoomNamePrdFix,[User shareInstance].userId] withKey:@"roomName"];
    NSString *roomSubject = [configurationDic configurationDicDefaultValue:[NSString stringWithFormat:@"%@%ld",KRoomNamePrdFix,[User shareInstance].userId] withKey:@"roomSubName"];
    NSString *roomPass = [configurationDic configurationDicDefaultValue:KRoomPass withKey:@"roomPass"];
    BOOL roomLiveLong = [configurationDic configurationDicDefaultBoolValue:KRoomLiveLong withKey:@"roomLiveLong"];
    int roomMaxNum = [configurationDic configurationDicDefaultNumValue:KRoomMaxNum withKey:@"roomMaxNum"];
    
    NSXMLElement * x = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    
    NSXMLElement * FORM_TYPE  = [NSXMLElement elementWithName:@"field"];
    [FORM_TYPE addAttributeWithName:@"var" stringValue:@"FORM_TYPE"];
    [FORM_TYPE addChild:[NSXMLElement elementWithName:@"value" stringValue:@"http://jabber.org/protocol/muc#roomconfig"]];
    [x addChild:FORM_TYPE];

    //房间名字
    NSXMLElement * roomname  = [NSXMLElement elementWithName:@"field"];
    [roomname addAttributeWithName:@"var" stringValue:@"muc#roomconfig_roomname"];
    [roomname addChild:[NSXMLElement elementWithName:@"value" stringValue:roomName]];
    [x addChild:roomname];
   
    //房间主题
    NSXMLElement * roomsubject  = [NSXMLElement elementWithName:@"field"];
    [roomsubject addAttributeWithName:@"var" stringValue:@"muc#roomconfig_changesubject"];
    [roomsubject addChild:[NSXMLElement elementWithName:@"value" stringValue:roomSubject]];
    [x addChild:roomsubject];

    //房间密码保护
    NSXMLElement * roompasswordprotected  = [NSXMLElement elementWithName:@"field"];
    [roompasswordprotected addAttributeWithName:@"var" stringValue:@"muc#roomconfig_passwordprotectedroom"];
    [roompasswordprotected addChild:[NSXMLElement elementWithName:@"value" stringValue:[[NSNumber numberWithBool:YES] stringValue]]];
    [x addChild:roompasswordprotected];
    
    //房间密码
    NSXMLElement * roompass  = [NSXMLElement elementWithName:@"field"];
    [roompass addAttributeWithName:@"var" stringValue:@"muc#roomconfig_roomsecret"];
    [roompass addChild:[NSXMLElement elementWithName:@"value" stringValue:roomPass]];
    [x addChild:roompass];

    //房间持久性
    NSXMLElement * roomlivelong  = [NSXMLElement elementWithName:@"field"];
    [roomlivelong addAttributeWithName:@"var" stringValue:@"muc#roomconfig_persistentroom"];
    [roomlivelong addChild:[NSXMLElement elementWithName:@"value" stringValue:[[NSNumber numberWithBool:roomLiveLong] stringValue]]];
    [x addChild:roomlivelong];
    
    //房间大小
    NSXMLElement * roommaxnum  = [NSXMLElement elementWithName:@"field"];
    [roommaxnum addAttributeWithName:@"var" stringValue:@"muc#roomconfig_maxusers"];
    [roommaxnum addChild:[NSXMLElement elementWithName:@"value" stringValue:[[NSNumber numberWithInt:roomMaxNum] stringValue]]];
    [x addChild:roommaxnum];
    
    //房间大小
    NSXMLElement *  enablelogging = [NSXMLElement elementWithName:@"field"];
    [enablelogging addAttributeWithName:@"var" stringValue:@"muc#muc#roomconfig_enablelogging"];
    [enablelogging addChild:[NSXMLElement elementWithName:@"value" stringValue:[[NSNumber numberWithBool:YES] stringValue]]];
    [x addChild:enablelogging];
    
    return x;
}


@end
