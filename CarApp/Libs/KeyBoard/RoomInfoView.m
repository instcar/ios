//
//  RoomInfoView.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-2-22.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "RoomInfoView.h"
#import "PListSettingView.h"
#import "UIButton+WebCache.h"
#import "ProfileViewController.h"
#define kEnsurePingcheTag 97777
#define kJojinPingcheTag 97776
#define kExitPingcheTag 97775

@interface RoomInfoView()<PListSettingViewDelegate>

@property (retain, nonatomic) UIView *infoView; //房间情况按钮
@property (retain, nonatomic) UIButton *infoBtn; //显示按钮
@property (retain, nonatomic) UILabel *numLable; //空位剩余
@property (retain, nonatomic) UIButton *closeBtn; //关闭按钮
@property (assign, nonatomic) CGRect fullScreenRect; //全屏大小
@property (assign, nonatomic) BOOL isOpen;
@property (assign, nonatomic) BOOL isRoomMaster;
@property (assign, nonatomic) int ensureBtnState; // 0,房主 1,确认 2,取消

-(void)show;

@end

@implementation RoomInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isOpen = YES;
        self.enableTouchBg = YES;
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        self.fullScreenRect = self.frame;
        self.infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, self.bounds.size.width, 180)];
        [self addSubview:self.infoView];
        
        UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 310, 180)];
        [background setImage:[[UIImage imageNamed:@"bg_sound"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [self.infoView addSubview:background];
        [background release];
        
        self.headImgView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.headImgView setFrame:CGRectMake(10, -5, 40, 40)];
        [self.headImgView.layer setCornerRadius:20];
        [self.headImgView setClipsToBounds:YES];
        [self.headImgView setBackgroundImageWithURL:nil forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"delt_user_s"]];
        [self.headImgView addTarget:self action:@selector(masterHeadImageTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.infoView addSubview:self.headImgView];
        
        self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 200, 20)];
        [self.nameLable setBackgroundColor:[UIColor clearColor]];
        [self.nameLable setTextAlignment:NSTextAlignmentLeft];
        [self.nameLable setText:@"房主"];
        [self.nameLable setFont:[UIFont fontWithName:kFangZhengFont size:14]];
        [self.nameLable setTextColor:[UIColor blackColor]];
        [self.infoView addSubview:self.nameLable];
        
        self.masterLable = [[UILabel alloc]initWithFrame:CGRectMake(260, 10, 40, 20)];
        [self.masterLable setFont:[UIFont fontWithName:kFangZhengFont size:12]];
        [self.masterLable setBackgroundColor:[UIColor clearColor]];
        [self.masterLable setTextAlignment:NSTextAlignmentLeft];
        [self.masterLable setText:@"房主"];
        [self.masterLable setTextColor:[UIColor lightGrayColor]];
        [self.infoView addSubview:self.masterLable];
        
        //人员状态名单
        self.pListSettingView = [[PListSettingView alloc]initWithFrame:CGRectMake(0, 45, 310, 80)];
        self.pListSettingView.delegate = self;
        self.pListSettingView.canEdit = YES;
        [self.infoView addSubview:self.pListSettingView];
        
        self.ensureBtn = [[UIButton alloc]initWithFrame:CGRectMake((320-235)/2.0, 135, 235, 40)];
        [self.ensureBtn setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin];
        [self.ensureBtn setImage:[UIImage imageNamed:@"btn_ready_normal@2x"] forState:UIControlStateNormal];
        [self.ensureBtn setImage:[UIImage imageNamed:@"btn_ready_pressed@2x"] forState:UIControlStateHighlighted];
//        [self.ensureBtn setImage:[UIImage imageNamed:@"btn_ready_normal@2x"] forState:UIControlStateNormal];
        [self.ensureBtn addTarget:self action:@selector(ensureAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.infoView addSubview:self.ensureBtn];
        
        self.numLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.numLable setFont:[UIFont fontWithName:kFangZhengFont size:12]];
        [self.numLable setTextColor:[UIColor appNavTitleGreenColor]];
        [self.numLable setTextAlignment:NSTextAlignmentCenter];
        [self.infoBtn addSubview:self.numLable];
        
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.closeBtn setFrame:CGRectMake(10, 5, 40, 40)];
        [self.closeBtn setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin];
        [self.closeBtn setBackgroundColor:[UIColor redColor]];
//        [self.infoBtn setBackgroundImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
//        [self.infoBtn setBackgroundImage:[UIImage imageNamed:nil] forState:UIControlStateHighlighted];
//        [self addSubview:self.closeBtn];
        
//        [self.layer setAnchorPoint:CGPointMake(1.0, 0.0)];
        
        CGPoint oldAnchorPoint = self.layer.anchorPoint;
        [self.layer setAnchorPoint:CGPointMake((self.bounds.size.width - 20.0)/self.bounds.size.width, 20.0/self.bounds.size.height)];
        [self.layer setPosition:CGPointMake(self.layer.position.x + self.layer.bounds.size.width * (self.layer.anchorPoint.x - oldAnchorPoint.x), self.layer.position.y + self.layer.bounds.size.height * (self.layer.anchorPoint.y - oldAnchorPoint.y))];

        CGAffineTransform newTransform = CGAffineTransformMakeScale(1.0, 1.0);
        [self setTransform:newTransform];
        
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgtapAction:)];
//        [self addGestureRecognizer:tapGesture];
//        [tapGesture release];
        
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(bgtapAction:)];
        [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
        [self addGestureRecognizer:swipeGestureRecognizer];
        [swipeGestureRecognizer release];
    }
    return self;
}

-(void)setData:(NSDictionary *)data
{
    if (data) {
//        [_data release];
        _data = [data copy];
    }
    NSMutableArray *users = [NSMutableArray arrayWithArray:[data valueForKey:@"users"]];
    int seats = [[[data valueForKey:@"room"]valueForKey:@"seatnum"]intValue];
    NSDictionary *owner = (NSDictionary *)[((NSArray *)[data objectForKey:@"owener"]) objectAtIndex:0];
    
    PListSettingView *plistview = (PListSettingView *)self.pListSettingView;
    Room *room = [[Room alloc]initWithDic:[data valueForKey:@"room"]];
    
    BOOL isRoomMaster = room.userid == [User shareInstance].userId?YES:NO;
    self.isRoomMaster = isRoomMaster;
    if (isRoomMaster) {
        [plistview setPersonArray:users RoomMaster:owner Seats:seats];
        [self.ensureBtn setImage:[UIImage imageNamed:@"btn_confirmation_normal@2x"] forState:UIControlStateNormal];
        [self.ensureBtn setImage:[UIImage imageNamed:@"btn_confirmation_pressed@2x"] forState:UIControlStateHighlighted];
        self.ensureBtnState = 0;
    }
    else
    {
        [plistview setPersonArray:users RoomMaster:owner Seats:seats];
        //乘客
        double userId = [User shareInstance].userId;
        BOOL isReady = NO;
        
        for (NSDictionary *user in users) {
            if ([[user valueForKey:@"id"] doubleValue] == userId) {
                isReady = YES;
                break;
            }
        }
        
        if (isReady) {
            [self.ensureBtn setImage:[UIImage imageNamed:@"btn_unready_normal@2x"] forState:UIControlStateNormal];
            [self.ensureBtn setImage:[UIImage imageNamed:@"btn_unready_pressed@2x"] forState:UIControlStateHighlighted];
            self.ensureBtnState = 2;
        }
        else
        {
            [self.ensureBtn setImage:[UIImage imageNamed:@"btn_ready_normal@2x"] forState:UIControlStateNormal];
            [self.ensureBtn setImage:[UIImage imageNamed:@"btn_ready_pressed@2x"] forState:UIControlStateHighlighted];
            self.ensureBtnState = 1;
        }
    }
    
    NSDictionary *owener = (NSDictionary *)[((NSArray *)[data objectForKey:@"owener"]) objectAtIndex:0];
    
    [self.nameLable setText:[owener valueForKey:@"username"]];
    [self.headImgView setBackgroundImageWithURL:[NSURL URLWithString:[owener valueForKey:@"headpic"]]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"delt_user_s"]];
    CGRect frame = self.nameLable.frame;
    frame.size.width = [self widthForRect:CGRectMake(0, 0, frame.size.width, frame.size.height) WithText:[owener valueForKey:@"username"] font:self.nameLable.font];
    [self.nameLable setFrame:frame];
    
    CGRect mframe = self.masterLable.frame;
    mframe.origin.x = self.nameLable.frame.origin.x + self.nameLable.frame.size.width;
    [self.masterLable setFrame:mframe];
    

}

-(float)widthForRect:(CGRect)rect WithText:(NSString *)strText font:(UIFont *)font
{
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(CGFLOAT_MAX, rect.size.height);
    
    CGSize size = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion]floatValue] < 7.0) {
		if ([[[UIDevice currentDevice] systemVersion]floatValue] < 6.0) {
			size = [strText sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
		} else {
			size = [strText sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
		}
	}
    else
    {
        size.width = [strText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size.width;
    }
    
    float fwidth = size.width + fPadding;
    
    return fwidth;
}


-(void)btnAction:(UIButton *)sender
{
    if (self.isOpen) {
        [self hide:YES];
    }
    else
    {
        [self show];
    }
}

- (void)bgtapAction:(UIButton *)sender
{
    if (!self.enableTouchBg) {
        return;
    }
    [self hide:YES];
    
}

-(void)show
{
    self.isOpen = YES;

    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setHidden:NO];
        [self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    } completion:^(BOOL finished) {
        
    }];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"infoViewHide" object:[NSNumber numberWithBool:NO]];
}

-(void)hide:(BOOL)animated
{
    self.isOpen = NO;
    
    if (animated) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
        } completion:^(BOOL finished) {
            [self setHidden:YES];
        }];
    }
    else
    {
        [self setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
        [self setHidden:YES];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"infoViewHide" object:[NSNumber numberWithBool:YES]];
}

#pragma mark - 确认/我准备好了
- (void)ensureAction:(UIButton *)sender
{
    DLog(@"我准备好了");
    
    NSArray *users = (NSArray *)[self.data valueForKey:@"users"];
    
    if (self.isRoomMaster) {
        //确认拼车人员
        DLog(@"确认拼车人员");
        if ([users count] == 0) {
            [UIAlertView showAlertViewWithTitle:@"当前没有准备的乘客,无法确认拼车" tag:kEnsurePingcheTag cancelTitle:@"取消" ensureTitle:@"确定" delegate:nil];
            return;
        }
        
        [UIAlertView showAlertViewWithTitle:@"是否确认拼车" tag:kEnsurePingcheTag cancelTitle:@"取消" ensureTitle:@"确定" delegate:(id)self.groupVC];
    }
    else
    {
        //我准备好了
        if(self.ensureBtnState == 1)
        {
            [UIAlertView showAlertViewWithTitle:@"是否加入拼车" tag:kJojinPingcheTag cancelTitle:@"取消" ensureTitle:@"确定" delegate:(id)self.groupVC];
        }
        
        if (self.ensureBtnState == 2) {
            
            [UIAlertView showAlertViewWithTitle:@"是否退出拼车" tag:kExitPingcheTag cancelTitle:@"取消" ensureTitle:@"确定" delegate:(id)self.groupVC];
        }
    }
}

-(void)PListSettingViewDelegate:(PListSettingView *)plistSettingView index:(int)index event:(kPListEvent)event
{
    if (self.groupVC) {
        DLog(@"头像点击");
        NSMutableArray *users = [NSMutableArray arrayWithArray:[self.data valueForKey:@"users"]];
        NSDictionary *user = (NSDictionary *)[users objectAtIndex:index];
        ProfileViewController * profileVC = [[ProfileViewController alloc]init];
        profileVC.uid = [[user valueForKey:@"id"] doubleValue];
        profileVC.state = 1;
        [self.groupVC.navigationController pushViewController:profileVC animated:YES];
        [profileVC release];
    }
}

- (void)masterHeadImageTap:(UIButton *)sender
{
    if (self.groupVC) {
        DLog(@"头像点击");
        NSDictionary *owner = (NSDictionary *)[((NSArray *)[self.data objectForKey:@"owener"]) objectAtIndex:0];
        ProfileViewController * profileVC = [[ProfileViewController alloc]init];
        profileVC.uid = [[owner valueForKey:@"id"] doubleValue];
        profileVC.state = 1;
        [self.groupVC.navigationController pushViewController:profileVC animated:YES];
        [profileVC release];
    }
}

@end
