//
//  EditCarInfoViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-13.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "EditCarInfoViewController.h"
#import "PhotoSelectManager.h"
#import "CarImageSampleViewController.h"

@interface EditCarInfoViewController ()

@end

@implementation EditCarInfoViewController

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
    
    [self setCtitle:@"编辑车辆信息"];
    [self setDesText:@"请拍摄行驶本和汽车照片完成认证"];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KOFFSETY, SCREEN_WIDTH, SCREEN_HEIGHT - KOFFSETY)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setScrollEnabled:YES];
    [_scrollView setAlwaysBounceVertical:YES];
    [self.view addSubview:_scrollView];
    [_scrollView release];
    
    CGRect bound = _scrollView.bounds;
    
    UIImageView * _bg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, bound.size.width - 20, 65)]; //线框背景
    [_bg setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin];
    [_bg.layer setCornerRadius:2.0];
    [_bg.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_bg.layer setBorderWidth:0.5];
    [_scrollView addSubview:_bg];
    [_bg release];
    
    _carLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (_bg.bounds.size.height-50)/2.0, 50.0, 50.0)]; //车辆标志
    [_carLogoImageView setBackgroundColor:[UIColor lightGrayColor]];
    [_carLogoImageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin];
    [_bg addSubview:_carLogoImageView];
    [_carLogoImageView release];
    
    _carName = [[UILabel alloc]initWithFrame:CGRectMake(70, 12.5, 100, 20)]; //车辆名字
    [_carName setBackgroundColor:[UIColor clearColor]];
    [_carName setTextColor:[UIColor darkGrayColor]];
    [_carName setText:@"宝马"];
    [_carName setFont:AppFont(13)];
    [_bg addSubview:_carName];
    [_carName release];
    
    _carModel = [[UILabel alloc]initWithFrame:CGRectMake(70, 32.5, 100, 20)]; //车辆型号
    [_carModel setBackgroundColor:[UIColor clearColor]];
    [_carModel setTextColor:[UIColor blackColor]];
    [_carModel setText:@"320Li"];
    [_carModel setFont:AppFont(13)];
    [_bg addSubview:_carModel];
    [_carModel release];
    
    _carBookbg = [[UIView alloc]initWithFrame:CGRectMake(10, 85, bound.size.width-20, 200)];
    [_carBookbg.layer setCornerRadius:2.0];
    [_carBookbg.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_carBookbg.layer setBorderWidth:0.5];
    [_scrollView addSubview:_carBookbg];
    [_carBookbg release];
    
    _carBookImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 85, bound.size.width-20, 200)];
    [_carBookImageView.layer setCornerRadius:2.0];
    [_carBookImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_carBookImageView.layer setBorderWidth:0.5];
    [_carBookImageView.layer setMasksToBounds:YES];
    [_carBookImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_scrollView addSubview:_carBookImageView];
    [_carBookImageView setHidden:YES];
    [_carBookImageView release];
    
    UIImageView *carbookImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 213.0/2.0, 134.0/2.0)];
    [carbookImage setCenter:CGPointMake(_carBookbg.bounds.size.width/2, _carBookbg.bounds.size.height/2 - 25)];
    [carbookImage setImage:[UIImage imageNamed:@"ic_paperwork"]];
    [_carBookbg addSubview:carbookImage];
    [carbookImage release];
    
    UIButton *addcarbookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addcarbookBtn setFrame:CGRectMake(0, 0, 220, 40)];
    [addcarbookBtn setCenter:CGPointMake(_carBookbg.bounds.size.width/2, _carBookbg.bounds.size.height/2 + 50)];
    [addcarbookBtn setBackgroundImage:[UIImage imageNamed:@"btn_paperwork_normal"] forState:UIControlStateNormal];
    [addcarbookBtn setBackgroundImage:[UIImage imageNamed:@"btn_paperwork_pressed"] forState:UIControlStateHighlighted];
    [addcarbookBtn.titleLabel setFont:AppFont(14)];
    [addcarbookBtn setTitle:@"拍摄或上传行驶本照片" forState:UIControlStateNormal];
    [addcarbookBtn addTarget:self action:@selector(addcarbookBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_carBookbg addSubview:addcarbookBtn];
    
    _addcarFrontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addcarFrontBtn setBackgroundColor:[UIColor whiteColor]];
    [_addcarFrontBtn setFrame:CGRectMake(10, 295.0, 290/2.0, 190/2.0)];
    [_addcarFrontBtn.layer setCornerRadius:2.0];
    [_addcarFrontBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_addcarFrontBtn.layer setBorderWidth:0.5];
    [_addcarFrontBtn setImage:[UIImage imageNamed:@"btn_car_positive_normal"] forState:UIControlStateNormal];
    [_addcarFrontBtn setImage:[UIImage imageNamed:@"btn_car_positive_pressed"] forState:UIControlStateHighlighted];
    [_addcarFrontBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addcarFrontBtn setImageEdgeInsets:UIEdgeInsetsMake(-35, 35, 0.0, -35)];
    [_addcarFrontBtn setTitleEdgeInsets:UIEdgeInsetsMake(40, -40, 0.0, 20)];
    [_addcarFrontBtn.titleLabel setFont:AppFont(14)];
    [_addcarFrontBtn setTitle:@"上传正面车照" forState:UIControlStateNormal];
    [_addcarFrontBtn addTarget:self action:@selector(addcarFrontBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_addcarFrontBtn];
    
    _carFrontImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 295.0, 290/2.0, 190/2.0)];
    [_carFrontImageView.layer setCornerRadius:2.0];
    [_carFrontImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_carFrontImageView.layer setBorderWidth:0.5];
    [_carFrontImageView.layer setMasksToBounds:YES];
    [_carFrontImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_scrollView addSubview:_carFrontImageView];
    [_carFrontImageView setHidden:YES];
    [_carFrontImageView release];
    
    _addcarSliderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addcarSliderBtn setBackgroundColor:[UIColor whiteColor]];
    [_addcarSliderBtn setFrame:CGRectMake(20+290.0/2.0, 295, 290/2.0, 190.0/2.0)];
    [_addcarSliderBtn.layer setCornerRadius:2.0];
    [_addcarSliderBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_addcarSliderBtn.layer setBorderWidth:0.5];
    [_addcarSliderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addcarSliderBtn setImage:[UIImage imageNamed:@"btn_car_side_normal"] forState:UIControlStateNormal];
    [_addcarSliderBtn setImage:[UIImage imageNamed:@"btn_car_side_pressed"] forState:UIControlStateHighlighted];
    [_addcarSliderBtn setImageEdgeInsets:UIEdgeInsetsMake(-35, 35, 0.0, -35)];
    [_addcarSliderBtn setTitleEdgeInsets:UIEdgeInsetsMake(40, -40, 0.0, 20)];
    [_addcarSliderBtn.titleLabel setFont:AppFont(14)];
    [_addcarSliderBtn setTitle:@"上传侧面车照" forState:UIControlStateNormal];
    [_addcarSliderBtn addTarget:self action:@selector(addcarSliderBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_addcarSliderBtn];
    
    _carSliderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20+290.0/2.0, 295, 290/2.0, 190.0/2.0)];
    [_carSliderImageView.layer setCornerRadius:2.0];
    [_carSliderImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_carSliderImageView.layer setBorderWidth:0.5];
    [_carSliderImageView.layer setMasksToBounds:YES];
    [_carSliderImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_scrollView addSubview:_carSliderImageView];
    [_carSliderImageView setHidden:YES];
    [_carSliderImageView release];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setFrame:CGRectMake(10, 295+ 10 + 95, 300, 44)];
    [_confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_confirmBtn.titleLabel setFont:AppFont(12)];
    [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_submit_empty"] forState:UIControlStateDisabled];
    [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_add_car_normal"] forState:UIControlStateNormal];
    [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_add_car_pressed"] forState:UIControlStateSelected];
    [_confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn setEnabled:NO];
    [_scrollView addSubview:_confirmBtn];
    
    [_scrollView setContentSize:CGSizeMake(bound.size.width, 295+ 10 + 95 + 44 +10)];
}

- (void)addcarbookBtn:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看照片样例",@"拍摄照片",@"从相册中选择照片", nil];
    [alertView setTag:110];
    [alertView show];
    [alertView release];
}

- (void)addcarFrontBtn:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看照片样例",@"拍摄照片",@"从相册中选择照片", nil];
    [alertView setTag:111];
    [alertView show];
    [alertView release];
}

- (void)addcarSliderBtn:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看照片样例",@"拍摄照片",@"从相册中选择照片", nil];
    [alertView setTag:112];
    [alertView show];
    [alertView release];
}

- (void)confirmBtnAction:(UIButton *)sender
{
    DLog(@"提交")
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            DLog(@"查看照片样例");
            CarImageSampleViewController *carImageSampleVC = [[CarImageSampleViewController alloc]init];
            [self.navigationController pushViewController:carImageSampleVC animated:YES];
            [carImageSampleVC release];
        }
            break;
        case 2:
        {
            [self uploadImage:alertView.tag];
            [self showImagePickerWithStyle:0];
        }
            break;
        case 3:
        {
            [self uploadImage:alertView.tag];
            [self showImagePickerWithStyle:1];
        }
            break;
        default:
            break;
    }
}

- (void)uploadImage:(int)tag
{
    switch (tag) {
        case 110:
        {
            DLog(@"上传驾照");
        }
            break;
        case 111:
        {
            DLog(@"上传正面车照");
        }
            break;
        case 112:
        {
            DLog(@"上传侧面车照");
        }
            break;
        default:
            break;
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

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];

}

-(void)saveImage:(UIImage *)image
{
    DLog(@"已选择头像");
    
    NSData* imageData = UIImagePNGRepresentation(image);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"img00.png"];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
    [[User shareInstance]setUserId:1];
    
    [APIClient networkUpLoadImageFileByType:1 user_id:[User shareInstance].userId dataFile:[NSArray arrayWithObject:fullPathToFile] success:^(Respone *respone) {
        DLog(@"%@",[respone description]);
    } failure:^(NSError *error) {
        
    }];
//
//    
//    SetProfileTableCell * cell = (SetProfileTableCell *)[self.view viewWithTag:77007];
//    [cell.photoImgView setImage:image];
//    self.headImage  = image;
//    User * user = [User shareInstance];
//    //保存请求
//    ASIFormDataRequest * editPhotoRequest =  [NetWorkManager networkEditHeadpic:image uid:user.userId mode:kNetworkrequestModeQueue success:^(BOOL flag, NSString *newHeadPicUrl, NSString *msg) {
//        //        if (flag) {
//        //            [cell.photoImgView setImage:image];
//        //        }
//        //        else
//        //        {
//        //            [UIAlertView showAlertViewWithTitle:@"失败" message:msg cancelTitle:@"确定"];
//        //        }
//    } failure:^(NSError *error) {}];
//    [self.networkRequestArray addObject:editPhotoRequest];
//    //    [editPhotoRequest release];
//    [_setProfileTable reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
