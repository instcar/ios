//
//  SettingViewController.m
//  CarApp
//
//  Created by Leno on 13-9-27.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableCell.h"
#import "Harpy.h"
#import "ADWebViewController.h"
#import "SDImageCache.h"

#define kSettingTableTag 2000
#define kClearCachaTag 3000
#define kAdScrollerViewTag 4000

@interface SettingViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *adsArray;
@property (copy, nonatomic) NSString *version;
@property (assign, nonatomic) long long cacheSize;

@end

@implementation SettingViewController

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
    [self setTitle:@"系统设置"];
    [self setMessageText:@"您可以按照自己的规律设置常用线路及个人隐私"];
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 45,320, 140)];
    [scrollView setTag:kAdScrollerViewTag];
    [scrollView setDelegate:self];
    [scrollView setContentSize:CGSizeMake(320, 120)];
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    [scrollView setPagingEnabled:YES];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setBounces:NO];
    [self.view insertSubview:scrollView aboveSubview:_messageBgView];
    
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adTapAction:)];
    [scrollView addGestureRecognizer:tapAction];
    
    UIImageView * brImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 140)];
    [brImgView setBackgroundColor:[UIColor placeHoldColor]];
    [brImgView setImage:[UIImage imageNamed:@"delt_pic_b"]];
    [scrollView addSubview:brImgView];
    
    UIPageControl * pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(110, 140 + 35, 100, 10)];
    [pageControl setTag:159];
    [pageControl setNumberOfPages:1];
    [pageControl setCurrentPage:0];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
     [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    }
    
    [self.view addSubview:pageControl];

    UITableView * settingTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 45 + 140, 320, APPLICATION_HEGHT - 44 - 45 -140) style:UITableViewStylePlain];
    [settingTable setTag:kSettingTableTag];
    [settingTable setBackgroundColor:[UIColor clearColor]];
    [settingTable setBackgroundView:nil];
    [settingTable setDelegate:self];
    [settingTable setDataSource:self];
    [settingTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [settingTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)]];
    [self.view addSubview:settingTable];
    
    [self performSelector:@selector(getServerData) withObject:nil afterDelay:0.1];
}

-(void)viewWillAppear:(BOOL)animated
{
    //获取缓存大小
    self.cacheSize = [[SDImageCache sharedImageCache] getSize];
}

#pragma mark - 获取广告接口
- (void)getServerData
{
    /*
    [NetWorkManager networkGetADListWithPage:1 rows:20 success:^(BOOL flag, NSArray *adsArray, NSString *msg) {
        if (flag) {
            self.adsArray = nil;
            self.adsArray = [NSMutableArray arrayWithArray:adsArray];
            [self reloadADView];
        }
    } failure:^(NSError *error) {
        
    }];
     */
}

//转载广告视图
- (void)reloadADView
{
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:kAdScrollerViewTag];
    
    //移除广告视图
    for (UIView *view in [scrollView subviews]) {
        [view removeFromSuperview];
    }
    
    int num = [self.adsArray count];
    [scrollView setContentSize:CGSizeMake(320*num, 120)];
    //加载过时数据
    for (int i = 0; i<num; i++) {
        UIImageView * brImgView = [[UIImageView alloc]initWithFrame:CGRectMake(320 * i, 0, 320, 140)];
        [brImgView setBackgroundColor:[UIColor placeHoldColor]];
        [scrollView addSubview:brImgView];
        NSDictionary *dic = (NSDictionary *)[self.adsArray objectAtIndex:i];
        NSURL *url = [NSURL URLWithString:[dic valueForKey:@"img"]];
        [brImgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"delt_pic_b"]];
    }
    
    UIPageControl *pageControl = (UIPageControl *)[self.view viewWithTag:159];
    [pageControl setNumberOfPages:num];
}

- (void)adTapAction:(UITapGestureRecognizer *)gesture
{
    DLog(@"enter adWebviewController");
    
    UIPageControl *pageControl = (UIPageControl *)[self.view viewWithTag:159];
    int index = pageControl.currentPage;
    NSDictionary *dic = (NSDictionary *)[self.adsArray objectAtIndex:index];
    NSString *url = [dic valueForKey:@"img"];

    ADWebViewController *adwebVC = [[ADWebViewController alloc]init];
    [adwebVC setUrl:url];
    [self.navigationController pushViewController:adwebVC animated:YES];
}

-(void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据交互
- (void)getAdServerData
{
    //请求广告数据
    if (NO) {
        UIScrollView *adScrollerView = (UIScrollView *)[self.view viewWithTag:kAdScrollerViewTag];
        for (UIView *view in adScrollerView.subviews) {
            [view removeFromSuperview];
        }
    }
    
}

#pragma mark - scrollerDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UIPageControl * pageControl = (UIPageControl *)[self.view viewWithTag:159];
    float xxx = scrollView.contentOffset.x;
    int page = (int)xxx/320;
    [pageControl setCurrentPage:page];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ResultsTable";
    SettingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SettingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setBackgroundColor:[UIColor whiteColor]];

//    [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
//
//    if (indexPath.row == 0 && [tableView numberOfRowsInSection:indexPath.section] > 1) {
//        [cell.cellBackGroundBtn setFrame:CGRectMake(0, 0, 320, 44+5)];
//    }
//    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1 && [tableView numberOfRowsInSection:indexPath.section] > 1) {
//        [cell.cellBackGroundBtn setFrame:CGRectMake(0, -5, 320, 44+5)];
//    }
//    if (indexPath.row != [tableView numberOfRowsInSection:indexPath.section]-1 && indexPath.row != 0) {
//        [cell.cellBackGroundBtn setFrame:CGRectMake(0, -5, 320, 44+10)];
//    }
//    [cell.cellBackGroundBtn setTag:indexPath.row+1000];
//    [cell.cellBackGroundBtn addTarget:self action:@selector(cellSelectAction:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.lineView setHidden:NO];
    [cell.switchhh setHidden:NO];
    [cell.detailLable setHidden:YES];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    /*
    if (indexPath.row == 0) {

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.titleLabel setText:@"声音"];
        [cell.switchhh setOn:[User shareInstance].soundEnable];
        [cell.switchhh addTarget:self action:@selector(soundChanged:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }*/
    
    if (indexPath.row == 0) {
        
        [cell.switchhh setHidden:YES];
        [cell.titleLabel setText:@"消息推送"];
        [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
        [cell.detailLable setHidden:NO];
        DLog(@"push:%d",[[UIApplication sharedApplication] enabledRemoteNotificationTypes]);
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] != UIRemoteNotificationTypeNone) {
            [cell.detailLable setText:@"已开启"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        else
        {
            [cell.detailLable setText:@"已关闭"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

        }
//        [cell.switchhh setOn:[User shareInstance].pushEnable];
//        [cell.switchhh addTarget:self action:@selector(pushChanged:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
    
    /*
    if (indexPath.row == 2) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.titleLabel setText:@"GPRS校准"];
        [cell.switchhh setOn:[User shareInstance].LocateEnable];
        [cell.switchhh addTarget:self action:@selector(locateChanged:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
    */
    /*
    if (indexPath.row == 3) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.titleLabel setText:@"自动发布"];
        [cell.switchhh setOn:[User shareInstance].autoPublish];
        [cell.switchhh addTarget:self action:@selector(autoPublishChanged:) forControlEvents:UIControlEventValueChanged];
        
        return cell;
    }*/

    if (indexPath.row == 1) {
        [cell.titleLabel setText:@"清除缓存"];
        [cell.switchhh setHidden:YES];
        [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
        [cell.detailLable setHidden:NO];
        if (self.cacheSize <= 0) {
            [cell.detailLable setText:@"0M"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        else
            [cell.detailLable setText:[NSString stringWithFormat:@"%.2lfM",self.cacheSize/1024.0/1024.0]];
        
        return cell;
    }
    
    if (indexPath.row == 2) {
        [cell.titleLabel setText:@"版本更新"];
        [cell.switchhh setHidden:YES];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.detailLable setHidden:NO];
        if ([[User shareInstance].version isEqualToString:kAppVersion]) {
            [cell.detailLable setText:@"当前版本为最新版本"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        else
        {
            [cell.detailLable setText:[NSString stringWithFormat:@"v%@",[User shareInstance].version]];
        }
        
//        [cell.lineView setHidden:YES];
        return cell;
    }
    
    if (indexPath.row == 3) {
        [cell.titleLabel setText:@"给易行评分"];
        [cell.switchhh setHidden:YES];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.detailLable setHidden:YES];
    
        //        [cell.lineView setHidden:YES];
        return cell;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 && [[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在iPhone的”设置“-”通知“中进行设置" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
    
    if (indexPath.row == 1) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"清除全部缓存 %.2lfM",self.cacheSize/1024.0/1024.0] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert setTag:kClearCachaTag];
        [alert show];
    }
    
    if (indexPath.row == 2) {
        [Harpy checkVersion:NO];
    }
    
    if (indexPath.row == 3) {
        [self goToAppStore];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //清除缓存
        [[SDImageCache sharedImageCache] cleanDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDisk];
        self.cacheSize = 0;
        
        //刷新列表
        UITableView *tableView = (UITableView *)[self.view viewWithTag:kSettingTableTag];
        [tableView reloadData];
        
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

//去给易行评分
-(void)goToAppStore
{
    NSString *str = [NSString stringWithFormat:
                     @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",kHarpyAppID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)soundChanged:(UISwitch *)sender
{
    [[User shareInstance]setSoundEnable:sender.on];
}

-(void)pushChanged:(UISwitch *)sender
{
    [[User shareInstance]setPushEnable:sender.on];
}

-(void)locateChanged:(UISwitch *)sender
{
    [[User shareInstance]setLocateEnable:sender.on];
}

-(void)autoPublishChanged:(UISwitch *)sender
{
    [[User shareInstance]setAutoPublish:sender.on];
}

@end
