//
//  CommentDetailViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-12-11.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "CommentDetailViewController.h"
#import "PassengerControl.h"
#import "MrSegmentedControl.h"

#define kAllStarControlTag 44444
#define kStarsYXControlTag 11111
#define kStarsJZControlTag 22222
#define kStarsRXControlTag 33333

@interface CommentDetailViewController ()<MrSegmentedControlDelegate,UIAlertViewDelegate>

@end

@implementation CommentDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations
    
    UIView * mainView = [[UIView alloc]initWithFrame:[AppUtility mainViewFrame]];
    [mainView setBackgroundColor:[UIColor appBackgroundColor]];
    [self.view addSubview:mainView];
    
    UIImage * naviBarImage = [UIImage imageNamed:@"navgationbar_64"];
    naviBarImage = [naviBarImage stretchableImageWithLeftCapWidth:4 topCapHeight:10];
    
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    [navBar setBackgroundImage:naviBarImage forBarMetrics:UIBarMetricsDefault];
    [mainView addSubview:navBar];
    
    if (kDeviceVersion < 7.0) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, navBar.frame.size.height, navBar.frame.size.width, 1)];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [navBar addSubview:lineView];
    }
    else
    {
                self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
    
    UIButton * backButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 20, 70, 44)];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_normal@2x"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed@2x"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backButton];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 27, 120, 30)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"评论"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor appNavTitleColor]];
    [titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [navBar addSubview:titleLabel];
    
    UILabel *zLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10+64, 200, 10)];
    [zLable setBackgroundColor:[UIColor clearColor]];
    [zLable setText:@"总体评价"];
    [zLable setTextAlignment:NSTextAlignmentLeft];
    [zLable setTextColor:[UIColor appBlackColor]];
    [zLable setFont:[UIFont fontWithName:kFangZhengFont size:10]];
    [navBar addSubview:zLable];
    
    MrSegmentedControl *segmentControl = [[MrSegmentedControl alloc]initWithItems:3];
    [segmentControl setFrame:CGRectMake(0, 30+64, 320, 45)];
    [segmentControl setTag:kAllStarControlTag];
    [segmentControl setImage:[UIImage imageNamed:@"btn_left_normal@2x"] forSegmentAtIndex:0 forState:UIControlStateNormal];
    [segmentControl setImage:[UIImage imageNamed:@"btn_left_pressed@2x"] forSegmentAtIndex:0 forState:UIControlStateHighlighted];
    [segmentControl setImage:[UIImage imageNamed:@"btn_left_pressed@2x"] forSegmentAtIndex:0 forState:UIControlStateSelected];
    [segmentControl setImage:[UIImage imageNamed:@"btn_mid_normal@2x"] forSegmentAtIndex:1 forState:UIControlStateNormal];
    [segmentControl setImage:[UIImage imageNamed:@"btn_mid_pressed@2x"] forSegmentAtIndex:1 forState:UIControlStateHighlighted];
    [segmentControl setImage:[UIImage imageNamed:@"btn_mid_pressed@2x"] forSegmentAtIndex:1 forState:UIControlStateSelected];
    [segmentControl setImage:[UIImage imageNamed:@"btn_right_normal@2x"] forSegmentAtIndex:2 forState:UIControlStateNormal];
    [segmentControl setImage:[UIImage imageNamed:@"btn_right_pressed@2x"] forSegmentAtIndex:2 forState:UIControlStateHighlighted];
    [segmentControl setImage:[UIImage imageNamed:@"btn_right_pressed@2x"] forSegmentAtIndex:2 forState:UIControlStateSelected];
    segmentControl.backgroundColor = [UIColor clearColor];
    segmentControl.delegate = self;
    [mainView addSubview:segmentControl];
    
//    [segmentControl setBackgroundImage:[UIImage imageNamed:@"btn_left_normal@2x"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [segmentControl setBackgroundImage:[UIImage imageNamed:@"btn_left_pressed@2x"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    UILabel *yLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 95+64, 200, 10)];
    [yLable setBackgroundColor:[UIColor clearColor]];
    [yLable setText:@"言而有信"];
    [yLable setTextAlignment:NSTextAlignmentLeft];
    [yLable setTextColor:[UIColor appBlackColor]];
    [yLable setFont:[UIFont fontWithName:kFangZhengFont size:10]];
    [navBar addSubview:yLable];
    
    //言而有信数
    PassengerControl *YXControl = [[PassengerControl alloc]initWithFrame:CGRectMake((320-233)/2, 115+64, 233, 45) NormalImage:[UIImage imageNamed:@"ic_star_none@2x"] SelectImage:[UIImage imageNamed:@"ic_star@2x"] indexs:5 size:CGSizeMake(20, 30)];
    YXControl.tag = kStarsYXControlTag;;
    YXControl.currentNum = 5;
    [mainView addSubview:YXControl];
    
    UILabel *jLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 170+64, 200, 10)];
    [jLable setBackgroundColor:[UIColor clearColor]];
    [jLable setText:@"举止文明"];
    [jLable setTextAlignment:NSTextAlignmentLeft];
    [jLable setTextColor:[UIColor appBlackColor]];
    [jLable setFont:[UIFont fontWithName:kFangZhengFont size:10]];
    [navBar addSubview:jLable];
    
    //举止文明数
    PassengerControl *JZcontrol = [[PassengerControl alloc]initWithFrame:CGRectMake((320-233)/2, 190+64, 233, 45) NormalImage:[UIImage imageNamed:@"ic_star_none@2x"] SelectImage:[UIImage imageNamed:@"ic_star@2x"] indexs:5 size:CGSizeMake(20, 30)];
    JZcontrol.tag = kStarsJZControlTag;
    JZcontrol.currentNum = 5;
    [mainView addSubview:JZcontrol];
    
    UILabel *rLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 245+64, 200, 10)];
    [rLable setBackgroundColor:[UIColor clearColor]];
    [rLable setText:@"热心体贴"];
    [rLable setTextAlignment:NSTextAlignmentLeft];
    [zLable setTextColor:[UIColor appBlackColor]];
    [rLable setFont:[UIFont fontWithName:kFangZhengFont size:10]];
    [navBar addSubview:rLable];
    
    //热心体贴数
    PassengerControl *RXcontrol = [[PassengerControl alloc]initWithFrame:CGRectMake((320-233)/2, 265+64, 233, 45) NormalImage:[UIImage imageNamed:@"ic_star_none@2x"] SelectImage:[UIImage imageNamed:@"ic_star@2x"] indexs:5 size:CGSizeMake(20, 30)];
    RXcontrol.tag = kStarsRXControlTag;
    RXcontrol.currentNum = 5;
    [mainView addSubview:RXcontrol];
    
    //发送验证码
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setAlpha:1.0];
    confirmBtn.showsTouchWhenHighlighted = YES;
    [confirmBtn setFrame:CGRectMake(54, 340+64, 212, 36)];
    [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_green_normal"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[[UIImage imageNamed:@"btn_green_pressed"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateSelected];
    [confirmBtn setTitle:@"确定评价" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [confirmBtn.titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:12]];
    [confirmBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:confirmBtn];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)segmentControl:(MrSegmentedControl *)segmentedControl didSelectIndex:(int)index
{
//    PassengerControl *YXControl = (PassengerControl *)[self.view viewWithTag:kStarsYXControlTag];
//    PassengerControl *JZControl = (PassengerControl *)[self.view viewWithTag:kStarsJZControlTag];
//    PassengerControl *RXControl = (PassengerControl *)[self.view viewWithTag:kStarsRXControlTag];
//    if (index == 0) {
//        YXControl.currentNum = 5;
//        JZControl.currentNum = 5;
//        RXControl.currentNum = 5;
//    }
//    if (index == 1) {
//        YXControl.currentNum = 4;
//        JZControl.currentNum = 4;
//        RXControl.currentNum = 4;
//    }
//    if (index == 2) {
//        YXControl.currentNum = 3;
//        JZControl.currentNum = 3;
//        RXControl.currentNum = 3;
//    }
}

-(void)commentAction:(UIButton *)sender
{
    MrSegmentedControl *segmentControl = (MrSegmentedControl *)[self.view viewWithTag:kAllStarControlTag];
    PassengerControl *YXControl = (PassengerControl *)[self.view viewWithTag:kStarsYXControlTag];
    PassengerControl *JZControl = (PassengerControl *)[self.view viewWithTag:kStarsJZControlTag];
    PassengerControl *RXControl = (PassengerControl *)[self.view viewWithTag:kStarsRXControlTag];
    
    if (segmentControl.selectedSegmentIndex == -1) {
        [UIAlertView showAlertViewWithTitle:@"对不起" message:@"您还没有给用户总体评价" cancelTitle:@"知道了"];
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否给予以下评价" message:[NSString stringWithFormat:@"言而有信:%d星\n举止文明:%d星\n热心体贴:%d星",YXControl.currentNum,JZControl.currentNum,RXControl.currentNum] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MrSegmentedControl *segmentControl = (MrSegmentedControl *)[self.view viewWithTag:kAllStarControlTag];
    PassengerControl *YXControl = (PassengerControl *)[self.view viewWithTag:kStarsYXControlTag];
    PassengerControl *JZControl = (PassengerControl *)[self.view viewWithTag:kStarsJZControlTag];
    PassengerControl *RXControl = (PassengerControl *)[self.view viewWithTag:kStarsRXControlTag];

    if (buttonIndex == 1) {
        //车主没来 房主失约+1
        if (!self.room || !self.userid) {
            return;
        }
        int commentLevel = 3 - segmentControl.selectedSegmentIndex;
        int userstatus = (self.userid == self.room.userid ? 0:1);//房主评乘客
        int ownerstatus = (self.userid == self.room.userid ? 1:0);//乘客评房主
        /*
        [NetWorkManager networkCommemtWithRoomID:self.room.ID uid:[User shareInstance].userId touid:self.userid content:@"" commentLever:commentLevel userstatus:userstatus yeyxstar:YXControl.currentNum jzwmstar:JZControl.currentNum rxttstar:RXControl.currentNum ownertatus:ownerstatus success:^(BOOL flag, NSString *msg) {
            if (flag) {
                [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            
        }];*/
    }
}

-(void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
