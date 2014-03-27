//
//  CustomSearchBarControl.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-14.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumCommon.h"
#import "BDRecognizerViewController.h"
#import "BDRecognizerViewDelegate.h"
#import "BDVRFileRecognizer.h"
#import "BDVRCustomRecognitonViewController.h"

typedef enum
{
    kSearchBarStyleBlue,
    kSearchBarStyleGreen
}kSearchBarStyle;

@protocol CustomSearchBarControlDelegate;

@interface CustomSearchBarControl : UIControl<BDRecognizerViewDelegate, MVoiceRecognitionClientDelegate,BDVRCustomRecognitonViewControllerDelegate,UITextFieldDelegate>
{
    kSearchBarStyle _searchBarstyle;
}
@property (assign, nonatomic)id<CustomSearchBarControlDelegate>delegate;
-(id)initWithFrame:(CGRect)frame withStyle:(kSearchBarStyle)style;

@end

@protocol CustomSearchBarControlDelegate <NSObject>

@required
- (void)customSearchBarControl:(CustomSearchBarControl *)customSearchBarControl result:(NSString *)result;

@end