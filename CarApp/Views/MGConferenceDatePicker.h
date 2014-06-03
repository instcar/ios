//
//  MGConferenceDatePicker.h
//  MGConferenceDatePicker
//
//  Created by Matteo Gobbi on 09/02/14.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MGConferenceDatePickerDelegate;


@interface MGPickerScrollView : UITableView
@property NSInteger tagLastSelected;

- (void)dehighlightLastCell;
- (void)highlightCellWithIndexPathRow:(NSUInteger)indexPathRow;
@end

//Data Picker
@interface MGConferenceDatePicker : UIView <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <MGConferenceDatePickerDelegate>delegate;
@property (nonatomic, strong, readonly) NSDate *selectedDate;
- (NSDate *)getCurrentDate;
@end
