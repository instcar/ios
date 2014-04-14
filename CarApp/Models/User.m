//
//  User.m
//  ToCall
//
//  Created by guo on 13-7-26.
//  Copyright (c) 2013年 guo. All rights reserved.
//

#import "User.h"
#import "AppUtility.h"
static User *user = nil;

@implementation User

+ (User *)shareInstance
{
    @synchronized(self){
        if (user == nil) {
			user = [[User alloc]init];
		}
    }
    return user;
}

-(void)clear
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ISSAVEPWD"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERPASSWORD"];
}

- (void)setUserId:(long)userId
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:userId] forKey:@"USERID"];
}

- (long)getUserId
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"] longValue];
}

- (void)setUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"USERNAME"];
}

- (NSString *)getUserName
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"USERNAME"];
}

- (void)setUserPwd:(NSString *)userPwd
{
    [[NSUserDefaults standardUserDefaults] setValue:userPwd forKey:@"USERPASSWORD"];
}

- (NSString *)getUserPwd
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"USERPASSWORD"];
}


- (void)setPhoneNum:(NSString *)phoneNum
{
    [[NSUserDefaults standardUserDefaults] setValue:phoneNum forKey:@"PHONENUM"];
}

- (NSString *)getPhoneNum
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"PHONENUM"];
}

- (void)setIsFirstUse:(BOOL)isFirstUse
{
    [[NSUserDefaults standardUserDefaults] setBool:isFirstUse forKey:@"ISFIRSTUSE"];
}

- (BOOL)getIsFirstUse
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ISFIRSTUSE"];
}

- (void)setIsSavePwd:(BOOL)isSavePwd
{
    [[NSUserDefaults standardUserDefaults] setBool:isSavePwd forKey:@"ISSAVEPWD"];
}

- (BOOL)getIsSavePwd
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ISSAVEPWD"];
}

- (void)setLat:(double)lat
{
     [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:lat] forKey:@"LAT"];
}

- (double)getLat
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"LAT"] doubleValue];
}

- (void)setLon:(double)lon
{
     [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:lon] forKey:@"LON"];
}

- (double)getLon
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"LON"] doubleValue];
}

- (void)setAddress:(NSString *)address
{
    [[NSUserDefaults standardUserDefaults] setValue:address forKey:@"ADDRESS"];
}

- (NSString *)getAddress
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"ADDRESS"];
}

- (void)setUserData:(NSMutableDictionary *)userData
{
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"USERDATA"];
}

- (NSMutableDictionary *)getUserData
{
    return [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"USERDATA"]];
}

- (void)setCookies:(NSArray *)cookies
{
    if (!cookies) {
        return;
    }
    if ([cookies count] == 0) {
        return;
    }
    //按键值更新
    NSMutableArray *lcookies = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Cookies"]) {
        NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"Cookies"];
        lcookies = [NSMutableArray arrayWithArray:(NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    }
    
    for (int i = 0; i < [cookies count]; i++) {
        NSHTTPCookie *httpCookie = [cookies objectAtIndex:i];
        for (int i = 0; i < [lcookies count]; i++) {
            NSHTTPCookie *lhttpCookie = [lcookies objectAtIndex:i];
            if ([httpCookie.name isEqualToString:lhttpCookie.name]) {
                [lcookies replaceObjectAtIndex:i withObject:httpCookie];
                break;
            }
            else
            {
                if (i == [lcookies count]-1) {
                    [lcookies addObject:httpCookie];
                    break;
                }
            }
        }
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:(NSArray *)cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Cookies"];
}

- (NSArray *)getCookies
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Cookies"]) {
        NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"Cookies"];
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return cookies;
    }
    return nil;
}

//系统设置
//声音
-(void)setSoundEnable:(BOOL)soundEnable
{
    [[NSUserDefaults standardUserDefaults] setBool:soundEnable forKey:@"SoundEnable"];
}

-(BOOL)getSoundEnable
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"SoundEnable"]) {
        return [[NSUserDefaults standardUserDefaults] boolForKey:@"SoundEnable"];
    }
    return YES;
}

//推送
-(void)setPushEnable:(BOOL)pushEnable
{
    [[NSUserDefaults standardUserDefaults] setBool:pushEnable forKey:@"PushEnable"];
}

-(BOOL)getPushEnable
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"PushEnable"]) {
        return [[NSUserDefaults standardUserDefaults] boolForKey:@"PushEnable"];
    }
    return YES;
}

//定位
-(void)setLocateEnable:(BOOL)locateEnable
{
    [[NSUserDefaults standardUserDefaults] setBool:locateEnable forKey:@"LocateEnable"];
}

-(BOOL)getLocateEnable
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"LocateEnable"]) {
        return [[NSUserDefaults standardUserDefaults] boolForKey:@"LocateEnable"];
    }
    return YES;
}

//自动发布
-(void)setAutoPublish:(BOOL)autoPublish
{
    [[NSUserDefaults standardUserDefaults] setBool:autoPublish forKey:@"autoPublish"];
}

-(BOOL)getAutoPublish
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"autoPublish"]) {
        return [[NSUserDefaults standardUserDefaults] boolForKey:@"autoPublish"];
    }
    return YES;
}

//版本
-(void)setVersion:(NSString *)version
{
    [[NSUserDefaults standardUserDefaults] setValue:version forKey:@"Version"];
}

-(NSString *)getVersion
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Version"]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey:@"Version"];
    }
    return @"version";
}

- (NSString *)getOpenuuid
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"phoneuuid"]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey:@"phoneuuid"];
    }
    return @"version";
}

- (void)setOpenuuid:(NSString *)openuuid
{
    [[NSUserDefaults standardUserDefaults] setValue:openuuid forKey:@"phoneuuid"];
}

@end
