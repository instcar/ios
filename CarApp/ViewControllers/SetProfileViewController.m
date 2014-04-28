//
//  SetProfileViewController.m
//  CarApp
//
//  Created by 海龙 李 on 13-11-13.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "SetProfileViewController.h"
#import "SetProfileTableCell.h"
#import "PhotoSelectManager.h"
#import "ProfileCompanyAddressViewController.h"
#import "ProfileHomeAddressViewController.h"
#import "WeiBoAccessViewController.h"
#import "ChangerPhoneViewController.h"
#import "GDCustomAlertView.h"
#import "PeopleManager.h"
#import "SetProfileHeadTableCell.h"
#import "ChangerNameViewController.h"
#import "NetWorkManager.h"

@interface SetProfileViewController ()<CompanyAddressDelegate,HomeAddressDelegate,GDCustomAlertDelegate,ChangerPhoneViewControllerDelegate,ChangerNameDelegate>

@property (retain, nonatomic) NSMutableArray *networkRequestArray;
@property (retain, nonatomic) People *userInfo;
@property (assign, nonatomic) BOOL canEdit;
@property (retain, nonatomic) UIImage *headImage;
@property (retain, nonatomic) UIPickerView * pickerView;
@property (retain, nonatomic) UIView *pickerConstionView;
@end

@implementation SetProfileViewController

@synthesize phoneNumberString = _phoneNumberString;
@synthesize pickerView = _pickerView;
@synthesize ageArray = _ageArray;

-(void)dealloc
{
    [SafetyRelease release:_setProfileTable];
    [SafetyRelease release:_phoneNumberString];
    [SafetyRelease release:_ageArray];
    [SafetyRelease release:_networkRequestArray];
    [SafetyRelease release:_userInfo];
    [SafetyRelease release:_headImage];
    [SafetyRelease release:_pickerView];
    [SafetyRelease release:_pickerConstionView];
    
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

    _phoneNumberString = [[NSString alloc]init];
    _networkRequestArray = [[NSMutableArray alloc]initWithCapacity:10];
    self.canEdit = NO;
    
    UIView * mainView = [[UIView alloc]initWithFrame:[AppUtility mainViewFrame]];
    [mainView setBackgroundColor:[UIColor appBackgroundColor]];
    [self.view addSubview:mainView];
    [mainView release];
    
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
    [titleLabel setText:@"补充资料"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor appNavTitleColor]];
    [titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [navBar addSubview:titleLabel];
    [titleLabel release];
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(320-70, 20, 70, 44)];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_edit_normal@2x"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_edit_normal@2x"] forState:UIControlStateHighlighted];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_save_normal@2x"] forState:UIControlStateSelected];
    [navBar addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(saveAtion:) forControlEvents:UIControlEventTouchUpInside];
    
    UITableView *setProfileTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 +45, 320, SCREEN_HEIGHT - 64 -45)];
    [setProfileTable setBackgroundColor:[UIColor colorWithRed:(float)243/255 green:(float)243/255 blue:(float)243/255 alpha:1]];
    [setProfileTable setDataSource:self];
    [setProfileTable setDelegate:self];
    [setProfileTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [mainView addSubview:setProfileTable];
    [self setSetProfileTable:setProfileTable];
    [setProfileTable release];
    
    UIView * tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    [tableHeaderView setBackgroundColor:[UIColor clearColor]];
    [self.setProfileTable setTableHeaderView:tableHeaderView];
    [self.setProfileTable setTableFooterView:tableHeaderView];
    [tableHeaderView release];
    
    UIImage * welcomeImage = [UIImage imageNamed:@"nav_hint@2x"];
    //    welcomeImage = [welcomeImage stretchableImageWithLeftCapWidth:8 topCapHeight:10];
    //导航栏下方的欢迎条
    UIImageView * welcomeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 49)];
    [welcomeImgView setImage:welcomeImage];
    [mainView addSubview:welcomeImgView];
    [welcomeImgView release];
    
    UILabel * welcomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 310, 44)];
    [welcomeLabel setBackgroundColor:[UIColor clearColor]];
    [welcomeLabel setText:@"为了您和他人的安全,发布有车信息需要进行实名认证"];
    [welcomeLabel setTextAlignment:NSTextAlignmentCenter];
    [welcomeLabel setTextColor:[UIColor whiteColor]];
    [welcomeLabel setFont:[UIFont appGreenWarnFont]];
    [welcomeImgView addSubview:welcomeLabel];
    [welcomeLabel release];
    
    UIButton * confirmAgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmAgeBtn setTag:50006];
    [confirmAgeBtn setFrame:CGRectMake(320-63, 0, 63, 39)];
    [confirmAgeBtn setBackgroundColor:[UIColor clearColor]];
    [confirmAgeBtn setBackgroundImage:[UIImage imageNamed:@"btn_key_down"] forState:UIControlStateNormal];
//    [confirmAgeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmAgeBtn addTarget:self action:@selector(saveAge) forControlEvents:UIControlEventTouchUpInside];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 39, 320, 216)];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    [pickerView setBackgroundColor:[UIColor whiteColor]];
    [pickerView setShowsSelectionIndicator:YES];
    [self setPickerView:pickerView];
    [pickerView release];

    UIView *pickerConstionView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 255)];
    [self setPickerConstionView:pickerConstionView];
    [pickerConstionView release];
    [self.pickerConstionView setUserInteractionEnabled:YES];
    [self.pickerConstionView setBackgroundColor:[UIColor clearColor]];
    [self.pickerConstionView addSubview:confirmAgeBtn];
    [self.pickerConstionView addSubview:self.pickerView];
    
    [mainView addSubview:self.pickerConstionView];
    
    self.ageArray = [[[NSMutableArray alloc]init]autorelease];
    for (int i = 0; i < 43; i++) {
        NSString * age = [NSString stringWithFormat:@"%d",18+i];
        [self.ageArray addObject:age];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //更新数据
    [self getUserInfo];
}

-(void)getUserInfo
{

    //保存用户信息
    [NetWorkManager networkGetUserInfoWithuid:[User shareInstance].userId success:^(BOOL flag, NSDictionary *userInfo, NSString *msg) {
        
        if (flag) {
            People *people = [[People alloc]initFromDic:userInfo];
            [User shareInstance].userName = people.name;
            [User shareInstance].userData = [NSMutableDictionary dictionaryWithDictionary:userInfo];//保存网络请求下来的数据
            [User shareInstance].phoneNum = people.phone;
            [User shareInstance].userId = people.ID;
            
            [PeopleManager insertPeopleShortInfo:people];
            
            self.userInfo = people;
            [people release];
            
            [_setProfileTable reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - tableViewDelegate/tableviewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SetProfileTableCell";
    SetProfileTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SetProfileTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    [cell setAccessoryType:self.canEdit==YES?UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryNone];
    [cell setUserInteractionEnabled:self.canEdit];
    
    if (kDeviceVersion >= 7.0) {
       [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    
    if (indexPath.section == 0) {
      static NSString *headCellIdentifier = @"SetProfileHeadCell";
      SetProfileHeadTableCell *headCell = [[[SetProfileHeadTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headCellIdentifier] autorelease];
        [headCell setUserInteractionEnabled:self.canEdit];
        [headCell setTag:77007];
        [headCell setAccessoryType:UITableViewCellAccessoryNone];
        if (self.canEdit) {
            [headCell.titleLabel setHidden:NO];
            [headCell.titleLabel setText:@"头像"];
            [headCell.nameLabel setHidden:YES];
            [headCell.sexLabel setHidden:YES];
            [headCell.ageLable setHidden:YES];
//            [headCell.realAuthImageView setHidden:YES];
//            [headCell.weiboImageView setHidden:YES];
//            [headCell.emailImageView setHidden:YES];
//            [headCell.carImageView setHidden:YES];

            [headCell.photoImgView setHidden:NO];
            [headCell.photoImgView setFrame:CGRectMake(320-9-92, 9, 92, 92)];
        }
        else
        {
            [headCell.nameLabel setHidden:NO];
            [headCell.sexLabel setHidden:NO];
            [headCell.ageLable setHidden:NO];
//            [headCell.realAuthImageView setHidden:NO];
//            [headCell.weiboImageView setHidden:NO];
//            [headCell.emailImageView setHidden:NO];
//            [headCell.carImageView setHidden:NO];
            [headCell.titleLabel setHidden:YES];
            
            [headCell.nameLabel setText:self.userInfo.name];
            [headCell.sexLabel setText:self.userInfo.sex];
            [headCell.ageLable setText:[NSString stringWithFormat:@"%d",self.userInfo.age]];
//            if (self.userInfo.realName && [self.userInfo.realName isEqualToString:@""]) {
//                headCell.realAuthImageView.alpha = 0.3;
//            }
//            else
//            {
//                headCell.realAuthImageView.alpha = 1.0;
//            }
            //参数不齐全
//            if (self.userInfo.realName && [self.userInfo.realName isEqualToString:@""]) {
//                headCell.weiboImageView.alpha = 0.3;
//            }
//            else
//            {
//                headCell.weiboImageView.alpha = 1.0;
//            }
//            
//            if (self.userInfo.realName && [self.userInfo.realName isEqualToString:@""]) {
//                headCell.emailImageView.alpha = 0.3;
//            }
//            else
//            {
//                headCell.emailImageView.alpha = 1.0;
//            }
//            
//            if (self.userInfo.realName && [self.userInfo.realName isEqualToString:@""]) {
//                headCell.carImageView.alpha = 0.3;
//            }
//            else
//            {
//                headCell.carImageView.alpha = 1.0;
//            }
            
            [headCell.photoImgView setHidden:NO];
            [headCell.photoImgView setFrame:CGRectMake(9, 9, 92, 92)];
        }
        
        if (self.userInfo.name && ![self.userInfo.name isEqualToString:@""]) {
            [headCell.photoImgView setImageWithURL:[NSURL URLWithString:self.userInfo.headpic] placeholderImage:[UIImage imageNamed:@"delt_camera"]];
        }
        else
        {
            [headCell.photoImgView setImage:[UIImage imageNamed:@"delt_camera"]];
        }
        
        if (self.headImage) {
            [headCell.photoImgView setImage:self.headImage];
        }
        
        return headCell;
    }
    
    
    if (indexPath.section == 1) {
        
        [cell.photoImgView setHidden:YES];
        [cell.titleLabel setHidden:NO];
        [cell.infoLabel setHidden:NO];
        [cell.arrowImgView setHidden:YES];
        
        if (self.canEdit) {

            if (indexPath.row == 0) {
                [cell.titleLabel setText:@"昵称"];
                if (self.userInfo.name && ![self.userInfo.name isEqualToString:@""]) {
                    [cell.infoLabel setTextColor:[UIColor blackColor]];
                    [cell.infoLabel setText:self.userInfo.name];
                }
                else
                {
                    [cell.infoLabel setTextColor:[UIColor lightGrayColor]];
                    [cell.infoLabel setText:@"未设置"];
                }
            }
            
            if (indexPath.row == 1) {
                [cell.titleLabel setText:@"性别"];
                if (self.userInfo.sex && ![self.userInfo.sex isEqualToString:@""]) {
                    [cell.infoLabel setTextColor:[UIColor blackColor]];
                    [cell.infoLabel setText:self.userInfo.sex];
                }
                else
                {
                    [cell.infoLabel setTextColor:[UIColor lightGrayColor]];
                    [cell.infoLabel setText:@"未设置"];
                }
            }
            
            if (indexPath.row == 2) {
                [cell.titleLabel setText:@"年龄"];
                
                if (self.userInfo.age > 0) {
                    [cell.infoLabel setTextColor:[UIColor blackColor]];
                    [cell.infoLabel setText:[NSString stringWithFormat:@"%d",self.userInfo.age] ];
                }
                else
                {
                    [cell.infoLabel setTextColor:[UIColor lightGrayColor]];
                    [cell.infoLabel setText:@"未设置"];
                }
            }
        }
        
        if (indexPath.row == (self.canEdit==YES?3:0)) {
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [cell.titleLabel setText:@"手机号码"];
            cell.infoLabel.text = self.userInfo.phone;
            [cell.infoLabel setTextColor:[UIColor blackColor]];
            
            CGSize mLblHieht = [cell.infoLabel.text sizeWithFont:[UIFont fontWithName:@"FZY3JW--GB1-0" size:16] constrainedToSize:CGSizeMake(220, 30) lineBreakMode:NSLineBreakByCharWrapping];
            
            [cell.arrowImgView setHidden:NO];
            [cell.arrowImgView setFrame:CGRectMake(mLblHieht.width + 120, 19, 12, 12)];
        }
        /*
        //暂无设置
        if (indexPath.row == (self.canEdit==YES?4:1)) {
            
            [cell.titleLabel setText:@"实名认证"];
            
            [cell.infoLabel setTextColor:[UIColor lightGrayColor]];
            [cell.infoLabel setText:self.canEdit==YES?@"进行实名认证":@"未认证"];
            
//            CGSize mLblHieht = [cell.infoLabel.text sizeWithFont:[UIFont fontWithName:@"FZY3JW--GB1-0" size:16] constrainedToSize:CGSizeMake(220, 30) lineBreakMode:NSLineBreakByCharWrapping];
//            
//            [cell.arrowImgView setHidden:NO];
//            [cell.arrowImgView setFrame:CGRectMake(mLblHieht.width + 120, 19, 12, 12)];
        }*/
        /*
        //暂无设置
        if (indexPath.row == (self.canEdit==YES?5:2)) {
            
            [cell.titleLabel setText:@"车辆信息"];
            
            [cell.infoLabel setTextColor:[UIColor lightGrayColor]];
            [cell.infoLabel setText:self.canEdit==YES?@"搭车无需进行填写":@"未设置"];
        }*/
        
//        if (indexPath.row == (self.canEdit==YES?6:3)) {
        if (indexPath.row == (self.canEdit==YES?4:1)) {

            [cell.titleLabel setText:@"公司地址"];
            
            NSString * company = self.userInfo.detail.comp_addr;
            
            if ([company isEqualToString:@""] || company.length ==0) {
                [cell.infoLabel setTextColor:[UIColor lightGrayColor]];
                [cell.infoLabel setText:self.canEdit==YES?@"添加公司地址":@"未设置"];
            }
            else
            {
                [cell.infoLabel setTextColor:[UIColor blackColor]];
                [cell.infoLabel setText:company];
            }
        }
        
//        if (indexPath.row == (self.canEdit==YES?7:4)) {
        if (indexPath.row == (self.canEdit==YES?5:2)) {
            [cell.titleLabel setText:@"家庭地址"];
            
            NSString * home = self.userInfo.detail.home_addr;
            
            if ([home isEqualToString:@""] || home.length ==0) {
                [cell.infoLabel setTextColor:[UIColor lightGrayColor]];
                [cell.infoLabel setText:self.canEdit==YES?@"添加家庭地址":@"未设置"];
            }
            else
            {
                [cell.infoLabel setTextColor:[UIColor blackColor]];
                [cell.infoLabel setText:home];
            }
        }
        
        /*
        //暂无设置
        if (indexPath.row == (self.canEdit==YES?8:5)) {
            
            [cell.titleLabel setText:@"新浪微博账号"];
            [cell.infoLabel setTextColor:[UIColor lightGrayColor]];
            [cell.infoLabel setText:self.canEdit==YES?@"点击添加微博账号绑定":@"未绑定"];

//            CGSize mLblHieht = [cell.infoLabel.text sizeWithFont:[UIFont fontWithName:@"FZY3JW--GB1-0" size:16] constrainedToSize:CGSizeMake(220, 30) lineBreakMode:NSLineBreakByCharWrapping];
//            
//            [cell.arrowImgView setHidden:NO];
//            [cell.arrowImgView setFrame:CGRectMake(mLblHieht.width + 120, 19, 12, 12)];
        }
         */
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        [self choosePhoto];
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            [self changeNickName];
        }
        if (indexPath.row == 1) {
            [self showGenderActionSheet];
        }
        if (indexPath.row == 2) {
            [self changeAge];
        }
        
        if (indexPath.row == 3) {
            [self changePhoneNum];
        }
        
//        if (indexPath.row == 6) {
//            [self changeCompanyAddrress];
//        }
//        if (indexPath.row == 7) {
//            [self changeHomeAddress];
//        }
//        if (indexPath.row == 8) {
//            [self showWeiboAccess];
//        }
        
        if (indexPath.row == 4) {
            [self changeCompanyAddrress];
        }
        
        if (indexPath.row == 5) {
            [self changeHomeAddress];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 110;
    }
    if (indexPath.section == 1) {
        return 45;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 10;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
        [headerView setBackgroundColor:[UIColor clearColor]];
        return headerView;
    }
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        if (self.canEdit) {
//            return 9;
            return 6;
        }
        else
        {
//            return 6;
            return 3;
        }
    }
    return 0;
}


#pragma mark - imagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }];
    UIImage *image = [[info objectForKey:UIImagePickerControllerEditedImage] retain];
    [self performSelector:@selector(saveImage:)
               withObject:image
               afterDelay:0.5];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }];
}



#pragma mark - pickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.ageArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * ageee = [self.ageArray objectAtIndex:row];
    return ageee;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _ageIndex = row;
}

#pragma mark - scrollViewdelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (self.pickerConstionView.frame.origin.y - SCREEN_HEIGHT-50) {
//        [self hideAgePickerView];
//    }
}

#pragma mark - TextViewdelegate


#pragma mark - AlertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 50008) {
        
        if (buttonIndex == 0) {
            DLog(@"取消");
        }
        if (buttonIndex == 1) {
            DLog(@"拍照");
            [self showImagePickerWithStyle:0];
        }
        if (buttonIndex == 2) {
            DLog(@"相册");
            [self showImagePickerWithStyle:1];
        }
    }
    if (alertView.tag == 111) {
        if (buttonIndex == 1) {
            [self queueNetWork];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - actionDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        DLog(@"--");
        [self saveSex:@"男"];
    }
    if (buttonIndex == 1) {
        DLog(@"^^");
       [self saveSex:@"女"];
    }
}

#pragma mark - customAction

-(void)choosePhoto
{

    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"选择上传头像方式" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择",nil];
    [alert setTag:50008];
    [alert show];
    [alert release];

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

//保存头像
-(void)saveImage:(UIImage *)image
{
    DLog(@"已选择头像");
    SetProfileTableCell * cell = (SetProfileTableCell *)[self.view viewWithTag:77007];
    [cell.photoImgView setImage:image];
    self.headImage  = image;
    User * user = [User shareInstance];
    //保存请求
    ASIFormDataRequest * editPhotoRequest =  [NetWorkManager networkEditHeadpic:image uid:user.userId mode:kNetworkrequestModeQueue success:^(BOOL flag, NSString *newHeadPicUrl, NSString *msg) {
//        if (flag) {
//            [cell.photoImgView setImage:image];
//        }
//        else
//        {
//            [UIAlertView showAlertViewWithTitle:@"失败" message:msg cancelTitle:@"确定"];
//        }
    } failure:^(NSError *error) {}];
    [self.networkRequestArray addObject:editPhotoRequest];
//    [editPhotoRequest release];
    [_setProfileTable reloadData];
    
}
-(void)changeNickName
{
    ChangerNameViewController *changeNickNameVC = [[ChangerNameViewController alloc]init];
    changeNickNameVC.delegate = self;
    [self.navigationController pushViewController:changeNickNameVC animated:YES];
    [changeNickNameVC release];
}

-(void)saveNickName:(NSString *)name
{
    [self.userInfo setUserName:name];
    
    //保存请求
    ASIFormDataRequest * saveNickName = [NetWorkManager networkEditUserNameWithuid:[User shareInstance].userId username:name mode:kNetworkrequestModeQueue success:^(BOOL flag) {} failure:^(NSError *error) {}];
    [self.networkRequestArray addObject:saveNickName];
    
    [_setProfileTable reloadData];

}

//修改手机号
-(void)changePhoneNum
{
    ChangerPhoneViewController *changePhoneNumVC = [[ChangerPhoneViewController alloc]init];
    changePhoneNumVC.delegate = self;
    [self.navigationController pushViewController:changePhoneNumVC animated:YES];
    [changePhoneNumVC release];
}

-(void)savePhoneNum:(NSString *)phonenum
{
    [self.userInfo setPhone:phonenum];
    
     [_setProfileTable reloadData];
    
//    User * user = [User shareInstance];
//    //保存请求
//    ASIFormDataRequest * editPhotoRequest =  [NetWorkManager networkEditHeadpic:image uid:user.userId mode:kNetworkrequestModeQueue success:^(BOOL flag, NSString *newHeadPicUrl, NSString *msg) {

//    } failure:^(NSError *error) {}];
//    [self.networkRequestArray addObject:editPhotoRequest];
    //    [editPhotoRequest release];
    [_setProfileTable reloadData];
}

//实名认证
-(void)RealNameAuthentication
{
    
}

//修改公司地址
-(void)changeCompanyAddrress
{
    ProfileCompanyAddressViewController * companyVC = [[[ProfileCompanyAddressViewController alloc]init]autorelease];
    companyVC.delegate =self;
    [self.navigationController pushViewController:companyVC animated:YES];
//    [companyVC release];
}

//修改家庭地址
-(void)changeHomeAddress
{
    ProfileHomeAddressViewController * homeVC = [[[ProfileHomeAddressViewController alloc]init]autorelease];
    homeVC.delegate =self;
    [self.navigationController pushViewController:homeVC animated:YES];
//    [homeVC release];
}

-(void)saveCompanyAddrress:(NSString *)address
{
    [self.userInfo setCompanyaddress:address];
    //保存请求
    ASIFormDataRequest * saveCompanyAddress = [NetWorkManager networkEditcompanyaddressWithuid:[User shareInstance].userId companyaddress:address mode:kNetworkrequestModeQueue success:^(BOOL flag) {

    } failure:^(NSError *error) {
        
    }];
    [self.networkRequestArray addObject:saveCompanyAddress];
    [_setProfileTable reloadData];
    
}

-(void)saveHomeAddress:(NSString *)address
{
    [self.userInfo setHomeaddress:address];
    //保存请求
    ASIFormDataRequest * savehomeAddress = [NetWorkManager networkEdithomeaddressWithuid:[User shareInstance].userId homeaddress:address mode:kNetworkrequestModeQueue success:^(BOOL flag) {
        
    } failure:^(NSError *error) {
        
    }];
    [self.networkRequestArray addObject:savehomeAddress];
    [_setProfileTable reloadData];
}

-(void)showWeiboAccess
{
    WeiBoAccessViewController * weiboVC = [[[WeiBoAccessViewController alloc]init]autorelease];
    [self presentViewController:weiboVC animated:YES completion:nil];
}

-(void)showGenderActionSheet
{
    UIActionSheet * genderAction = [[UIActionSheet alloc]initWithTitle:@"选择您的性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",nil];
    [genderAction showInView:self.view];
}

-(void)saveSex:(NSString *)sex
{
    //保存请求
    ASIFormDataRequest * saveSex= [NetWorkManager networkEditSexWithuid:[User shareInstance].userId sex:sex mode:kNetworkrequestModeQueue success:^(BOOL flag) {
        
    } failure:^(NSError *error) {
        
    }];
    
    [self.networkRequestArray addObject:saveSex];
    [self.userInfo setSex:sex];
    [_setProfileTable reloadData];
}

-(void)changeAge
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];//动画时间长度，单位秒，浮点数
    self.pickerConstionView .frame = CGRectMake(0.0, SCREEN_HEIGHT - 255, 320.0, 255.0);
    [UIView commitAnimations];
}

-(void)saveAge
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];//动画时间长度，单位秒，浮点数
    self.pickerConstionView.frame = CGRectMake(0.0, SCREEN_HEIGHT, 320.0, 255.0);
    [UIView commitAnimations];
    
    //保存请求
    ASIFormDataRequest * saveAge = [NetWorkManager networkEditAgeWithuid:[User shareInstance].userId age:[[self.ageArray objectAtIndex:_ageIndex] intValue] mode:kNetworkrequestModeQueue success:^(BOOL flag) {
        
    } failure:^(NSError *error) {
        
    }];
    [self.networkRequestArray addObject:saveAge];
    
    [self.userInfo setAge:[[self.ageArray objectAtIndex:_ageIndex] intValue]];
    [_setProfileTable reloadData];
}

-(void)backToMain
{
    if ([self.networkRequestArray count]>0) {
        //保存
        [self saveAtion:nil];
    }
    else
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveAtion:(UIButton *)button
{
    button.selected = !button.selected;
    self.canEdit = button.selected;
    [_setProfileTable reloadData];
    if (button.selected) {

    }
    else
    {
        //保存
        [UIAlertView showAlertViewWithTitle:@"信息有改动，是否保存？" tag:111 cancelTitle:@"不保存" ensureTitle:@"保存" delegate:self];
    }
}

-(void)queueNetWork
{
    [SVProgressHUD show];
    if([self.networkRequestArray count]>0)
    {
        [NetWorkManager networkQueueWork:self.networkRequestArray withDelegate:self asiHttpSuccess:@selector(requestDidSuccess:) asiHttpFailure:@selector(requestDidFailed:) queueSuccess:@selector(queueDidFinish:)];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"更新成功"];
    }
}

-(void)requestDidSuccess:(ASIFormDataRequest *)request
{
    DLog(@"Tag:%d,%@",request.tag,request.responseString);
}

-(void)requestDidFailed:(ASIFormDataRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"更新失败"];
}

-(void)queueDidFinish:(ASINetworkQueue *)queue
{
    [SVProgressHUD showSuccessWithStatus:@"更新成功"];
    [self performSelector:@selector(getUserInfo) withObject:nil afterDelay:0.3];
    [queue reset];
    [self.networkRequestArray removeAllObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
