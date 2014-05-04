//
//  CarImageSampleViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-13.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "CarImageSampleViewController.h"

@interface CarImageSampleViewController ()

@end

@implementation CarImageSampleViewController

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
    
    [self setTitle:@"照片样例"];
    [self setMessageText:@"请按照以下示例拍摄上传照片"];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KOFFSETY, APPLICATION_WIDTH, APPLICATION_HEGHT - KOFFSETY)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setScrollEnabled:YES];
    [_scrollView setAlwaysBounceVertical:YES];
    [self.view addSubview:_scrollView];
    
    CGRect bound = _scrollView.bounds;
    
    _carBookImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, bound.size.width-20, 200)];
    [_carBookImageView.layer setCornerRadius:2.0];
    [_carBookImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_carBookImageView.layer setBorderWidth:0.5];
    [_carBookImageView.layer setMasksToBounds:YES];
    [_carBookImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_scrollView addSubview:_carBookImageView];
    
    UILabel *carbookLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 200-40, _carBookImageView.bounds.size.width, 40)];
    [carbookLable setText:@"拍摄机动车行驶证第一页即可"];
    [carbookLable setFont:AppFont(16)];
    [carbookLable setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6]];
    [carbookLable setTextAlignment:NSTextAlignmentCenter];
    [_carBookImageView addSubview:carbookLable];
    
    _carFrontImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 210+10, 290/2.0, 190/2.0)];
    [_carFrontImageView.layer setCornerRadius:2.0];
    [_carFrontImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_carFrontImageView.layer setBorderWidth:0.5];
    [_carFrontImageView.layer setMasksToBounds:YES];
    [_carFrontImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_carFrontImageView setImage:[UIImage imageNamed:@"car1"]];
    [_scrollView addSubview:_carFrontImageView];
    
    UILabel *carfrontLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 220+_carFrontImageView.bounds.size.height, _carFrontImageView.bounds.size.width, 40)];
    [carfrontLable setText:@"注意车牌清晰"];
    [carfrontLable setFont:AppFont(14)];
    [carfrontLable setTextColor:[UIColor blackColor]];
    [carfrontLable setTextAlignment:NSTextAlignmentCenter];
    [_scrollView addSubview:carfrontLable];
    
    _carSliderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20+290.0/2.0, 210+10, 290/2.0, 190.0/2.0)];
    [_carSliderImageView.layer setCornerRadius:2.0];
    [_carSliderImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_carSliderImageView.layer setBorderWidth:0.5];
    [_carSliderImageView setImage:[UIImage imageNamed:@"car2"]];
    [_carSliderImageView.layer setMasksToBounds:YES];
    [_carSliderImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_scrollView addSubview:_carSliderImageView];
    
    UILabel *carsliderLable = [[UILabel alloc]initWithFrame:CGRectMake(20+290.0/2.0, 220+_carSliderImageView.bounds.size.height, _carSliderImageView.bounds.size.width, 40)];
    [carsliderLable setText:@"车身正侧面或斜面"];
    [carsliderLable setFont:AppFont(14)];
    [carsliderLable setTextColor:[UIColor blackColor]];
    [carsliderLable setTextAlignment:NSTextAlignmentCenter];
    [_scrollView addSubview:carsliderLable];
    
    [_scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 220+95+40+50)];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setFrame:CGRectMake(10, 295+ 10 + 95, 300, 44)];
    [_confirmBtn setTitle:@"继续上传图片" forState:UIControlStateNormal];
    [_confirmBtn.titleLabel setFont:AppFont(12)];
    [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_submit_empty"] forState:UIControlStateDisabled];
    [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_add_car_normal"] forState:UIControlStateNormal];
    [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_add_car_pressed"] forState:UIControlStateSelected];
    [_confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn setEnabled:YES];
    [_scrollView addSubview:_confirmBtn];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirmBtnAction:(UIButton *)sender
{
    DLog(@"继续上传照片");
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
