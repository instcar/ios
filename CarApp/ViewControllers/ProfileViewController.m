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
#import "ProFileEditTableViewCell.h"

#import "PeopleManager.h"
#import "XmppManager.h"
#import "SetProfileViewController.h"
#import "SingleChatViewController.h"
#import "CarImageViewController.h"
#import "CommonRoutesViewController.h"

#import "CarInfoTableViewCell.h"
#import "SelectCarBrandViewController.h"
#import "IdentityAuthViewController.h"

#import "EditCompanyViewController.h"
#import "EditfavLineViewController.h"
#import "EditSignatureViewController.h"

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
    
    _isEditing = NO;
    
    [self setCtitle:@"个人中心"];
    [self setDesText:nil];
    
    if (self.uid == [User shareInstance].userId) {
        UIButton * editButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [editButton setFrame:CGRectMake(320- 70, 20, 70, 44)];
        [editButton setBackgroundColor:[UIColor clearColor]];
        [editButton setBackgroundImage:[UIImage imageNamed:@"btn_edit_normal@2x"] forState:UIControlStateNormal];
        [editButton setBackgroundImage:[UIImage imageNamed:@"btn_edit_pressed@2x"] forState:UIControlStateHighlighted];
        [editButton setBackgroundImage:[UIImage imageNamed:@"btn_save_normal@2x"] forState:UIControlStateSelected];
        [editButton addTarget:self action:@selector(editProfile:) forControlEvents:UIControlEventTouchUpInside];
        [self setRightBtn:editButton];
    }
    
    UITableView *profileTable = [[UITableView alloc]initWithFrame:CGRectMake(0, KOFFSETY, SCREEN_WIDTH, SCREEN_HEIGHT - KOFFSETY)];
    [profileTable setBackgroundColor:[UIColor clearColor]];
    [profileTable setBackgroundView:nil];
    [profileTable setDelegate:self];
    [profileTable setDataSource:self];
    [profileTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [profileTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)]];
    [self.view addSubview:profileTable];
    [self setProfileTable:profileTable];
    [profileTable release];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserInfo];
}

-(void)getUserInfo
{
    //保存用户信息
//    [NetWorkManager networkGetUserInfoCenterWithuid:self.uid success:^(BOOL flag, NSDictionary *userInfoDic, NSString *msg) {
//        
//        if (flag) {
//            
//            NSDictionary * userDic = [userInfoDic valueForKey:@"user"];
//            People *people = [[People alloc]initFromDic:userDic];
//            people.favlinenum = [[userInfoDic valueForKey:@"favlinenum"] intValue];
//            people.goodcount = [[userInfoDic valueForKey:@"goodcount"] intValue];
//            people.midcount = [[userInfoDic valueForKey:@"midcount"] intValue];
//            people.badcount = [[userInfoDic valueForKey:@"badcount"] intValue];
////            [User shareInstance].userName = people.userName;
////            [User shareInstance].userData = [NSMutableDictionary dictionaryWithDictionary:userInfo];//保存网络请求下来的数据
////            [User shareInstance].phoneNum = people.phone;
////            [User shareInstance].userId = people.ID;
////            [[User shareInstance] save];
//            
//            [PeopleManager insertPeopleShortInfo:people];
//            
//            UILabel *welcomeLable = (UILabel *)[self.view viewWithTag:22222];
//            [welcomeLable setText:[NSString stringWithFormat:@"%@",people.userName]];
//            
//            [self setUserInfo:people];
//            [people release];
//            
//            [self.profileTable reloadData];
//        }
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
    
    [APIClient networkGetUserInfoWithuid:self.uid success:^(Respone *respone) {
        if (respone.status == kEnumServerStateSuccess ) {
            
            People *people = [[People alloc]initFromDic:(NSDictionary *)respone.data];

            [PeopleManager insertPeopleShortInfo:people];

            UILabel *welcomeLable = (UILabel *)[self.view viewWithTag:22222];
            [welcomeLable setText:[NSString stringWithFormat:@"%@",people.name]];
            
            [self setUserInfo:people];
            [people release];
            
            //更新视图
            [self updateView];
        }

    } failure:^(NSError *error) {
        
    }];
}

- (void)updateView
{
    [self setDesText:self.userInfo.detail.signature];
    [self.profileTable reloadData];
}

-(void)editProfile:(UIButton *)sender
{
    //编辑个人
    sender.selected = !sender.selected;
    _isEditing = sender.selected;
    if (!sender.selected) {
        DLog(@"保存");
        //保存
        [UIAlertView showAlertViewWithTitle:@"信息有改动，是否保存？" tag:113 cancelTitle:@"不保存" ensureTitle:@"保存" delegate:self];
    }
    [self.profileTable reloadData];
}

- (void)addCarIdentify:(UIButton *)btn
{
    DLog(@"增加车辆验证信息");
    SelectCarBrandViewController *selectCarBrandVC = [[SelectCarBrandViewController alloc]init];
    [self.navigationController pushViewController:selectCarBrandVC animated:YES];
    [selectCarBrandVC release];
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
    [singleChatVC setUserName:self.userInfo.name];
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
    if (section == 0) {
        return 2;
    }
    
    if (section == 1) {
        return 5;
    }

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 60.0;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {

        UIView * cell = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)]autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(7.5, 8, 305, 44)];
        [btn setTitle:@"增加验证车辆信息" forState:UIControlStateNormal];
        [btn.titleLabel setFont:AppFont(14)];
        [btn setBackgroundImage:[[UIImage imageNamed:@"btn_add_car_normal"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [btn setBackgroundImage:[[UIImage imageNamed:@"btn_add_car_press"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"ic_add_car"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addCarIdentify:) forControlEvents:UIControlEventTouchUpInside];
        [btn setCenter:cell.center];
        [cell addSubview:btn];
        [btn release];
        return cell;
    }
    return nil;
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
        if (indexPath.row == 0) {
            return 115;
        }
        else
        {
            return 80.0;
        }
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
        
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"ProfilePhotoFirst";
            ProfilePhotoFirstCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[ProfilePhotoFirstCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.backgroundView = nil;
            [cell setData:self.userInfo];
            
    //评分暂时一期不做展示，积累信誉数据
//            float score = 0.0;
//            float goodPoint = 0.0;
//            float minPoint = 0.0;
//            float badPoint = 0.0;
//            
//            if (self.userInfo) {
//                score = self.userInfo.goodcount+self.userInfo.midcount+self.userInfo.badcount;
//                if (score > 0) {
//                    goodPoint = (float)self.userInfo.goodcount/score;
//                    minPoint = (float)self.userInfo.midcount/score;
//                    badPoint = (float)self.userInfo.badcount/score ;
//                }
//            }
//            
//            [cell.scoreLabel setText:[NSString stringWithFormat:@"%.1f%%",goodPoint*100.0]];
//            [cell.goodLabel setText:[NSString stringWithFormat:@"好评 (%.1f%%) ",goodPoint*100.0]];
//            [cell.mediumLabel setText:[NSString stringWithFormat:@"中评 (%.1f%%) ",minPoint*100.0]];
//            [cell.poorLable setText:[NSString stringWithFormat:@"差评 (%.1f%%) ",badPoint*100.0]];
//            
//            [cell.goodProgressView setProgress:goodPoint animated:YES];
//            [cell.mediumProgressView setProgress:minPoint animated:YES];
//            [cell.poorProgressView setProgress:badPoint animated:YES];
            
            return cell;

        }
        else
        {
            static NSString *carInfoCellIdentifier = @"carInfoTableCell";
            CarInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:carInfoCellIdentifier];
            if (cell == nil) {
                cell = [[[CarInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:carInfoCellIdentifier] autorelease];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            
            cell.data = [NSDictionary dictionaryWithObjectsAndKeys:@"ok",@"ok", nil];
            return cell;
        }
        
    }
    
    if (indexPath.section == 1) {
        
        if (!_isEditing) {
            
            ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileOne"];
            if (cell == nil) {
                cell = [[[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileOne"] autorelease];
            }

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
                case 1:
                {
                    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                    [cell.checkLable setHidden:NO];
                    [cell.checkLable setCheckState:self.userInfo.status];
                    [cell.titleLabel setText:@"实名认证:"];
                    [cell.infoLabel setText:self.userInfo.status?@"完成":@"未完成"];
                    break;
                }
                case 2:
                {
                    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                    [cell.checkLable setHidden:YES];
                    [cell.checkLable setCheckState:YES];
                    [cell.titleLabel setText:@"常用路线:"];
//                    [cell.infoLabel setText:[NSString stringWithFormat:@"%d条",self.userInfo.favlinenum]];
                    break;
                }
                case 3:
                {
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.checkLable setHidden:YES];
                    [cell.checkLable setCheckState:YES];
                    [cell.titleLabel setText:@"公司地址:"];
                    [cell.infoLabel setText:(self.uid == [User shareInstance].userId?([self.userInfo.detail.comp_addr isEqualToString:@""]?@"无":self.userInfo.detail.comp_addr):@"保密")];
                    break;
                }
                case 4:
                {
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.checkLable setHidden:YES];
                    [cell.checkLable setCheckState:YES];
                    [cell.titleLabel setText:@"家庭地址:"];
                    [cell.infoLabel setText:(self.uid == [User shareInstance].userId?([self.userInfo.detail.home_addr isEqualToString:@""]?@"无":self.userInfo.detail.home_addr):@"保密")];
                    break;
                }
                default:
                    break;
            }
            return cell;
        }
        else
        {
            //编辑状态
            ProFileEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileEditOne"];
            if (cell == nil) {
                cell = [[[ProFileEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileEditOne"] autorelease];
                 [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            }
            
            switch (indexPath.row) {
                case 0:
                {

                    [cell setTitleStr:@"编辑签名备注信息:"];
                    [cell setInfoStr:![[self.userInfo.detail signature] isEqualToString:@""]?[self.userInfo.detail signature]:@"暂无"];
                    
                    break;
                }
                case 1:
                {
                    [cell setTitleStr:@"编辑公司地址:"];
                    [cell setInfoStr:![[self.userInfo.detail comp_addr] isEqualToString:@""]?[self.userInfo.detail comp_addr]:@"暂无"];
                    break;
                }
                case 2:
                {
                    [cell setTitleStr:@"编辑家庭地址:"];
                    [cell setInfoStr:![[self.userInfo.detail home_addr] isEqualToString:@""]?[self.userInfo.detail home_addr]:@"暂无"];
                    break;
                }
                case 3:
                {
                    [cell setTitleStr:@"更换手机号码:"];
                    [cell setInfoStr:[self.userInfo phone]];
                    break;
                }
                case 4:
                {
                    [cell setTitleStr:@"编辑常用线路:"];
//                    [cell setInfoStr:[NSString stringWithFormat:@"%d条",[self.userInfo favlinenum]]];
                    break;
                }
                default:
                    break;
            }
            return cell;
        }
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
        
        if (!_isEditing) {

            //电话
            if (indexPath.row == 0) {
                DLog(@"打电话");
                if (self.userInfo.ID == [User shareInstance].userId) {
                    [UIAlertView showAlertViewWithTitle:@"你确定要联系自己么?" tag:111 cancelTitle:@"忽略" ensureTitle:nil delegate:self];
                }
                else
                {
                    [UIAlertView showAlertViewWithTitle:[NSString stringWithFormat:@"你确定要联系%@么?\n拨通电话tel:%@",self.userInfo.name,self.userInfo.phone] tag:112 cancelTitle:@"取消" ensureTitle:@"确定" delegate:self];
                }
            }
            
            //实名认证
            if(indexPath.row == 1)
            {
                DLog(@"实名认证");
                IdentityAuthViewController *identityAuthVC = [[IdentityAuthViewController alloc]init];
                [self.navigationController pushViewController:identityAuthVC animated:YES];
                [identityAuthVC release];
            }
            
            //路线
            if(indexPath.row == 2)
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
        else
        {
            //编辑签名
            if (indexPath.row == 0) {
                DLog(@"编辑签名");
                EditSignatureViewController *editSignatureVC = [[EditSignatureViewController alloc]init];
                [self.navigationController pushViewController:editSignatureVC animated:YES];
                [editSignatureVC release];
            }
            
            //编辑公司地址
            if(indexPath.row == 1)
            {
                DLog(@"编辑公司地址");
                EditCompanyViewController *editCompanyVC = [[EditCompanyViewController alloc]init];
                [self.navigationController pushViewController:editCompanyVC animated:YES];
                [editCompanyVC release];
            }
            
            //编辑家庭地址
            if(indexPath.row == 2)
            {
                DLog(@"编辑家庭地址");
                
            }
            //更换手机号码
            if(indexPath.row == 3)
            {
                DLog(@"更换手机号码");

            }
            //编辑常用路线
            if (indexPath.row == 4) {
                DLog(@"编辑常用路线");
                EditfavLineViewController *editFavlineVC = [[EditfavLineViewController alloc]init];
                [self.navigationController pushViewController:editFavlineVC animated:YES];
                [editFavlineVC release];
            }
        }
    }
    
}


#pragma mark - actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        //退出登入
        [APIClient networkLoginoutWithSuccess:^(Respone *respone) {
            //清除账户信息
            //保存信息
            User * user = [User shareInstance];
            user.userPwd = @"";
            user.isSavePwd = NO;
            
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
        } failure:^(NSError *error) {
            
        }];
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
    if (alertView.tag == 113) {
        if (buttonIndex == 1) {
            //保存
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
