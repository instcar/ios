//
//  DateSelectControl.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-26.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateSelectControl : UIView

@property (retain, nonatomic)NSString *selectTime;
@property (retain, nonatomic)NSArray *selectDay;
@property (assign, nonatomic)SEL btnAction;
@property (assign, nonatomic)id target;
@property (assign, nonatomic)BOOL canEidt;
@property (retain, nonatomic)NSDate *date;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
//- (void)setSelectDay:(NSArray *)selectDay andSelectTime:(NSString *)selectTime;

@end
