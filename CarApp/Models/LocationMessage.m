//
//  LocationMessage.m
//  WPWProject
//
//  Created by Mr.Lu on 13-7-19.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import "LocationMessage.h"
#import "JSONKit.h"
#import "Base64Helper.h"
#import "UIImage+Compress.h"

@implementation LocationMessage
-(CommonMessage *)transformToMessage
{
    
//    NSString * loglocStr = @"";
//    if (self.loginLocate.latitude) {
//        loglocStr = [NSString stringWithFormat:@"%f,%f",self.loginLocate.longitude,self.loginLocate.latitude];
//    }
//    
//    
//    
//    NSString * locStr = [NSString stringWithFormat:@"%f,%f",self.location.longitude,self.location.latitude];
//    
//    //压缩
//    UIImage * image = [UIImage imageWithData:[self.locationImage compressedData]];
//    
//    //编码
//    NSString * imageString = [Base64Helper image2String:image];
//
//    NSDictionary * locationDic = [NSDictionary dictionaryWithObjectsAndKeys:locStr,@"location",self.address,@"address",imageString,@"image",loglocStr,@"loginLocate",[NSNumber numberWithDouble:[self.date timeIntervalSince1970]],@"date",nil];
//    
//    NSString * jsonStr = [locationDic JSONString];
//    NSString * content = [NSString stringWithFormat:@"%@%@",kLocationRequest,jsonStr];
//    
//    CommonMessage * message = [[CommonMessage alloc]init];
//    message.uid = self.uid;
//    message.touid = self.touid;
//    message.content = content;
//    message.state = self.state;
//    message.type = self.type;
//    message.date = self.date;
//    message.loginLocate = self.loginLocate;
//    
//    return [message autorelease];
    return nil;
}

-(LocationMessage *)confromFromMessage:(CommonMessage *)message
{
//    LocationMessage * locationMessage = [[LocationMessage alloc]init];
//    if([message.content hasPrefix:kLocationRequest])
//    {
//        NSString * josnStr = [message.content substringFromIndex:[kLocationRequest length]];
//        NSDictionary * locationDic= [josnStr objectFromJSONString];
//        
//        NSString * locationStr = [locationDic objectForKey:@"location"];
//        NSString * addressStr = [locationDic objectForKey:@"address"];
//        float longtitude = [[[locationStr componentsSeparatedByString:@","]objectAtIndex:0]floatValue];
//        float latitude = [[[locationStr componentsSeparatedByString:@","]objectAtIndex:1]floatValue];
//        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude, longtitude);
//        
//        NSString * imageStr = [locationDic valueForKey:@"image"];
//        UIImage * image = nil;
//        if (imageStr) {
//           image  = [Base64Helper string2Image:imageStr];
//        }
//        
//        NSString * loginLocate = [locationDic objectForKey:@"loginLocate"];
//        CLLocationCoordinate2D loglocation = CLLocationCoordinate2DMake(0.0, 0.0);
//        if (loginLocate) {
//            float longtitude = [[[loginLocate componentsSeparatedByString:@","]objectAtIndex:0]floatValue];
//            float latitude = [[[loginLocate componentsSeparatedByString:@","]objectAtIndex:1]floatValue];
//            loglocation = CLLocationCoordinate2DMake(latitude, longtitude);
//        }
//
//        
//        
//        locationMessage.uid = message.uid;
//        locationMessage.touid = message.touid;
//        locationMessage.location = location;
//        locationMessage.address = addressStr;
//        locationMessage.locationImage = image;
//        
//        if ([locationDic objectForKey:@"date"]) {
//           locationMessage.date = [NSDate dateWithTimeIntervalSince1970:[[locationDic valueForKey:@"date"]doubleValue]];
//        }
//        else
//        locationMessage.date = message.date;
//        
//        locationMessage.state = message.state;
//        locationMessage.type = message.type;
//        
//        locationMessage.loginLocate = loglocation;
//    }
//
//    return [locationMessage autorelease];
    return nil;
}
@end
