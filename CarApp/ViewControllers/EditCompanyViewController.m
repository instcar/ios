//
//  EditCompanyViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-15.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "EditCompanyViewController.h"

@interface EditCompanyViewController ()

@end

@implementation EditCompanyViewController

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
    [self setCtitle:@"编辑公司地址"];
    [self setDesText:@"您的公司地址可以选择对所有人公开或保密"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KOFFSETY, SCREEN_WIDTH, SCREEN_HEIGHT - KOFFSETY)];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    [_tableView release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"_companyCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"_companyCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    switch (indexPath.row) {
        case 0:
        {
            [cell.textLabel setText:@"城市:"];
            [cell.detailTextLabel setText:@"北京市"];
            [cell setAccessoryView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_next"]]];
        }
            break;
        case 1:
        {
            [cell.textLabel setText:@"区域:"];
            [cell.detailTextLabel setText:@"海定区"];
            [cell setAccessoryView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_next"]]];
        }
            break;
        case 2:
        {
            [cell.textLabel setText:@"详细:"];
            [cell.detailTextLabel setText:@"上地十街10号百度大厦"];
            [cell setAccessoryView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_next"]]];
        }
            break;
        case 3:
        {
            [cell.textLabel setText:@"公开或保密:"];
            [cell.detailTextLabel setText:@"保密"];
            UISwitch *switchBtn = [[UISwitch alloc]init];
            [switchBtn addTarget:self action:@selector(switchBtnAction:) forControlEvents:UIControlEventValueChanged];
            [cell setAccessoryView:switchBtn];
        }
            break;
        default:
            break;
    }
    return cell;
}

-(void)switchBtnAction:(UIButton *)sender
{
    DLog(@"保密切换");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
