//
//  SelectCarTypeViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-13.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "SelectCarTypeViewController.h"
#import "EditCarInfoViewController.h"
#import "CarType.h"
#import "UIColor+utils.h"

@interface SelectCarTypeViewController ()

@property (retain, nonatomic) NSMutableArray *sectionArray;
@property (retain, nonatomic) NSMutableArray *allKeyArray; //城市首字母

@end

@implementation SelectCarTypeViewController

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
    [self setMessageText:@"请选择您的车型"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KOFFSETY, APPLICATION_WIDTH, APPLICATION_HEGHT - KOFFSETY - 44) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view insertSubview:_tableView belowSubview:_messageBgView];
    
   [self requestData];
}

#pragma mark - 获取城市数据
-(void)requestData
{
    [APIClient networkGetCarListWithAliasname:self.car.aliasname success:^(Respone *respone) {
        if (respone.status == kEnumServerStateSuccess) {
            self.sectionArray = [NSMutableArray array];
            self.allKeyArray = [NSMutableArray array];
            for (int i = 0; i < [(NSArray *)respone.data count]; i++) {
                NSDictionary *dic = [(NSArray *)respone.data objectAtIndex:i];
                NSString *key = [dic valueForKey:@"name"];
                [self.allKeyArray addObject:key];
                
                NSArray *sectionArray = [CarType initWithArray:[dic valueForKey:@"list"]];
                [self.sectionArray addObject:sectionArray];
            }
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
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
    
    NSString *key = [self.allKeyArray objectAtIndex:section];
    titleLabel.text = key;
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return self.allKeyArray;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.allKeyArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.sectionArray objectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CarTypeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = AppFont(16);
    }
    CarType *cartype = [[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = cartype.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"编辑车辆验证信息");
    CarType *cartype = [[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    EditCarInfoViewController *editVC = [[EditCarInfoViewController alloc]init];
    editVC.carType = cartype;
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
