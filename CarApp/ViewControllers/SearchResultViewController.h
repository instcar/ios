//
//  SearchResultViewController.h
//  CarApp
//
//  Created by 海龙 李 on 13-11-25.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol searchResultDelegate;

@interface SearchResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _resultsTable;
}

@property (nonatomic, assign) id<searchResultDelegate> delegate;

@property(retain,nonatomic)NSString * searchKeyWord;

@end


@protocol searchResultDelegate <NSObject>

-(void)searchResultSelected:(NSString *)result;

@end
