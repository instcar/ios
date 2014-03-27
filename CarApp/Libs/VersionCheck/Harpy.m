//
//  Harpy.m
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import "Harpy.h"
#import "HarpyConstants.h"
#import "SVProgressHUD.h"

@implementation Harpy

#pragma mark - Public Methods

+ (void)checkVersion:(BOOL)autoCheck
{
    // Asynchronously query iTunes AppStore for publically available version
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kHarpyAppID];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:1000];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [SVProgressHUD showWithStatus:@"正在检测版本..."];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ( [data length] > 0 && !error ) { // Success
            
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",[appData valueForKey:@"results"]);
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                
                if ( ![versionsInAppStore count] ) {
                    // No versions of app in AppStore
                    if (autoCheck) {
                        return;
                    }
                    else
                    {
                        [SVProgressHUD showSuccessWithStatus:@"当前版本是最新的"];
                    }
                    
                } else {

                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                    NSString * message =[[[appData valueForKey:@"results"] objectAtIndex:0] valueForKey:@"releaseNotes"];
                    if ([kHarpyCurrentVersion compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
		                
                        [Harpy showAlertWithAppStoreVersion:currentAppStoreVersion withMessage:message];
                    }
                    else { // Current installed version is the newest public version or newer
                        if(autoCheck)
                        {
                            return;
                        }
                        else
                        {
                             [SVProgressHUD showSuccessWithStatus:@"当前版本是最新的"];
                        }
                    }

                }
              
            });
        }
        
    }];
}

#pragma mark - Private Methods
+ (void)showAlertWithAppStoreVersion:(NSString *)currentAppStoreVersion withMessage:(NSString *)message
{
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    [SVProgressHUD dismiss];
    if ( harpyForceUpdate ) { // Force user to update app
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                            message:[NSString stringWithFormat:@"%@  version %@ 更新内容:\n %@", appName, currentAppStoreVersion,message]
                                                           delegate:self
                                                  cancelButtonTitle:kHarpyUpdateButtonTitle
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];

        
    } else { // Allow user option to update next time user launches your app
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                            message:[NSString stringWithFormat:@"%@  version %@ 更新内容:\n %@", appName, currentAppStoreVersion,message]
                                                           delegate:self
                                                  cancelButtonTitle:kHarpyCancelButtonTitle
                                                  otherButtonTitles:kHarpyUpdateButtonTitle, nil];
        
        
        [alertView show];
        [alertView release];
    }
}

#pragma mark - UIAlertViewDelegate Methods
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( harpyForceUpdate ) {
        NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
        NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
        [[UIApplication sharedApplication] openURL:iTunesURL];
    }
    else
    {
        switch ( buttonIndex ) {
            case 0:{ // Cancel
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
            } break;
                
            case 1:{ // Update
                NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
                NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
                [[UIApplication sharedApplication] openURL:iTunesURL];
            } break;
                
            default:
                break;
        }
    }
}

+(void)checkVersion:(void (^)(NSString *, NSString *))success failse:(void (^)(NSError *))failse
{
    // Asynchronously query iTunes AppStore for publically available version
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kHarpyAppID];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:1000];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ( [data length] > 0 && !error ) { // Success
            
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",[appData valueForKey:@"results"]);
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                
                if ( ![versionsInAppStore count] ) {
                    // No versions of app in AppStore
                        success(@"当前版本为最新版本",nil);
                    
                } else {
                    
                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                    NSString * message =[[[appData valueForKey:@"results"] objectAtIndex:0] valueForKey:@"releaseNotes"];
                    if ([kHarpyCurrentVersion compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
                        success(currentAppStoreVersion,message);
                    }
                    else { // Current installed version is the newest public version or newer
                        success(@"当前版本为最新版本",nil);
                    }
                    
                }
                
            });
        }
        else
        {
            failse(error);
        }
    }];

}

+(void)goAppStore
{
    NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
    NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
    [[UIApplication sharedApplication] openURL:iTunesURL];
}
@end
