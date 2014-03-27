//
//  ProfileViewController.m
//  CarApp
//
//  Created by leno on 13-10-9.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "ProfileViewController.h"
#import "StartViewController.h"
#import "LogInViewController.h"
#import "ProfilePhotoFirstCustomCell.h"
#import "ProfileCell.h"
#import "PeopleManager.h"
#import "XmppManager.h"
#import "SetProfileViewController.h"
#import "SingleChatViewController.h"
#import "CarImageViewController.h"
#import "CommonRoutesViewController.h"

@interface ProfileViewController ()

@property (retain, nonatomic) People *userInfo;

@end

@implementation ProfileViewController

@synthesize profileTable = _profileTable;

-(void)dealloc
{
    [SafetyRelease release:_userInfo];
    [SafetyRelease release:_profileTable];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView * mainView = [[UIView alloc]initWithFrame:[AppUtility mainViewFrame]];
    [mainView setBackgroundColor:[UIColor appBackgroundColor]];
    [self.view addSubview:mainView];
    [mainView release];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backToMain)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeGesture];
    [swipeGesture release];
    
    UIImage * naviBarImage = [UIImage imageNamed:@"navgationbar_64"];
    naviBarImage = [naviBarImage stretchableImageWithLeftCapWidth:4 topCapHeight:10];
    
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    [navBar setBackgroundImage:naviBarImage forBarMetrics:UIBarMetricsDefault];
    [mainView addSubview:navBar];
    [navBar release];
    
    if (kDeviceVersion < 7.0) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, navBar.frame.size.height, navBar.frame.size.width, 1)];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [navBar addSubview:lineView];
        [lineView release];
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
    [titleLabel setText:@"个人中心"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor appNavTitleColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [navBar addSubview:titleLabel];
    [titleLabel release];
    
    if (self.uid == [User shareInstance].userId) {
        UIButton * editButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [editButton setFrame:CGRectMake(320- 70, 20, 70, 44)];
        [editButton setBackgroundColor:[UIColor clearColor]];
        [editButton setBackgroundImage:[UIImage imageNamed:@"btn_info_normal@2x"] forState:UIControlStateNormal];
        [editButton setBackgroundImage:[UIImage imageNamed:@"btn_info_pressed@2x"] forState:UIControlStateHighlighted];
        [editButton addTarget:self action:@selector(editProfile) forControlEvents:UIControlEventTouchUpInside];
        [navBar addSubview:editButton];
    }
    
    UIImage * welcomeImage = [UIImage imageNamed:@"nav_hint@2x"];
    UIImageView * welcomeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 49)];
    [welcomeImgView setImage:welcomeImage];
    [mainView addSubview:welcomeImgView];
    [welcomeImgView release];
    
    UILabel * welcomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
    [welcomeLabel setTag:22222];
    [welcomeLabel setBackgroundColor:[UIColor clearColor]];
//    [welcomeLabel setText:[NSString stringWithFormat:@"%@",[User shareInstance].userName]];
    [welcomeLabel setTextAlignment:NSTextAlignmentLeft];
    [welcomeLabel setTextColor:[UIColor whiteColor]];
    [welcomeLabel setFont:[UIFont appGreenWarnFont]];
    [welcomeImgView addSubview:welcomeLabel];
    [welcomeLabel release];
    
    UITableView *profileTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+49, 320, SCREEN_HEIGHT - 64-49)];
    [profileTable setBackgroundColor:[UIColor clearColor]];
    [profileTable setBackgroundView:nil];
    [profileTable setDelegate:self];
    [profileTable setDataSource:self];
    [profileTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [profileTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)]];
    [mainView addSubview:profileTable];
    [self setProfileTable:profileTable];
    [profileTable release];
    
    [self performSelector:@selector(getUserInfo) withObject:nil afterDelay:0.1];
}

-(void)getUserInfo
{
    //保存用户信息
    [NetWorkManager networkGetUserInfoCenterWithuid:self.uid success:^(BOOL flag, NSDictionary *userInfoDic, NSString *msg) {
        
        if (flag) {
            
            NSDictionary * userDic = [userInfoDic valueForKey:@"user"];
            People *people = [[People alloc]initFromDic:userDic];
            people.favlinenum = [[userInfoDic valueForKey:@"favlinenum"] intValue];
            people.goodcount = [[userInfoDic valueForKey:@"goodcount"] intValue];
            people.midcount = [[userInfoDic valueForKey:@"midcount"] intValue];
            people.badcount = [[userInfoDic valueForKey:@"badcount"] intValue];
//            [User shareInstance].userName = people.userName;
//            [User shareInstance].userData = [NSMutableDictionary dictionaryWithDictionary:userInfo];//保存网络请求下来的数据
//            [User shareInstance].phoneNum = people.phone;
//            [User shareInstance].userId = people.ID;
//            [[User shareInstance] save];
            
            [PeopleManager insertPeopleShortInfo:people];
            
            UILabel *welcomeLable = (UILabel *)[self.view viewWithTag:22222];
            [welcomeLable setText:[NSString stringWithFormat:@"%@",people.userName]];
            
            [self setUserInfo:people];
            [people release];
            
            [self.profileTable reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)editProfile
{
    //编辑个人
    SetProfileViewController *setProfileVC = [[SetProfileViewController alloc]init];
    [self.navigationController pushViewController:setProfileVC animated:YES];
    [setProfileVC release];
    
}

-(void)exitLoginState:(UIButton *)btn
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出当前账号" otherButtonTitles:nil];
    [actionSheet showInView:[AppDelegate shareDelegate].window];
    [actionSheet release];
}

//进入单人聊天
-(void)enterSingleChat:(UIButton *)btn
{
    SingleChatViewController *singleChatVC = [[SingleChatViewController alloc]init];
    [singleChatVC setUserID:self.userInfo.ID];
    [singleChatVC setUserName:self.userInfo.userName];
    [self.navigationController pushViewController:singleChatVC animated:YES];
    [singleChatVC release];
}

-(void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.state == 1) {
        return 2;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 4;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * clearView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)]autorelease];
    [clearView setBackgroundColor:[UIColor clearColor]];
    return clearView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 115;
    }
    if (indexPath.section == 1) {
        return 44;
    }
    if (indexPath.section == 2) {
        return 44;
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *CellIdentifier = @"ProfilePhotoFirst";
        ProfilePhotoFirstCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[ProfilePhotoFirstCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [cell.photoImgView setImageWithURL: [NSURL URLWithString:self.userInfo.headpic] placeholderImage:[UIImage imageNamed:@"delt_user_b"]];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;

        float score = 0.0;
        float goodPoint = 0.0;
        float minPoint = 0.0;
        float badPoint = 0.0;
    
        if (self.userInfo) {
            score = self.userInfo.goodcount+self.userInfo.midcount+self.userInfo.badcount;
            if (score > 0) {
                goodPoint = (float)self.userInfo.goodcount/score;
                minPoint = (float)self.userInfo.midcount/score;
                badPoint = (float)self.userInfo.badcount/score ;
            }
        }
    
        [cell.scoreLabel setText:[NSString stringWithFormat:@"%.1f%%",goodPoint*100.0]];
        [cell.goodLabel setText:[NSString stringWithFormat:@"好评 (%.1f%%) ",goodPoint*100.0]];
        [cell.mediumLabel setText:[NSString stringWithFormat:@"中评 (%.1f%%) ",minPoint*100.0]];
        [cell.poorLable setText:[NSString stringWithFormat:@"差评 (%.1f%%) ",badPoint*100.0]];
        
        [cell.goodProgressView setProgress:goodPoint animated:YES];
        [cell.mediumProgressView setProgress:minPoint animated:YES];
        [cell.poorProgressView setProgress:badPoint animated:YES];
        
        return cell;
    }
    
    if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"ProfileOne";
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }

//        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        [cell.checkLable setHidden:YES];
        switch (indexPath.row) {
            case 0:
            {
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                [cell.checkLable setHidden:NO];
                [cell.checkLable setCheckState:YES];
                [cell.titleLabel setText:@"手机号码:"];
                [cell.infoLabel setText:self.userInfo.phone];
                
                break;
            }
//            case 1:
//            {
//                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
//                [cell.checkLable setHidden:NO];
//                [cell.checkLable setCheckState:YES];
//                [cell.titleLabel setText:@"车辆信息:"];
//                [cell.infoLabel setText:@"大众高尔夫6"];
//                break;
//            }
//            case 2:
//            {
//                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
//                [cell.checkLable setHidden:NO];
//                [cell.checkLable setCheckState:YES];
//                [cell.titleLabel setText:@"实名认证:"];
//                [cell.infoLabel setText:@"完成"];
//                break;
//            }
            case 1:
            {
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                [cell.checkLable setHidden:YES];
                [cell.checkLable setCheckState:YES];
                [cell.titleLabel setText:@"常用路线:"];
                [cell.infoLabel setText:[NSString stringWithFormat:@"%d条",self.userInfo.favlinenum]];
                break;
            }
            case 2:
            {
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.checkLable setHidden:YES];
                [cell.checkLable setCheckState:YES];
                [cell.titleLabel setText:@"公司地址:"];
                [cell.infoLabel setText:(self.uid == [User shareInstance].userId?([self.userInfo.companyaddress isEqualToString:@""]?@"无":self.userInfo.companyaddress):@"保密")];
                break;
            }
            case 3:
            {
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.checkLable setHidden:YES];
                [cell.checkLable setCheckState:YES];
                [cell.titleLabel setText:@"家庭地址:"];
                [cell.infoLabel setText:(self.uid == [User shareInstance].userId?([self.userInfo.homeaddress isEqualToString:@""]?@"无":self.userInfo.homeaddress):@"保密")];
                break;
            }
            default:
                break;
        }
        
        return cell;
    }
    
    
    if (indexPath.section == 2) {
        static NSString *CellIdentifier = @"ExitButtonCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        if (self.state == 2) {
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(7.5, 4, 305, 36)];
            [btn setTitle:@"退出登入" forState:UIControlStateNormal];
            //        [btn setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor clearColor]];
            [btn setBackgroundImage:[[UIImage imageNamed:@"btn_blue_normal"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
            [btn setBackgroundImage:[[UIImage imageNamed:@"btn_blue_pressed"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(exitLoginState:) forControlEvents:UIControlEventTouchUpInside];
            [btn setCenter:cell.contentView.center];
            [cell.contentView addSubview:btn];
            [btn release];
        }
        if (self.state == 1) {
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(7.5, 4, 305, 36)];
            [btn setTitle:@"发起聊天" forState:UIControlStateNormal];
            //        [btn setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor clearColor]];
            [btn setBackgroundImage:[[UIImage imageNamed:@"btn_blue_normal"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
            [btn setBackgroundImage:[[UIImage imageNamed:@"btn_blue_pressed"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(enterSingleChat:) forControlEvents:UIControlEventTouchUpInside];
            [btn setCenter:cell.contentView.center];
            [cell.contentView addSubview:btn];
            [btn release];
        }

        return cell;
    }
    
    static NSString *CellIdentifier = @"ResultsTable";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (self.state == 1) {
//        return;
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        //电话
        if (indexPath.row == 0) {
            DLog(@"打电话");
            if (self.userInfo.ID == [User shareInstance].userId) {
                [UIAlertView showAlertViewWithTitle:@"你确定要联系自己么?" tag:111 cancelTitle:@"忽略" ensureTitle:nil delegate:self];
            }
            else
            {
                [UIAlertView showAlertViewWithTitle:[NSString stringWithFormat:@"你确定要联系%@么?\n拨通电话tel:%@",self.userInfo.userName,self.userInfo.phone] tag:112 cancelTitle:@"取消" ensureTitle:@"确定" delegate:self];
            }
        }
        
//        //评论
//        if(indexPath.row == 1)
//        {
//            DLog(@"评论列表");
//        }
        
        //路线
        if(indexPath.row == 1)
        {
            DLog(@"常用路线列表");
            CommonRoutesViewController *commonRoutesVC = [[CommonRoutesViewController alloc]init];
            commonRoutesVC.myInfo = self.userInfo;
            [self.navigationController pushViewController:commonRoutesVC animated:YES];
            [commonRoutesVC release];
        }
        
        //车辆
//        if(indexPath.row == 3)
//        {
//            DLog(@"车辆信息");
//            
//        }
    }
    
}


#pragma mark - actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        //退出登入
        //清除账户信息
        //保存信息
        User * user = [User shareInstance];
        user.userPwd = @"";
        user.isSavePwd = NO;
        [user save];
        [user clear];
        
        [[XmppManager sharedInstance] disconnect];
        
        //显示的登入信息
        LogInViewController * logInVC= [[LogInViewController alloc] init];
        UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:logInVC];
        [navi setNavigationBarHidden:YES];
        [navi setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:navi animated:YES completion:^{
            [[AppDelegate shareDelegate].window setRootViewController:navi];
        }];
        [navi release];
        [logInVC release];
    }
}

#pragma mark - aleartDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 111) {
        return;
    }
    if (alertView.tag == 112) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.userInfo.phone]]];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
