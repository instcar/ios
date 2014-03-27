//
//  WarnView.h
//  CloudThinkProject
//
//  Created by Mr.Lu on 13-5-30.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kenumWarnViewTypeNullData,
    kenumWarnViewTypeServeError,
}kenumWarnViewType;

@protocol WarnViewDelegate<NSObject>
@optional
-(void)warnViewBtnAction:(id)sender; //警告视图的按钮事件
@end

@interface WarnView : UIView<WarnViewDelegate>
{
    UILabel * warnLable;
}
@property (assign, nonatomic)id<WarnViewDelegate> delegate;
@property (copy, nonatomic)NSString * warnTitle;
//警告视图的按钮事件
-(id)initWithFrame:(CGRect)frame showImage:(NSString *)logoImage withTitle:(NSString *)title withButtonStr:(NSString *)buttonTitle withDelegate:(id)delegate ;

+ (WarnView *)initWarnViewWithText:(NSString *)text withView:(UIView *)view height:(float)height withDelegate:(id)delegate;
-(void)show:(kenumWarnViewType)type;
-(void)dismiss;
@end




