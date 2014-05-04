//
//  MainFirstView.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-2-22.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "MainFirstView.h"
#import "PassengerRouteUIViewController.h"
#import "GetRouteViewController.h"
#import "GroupChatViewController.h"

@implementation MainFirstView

-(void)dealloc
{

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //在第主页添加的按钮们
        //司机的选项按钮
        UIButton * driverButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [driverButton setFrame:CGRectMake(25,(frame.size.height -125)/2, 125, 125)];
        [driverButton setBackgroundColor:[UIColor clearColor]];
        [driverButton setBackgroundImage:[UIImage imageNamed:@"btn_have_normal@2x"] forState:UIControlStateNormal];
        [driverButton setBackgroundImage:[UIImage imageNamed:@"btn_have_pressed@2x"] forState:UIControlStateHighlighted];
        [driverButton addTarget:self action:@selector(driverGetRoute) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:driverButton];
        
        //乘客的选项按钮
        UIButton * passengerButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [passengerButton setFrame:CGRectMake(170,(frame.size.height - 125)/2, 125, 125)];
        [passengerButton setBackgroundColor:[UIColor clearColor]];
        [passengerButton addTarget:self action:@selector(enterPassenger) forControlEvents:UIControlEventTouchUpInside];
        [passengerButton setBackgroundImage:[UIImage imageNamed:@"btn_pool_normal@2x"] forState:UIControlStateNormal];
        [passengerButton setBackgroundImage:[UIImage imageNamed:@"btn_pool_pressed@2x"] forState:UIControlStateHighlighted];
        [self addSubview:passengerButton];
    }
    return self;
}

-(void)driverGetRoute
{
    if (self.mainVC) {
        GetRouteViewController * routeVC = [[GetRouteViewController alloc]init];
        [self.mainVC.navigationController pushViewController:routeVC animated:YES];

        /*
        DLog(@"%@",[User shareInstance].phoneNum);
        [APIClient networkCreatRoomWithUser_phone:[User shareInstance].phoneNum line_id:1 price:10 description:@"MrLu测试房间" start_time:@"2014-04-27"  max_seat_num:4 success:^(Respone *respone) {
            if (respone.status == kEnumServerStateSuccess) {
                DLog(@"%@",respone.data);
                [SVProgressHUD showSuccessWithStatus:respone.msg];
                //创建成功进入聊天室
                GroupChatViewController * gVC = [[GroupChatViewController alloc]init];
                gVC.roomID = [(NSString *)[respone.data valueForKey:@"id"] intValue];
                gVC.openfireRoomName = [respone.data valueForKey:@"openfire"];
                gVC.isRoomMaster = NO;
                gVC.userState = 1;
                [self.mainVC.navigationController pushViewController:gVC animated:YES];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:respone.msg];
            }
        } failure:^(NSError *error) {
            
        }];*/
    }
}

-(void)enterPassenger
{
    if (self.mainVC) {
        
        PassengerRouteUIViewController * pVC = [[PassengerRouteUIViewController alloc]init];
        pVC.state = 1;
        [self.mainVC.navigationController pushViewController:pVC animated:YES];

        /*
        [APIClient networkCloseRoomWithroom_id:5 success:^(Respone *respone) {
            if (respone.status == kEnumServerStateSuccess) {
                DLog(@"%@",respone.msg);
            }
            else
            {
                DLog(@"");
            }
        } failure:^(NSError *error) {
            
        }];*/
        
        
    }
}

@end
