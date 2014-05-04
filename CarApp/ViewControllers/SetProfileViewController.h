//
//  SetProfileViewController.h
//  CarApp
//
//  Created by 海龙 李 on 13-11-13.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMBlurView.h"


@interface SetProfileViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    int _ageIndex;
}
@property(strong, nonatomic)UITableView *setProfileTable;
@property(strong, nonatomic)NSString *phoneNumberString;
@property(strong, nonatomic)NSMutableArray *ageArray;

@end
