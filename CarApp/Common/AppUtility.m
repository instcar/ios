//
//  AppUtility.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-13.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "AppUtility.h"
#import "XmppManager.h"

static NSDateFormatter *dateFormate=nil;

@implementation AppUtility

+(NSDateFormatter *)shareDateFormate
{
    @synchronized(self) {
        if (dateFormate == nil) {
            dateFormate = [[NSDateFormatter alloc]init];
        }
    }
    return dateFormate;
}

+(CGRect)mainViewFrame;
{
    
    if(kDeviceVersion >= 7.0)
    {
        return CGRectMake(0, 0, 320, SCREEN_HEIGHT);
    }
    else
    {
        return CGRectMake(0, -20, 320, SCREEN_HEIGHT);
    }
}

+ (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(textView.contentSize.width - fPadding, CGFLOAT_MAX);
    
    CGSize size = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion]floatValue] < 7.0) {
		if ([[[UIDevice currentDevice] systemVersion]floatValue] < 6.0) {
			size = [strText sizeWithFont:textView.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
		} else {
			size = [strText sizeWithFont:textView.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
		}
	}
    else
    {
        size.height = [strText boundingRectWithSize:CGSizeMake(textView.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:textView.font,NSFontAttributeName, nil] context:nil].size.height;
    }
    
    float fHeight = size.height + 16.0;
    
    return fHeight;
}

+ (float)widthForRect:(CGRect)rect WithText:(NSString *)strText font:(UIFont *)font
{
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(CGFLOAT_MAX, rect.size.height);
    
    CGSize size = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion]floatValue] < 7.0) {
		if ([[[UIDevice currentDevice] systemVersion]floatValue] < 6.0) {
			size = [strText sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
		} else {
			size = [strText sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
		}
	}
    else
    {
        size.width = [strText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size.width;
    }
    
    float fwidth = size.width + fPadding;
    
    return fwidth;
}

+(float)heightForRect:(CGRect)rect WithText:(NSString *)strText font:(UIFont *)font
{
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(rect.size.width - fPadding, CGFLOAT_MAX);
    
    CGSize size = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion]floatValue] < 7.0) {
		if ([[[UIDevice currentDevice] systemVersion]floatValue] < 6.0) {
			size = [strText sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
		} else {
			size = [strText sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
		}
	}
    else
    {
        size.height = [strText boundingRectWithSize:CGSizeMake(rect.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size.height;
    }
    
    float fHeight = size.height + 16.0;
    
    return fHeight;
}

//将null以及nsnull类型转换成空字符串
+(NSString *)getStrByNil:(NSString *)str{
    if (str==nil||[str isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    return str;
}

+(NSDate *)dateFromStr:(NSString *)string withFormate:(NSString *)formate
{
    if ([string isEqualToString:@""] || string == nil) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [AppUtility shareDateFormate];
    [dateFormatter setDateFormat:formate];
    NSDate *date=[dateFormatter dateFromString:string];   //需要转化的字符串
    return date;
}

+(NSString *)strFromDate:(NSDate *)date withFormate:(NSString *)formate
{
    NSDateFormatter *dateFormatter = [AppUtility shareDateFormate];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:formate];
    NSString *dateStr=[dateFormatter stringFromDate:date];   //需要转化的字符串
    return dateStr;
}

+(NSString *)strTimeInterval:(NSTimeInterval)timeInterval
{
    int d = timeInterval/60/60/24;
    int h = timeInterval/60/60;
    int m = timeInterval/60;
    if( d > 0)
    {
        return [NSString stringWithFormat:@"%d天前",d];
    }
    if (h > 0) {
        return [NSString stringWithFormat:@"%d小时前",h];
    }
    if (m > 0) {
        return [NSString stringWithFormat:@"%d分钟前",m];
    }

    return @"刚刚";
}

+(NSString *)dayStrTimeDate:(NSDate *)date
{
    int nowDay = [AppUtility getDayConponentFromDate:[NSDate date]];
    int startDay = [AppUtility getDayConponentFromDate:date];
    
    if(startDay == nowDay)
    {
        return @"今天";
    }
    
    if ((startDay - nowDay) == 1) {
        return @"明天";
    }
    
    if ((startDay - nowDay) == 2) {
        return @"后天";
    }
    
    return @"未知";
}

+(NSString *)ampmStrTimeDate:(NSDate *)date
{
    NSString *ampm = [AppUtility strFromDate:date withFormate:@"hh:mm:a"];
    ampm = [[ampm componentsSeparatedByString:@":"] objectAtIndex:2];
    if([ampm isEqualToString:@"AM"]){
        return @"上午";
    }
    
    if ([ampm isEqualToString:@"PM"]) {
        return @"下午";
    }
    
    return @"未知";
}

+(int)getDayConponentFromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    int day = [dateComponent day];
    return day;
}

//去掉多余的分割线
+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

+(NSString *)LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2
{
    CLLocation* orig=[[CLLocation alloc] initWithLatitude:lat1  longitude:lon1];
    CLLocation* dist=[[CLLocation alloc] initWithLatitude:lat2 longitude:lon2];
    
    CLLocationDistance meters=[orig distanceFromLocation:dist];
    if (meters < 1000) {
        return [NSString stringWithFormat:@"%.fm",meters];
    }
    else
    {
        NSString * distance = [NSString stringWithFormat:@"%.1fkm",meters/1000];
        return distance;
    }
}

+(CLLocationCoordinate2D)transformFromNSString:(NSString *)locationStr
{
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(0.0, 0.0);
    if (locationStr && [[locationStr componentsSeparatedByString:@","] count]==2) {
        float latitude = [[[locationStr componentsSeparatedByString:@","]objectAtIndex:0]floatValue];
        float longtitude = [[[locationStr componentsSeparatedByString:@","]objectAtIndex:1]floatValue];
        location = CLLocationCoordinate2DMake(latitude, longtitude);
    }
    return location;
}


//+(int)getuidForm:(NSString *)string
//{
//    NSString * stortUidStr = (NSString *)[[string componentsSeparatedByString:@"@"] objectAtIndex:0];
//    NSString * uid = [stortUidStr substringFromIndex:[@"mt" length]];
//    return [uid intValue];
//}
//+(NSString *)formateToUserWithUid:(int)uid
//{
//    return [NSString stringWithFormat:@"mt%d@%@",uid,kOpenFireHostName];
//}

+(long)useridFromUserName:(NSString *)userName
{
    
    if ([userName hasPrefix:kJidPrdfix]) {
        NSString *user = [[userName componentsSeparatedByString:@"@"]objectAtIndex:0];
        long roomid = [[user substringFromIndex:[kJidPrdfix length]] longLongValue];
        return roomid;
    }
    else
    {
        DLog(@"%@ 不是正确的用户名",userName);
        return 0;
    }
}

+(NSString *)userNameFromUserID:(long)userid
{
        //格式化xmpp uid名字
    NSString *uidStr = [NSString stringWithFormat:@"%@%ld",kJidPrdfix,userid];
    NSString *jid = [NSString stringWithFormat:@"%@@%@/InstcarXmppIOS",uidStr,kOpenFireHost];
    return jid;
}

+(long)useridFromRoomName:(NSString *)userName
{
    
    if ([userName hasPrefix:KRoomNamePrdFix]) {
        NSArray *array = [userName componentsSeparatedByString:@"/"];
        if ([array count]>1) {
            NSString *user = [array objectAtIndex:1];
            NSArray *array = [user componentsSeparatedByString:@"/"];
            if ([array count]>1) {
                user = [array objectAtIndex:1];
            }
            long userid = [[user substringFromIndex:[kJidPrdfix length]] longLongValue];
            return userid;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        DLog(@"%@ 不是正确的用户名",userName);
        return -1;
    }
}

+(long)roomidFromgroupName:(NSString *)roomName
{
    if ([roomName hasPrefix:KRoomNamePrdFix]) {
        NSString *groupName = [[roomName componentsSeparatedByString:@"@"]objectAtIndex:0];
        long roomid = [[groupName substringFromIndex:[KRoomNamePrdFix length]] longLongValue];
        return roomid;
    }
    else
    {
        DLog(@"%@ 不是正确的房间名",roomName);
        return 0;
    }
}

+(NSString *)groupNameFromRoomID:(long)roomid
{
    NSString * groupName = [NSString stringWithFormat:@"%@%ld",KRoomNamePrdFix,roomid];
    
    //创建一个新的群聊房间,roomName是房间名 Nickname是房间里自己所用的昵称
    
    NSString * hostname = kopenFireMasterName;
    
    NSString * roomName = [NSString stringWithFormat:@"%@@conference.%@",groupName,hostname];
    
    return roomName;
}



@end
