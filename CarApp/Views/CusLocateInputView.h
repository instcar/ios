//
//  CusLocateInputView.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-5-3.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CusLocateInputViewDelegate;

@interface CusLocateInputView : UIView<UITextFieldDelegate>
{
    UILabel *_startLocateLable;
    UILabel *_startLable;
    UITextField *c;
    UIButton *_locateBtn;
    UIActivityIndicatorView *_activity;
}
@property (strong, nonatomic) UILabel *startLable;
@property (strong, nonatomic) UITextField *startInputView;
@property (weak, nonatomic) id<CusLocateInputViewDelegate>delegate;
@property (assign, nonatomic) int type; //当前状态 1，定位 2手动输入
@property (copy, nonatomic) NSString *locateAddress;//定位的信息
@property (copy, nonatomic) NSString *inputAddress;

- (void)resumeView;//恢复视图
- (void)startLocate;//开始定位

@end

@protocol CusLocateInputViewDelegate <NSObject>

- (void)inputModeChange:(int)type;
- (void)locateBtnAction:(UIButton *)sender;
//添加 By Liang Zhao
- (void)inputViewShouldReturn:(CusLocateInputView *) inputView;
//添加 By Liang Zhao
- (void)inputViewTextChanged:(CusLocateInputView *) inputView WithText:(NSString *)text;
@end