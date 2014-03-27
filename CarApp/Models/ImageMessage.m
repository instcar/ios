//
//  ImageMessage.m
//  WPWProject
//
//  Created by Mr.Lu on 13-7-19.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import "ImageMessage.h"
#import "Base64Helper.h"
#import "JSONKit.h"
#import "UIImage+Compress.h"
#import "XmppManager.h"

@implementation ImageMessage

-(CommonMessage *)transformToMessage
{
    
//    NSString * loglocStr = @"";
//    if (self.loginLocate.latitude) {
//        loglocStr = [NSString stringWithFormat:@"%f,%f",self.loginLocate.longitude,self.loginLocate.latitude];
//    }
//    
//    //压缩
//    UIImage * image = [UIImage imageWithData:[self.image compressedDataWithRate]];
//    
//    //编码
//    NSString * imageString = [Base64Helper image2String:image];
//    NSDictionary * imageDic = [NSDictionary dictionaryWithObjectsAndKeys:imageString,@"image",loglocStr,@"loginLocate",[NSNumber numberWithDouble:[self.date timeIntervalSince1970]],@"date",nil];
    
    //压缩
    UIImage * image = [UIImage imageWithData:[self.image compressedDataWithRate]];

    //编码
    NSString * imageString = [Base64Helper image2String:image];
    NSDictionary * imageDic = [NSDictionary dictionaryWithObjectsAndKeys:imageString,@"image",[NSNumber numberWithDouble:[self.date timeIntervalSince1970]],@"date",nil];
    
    NSString * jsonStr = [imageDic JSONString];
    NSString * content = [NSString stringWithFormat:@"%@%@",kImageRequest,jsonStr];
    
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
    
    return [message autorelease];
}

-(ImageMessage *)confromFromMessage:(CommonMessage *)message
{
    ImageMessage * imgMessage = [[ImageMessage alloc]init];
    if([message.content hasPrefix:kImageRequest])
    {
        NSString * josnStr = [message.content substringFromIndex:[kImageRequest length]];
        NSDictionary * josnDic = [josnStr objectFromJSONString];
        NSString * imageStr = [josnDic valueForKey:@"image"];
        UIImage * image = [Base64Helper string2Image:imageStr];
        
//        NSString * loginLocate = [josnDic objectForKey:@"loginLocate"];
//        CLLocationCoordinate2D loglocation = CLLocationCoordinate2DMake(0.0, 0.0);
//        if (loginLocate) {
//            
//            loglocation = [AppUtility transformFromNSString:loginLocate];
//        }

        imgMessage.uid = message.uid;
        imgMessage.fid = message.fid;
        imgMessage.image = image;
        imgMessage.roomid = message.roomid;
        imgMessage.date = [NSDate dateWithTimeIntervalSince1970:[[josnDic valueForKey:@"date"]doubleValue]];
        imgMessage.type = message.type;
        
//        imgMessage.touid = message.touid;
//        imgMessage.state = message.state;

//        imgMessage.loginLocate = loglocation;

        
    }
    return [imgMessage autorelease];
}

+(void)imageManager:(CommonMessage *)message
{
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        @try{
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
}


@end
