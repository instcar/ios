//
//  SelectPassengerNumPicker.h
//  CarApp
//
//  Created by Mac_ZL on 14-5-22.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PickerScrollView : UITableView
@property NSInteger tagLastSelected;

- (void)dehighlightLastCell;
- (void)highlightCellWithIndexPathRow:(NSUInteger)indexPathRow;
@end

@interface SelectPassengerNumPicker : UIView<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
- (void)setPassengerNum:(int) num;
- (int)getPassengetNum;
@end
