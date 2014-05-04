//
//  SetAgeGenderViewController.h
//  CarApp
//
//  Created by 海龙 李 on 13-11-17.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMBlurView.h"

@interface SetAgeGenderViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    int _ageIndex;
    int _age;                                           //选择的年龄
    NSString *_sex;                                     //选中的性别
}

@property(strong, nonatomic)AMBlurView * pickerBackView;
@property(strong, nonatomic)UIPickerView * pickerView;
@property(strong, nonatomic)NSMutableArray * ageArray;

@property(strong, nonatomic) NSMutableDictionary *registerDic;//保存流程传递的数据

@end
