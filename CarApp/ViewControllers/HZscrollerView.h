//
//  HZscrollerView.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-27.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HZscrollerViewDelegate;

@interface HZscrollerView : UIView<UIScrollViewDelegate>
{
    int _currentSelectIndex;
    int _type;
}


@property (strong, nonatomic) NSArray *data;
@property (assign, nonatomic) id<HZscrollerViewDelegate> delegate;
@property (assign, nonatomic) int initSelectIndex;

-(id)initWithFrame:(CGRect)frame withType:(int)type;
-(void)reloadView;
-(int)currentSelectIndex;

@end

@protocol HZscrollerViewDelegate<NSObject>

-(void)HZScrollerView:(HZscrollerView *)hzscrollerView select:(int)index;

//-(void)HZScrollerViewLoadmoreData;
//
//-(void)HZScrollerViewRefreshData;

@end