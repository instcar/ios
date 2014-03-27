//
//  MainThirdView.h
//  CarApp
//
//  Created by Leno on 13-9-27.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@protocol MainThirdViewDelegate;

@interface MainThirdView : UIView<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    int _jokepage;
    BOOL _jokeCanLoadMore;

    NSArray *_thridTableData;
}
@property(retain, nonatomic)PullingRefreshTableView *tableView;
@property(retain, nonatomic) NSArray *thridTableData;
@property (nonatomic, assign) id<MainThirdViewDelegate> delegate;
@property(retain, nonatomic) NSMutableArray *jokeArray;
@property (retain, nonatomic) UIViewController *mainVC;

-(void)setTableData:(NSArray *)array;

@end

@protocol MainThirdViewDelegate <NSObject>

-(void)thirdTableDidClicked:(int)index;
-(void)mainThirdViewLoadMoreData;
-(void)mainThirdViewreflushData;

@end

