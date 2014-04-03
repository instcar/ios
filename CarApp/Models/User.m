
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
	@synchronized(self) {
		if (user == nil) {
			user = [[User alloc]init];
		}
	}
	return user;
}

//检查各种配置文件是否存在，不存在则拷贝到document下：1.用户配置
+(void)userDataInit{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",KPlistUser]];
    
    if ([fm fileExistsAtPath:filePath]==NO) {
        //初始化主配置列表并且复制过去
            User *user = [[User alloc] init];
            user.isFirstUse = YES;
            [user save];
    }
    //填装数据
    [[User shareInstance]userWithPlist];
}

//装填
-(void)userWithPlist{
    NSMutableDictionary *dict = [self getPlistContent:KPlistUser];
    user.userId = [[dict objectForKey:@"userId"]longValue];
    user.userName = [dict objectForKey:@"userName"];
    user.userPwd = [dict objectForKey:@"userPwd"];
    user.userData = [dict objectForKey:@"userData"];
    user.session = [dict objectForKey:@"session"];
    user.phoneNum = [dict objectForKey:@"userPhone"];
    user.address = [dict objectForKey:@"address"];
    user.lon = [[dict objectForKey:@"lon"]doubleValue];
    user.lat = [[dict objectForKey:@"lat"]doubleValue];
    
    NSString *isFirstUse = [dict objectForKey:@"isFirstUse"];
    user.isFirstUse =  isFirstUse.boolValue;
    NSString *isSavePwd = [dict objectForKey:@"isSavePwd"];
    user.isSavePwd = isSavePwd.boolValue;
}

//获取plist里的内容
-(NSMutableDictionary *)getPlistContent:(NSString *)plistName{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getPlistPath:plistName]];
    return dict;
}

//获取plist地址
+(NSString *)getPlistPath:(NSString *)plistName{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",plistName]];
    return filePath;
}

//获取plist地址
-(NSString *)getPlistPath:(NSString *)plistName{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",plistName]];
    return filePath;
}

//保存到plist里
-(void)save{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithLong:self.userId] forKey:@"userId"];
    [dict setObject:[AppUtility getStrByNil:self.userName] forKey:@"userName"];
    [dict setObject:[AppUtility getStrByNil:self.userPwd] forKey:@"userPwd"];
    [dict setObject:[AppUtility getStrByNil:self.session] forKey:@"session"];
    [dict setObject:[AppUtility getStrByNil:self.phoneNum] forKey:@"userPhone"];
    [dict setValue:[AppUtility getStrByNil:self.address] forKey:@"address"];
    [dict setObject:[NSString stringWithFormat:@"%lf",self.lon] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%lf",self.lat] forKey:@"lat"];
    
    if (self.userData!=nil) {
        [dict setObject:self.userData forKey:@"userData"];
    }else{
        [dict setObject:[[NSDictionary alloc] init] forKey:@"userData"];
    }

    if (self.address!=nil) {
        [dict setObject:self.address forKey:@"address"];
    }else{
        [dict removeObjectForKey:@"address"];
    }
    
    [dict setObject:[NSNumber numberWithBool:self.isFirstUse] forKey:@"isFirstUse"];
    [dict setObject:[NSNumber numberWithBool:self.isSavePwd] forKey:@"isSavePwd"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [dict writeToFile:[self getPlistPath:KPlistUser] atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    });
}

-(void)clear
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isFirstUse"];
    [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isSavePwd"];
    self.userPwd = @"";
    [self setIsSavePwd:NO];
    [self setIsFirstUse:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [dict writeToFile:[self getPlistPath:KPlistUser] atomically:YES];
    });
}

- (void)setCookies:(NSMutableArray *)cookies
{
    [[NSUserDefaults standardUserDefaults] setObject:cookies forKey:@"Cookies"];
}

- (NSMutableArray *)getCookies
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Cookies"]) {
        return [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"Cookies"]];
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
