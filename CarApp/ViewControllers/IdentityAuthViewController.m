//
//  IdentityAuthViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-6.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "IdentityAuthViewController.h"
#import "MBProgressHUD+Add.h"
#import "PhotoSelectManager.h"
#import "UIImage+Compress.h"

@interface IdentityAuthViewController ()

@property (copy, nonatomic) NSString *imageUrl;         //上传取到的图片路径
@property (copy, nonatomic)NSString *imagePath;         //上传的图片路径

@end

@implementation IdentityAuthViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self setTitle:@"实名认证"];
    [self setMessageText:@"请按照以下样例拍摄或上传本人手持身份证的清晰照片"];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KOFFSETY, SCREEN_WIDTH, SCREEN_HEIGHT - KOFFSETY)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setScrollEnabled:YES];
    [_scrollView setAlwaysBounceVertical:YES];
    [self.view addSubview:_scrollView];
    
    CGRect bound = _scrollView.bounds;

    _peopleSampleBookImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, bound.size.width-40, 180)];
    [_peopleSampleBookImageView.layer setCornerRadius:2.0];
    [_peopleSampleBookImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_peopleSampleBookImageView.layer setBorderWidth:0.5];
    [_peopleSampleBookImageView.layer setMasksToBounds:YES];
    [_peopleSampleBookImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_scrollView addSubview:_peopleSampleBookImageView];
    
    _peopleBookbg = [[UIView alloc]initWithFrame:CGRectMake(20, 200, bound.size.width-40, 180)];
    [_peopleBookbg.layer setCornerRadius:2.0];
    [_peopleBookbg.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_peopleBookbg.layer setBorderWidth:0.5];
    [_scrollView addSubview:_peopleBookbg];
    
    _peopleBookImageView = [[UIImageView alloc]initWithFrame:_peopleBookbg.bounds];
    [_peopleBookImageView.layer setCornerRadius:2.0];
    [_peopleBookImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_peopleBookImageView.layer setBorderWidth:0.5];
    [_peopleBookImageView.layer setMasksToBounds:YES];
    [_peopleBookImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_peopleBookbg addSubview:_peopleBookImageView];
    [_peopleBookImageView setHidden:YES];
    
    UIImageView *carbookImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 213.0/2.0, 134.0/2.0)];
    [carbookImage setCenter:CGPointMake(_peopleBookbg.bounds.size.width/2, _peopleBookbg.bounds.size.height/2 - 25)];
    [carbookImage setImage:[UIImage imageNamed:@"ic_paperwork"]];
    [_peopleBookbg addSubview:carbookImage];
    
    UIButton *addcarbookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addcarbookBtn setFrame:CGRectMake(0, 0, 220, 40)];
    [addcarbookBtn setCenter:CGPointMake(_peopleBookbg.bounds.size.width/2, _peopleBookbg.bounds.size.height/2 + 50)];
    [addcarbookBtn setBackgroundImage:[UIImage imageNamed:@"btn_paperwork_normal"] forState:UIControlStateNormal];
    [addcarbookBtn setBackgroundImage:[UIImage imageNamed:@"btn_paperwork_pressed"] forState:UIControlStateHighlighted];
    [addcarbookBtn setTitle:@"拍摄或上传身份证清晰照片" forState:UIControlStateNormal];
    [addcarbookBtn.titleLabel setFont:AppFont(14)];
    [addcarbookBtn addTarget:self action:@selector(addpeoplebookBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_peopleBookbg addSubview:addcarbookBtn];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setFrame:CGRectMake(10, 400, 300, 44)];
    [_confirmBtn.titleLabel setFont:AppFont(12)];
    [_confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_submit_empty"] forState:UIControlStateDisabled];
    [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_add_car_normal"] forState:UIControlStateNormal];
    [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_add_car_pressed"] forState:UIControlStateSelected];
    [_confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn setEnabled:NO];
    [_scrollView addSubview:_confirmBtn];
    
    [_scrollView setContentSize:CGSizeMake(bound.size.width, 454)];
}

- (void)confirmBtnAction:(UIButton *)sender
{
    DLog(@"提交");
    MBProgressHUD *hubView = [MBProgressHUD showMessag:@"正在上传" toView:self.view];
    [APIClient networkUpLoadImageFileByType:2 user_id:[User shareInstance].userId dataFile:[NSArray arrayWithObject:self.imagePath] success:^(Respone *respone) {
        DLog(@"%@",[respone description]);
        if (respone.status == kEnumServerStateSuccess) {
            [hubView setLabelText:@"上传成功"];
            self.imageUrl = [respone.data valueForKey:@"file_0"];
            //获取用户实名认证
            [APIClient networkUserRealNameRequestWithid_cards_1:self.imageUrl id_cards_2:nil success:^(Respone *respone) {
                if (respone.status == kEnumServerStateSuccess) {
                    [self.navigationController popViewControllerAnimated:YES];
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

- (void)addpeoplebookBtn:(UIButton *)sender
{
    DLog(@"选择照相机");

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍摄照片",@"从相册中选择照片", nil];
    [alertView setTag:110];
    [alertView show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
    //更新显示
    [_peopleBookImageView setImage:image];
    [_peopleBookImageView setHidden:NO];
    [_confirmBtn setEnabled:YES];
    
    self.imagePath = nil;
    //压缩保存
    self.imagePath = [self saveImage:image];
//    //更新上传到服务器
//    [self performSelector:@selector(saveImage:)
//               withObject:image
//               afterDelay:0.5];
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

-(NSString *)saveImage:(UIImage *)image
{
    DLog(@"已选择头像");
    
    //可以对图片进行处理后上传
    NSData  *imageData = [image compressedDataSize:2*1024];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"img00.png"];
    [imageData writeToFile:fullPathToFile atomically:NO];
   
    return fullPathToFile;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
