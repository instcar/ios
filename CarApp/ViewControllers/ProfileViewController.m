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

#import "EditAddressViewController.h"
#import "EditfavLineViewController.h"
#import "EditSignatureViewController.h"

#import "Car.h"
#import "UIImage+Compress.h"
#import "PhotoSelectManager.h"
#import "UIButton+WebCache.h"

@interface ProfileViewController ()<CarInfoTableViewCellDelegate,ProfilePhotoFirstCustomCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (retain, nonatomic) People *userInfo;             //用户信息
@property (retain, nonatomic) NSArray *carArray;            //用户车辆信息
@property (copy, nonatomic) NSString *headFilePath;         //头像文件位置
@property (copy, nonatomic) NSString *headUrl;              //头像上传地址

@end

@implementation ProfileViewController


-(void)dealloc
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //请求/刷新用户数据
    [self requestData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isEditing = NO;
    
    [self setTitle:@"个人中心"];
    [self setMessageText:@""];
    [self setFormData:[NSMutableDictionary dictionary]];
    
    if (self.uid == [User shareInstance].userId) {
        [self setEnableEditing:YES];
    }
    
    _profileTable = [[UITableView alloc]initWithFrame:CGRectMake(0, KOFFSETY, APPLICATION_WIDTH, APPLICATION_HEGHT - KOFFSETY - 44)];
    [_profileTable setBackgroundColor:[UIColor clearColor]];
    [_profileTable setBackgroundView:nil];
    [_profileTable setDelegate:self];
    [_profileTable setDataSource:self];
    [_profileTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_profileTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)]];
    [self.view insertSubview:_profileTable belowSubview:_messageBgView];
    
}

-(void)requestData
{
    
    //获取用户信息
    [APIClient networkGetUserInfoWithuid:self.uid success:^(Respone *respone) {
        if (respone.status == kEnumServerStateSuccess ) {
            People *people = [[People alloc]initFromDic:(NSDictionary *)respone.data];
            [self setUserInfo:people];
            
            //更新视图
            [self updateView];
        }
        else
        {
            //请求失败
            
        }

    } failure:^(NSError *error) {
        
    }];
    
    //获取用户车辆信息 -1参数不填
    [APIClient networkUserGetCarsWithcar_id:-1 success:^(Respone *respone) {
        if (respone.status == kEnumServerStateSuccess ) {
            [self setCarArray:[Car initWithArray:[respone.data valueForKey:@"list"]]];
            //测试
            for (int i = 0; i < [self.carArray count]; i++) {
                Car *car = [self.carArray objectAtIndex:i];
                if (i == 0) {
                   car.status = 2;
                }
            }
            [self updateView];
        }
        else
        {
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    //
}
//刷新视图
- (void)updateView
{
    [self setMessageText:self.userInfo.detail.signature];
    [_profileTable reloadData];
}

#pragma mark - 按钮事件
//编辑个人信息
-(void)editBtnAction:(UIButton *)sender
{
    //编辑个人
    sender.selected = !sender.selected;
    _isEditing = sender.selected;
    
    ProfilePhotoFirstCustomCell *cell = (ProfilePhotoFirstCustomCell *)[_profileTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell setEditing:_isEditing];
    
    if (!sender.selected) {
        DLog(@"保存");
        //保存
        [UIAlertView showAlertViewWithTitle:@"信息有改动，是否保存？" tag:113 cancelTitle:@"不保存" ensureTitle:@"保存" delegate:self];
    }
    [_profileTable reloadData];
}

//增加车辆验证
- (void)addCarIdentify:(UIButton *)btn
{
    DLog(@"增加车辆验证信息");
    SelectCarBrandViewController *selectCarBrandVC = [[SelectCarBrandViewController alloc]init];
    [self.navigationController pushViewController:selectCarBrandVC animated:YES];
}

//退出登入
-(void)exitLoginState:(UIButton *)btn
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出当前账号" otherButtonTitles:nil];
    [actionSheet showInView:[AppDelegate shareDelegate].window];
}

//进入单人聊天
-(void)enterSingleChat:(UIButton *)btn
{
    SingleChatViewController *singleChatVC = [[SingleChatViewController alloc]init];
    [singleChatVC setUserID:self.userInfo.ID];
    [singleChatVC setUserName:self.userInfo.name];
    [self.navigationController pushViewController:singleChatVC animated:YES];
}

-(void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //不显示退出按钮
    if (self.state == 1) {
        return 2;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1 + [self.carArray count];
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
    //自己的时候
    if (section == 0 && self.uid == [User shareInstance].userId) {
        //无车状态现实增加车辆认证按钮，有车状态在非编辑状态不显示
        if ([self.carArray count]==0 || _isEditing) {
            return 60.0;
        }
    }
    else
        if (section == 0)
        {
            return 10.0;
        }
    return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //自己的时候
    if (section == 0 && self.uid == [User shareInstance].userId) {
        //无车状态现实增加车辆认证按钮，有车状态在非编辑状态不显示
        if ([self.carArray count]==0 || _isEditing) {
            
            UIView * cell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
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
            return cell;
        }
    }
    else
        if (section == 0)
        {
            UIView * cell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10.0)];
            [cell setBackgroundColor:[UIColor clearColor]];
            return cell;
        }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
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
            float height = 80;
            Car *car = (Car *)[self.carArray objectAtIndex:indexPath.row-1];
            if ([self.carArray count]>0) {
                switch (car.status) {
                    case 0:
                        height = 80.0;
                        break;
                    case 1:
                        height = 80.0;
                        break;
                    case 2:
                        height = 135.0;
                        break;
                    default:
                        break;
                }
            }
            return height;
        }
        return 80.0;
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
                cell = [[ProfilePhotoFirstCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.backgroundView = nil;
            //放弃调用修改图片
            if (self.headFilePath) {
                self.userInfo.headpic = @"image";
            }
            [cell setData:self.userInfo];

            [cell setDeleagte:self];
            
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
            //显示车辆
            static NSString *carInfoCellIdentifier = @"carInfoTableCell";
            CarInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:carInfoCellIdentifier];
            if (cell == nil) {
                cell = [[CarInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:carInfoCellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            //添加数据
            cell.carData = (Car *)[self.carArray objectAtIndex:indexPath.row - 1];
            cell.delegate = self;
            return cell;
        }
        
    }
    
    if (indexPath.section == 1) {
        
        if (!_isEditing) {
            
            ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileOne"];
            if (cell == nil) {
                cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileOne"];
            }

            [cell.checkLable setHidden:YES];
            [cell.infoLabel setTextColor:[UIColor appBlackColor]];
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
                    
                    switch (self.userInfo.status) {
                        case 0:
                        {
                            [cell.infoLabel setText:@"马上审核"];
                            [cell.infoLabel setTextColor:[UIColor appNavTitleGreenColor]];
                            break;
                        }
                        case 1:
                        {
                            [cell.infoLabel setText:@"完成"];
                            break;
                        }
                        case 2:
                        {
                            [cell.infoLabel setText:@"拒绝"];
                            [cell.infoLabel setTextColor:[UIColor redColor]];
                            break;
                        }
                        case 3:
                        {
                            [cell.infoLabel setText:@"审核中..."];
                            [cell.infoLabel setTextColor:[UIColor redColor]];
                            break;
                        }
                        default:
                            break;
                    }
                    
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
                    NSString *comStr = self.userInfo.detail?((self.uid == [User shareInstance].userId?([self.userInfo.detail.comp_addr isEqualToString:@""]?@"无":self.userInfo.detail.comp_addr):@"保密")):@"暂无";
                    [cell.infoLabel setText:comStr];
                    break;
                }
                case 4:
                {
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.checkLable setHidden:YES];
                    [cell.checkLable setCheckState:YES];
                    [cell.titleLabel setText:@"家庭地址:"];
                    NSString *homeStr = self.userInfo.detail?(self.uid == [User shareInstance].userId?([self.userInfo.detail.home_addr isEqualToString:@""]?@"无":self.userInfo.detail.home_addr):@"保密"):@"暂无";
                    [cell.infoLabel setText:homeStr];
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
                cell = [[ProFileEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileEditOne"];
                 [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            }
            
            switch (indexPath.row) {
                case 0:
                {
                    [cell setTitleStr:@"编辑签名备注信息:"];
                    NSString *sig = self.userInfo.detail?([[self.userInfo.detail signature] isEqualToString:@""]?@"暂无":[self.userInfo.detail signature]):@"暂无";
                    [cell setInfoStr:sig];
                    break;
                }
                case 1:
                {
                    [cell setTitleStr:@"编辑公司地址:"];
                    NSString *comStr = self.userInfo.detail?((self.uid == [User shareInstance].userId?([self.userInfo.detail.comp_addr isEqualToString:@""]?@"无":self.userInfo.detail.comp_addr):@"保密")):@"暂无";
                    [cell setInfoStr:comStr];
                    break;
                }
                case 2:
                {
                    [cell setTitleStr:@"编辑家庭地址:"];
                    NSString *homeStr = self.userInfo.detail?(self.uid == [User shareInstance].userId?([self.userInfo.detail.home_addr isEqualToString:@""]?@"无":self.userInfo.detail.home_addr):@"保密"):@"暂无";
                    [cell setInfoStr:homeStr];
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
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
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
        }

        return cell;
    }
    
    static NSString *CellIdentifier = @"ResultsTable";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
            }
            
            //路线
            if(indexPath.row == 2)
            {
                DLog(@"常用路线列表");
                CommonRoutesViewController *commonRoutesVC = [[CommonRoutesViewController alloc]init];
                commonRoutesVC.userInfo = self.userInfo;
                [self.navigationController pushViewController:commonRoutesVC animated:YES];
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
                editSignatureVC.parentVC = self;
                editSignatureVC.peopleInfo = self.userInfo;
                [self.navigationController pushViewController:editSignatureVC animated:YES];
            }
            
            //编辑公司地址
            if(indexPath.row == 1)
            {
                DLog(@"编辑公司地址");
                EditAddressViewController *editCompanyVC = [[EditAddressViewController alloc]init];
                editCompanyVC.type = 1;
                [self.navigationController pushViewController:editCompanyVC animated:YES];
            }
            
            //编辑家庭地址
            if(indexPath.row == 2)
            {
                DLog(@"编辑家庭地址");
                EditAddressViewController *editHomeVC = [[EditAddressViewController alloc]init];
                editHomeVC.type = 2;
                [self.navigationController pushViewController:editHomeVC animated:YES];
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
            }
        }
    }
 
}
#pragma mark - ProfilePhotoFirstCustomCellDelegate
- (void)photoImgViewAction:(ProfilePhotoFirstCustomCell *)sender
{
    DLog(@"编辑photo按钮");
    if (_isEditing) {
        DLog(@"上传头像");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍摄照片",@"从相册中选择照片", nil];
        [alertView setTag:110];
        [alertView show];

    }
    else
    {
        DLog(@"查看头像");
    }
}

//  style = 0 拍照 ; style = 1 相册 ;
-(void)showImagePickerWithStyle:(int)style
{
    //选择拍照
    if (style == 0) {
        [PhotoSelectManager selectPhotoFromCamreWithDelegate:self withVC:self withEdit:YES];
    }
    
    //选择相册
    if (style == 1) {
        [PhotoSelectManager selectPhotoFromPhotoWithDelegate:self withVC:self withEdit:YES];
    }
}

#pragma mark - imagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //更新上传到服务器
    [self performSelector:@selector(saveImage:)
               withObject:image
               afterDelay:0.0];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }];
}

-(NSString *)saveImage:(UIImage *)image
{
    DLog(@"已选择头像");
    
    //可以对图片进行处理后上传
    NSData  *imageData = [image compressedDataSize:0.2*1024];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"head0.png"];
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    ProfilePhotoFirstCustomCell *cell = (ProfilePhotoFirstCustomCell *)[_profileTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.photoImgView setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    //上传头像
    self.headFilePath = fullPathToFile;
    
    return fullPathToFile;
}


#pragma mark - CarInfoTableViewCellDelegate
//重新审核
-(void)reConfirmBtnAction:(CarInfoTableViewCell *)sender
{
    DLog(@"重新审核车辆");
    [self requestData];
}
//取消
-(void)cancleConfirmBtnAction:(CarInfoTableViewCell *)sender
{
    DLog(@"取消车辆验证");
    [self requestData];
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
            [self requestEditUserInfo];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    //头像选择
    if (alertView.tag == 110) {
        switch (buttonIndex) {
            case 1:
            {
                [self showImagePickerWithStyle:0];
            }
                break;
            case 2:
            {
                [self showImagePickerWithStyle:1];
            }
                break;
            default:
                break;
        }
    }
}

- (void)requestEditUserInfo
{
    if (self.headFilePath) {

        MBProgressHUD *hubView = [MBProgressHUD showMessag:@"正在上传" toView:self.view];
        [APIClient networkUpLoadImageFileByType:2 user_id:[User shareInstance].userId dataFile:[NSArray arrayWithObject:self.headFilePath] success:^(Respone *respone) {
            DLog(@"%@",[respone description]);
            if (respone.status == kEnumServerStateSuccess) {
                [hubView setLabelText:@"保存用户修改"];
                NSString *imageUrl = [respone.data valueForKey:@"file_0"];
                [self.formData setValue:imageUrl forKey:@"headpic"];
                //获取用户实名认证
                [APIClient networkEditUserInfo:self.formData success:^(Respone *respone) {
                    if (respone.status == kEnumServerStateSuccess) {
                        //清楚数据
                        self.headFilePath = nil;
                        [self.formData removeAllObjects];
                        //请求/刷新用户数据
                        [self requestData];
                    }
                    [hubView setLabelText:respone.msg];
                    [hubView hide:YES afterDelay:1.0];
                } failure:^(NSError *error) {
                    [hubView setLabelText:error.description];
                    [hubView hide:YES afterDelay:1.0];
                }];
            }
            else
            {
                [hubView setLabelText:respone.msg];
                [hubView hide:YES afterDelay:1.0];
            }
            
        } failure:^(NSError *error) {
            [hubView setLabelText:error.description];
            [hubView hide:YES afterDelay:1.0];
        }];
    }
    else
    {
        if ([[self.formData allKeys]count]>0) {

            MBProgressHUD *hubView = [MBProgressHUD showMessag:@"保存修改" toView:self.view];
            [APIClient networkEditUserInfo:self.formData success:^(Respone *respone) {
                if (respone.status == kEnumServerStateSuccess) {
                    //清楚数据
                    self.headFilePath = nil;
                    [self.formData removeAllObjects];
                    //请求/刷新用户数据
                    [self requestData];
                }
                [hubView setLabelText:respone.msg];
                [hubView hide:YES afterDelay:1.0];
            } failure:^(NSError *error) {
                [hubView setLabelText:error.description];
                [hubView hide:YES afterDelay:1.0];
            }];
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
