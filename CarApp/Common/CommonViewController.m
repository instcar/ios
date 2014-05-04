//
//  CommonViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-17.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()


@end

@implementation CommonViewController
-(void)dealloc
{

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

//- (id)init
//{
//    self = [super init];
//    if (self) {
//        self.enableMessage = YES;
//        self.editing = NO;
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.enableMessage = YES;
    self.enableEditing = NO;
    self.enableBackButton = NO;
    
    //标题
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor appNavTitleColor]];
    [_titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
//    [self.navigationController.navigationItem setTitleView:_titleLabel];
    
    //logo
    _headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 110, 25)];
    [_headerImgView setBackgroundColor:[UIColor clearColor]];
    [_headerImgView setImage:[UIImage imageNamed:@"logo_start"]];
    [self.navigationItem setTitleView:_headerImgView];
    
    if(self!=[self.navigationController.viewControllers objectAtIndex:0]){
        // Put Back button in navigation bar
        [self setEnableBackButton:YES];
    }
    else
    {
        [self setEnableBackButton:NO];
    }

}

//设置标题和logo
- (void)setTitle:(NSString *)title
{
    //设置标题 else 显示logo
    if (title) {
        [_titleLabel setText:title];
        [self.navigationItem setTitleView:_titleLabel];
    }
}

- (void)setMessageText:(NSString *)messageText
{
    if (messageText && _enableMessage) {
        _messageText = messageText;
        [_desLable setText:_messageText];
    }
}

- (void)setMessageView:(UIView *)messageView
{
    if (_enableMessage && messageView) {
        [_desLable setHidden:YES];
        _messageView = messageView;
        [_messageBgView setUserInteractionEnabled:YES];
        [_messageBgView addSubview:_messageView];
    }
}

- (void)setLeftBtn:(UIButton *)leftBtn
{
    if (leftBtn) {
        _leftBtn = leftBtn;
        _leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftBtn];
        self.navigationItem.leftBarButtonItem = _leftButtonItem;
    }
}

- (void)setRightBtn:(UIButton *)rightBtn
{
    if (rightBtn) {
        _rightBtn = rightBtn;
        _rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
        self.navigationItem.rightBarButtonItem = _rightButtonItem;
    }
}

- (void)setEnableBackButton:(BOOL)enableBackButton
{
    if (enableBackButton) {
        _enableBackButton = enableBackButton;
        //返回按钮默认按钮
        UIButton * backButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(0, 0, 40, 30)];
        [backButton setBackgroundColor:[UIColor clearColor]];
        [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_normal@2x"] forState:UIControlStateNormal];
        [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed@2x"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        _backButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = _backButtonItem;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

//启动编辑按钮
-(void)setEnableEditing:(BOOL)enableEditing
{
    if (enableEditing) {
        _enableEditing = enableEditing;
        //编辑按钮
        UIButton * editButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [editButton setFrame:CGRectMake(0, 0, 40, 30)];
        [editButton setBackgroundColor:[UIColor clearColor]];
        [editButton setBackgroundImage:[UIImage imageNamed:@"btn_edit_normal@2x"] forState:UIControlStateNormal];
        [editButton setBackgroundImage:[UIImage imageNamed:@"btn_edit_pressed@2x"] forState:UIControlStateHighlighted];
        [editButton setBackgroundImage:[UIImage imageNamed:@"btn_save_normal@2x"] forState:UIControlStateSelected];
        [editButton addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn = editButton;
        _editBtnItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
        self.navigationItem.rightBarButtonItem = _editBtnItem;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

//启动messageView
- (void)setEnableMessage:(BOOL)enableMessage
{
    if (enableMessage) {
        _enableMessage = enableMessage;
        //导航栏下方的欢迎条
        UIImage * welcomeImage = [UIImage imageNamed:@"nav_hint@2x"];
        _messageBgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 49)];
        [_messageBgView setImage:welcomeImage];
        [self.view addSubview:_messageBgView ];
        
        //文本信息
        _desLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
        [_desLable setBackgroundColor:[UIColor clearColor]];
        [_desLable setTextAlignment:NSTextAlignmentLeft];
        [_desLable setTextColor:[UIColor whiteColor]];
        [_desLable setFont:[UIFont appGreenWarnFont]];
        [_messageBgView addSubview:_desLable];
    }
    else
    {
        [_messageBgView removeFromSuperview];
    }
}

- (void)backAction:(UIButton *)sender
{
    //返回按钮 可重写
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editBtnAction:(UIButton *)sender
{
    //返回按钮 可重写
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
