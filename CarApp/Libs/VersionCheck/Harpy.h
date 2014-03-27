//
//  Harpy.h
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHarpyCurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]

@interface Harpy : NSObject <UIAlertViewDelegate>

/*
  Checks the installed version of your application against the version currently available on the iTunes store.
  If a newer version exists in the AppStore, it prompts the user to update your app.
 */
+ (void)checkVersion:(BOOL)autoCheck; //autoCheck 为true 在自动版本的时候的检测 state 为false为手动版本版本检测

+ (void)checkVersion:(void(^)(NSString *version,NSString *updataContent))success failse:(void(^)(NSError *error))failse;

+ (void)goAppStore;
@end
