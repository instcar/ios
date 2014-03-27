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

@property(retain,nonatomic)AMBlurView * pickerBackView;
@property(retain,nonatomic)UIPickerView * pickerView;
@property(retain,nonatomic)NSMutableArray * ageArray;

@property (retain, nonatomic) NSMutableDictionary *registerDic;//保存流程传递的数据

@end
