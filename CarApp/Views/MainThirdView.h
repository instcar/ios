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
@property(strong, nonatomic)PullingRefreshTableView *tableView;
@property(strong, nonatomic) NSArray *thridTableData;
@property (nonatomic, assign) id<MainThirdViewDelegate> delegate;
@property(strong, nonatomic) NSMutableArray *jokeArray;
@property (strong, nonatomic) UIViewController *mainVC;

-(void)setTableData:(NSArray *)array;

@end

@protocol MainThirdViewDelegate <NSObject>

-(void)thirdTableDidClicked:(int)index;
-(void)mainThirdViewLoadMoreData;
-(void)mainThirdViewreflushData;

@end

