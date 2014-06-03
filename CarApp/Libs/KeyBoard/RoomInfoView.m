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
#import "Room.h"
#import "GroupChatViewController.h"
#define kEnsurePingcheTag 97777
#define kJojinPingcheTag 97776
#define kExitPingcheTag 97775

@interface RoomInfoView()<PListSettingViewDelegate>

@property (strong, nonatomic) UIView *infoView; //房间情况按钮
@property (strong, nonatomic) UIButton *infoBtn; //显示按钮
@property (strong, nonatomic) UILabel *numLable; //空位剩余
@property (strong, nonatomic) UIButton *closeBtn; //关闭按钮
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
        [self.nameLable setText:@"冯源"];
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
        
        self.ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.ensureBtn setFrame:CGRectMake((320-235)/2.0, 135, 235, 40)];
        [self.ensureBtn setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin];
//        [self.ensureBtn setImage:[UIImage imageNamed:@"btn_ready_normal@2x"] forState:UIControlStateNormal];
//        [self.ensureBtn setImage:[UIImage imageNamed:@"btn_ready_pressed@2x"] forState:UIControlStateHighlighted];
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
    }
    return self;
}

-(void)setRoomInfo:(Room *)room AndUserInfo:(NSArray *)users
{
    _room = room;
    _users = users;
    int seats = room.max_seat_num-room.booked_seat_num;
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat: @"ID == %d",room.user_id];
    NSArray *array = [users filteredArrayUsingPredicate:predicate];
    People *owner = [array objectAtIndex:0];
    
    NSMutableArray *passenger = [NSMutableArray arrayWithArray:users];
    [passenger removeObject:owner];
    
    PListSettingView *plistview = (PListSettingView *)self.pListSettingView;
    
    BOOL isRoomMaster = room.user_id == [User shareInstance].userId?YES:NO;
    self.isRoomMaster = isRoomMaster;
    if (isRoomMaster)
    {
        [plistview setPersonArray:passenger RoomMaster:owner Seats:seats];
        [self setEnsureBtnName:@"编辑座位" AndBackgroundImage:@"bg_red"];
        self.ensureBtnState = 0;
    }
    else
    {
        [plistview setPersonArray:passenger RoomMaster:owner Seats:seats];
        //乘客
        double userId = [User shareInstance].userId;
        BOOL isReady = NO;
        
        for (NSDictionary *user in users) {
            if ([[user valueForKey:@"id"] doubleValue] == userId) {
                isReady = YES;
                break;
            }
        }
        
        if (isReady)
        {
            [self setEnsureBtnName:@"取消预定" AndBackgroundImage:@"bg_red"];
            self.ensureBtnState = 2;
        }
        else
        {
            [self setEnsureBtnName:@"立即抢座" AndBackgroundImage:@"bg_blue"];
            self.ensureBtnState = 1;
        }
    }
    
    People *owener = [users objectAtIndex:0];
    
    [self.nameLable setText:owener.name];
    [self.headImgView setBackgroundImageWithURL:[NSURL URLWithString:owener.headpic]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"delt_user_s"]];
    CGRect frame = self.nameLable.frame;
    frame.size.width = [self widthForRect:CGRectMake(0, 0, frame.size.width, frame.size.height) WithText:owener.name font:self.nameLable.font];
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
#pragma mark - Reponse
- (void)setMaxSeatNum:(int) num
{
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"同步中" toView:self.groupVC.view];
    __block typeof(self) bSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [APIClient networkChangemaxseatnumWithroom_id:_room.ID max_seat_num:num success:^(Respone *respone) {
            if (respone.status == kEnumServerStateSuccess)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES afterDelay:0.1];
                    //重新请求房间数据，刷新
                    [bSelf.groupVC refreshRoomInfo];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [MBProgressHUD showError:respone.msg toView:bSelf.groupVC.view];
                });
            }
        } failure:^(NSError *error) {
            
        }];
    });
}
#pragma mark - Other
- (void) setEnsureBtnName:(NSString *) name AndBackgroundImage:(NSString *) imgName
{
    [self.ensureBtn setBackgroundImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal@2x.png",imgName]] stretchableImageWithLeftCapWidth:20 topCapHeight:20] forState:UIControlStateNormal];
    [self.ensureBtn setBackgroundImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed@2x.png",imgName]] stretchableImageWithLeftCapWidth:20 topCapHeight:20] forState:UIControlStateHighlighted];
    [self.ensureBtn setTitle:name forState:UIControlStateNormal];
    [self.ensureBtn setTitle:name forState:UIControlStateHighlighted];

}
#pragma mark - 确认/我准备好了
- (void)ensureAction:(UIButton *)sender
{
    DLog(@"我准备好了");
    
   // NSArray *users = (NSArray *)[self.data valueForKey:@"users"];
    
    if (self.isRoomMaster)
    {
        if ([sender.currentTitle isEqualToString:@"编辑座位"])
        {
            [self.pListSettingView enterEditSeatMode];
            [self setEnsureBtnName:@"确定" AndBackgroundImage:@"bg_green"];
        }
        else
        {
           
            if (self.pListSettingView.seatNum != 0)
            {
                [self.pListSettingView reloadView];
                [self setEnsureBtnName:@"编辑座位" AndBackgroundImage:@"bg_red"];
                /*
                 * 子线程调用司机修改最大座位数目
                 * server/room/changemaxseatnum
                 */
                [self setMaxSeatNum:self.pListSettingView.seatNum];
            }
            else
            {
                [MBProgressHUD showError:@"座位数不能为零" toView:self.groupVC.view];
            }
          
        }
        
      
    }
    else
    {
        //我准备好了
        if(self.ensureBtnState == 1)
        {
            //取消预订
        }
        
        if (self.ensureBtnState == 2)
        {
            //立即抢座
           
        }
    }
}

-(void)PListSettingViewDelegate:(PListSettingView *)plistSettingView index:(int)index event:(kPListEvent)event
{
    if (self.groupVC) {
        /*
        DLog(@"头像点击");
        NSMutableArray *users = [NSMutableArray arrayWithArray:[self.data valueForKey:@"users"]];
        NSDictionary *user = (NSDictionary *)[users objectAtIndex:index];
        ProfileViewController * profileVC = [[ProfileViewController alloc]init];
        profileVC.uid = [[user valueForKey:@"id"] doubleValue];
        profileVC.state = 1;
        [self.groupVC.navigationController pushViewController:profileVC animated:YES];*/
    }
}

- (void)masterHeadImageTap:(UIButton *)sender
{
    if (self.groupVC) {
        /*
        DLog(@"头像点击");
        NSDictionary *owner = (NSDictionary *)[((NSArray *)[self.data objectForKey:@"owener"]) objectAtIndex:0];
        ProfileViewController * profileVC = [[ProfileViewController alloc]init];
        profileVC.uid = [[owner valueForKey:@"id"] doubleValue];
        profileVC.state = 1;
        [self.groupVC.navigationController pushViewController:profileVC animated:YES];*/
    }
}

@end
