//
//  ConnectStateView.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-17.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "ConnectStateView.h"

@implementation ConnectStateView

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicatorView setFrame:CGRectMake(0, 0, 44, 44)];
        [_activityIndicatorView setHidden:YES];
        [_activityIndicatorView setHidesWhenStopped:YES];
        [self addSubview:_activityIndicatorView];
        
        _stateLable  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
        [_stateLable setHidden:YES];
        [_stateLable setFont:[UIFont fontWithName:kFangZhengFont size:12]];
        [_stateLable setTextColor:[UIColor appDarkGrayColor]];
        [self addSubview:_stateLable];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xmppWillConnect) name:@"XmppStreamWillConnnect" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xmppConnect) name:@"XmppStreamConnected" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmppDidNotConnect) name:@"XmppStreamDidNotConnected" object:nil];
    }
    return self;
}

- (void)showActivity
{
    [_stateLable setHidden:YES];
    [_activityIndicatorView setHidden:NO];
    [_activityIndicatorView startAnimating];
}

- (void)showStateLable:(NSString *)stateStr hidden:(BOOL)hidden
{
    [_activityIndicatorView stopAnimating];
    [_stateLable setText:stateStr];
    [_stateLable setHidden:NO];
    [_stateLable setAlpha:1.0];
    
    if (hidden) {
        [UIView beginAnimations:@"stateHidden" context:nil];
        [UIView setAnimationDelay:0.5];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDidStopSelector:@selector(hideFinish)];
        [_stateLable setAlpha:0.0];
        [UIView commitAnimations];
    }
}

- (void)hideFinish
{
    [_stateLable setHidden:YES];
    [_stateLable setAlpha:1.0];
}

- (void)xmppWillConnect
{
    [self showActivity];
}

- (void)xmppConnect
{
    [self performSelector:@selector(connectSuccess) withObject:nil afterDelay:1.0];
}

- (void)connectSuccess
{
    [self showStateLable:@"已连接" hidden:YES];
}

- (void)xmppDidNotConnect
{
    [self performSelector:@selector(connectfaile) withObject:nil afterDelay:1.0];
}

- (void)connectfaile
{
    [self showStateLable:@"未连接" hidden:NO];
}

- (void)connectStateViewAppeared
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xmppWillConnect) name:@"XmppStreamWillConnnect" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xmppConnect) name:@"XmppStreamConnected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmppDidNotConnect) name:@"XmppStreamDidNotConnected" object:nil];
}

- (void)connectStateViewDisAppeared
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
