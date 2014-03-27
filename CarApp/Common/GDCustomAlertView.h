//
//  GDCustomAlertView.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-6.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GDCustomAlertDelegate;

@interface GDCustomAlertView : UIAlertView{
    id  _GDdelegate;
    UIImage *_backgroundImage;
    UIImage *_contentImage;
    NSMutableArray *_buttonArrays;
    
}

@property(readwrite, retain) UIImage *backgroundImage;
@property(readwrite, retain) UIImage *contentImage;
@property(nonatomic, assign) id<GDCustomAlertDelegate> GDdelegate;

- (id)initWithImage:(UIImage *)image frame:(CGRect)frame contentImage:(UIImage *)content;
-(void) addButtonWithUIButton:(UIButton *) btn;

@end

@protocol GDCustomAlertDelegate <NSObject>
@optional
- (void)customAlertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end