//
//  ExtendView.h
//  PRJ_MrLu_GroupChat
//
//  Created by MacPro-Mr.Lu on 13-11-22.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExtendViewDelegate;

@interface ExtendView : UIView
{
    NSArray *_btnTitleArray;
    NSArray *_btnImageArray;
}

@property(nonatomic,assign)id<ExtendViewDelegate> delegate;

-(void)loadExtendView:(int)page size:(CGSize)size row:(int)row column:(int)column;

@end

@protocol ExtendViewDelegate<NSObject>

-(void)selectedExtendView:(int)index;

@end