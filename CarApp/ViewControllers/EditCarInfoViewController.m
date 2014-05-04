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
#import "UIImage+Compress.h"

@interface EditCarInfoViewController ()

@property (copy, nonatomic) NSString *imageUrl1;         //上传取到的图片路径
@property (copy, nonatomic)NSString *imagePath1;         //上传的图片路径
@property (copy, nonatomic) NSString *imageUrl2;         //上传取到的图片路径
@property (copy, nonatomic)NSString *imagePath2;         //上传的图片路径
@property (copy, nonatomic) NSString *imageUrl3;         //上传取到的图片路径
@property (copy, nonatomic)NSString *imagePath3;         //上传的图片路径

@property (assign, nonatomic) int status; //0:没有操作  1：上传驾照 2:上传正面照片 3：上传侧面照

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
    
    [self setTitle:@"编辑车辆信息"];
    [self setMessageText:@"请拍摄行驶本和汽车照片完成认证"];
    [self setStatus:0];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KOFFSETY, APPLICATION_WIDTH, APPLICATION_HEGHT - KOFFSETY)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setScrollEnabled:YES];
    [_scrollView setAlwaysBounceVertical:YES];
    [self.view addSubview:_scrollView];
    
    CGRect bound = _scrollView.bounds;
    
    UIImageView * _bg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, bound.size.width - 20, 65)]; //线框背景
    [_bg setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin];
    [_bg.layer setCornerRadius:2.0];
    [_bg.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_bg.layer setBorderWidth:0.5];
    [_scrollView addSubview:_bg];
    
    _carLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (_bg.bounds.size.height-50)/2.0, 50.0, 50.0)]; //车辆标志
    [_carLogoImageView setBackgroundColor:[UIColor lightGrayColor]];
    [_carLogoImageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin];
    [_carLogoImageView setImageWithURL:[NSURL URLWithString:self.carType.picture] placeholderImage:[UIImage imageNamed:@"delt_pic_s"]];
    [_bg addSubview:_carLogoImageView];
    
    _carName = [[UILabel alloc]initWithFrame:CGRectMake(70, 12.5, 100, 20)]; //车辆名字
    [_carName setBackgroundColor:[UIColor clearColor]];
    [_carName setTextColor:[UIColor darkGrayColor]];
    [_carName setText:self.carType.brand]; //品牌
    [_carName setFont:AppFont(13)];
    [_bg addSubview:_carName];
    
    _carModel = [[UILabel alloc]initWithFrame:CGRectMake(70, 32.5, 100, 20)]; //车辆型号
    [_carModel setBackgroundColor:[UIColor clearColor]];
    [_carModel setTextColor:[UIColor blackColor]];
    [_carModel setText:self.carType.name];       //型号
    [_carModel setFont:AppFont(13)];
    [_bg addSubview:_carModel];
    
    _carBookbg = [[UIView alloc]initWithFrame:CGRectMake(10, 85, bound.size.width-20, 200)];
    [_carBookbg.layer setCornerRadius:2.0];
    [_carBookbg.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_carBookbg.layer setBorderWidth:0.5];
    [_scrollView addSubview:_carBookbg];
    
    _carBookImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bound.size.width-20, 200)];
    [_carBookImageView.layer setCornerRadius:2.0];
    [_carBookImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_carBookImageView.layer setBorderWidth:0.5];
    [_carBookImageView.layer setMasksToBounds:YES];
    [_carBookImageView setBackgroundColor:[UIColor whiteColor]];
    [_carBookImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_carBookbg addSubview:_carBookImageView];
    [_carBookImageView setHidden:YES];
    
    UIImageView *carbookImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 213.0/2.0, 134.0/2.0)];
    [carbookImage setCenter:CGPointMake(_carBookbg.bounds.size.width/2, _carBookbg.bounds.size.height/2 - 25)];
    [carbookImage setImage:[UIImage imageNamed:@"ic_paperwork"]];
    [_carBookbg addSubview:carbookImage];
    
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
    [_addcarFrontBtn setBackgroundColor:[UIColor clearColor]];
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
    [_carFrontImageView setBackgroundColor:[UIColor whiteColor]];
    [_carFrontImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_scrollView insertSubview:_carFrontImageView belowSubview:_addcarFrontBtn];
    [_carFrontImageView setHidden:YES];
    
    _addcarSliderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addcarSliderBtn setBackgroundColor:[UIColor clearColor]];
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
    [_carSliderImageView setBackgroundColor:[UIColor whiteColor]];
    [_carSliderImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_scrollView insertSubview:_carSliderImageView belowSubview:_addcarSliderBtn];
    [_carSliderImageView setHidden:YES];
    
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
}

- (void)addcarFrontBtn:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看照片样例",@"拍摄照片",@"从相册中选择照片", nil];
    [alertView setTag:111];
    [alertView show];
}

- (void)addcarSliderBtn:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看照片样例",@"拍摄照片",@"从相册中选择照片", nil];
    [alertView setTag:112];
    [alertView show];
}
//提交
- (void)confirmBtnAction:(UIButton *)sender
{
    DLog(@"提交");
     MBProgressHUD *hubView = [MBProgressHUD showMessag:@"正在上传" toView:self.view];
    [APIClient networkUpLoadImageFileByType:1 user_id:[User shareInstance].userId dataFile:[NSArray arrayWithObjects:self.imagePath1,self.imagePath2,self.imagePath3,nil] success:^(Respone *respone) {
        DLog(@"%@",[respone description]);
        if (respone.status == kEnumServerStateSuccess) {
            [hubView setLabelText:@"上传成功"];
            self.imageUrl1 = [respone.data valueForKey:@"file_0"];
            self.imageUrl2 = [respone.data valueForKey:@"file_1"];
            self.imageUrl3 = [respone.data valueForKey:@"file_2"];
            //获取增加车辆
            [APIClient networkAddCarWithid:self.carType.ID license:self.imageUrl1 cars_1:self.imageUrl2 cars_2:self.imageUrl3 success:^(Respone *respone)
            {
                if (respone.status == kEnumServerStateSuccess) {
                    [self popToProfileViewController];
                }
                [hubView setLabelText:respone.msg];
                [hubView hide:YES afterDelay:1.0];
            } failure:^(NSError *error) {
                [hubView setLabelText:respone.msg];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            DLog(@"查看照片样例");
            CarImageSampleViewController *carImageSampleVC = [[CarImageSampleViewController alloc]init];
            [self.navigationController pushViewController:carImageSampleVC animated:YES];
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

- (void)updateView:(NSData *)imageData
{
    //更新显示
    if (self.status == 1) {
        [_carBookImageView setImage:[UIImage imageWithData:imageData]];
        [_carBookImageView setHidden:NO];
    }
    if (self.status == 2) {
       [_carFrontImageView setImage:[UIImage imageWithData:imageData]];
        [_carFrontImageView setHidden:NO];
    }
    if (self.status == 3) {
        [_carSliderImageView setImage:[UIImage imageWithData:imageData]];
        [_carSliderImageView setHidden:NO];
    }
    if (self.imagePath1 && self.imagePath2 && self.imagePath3) {
        [_confirmBtn setEnabled:YES];
    }
    else
    {
        [_confirmBtn setEnabled:NO];
    }

}

- (void)uploadImage:(int)tag
{
    switch (tag) {
        case 110:
        {
            DLog(@"上传驾照");
            [self setStatus:1];
        }
            break;
        case 111:
        {
            DLog(@"上传正面车照");
            [self setStatus:2];
        }
            break;
        case 112:
        {
            DLog(@"上传侧面车照");
            [self setStatus:3];
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
        [PhotoSelectManager selectPhotoFromCamreWithDelegate:self withVC:self withEdit:NO];
    }
    
    //选择相册
    if (style == 1) {
        [PhotoSelectManager selectPhotoFromPhotoWithDelegate:self withVC:self withEdit:NO];
    }
}

#pragma mark - imagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self performSelector:@selector(saveImage:)
               withObject:image
               afterDelay:0.0];
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
    
    NSData  *imageData = [image compressedDataSize:2*1024];

    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = nil;
    
    switch (self.status) {
        case 1:
        {
            fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"book01.png"];
            self.imagePath1 = fullPathToFile;
        }
            break;
        case 2:
        {
            fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"car02.png"];
            self.imagePath2 = fullPathToFile;
        }
            break;
        case 3:
        {
            fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"car03.png"];
            self.imagePath3 = fullPathToFile;
        }
            break;
        default:
            break;
    }
    
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:YES];
    
    [self updateView:imageData];
}

- (void)popToProfileViewController
{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:NSClassFromString(@"ProfileViewController")]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
