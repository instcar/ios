//
//  IdentityAuthViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-6.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CommonViewController.h"

@interface IdentityAuthViewController : CommonViewController<UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_peopleSampleBookImageView;
    UIView *_peopleBookbg;
    UIImageView *_peopleBookImageView;
    UIButton *_confirmBtn;
}



@end
