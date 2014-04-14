//
//  SelectCarTypeViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-13.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "SelectCarTypeViewController.h"
#import "EditCarInfoViewController.h"

@interface SelectCarTypeViewController ()

@property (retain, nonatomic) NSMutableDictionary *carTypes;
@property (retain, nonatomic) NSMutableArray *keys; //城市首字母

@end

@implementation SelectCarTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.keys = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getCityData];
    [self setCtitle:@"编辑车辆信息"];
    [self setDesText:@"请选择您的车型"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KOFFSETY, SCREEN_WIDTH, SCREEN_HEIGHT - KOFFSETY) style:UITableViewStylePlain];
    _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view insertSubview:_tableView belowSubview:_navBar];
    [_tableView release];
}

#pragma mark - 获取城市数据
-(void)getCityData
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"
                                                   ofType:@"plist"];
    self.carTypes = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    [self.keys addObjectsFromArray:[[self.carTypes allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    //添加热门Car
    //    NSString *strHot = @"热";
    //    [_keys insertObject:strHot atIndex:0];
    //    [_cities setObject:_arrayHotCity forKey:strHot];
}

#pragma mark - tableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)]autorelease];
    bgView.backgroundColor = ColorRGB(232.0, 232.0, 232.0);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 250, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *key = [self.keys objectAtIndex:section];
    //    if ([key rangeOfString:@"热"].location != NSNotFound) {
    //        titleLabel.text = @"热门城市";
    //    }
    //    else
    titleLabel.text = key;
    
    [bgView addSubview:titleLabel];
    [titleLabel release];
    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keys;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [self.keys objectAtIndex:section];
    NSArray *carSection = [self.carTypes objectForKey:key];
    return [carSection count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CarTypeCell";
    
    NSString *key = [self.keys objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = AppFont(16);
    }
    cell.textLabel.text = [[self.carTypes objectForKey:key] objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"编辑车辆验证信息");
    EditCarInfoViewController *editVC = [[EditCarInfoViewController alloc]init];
    [self.navigationController pushViewController:editVC animated:YES];
    [editVC release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
