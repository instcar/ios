//
//  CustomLineTableView.h
//  CarApp
//
//  Created by Mac_ZL on 14-5-20.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomLineTableViewCell;
@protocol CustomLineTableViewDelegate;
@interface CustomLineTableView : UIView<UITableViewDataSource,UITableViewDelegate>
{
   
    UITableView *_tableView;
    UIButton *_arrowBtn;
    UIView * _bottomLineView;
    CustomLineTableViewCell *_confirmView;
    UILabel *_confirmLabel;
    UILabel *_confirmNumLabel;
    
    CGRect _initframe;
    NSMutableArray *_record;
    BOOL _isHide;
    
}
@property (strong, nonatomic) NSArray *record;
@property BOOL isConfirm;
@property (weak, nonatomic) id<CustomLineTableViewDelegate> delegate;
- (void) hideTableView;
- (void) showTableView;
- (void) reloadTaleView;
@end

@protocol CustomLineTableViewDelegate <NSObject>

@optional
- (void) lineDidSelectedAtrowIndex:(NSInteger) index;
//isFold 是否展开
- (void) lineTableViewDidAnimate:(BOOL) isFold;
@end

