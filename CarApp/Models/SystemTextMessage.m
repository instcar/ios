//
//  SystemTextMessage.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-2.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "SystemTextMessage.h"
#import "JSONKit.h"
#import "MessageProtocol.h"
#import "XmppManager.h"

@implementation SystemTextMessage

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
    
    NSDictionary * requestDic = [NSDictionary dictionaryWithObjectsAndKeys:self.content,@"content",[NSNumber numberWithDouble:[self.date timeIntervalSince1970]],@"date", [NSNumber numberWithInt:self.comandtype],@"type",nil];
    NSString * jsonStr = [requestDic JSONString];
    content = [NSString stringWithFormat:@"%@%@",kSystemRequest,jsonStr];
    
    CommonMessage * message = [[CommonMessage alloc]init];
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

-(SystemTextMessage *)confromFromMessage:(CommonMessage *)message
{
    SystemTextMessage * tbmessage = [[SystemTextMessage alloc]init];
    
    if([message.content hasPrefix:kSystemRequest])
    {
        NSString * josnStr = [message.content substringFromIndex:[kSystemRequest length]];
        NSString * content = @"";
        NSDate * date = nil;
        SystemCommendType commandType = 0;
        //        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(0.0, 0.0);
        
        if ([josnStr objectFromJSONString]) {
            NSDictionary * josnDic = [josnStr objectFromJSONString];
            content = [josnDic valueForKey:@"content"];
            date = [NSDate dateWithTimeIntervalSince1970:[[josnDic valueForKey:@"date"]doubleValue]];
            //            NSString * loginLocate = [josnDic objectForKey:@"loginLocate"];
            //            if (loginLocate) {
            //                location = [AppUtility transformFromNSString:loginLocate];
            //            }
            commandType = [[josnDic valueForKey:@"type"]intValue];
            
        }
        else
        {
            date = message.date;
            content = [message.content substringFromIndex:[kSystemRequest length]];
        }
        
        tbmessage.uid = message.uid;
        tbmessage.fid = message.fid;
        tbmessage.roomid = message.roomid;
        tbmessage.content = content;
        tbmessage.date = date;
        tbmessage.type = message.type;
        tbmessage.comandtype = commandType;
        
        //        tbmessage.loginLocate = location;
        //        tbmessage.touid = message.touid;
        //        tbmessage.state = message.state;
    }
    return tbmessage;
}

+(void)baseTextManager:(SystemTextMessage *)message
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
