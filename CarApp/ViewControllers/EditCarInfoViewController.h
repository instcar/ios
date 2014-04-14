//
//  EditCarInfoViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-13.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CommonViewController.h"

@interface EditCarInfoViewController : CommonViewController<UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIScrollView *_scrollView;

    UIImageView *_carLogoImageView;
    UILabel *_carName;
    UILabel *_carModel;
    
    UIView *_carBookbg;
    UIButton *_addcarFrontBtn;
    UIButton *_addcarSliderBtn;
    
    UIImageView *_carBookImageView;
    UIImageView *_carFrontImageView;
    UIImageView *_carSliderImageView;
    UIButton *_confirmBtn;
}
@end
