//
//  PhotoSelectManager.h
//  WPWProject
//
//  Created by Mr.Lu on 13-7-20.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol PhotoSelectManagerDelegate;

@interface PhotoSelectManager : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UINavigationControllerDelegate>

//@property (assign, nonatomic)id<PhotoSelectManagerDelegate> delegate; //代理
//@property (retain, nonatomic)UIViewController * viewController; //视图
//@property (retain, nonatomic)NSMutableArray * selectImages; //选中的照片

//照相机器选择
+ (void)selectPhotoFromCamreWithDelegate:(id<UIImagePickerControllerDelegate>)delegate withVC:(UIViewController *)viewController withEdit:(BOOL)edit;

+ (void)selectPhotoFromPhotoWithDelegate:(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate withVC:(UIViewController *)viewController withEdit:(BOOL)edit;
@end

/*@protocol PhotoSelectManagerDelegate<NSObject>

@optional

//照片选择成功
-(void)photoSelectManager:(PhotoSelectManager *)photoSelectManager SuccessWithInfo:(NSArray *)info;

//照片选择上传成功
-(void)photoSelectManagerToUpload:(PhotoSelectManager *)photoSelectManager SuccessWithInfo:(NSArray *)info;

//相机拍摄成功
-(void)photoSelectManagerFromCamera:(PhotoSelectManager *)photoSelectManager SuccessWithInfo:(NSArray *)info;

//照片选择失败
-(void)photoSelectManager:(PhotoSelectManager *)photoSelectManager FailedWithInfo:(NSError *)error;

//相机拍摄失败
-(void)photoSelectManagerFromCamera:(PhotoSelectManager *)photoSelectManager FailedWithInfo:(NSError *)error;

@end*/