//
//  EditTimeViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-26.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditTimeViewControllerDelegate;

@interface EditTimeViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray * _dayArray;
    NSArray * _hourArray;
    NSArray * _minuteArray;
    NSMutableArray * _selectArray;//用来保存选中的数据或是索引
    int _index;//单选
}

@property(retain,nonatomic)UIPickerView * dayPicker;
@property(retain,nonatomic)UIPickerView * timePicker;
@property(retain,nonatomic)id<EditTimeViewControllerDelegate>delegate;
//@property (retain, nonatomic)NSString *selectTime;
//@property (retain, nonatomic)NSArray *selectDay;
@property (retain, nonatomic) NSDate *date;

@end

@protocol EditTimeViewControllerDelegate <NSObject>

-(void)editTimeViewController:(EditTimeViewController *)editTimeViewController select:(NSDate *)date;

@end