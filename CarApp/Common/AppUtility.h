//
//  AppUtility.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-13.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AppUtility : NSObject

+(CGRect)mainViewFrame;//ios7 适配

//检测手机号码是否符合要求
+ (BOOL)validateMobile:(NSString *)mobileNum;

//得到文本框的高度
+ (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText;
//得到文本框的高度
+ (float) heightForRect:(CGRect)rect WithText:(NSString *) strText font:(UIFont *)font;

+ (float)widthForRect:(CGRect)rect WithText:(NSString *)strText font:(UIFont *)font;

//格式化字符串
+ (NSString *)getStrByNil:(NSString *)str;

//时间转换
+(NSDate *)dateFromStr:(NSString *)string withFormate:(NSString *)formate;
+(NSString *)strFromDate:(NSDate *)date withFormate:(NSString *)formate;
+(NSString *)strTimeInterval:(NSTimeInterval)timeInterval;
+(NSString *)dayStrTimeDate:(NSDate *)date;
+(NSString *)ampmStrTimeDate:(NSDate *)date;
+(int)getDayConponentFromDate:(NSDate *)date;

//去除tableView多余的线
+ (void)setExtraCellLineHidden: (UITableView *)tableView;

//计算定位点的距离
+(NSString *)LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2;

//字符串转换串定位信息
+(CLLocationCoordinate2D)transformFromNSString:(NSString *)locationStr;

//聊天相关
+(NSString *)groupNameFromRoomID:(long)roomid;
+(long)roomidFromgroupName:(NSString *)groupName;

+(NSString *)userNameFromUserID:(long)userid;
+(long)useridFromUserName:(NSString *)userName;//群聊天室
+(long)useridFromRoomName:(NSString *)userName;//群聊天室里面的用户

@end
