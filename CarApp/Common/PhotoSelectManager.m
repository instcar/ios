//
//  PhotoSelectManager.m
//  WPWProject
//
//  Created by Mr.Lu on 13-7-20.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import "PhotoSelectManager.h"
//#import "QBImagePickerController.h"

@implementation PhotoSelectManager

//相机照片选择
+(void)selectPhotoFromCamreWithDelegate:(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate withVC:(UIViewController *)viewController withEdit:(BOOL)edit
{
    @try {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
            [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
            [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
            [cameraVC setDelegate:delegate];
            [cameraVC setAllowsEditing:edit];
//            [cameraVC setShowsCameraControls:NO];
            [cameraVC setModalPresentationStyle:UIModalPresentationCurrentContext];
            [cameraVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade]; //隐藏工具栏
            
            if (kDeviceVersion >= 7.0) {
                [[cameraVC navigationBar] setBarTintColor:[UIColor blackColor]];
                [[cameraVC navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor flatGrayColor],UITextAttributeTextColor,nil]];
                [[cameraVC navigationBar] setBackgroundImage:[[UIImage imageNamed:@"navgationbar_64"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)] forBarPosition:UIBarPositionTop  barMetrics:UIBarMetricsDefault];
//                [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                // ios 7 导航栏遮盖问题
                [[cameraVC navigationBar] setTranslucent:NO];
            }
            else
            {
                [[cameraVC navigationBar] setTintColor:[UIColor blackColor]];
                [[cameraVC navigationBar] setBackgroundImage:[[UIImage imageNamed:@"navgationbar_44"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)] forBarMetrics:UIBarMetricsDefault];
                [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }

            
            //显示Camera VC
            [viewController presentViewController:cameraVC animated:YES completion:^{
                
            }];
            
        }else {
            DLog(@"Camera is not available.");
        }
    }
    @catch (NSException *exception) {
        DLog(@"Camera is not available.");
    }
}


//选择照片
+(void)selectPhotoFromPhotoWithDelegate:(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate withVC:(UIViewController *)viewController withEdit:(BOOL)edit
{
    @try {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController * picker_library = [[UIImagePickerController alloc] init];
            [picker_library setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [picker_library setAllowsEditing:edit];
            [picker_library setDelegate:delegate];
            
            if (kDeviceVersion >= 7.0) {
                [[picker_library navigationBar] setBarTintColor:[UIColor blackColor]];
                [[picker_library navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor flatGrayColor],UITextAttributeTextColor,nil]];
                [[picker_library navigationBar] setBackgroundImage:[[UIImage imageNamed:@"navgationbar_64"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)] forBarPosition:UIBarPositionTop  barMetrics:UIBarMetricsDefault];
                [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                // ios 7 导航栏遮盖问题
                [[picker_library navigationBar] setTranslucent:NO];
            }
            else
            {
                [[picker_library navigationBar] setTintColor:[UIColor blackColor]];
                [[picker_library navigationBar] setBackgroundImage:[[UIImage imageNamed:@"navgationbar_44"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)] forBarMetrics:UIBarMetricsDefault];
                [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }
            
            [viewController presentViewController:picker_library animated:YES completion:^{}];
        }
    }
    @catch (NSException *exception) {
        
    }
}

@end
