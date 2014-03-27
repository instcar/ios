//
//  CheckNetwork.m
//  CloudThinkProject
//
//  Created by Mr.Lu on 13-5-9.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import "CheckNetwork.h"
#import "SVProgressHUD.h"
@implementation CheckNetwork
+(BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork = YES;
    Reachability *r = [Reachability reachabilityForInternetConnection];

    switch ([r currentReachabilityStatus]) {
        case NotReachable:
        {
            isExistenceNetwork=NO;
            [SVProgressHUD showErrorWithStatus:@"网络断开"];
            break;
        }
        case ReachableViaWWAN:
        {
            isExistenceNetwork=YES;
            [SVProgressHUD showSuccessWithStatus:@"3G网络开启"];
            break;
        }
        case ReachableViaWiFi:
        {
            isExistenceNetwork=YES;
            [SVProgressHUD showSuccessWithStatus:@"wifi网络开启"];
            break;
        }
    }
    
    return isExistenceNetwork;
}
@end
