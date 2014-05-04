//
//  SelectCarBrandViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-11.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "SelectCarBrandViewController.h"
#import "SelectCarTypeViewController.h"
#import "HandleCarData.h"
#import "CarLogoTableViewCell.h"
#import "UIColor+utils.h"

@interface SelectCarBrandViewController ()

@property (retain, nonatomic) NSMutableArray *allSectionKeyArray; //所有关键字数组
@property (retain, nonatomic) NSMutableArray *sectionArray; //排序好的数组

@end

@implementation SelectCarBrandViewController

- (void)dealloc
{
    _allSectionKeyArray = nil;
    _sectionArray = nil;
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
    
    [self getCityData];
    [self setTitle:@"编辑车辆信息"];
    [self setMessageText:@"请选择您的车辆品牌"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KOFFSETY, APPLICATION_WIDTH, APPLICATION_HEGHT - KOFFSETY - 44) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view insertSubview:_tableView belowSubview:_messageBgView];
}

#pragma mark - 获取城市数据
-(void)getCityData
{
    HandleCarData * handle = [[HandleCarData alloc] init];
    NSArray * carInforArray = [handle carDataDidHandled];
    self.allSectionKeyArray = [[NSMutableArray alloc]initWithArray:[carInforArray objectAtIndex:0]];//存放所有section字母
    self.sectionArray  = [[NSMutableArray alloc]initWithArray:[carInforArray objectAtIndex:1]];//存放所有汽车信息数组嵌入数组和字母匹配
}

#pragma mark - tableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    bgView.backgroundColor = [UIColor colorHelpWithRed:232.0 green:232.0 blue:232.0 alpha:0.6];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 250, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *key = [self.allSectionKeyArray objectAtIndex:section];
    titleLabel.text = key;
    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.allSectionKeyArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.allSectionKeyArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.sectionArray objectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarLogoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarBrandCell"];
    if (cell == nil) {
        cell = [[CarLogoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CarBrandCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    CarD *car= [[self.sectionArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    [cell setData:car];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"增加车辆车型信息");
    CarD *car= [[self.sectionArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    SelectCarTypeViewController *selectCarTypeVC = [[SelectCarTypeViewController alloc]init];
    selectCarTypeVC.car = car;
    [self.navigationController pushViewController:selectCarTypeVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
