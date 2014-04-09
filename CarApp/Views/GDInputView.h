//
//  GDInputView.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-6.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kGDInputViewStatusNomal,
    kGDInputViewStatusDisable,
    kGDInputViewStatusTure,
    kGDInputViewStatusError,
    kGDInputViewStatusNull
    
}kGDInputViewStatus;

@interface GDInputView : UIView<UITextFieldDelegate>
{
    UIImageView *_backGtextImgView;
    UIImageView *_arrowImgView;
}
@property (retain, nonatomic)UITextField *textfield;

-(void)setResult:(kGDInputViewStatus)status;

@end
