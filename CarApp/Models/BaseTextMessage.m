//
//  BaseTextMessage.m
//  WPWProject
//
//  Created by Mr.Lu on 13-7-20.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import "BaseTextMessage.h"
#import "JSONKit.h"
#import "MessageProtocol.h"
#import "XmppManager.h"

@implementation BaseTextMessage
-(CommonMessage *)transformToMessage
{
    NSString * content = @"";
//    if(self.loginLocate.latitude&&self.loginLocate.longitude)
//    {
//        NSString * loginlocateStr = @"";
//        if (self.loginLocate.latitude) {
//            loginlocateStr = [NSString stringWithFormat:@"%f,%f",self.loginLocate.longitude,self.loginLocate.latitude];
//        }
//        NSDictionary * requestDic = [NSDictionary dictionaryWithObjectsAndKeys:self.content,@"content",loglocStr,@"loginLocate",[NSNumber numberWithDouble:[self.date timeIntervalSince1970]],@"date",nil];
//        NSString * jsonStr = [requestDic JSONString];
//        content = [NSString stringWithFormat:@"%@%@",kTextRequest,jsonStr];
//    }
    
    NSDictionary * requestDic = [NSDictionary dictionaryWithObjectsAndKeys:self.content,@"content",[NSNumber numberWithDouble:[self.date timeIntervalSince1970]],@"date",nil];
    NSString * jsonStr = [requestDic JSONString];
    content = [NSString stringWithFormat:@"%@%@",kTextRequest,jsonStr];
    
    CommonMessage * message = [[[CommonMessage alloc]init]autorelease];
    message.uid = self.uid;
    message.fid = self.fid;
    message.roomid = self.roomid;
    message.content = content;
    message.date = self.date;
    message.type = self.type;
    
//    message.touid = self.touid;
//    message.state = self.state;
//    message.loginLocate = self.loginLocate;
    
    return message;
}

-(BaseTextMessage *)confromFromMessage:(CommonMessage *)message
{
    BaseTextMessage * tbmessage = [[[BaseTextMessage alloc]init]autorelease];
    
    if([message.content hasPrefix:kTextRequest])
    {
        NSString * josnStr = [message.content substringFromIndex:[kTextRequest length]];
        NSString * content = @"";
        NSDate * date = nil;
//        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(0.0, 0.0);
        
        if ([josnStr objectFromJSONString]) {
            NSDictionary * josnDic = [josnStr objectFromJSONString];
            content = [josnDic valueForKey:@"content"];
            date = [NSDate dateWithTimeIntervalSince1970:[[josnDic valueForKey:@"date"]doubleValue]];
//            NSString * loginLocate = [josnDic objectForKey:@"loginLocate"];
//            if (loginLocate) {
//                location = [AppUtility transformFromNSString:loginLocate];
//            }
        }
        else
        {
            date = message.date;
            content = [message.content substringFromIndex:[kTextRequest length]];
        }
        
        tbmessage.uid = message.uid;
        tbmessage.fid = message.fid;
        tbmessage.roomid = message.roomid;
        tbmessage.content = content;
        tbmessage.date = date;
        tbmessage.type = message.type;
        
//        tbmessage.loginLocate = location;
//        tbmessage.touid = message.touid;
//        tbmessage.state = message.state;
    }
    return tbmessage;
}

+(void)baseTextManager:(BaseTextMessage *)message
{
//    int userID = message.uid;
    
    @try {
        //短信代理接受
        if ([XmppManager sharedInstance].chatDelegate && [[XmppManager sharedInstance].chatDelegate respondsToSelector:@selector(getNewRoomMessage:)]) {
            [[XmppManager sharedInstance].chatDelegate getNewRoomMessage:message];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
