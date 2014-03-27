//
//  SearchResultViewController.m
//  CarApp
//
//  Created by 海龙 李 on 13-11-25.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "SearchResultViewController.h"

#import "DriverRouteCell.h"


@interface SearchResultViewController ()

@end

@implementation SearchResultViewController

@synthesize searchKeyWord = _searchKeyWord;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.searchKeyWord = [[NSString alloc]init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView * mainView = [[UIView alloc]initWithFrame:[AppUtility mainViewFrame]];
    [mainView setBackgroundColor:[UIColor flatWhiteColor]];
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
    [titleLabel setText:@"目的地选择"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor flatGreenColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [navBar addSubview:titleLabel];
    [titleLabel release];

    
    _resultsTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, 320, SCREEN_HEIGHT -65)];
    [_resultsTable setDelegate:self];
    [_resultsTable setDataSource:self];
    [_resultsTable setBackgroundColor:[UIColor clearColor]];
    [_resultsTable setBackgroundView:Nil];
    [mainView addSubview:_resultsTable];
    [_resultsTable release];
    
    
    //发起获取关键字结果的请求
    [self searchKeyWord:self.searchKeyWord];
    
}

-(void)searchKeyWord:(NSString *)keyWord
{
    NSLog(@"搜索关键字为：%@",keyWord);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ResultsTable";
    DriverRouteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[DriverRouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [cell.routeLabel setHidden:NO];
    [cell.addressLabel setHidden:NO];
    
    [cell.routeLabel setText:@"潮白人家东门"];
    [cell.addressLabel setText:@"地址:燕郊行宫西大街"];
    
    [cell.routeLabel setFrame:CGRectMake(20, 7, 270, 30)];
    [cell.addressLabel setFrame:CGRectMake(20, 26, 270, 30)];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSString * resultSelected = @"潮白人家西门";
        [_delegate searchResultSelected:resultSelected];
    }];
}

















-(void)backToMain
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
