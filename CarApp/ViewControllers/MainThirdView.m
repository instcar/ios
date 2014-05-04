//
//  MainThirdView.m
//  CarApp
//
//  Created by Leno on 13-9-27.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "MainThirdView.h"
#import "XHBKCell.h"

#import "UIImageView+WebCache.h"

#import "XHBKViewController.h"

@interface MainThirdView()

@property (strong, nonatomic) WarnView *warnView;

@end

@implementation MainThirdView
@synthesize tableView = _tableView;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        //初始化数据
        _jokepage = 1;
        _jokeCanLoadMore = true;
        self.jokeArray = [[NSMutableArray alloc]init];
        
        self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(10, 52, 300, SCREEN_HEIGHT - 96 -80) pullingDelegate:self];
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];
        [self.tableView setBackgroundView:nil];
        [self.tableView setBackgroundColor:[UIColor clearColor]];
        [self.tableView setShowsHorizontalScrollIndicator:NO];
        [self.tableView setShowsVerticalScrollIndicator:NO];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
        [self addSubview:self.tableView];
        
//        self.tableView.layer.cornerRadius = 6;
//        self.tableView.layer.masksToBounds = YES;
        
        self.userInteractionEnabled = YES;
        
        self.warnView = [WarnView initWarnViewWithText:@"非常抱歉,暂无数据..." withView:_tableView height:120 withDelegate:nil];
        
    }
    return self;
}

/*
//一版未上线
-(void)requestThirdTableDataFromServer:(kRequestMode)mode
{
    [NetWorkManager networkGetJokeListPage:_jokepage rows:kBKPerRowCellNum success:^(BOOL flag, BOOL hasnextpage, NSArray *jokeArray, NSString *msg) {
        if (mode==kRequestModeRefresh) {
            [self.jokeArray removeAllObjects];
        }
        if (flag) {
            _jokeCanLoadMore = hasnextpage;
            for (int i = 0; i < [jokeArray count]; i++) {
                [self.jokeArray addObject:[jokeArray objectAtIndex:i]];
            }
            MainThirdView *thirdView = (MainThirdView *)[self.view viewWithTag:1003];
            MainThirdView *thirdViewCopy = (MainThirdView *)[self.view viewWithTag:3003];
            
            [thirdView.tableView tableViewDidFinishedLoading];
            [thirdView.tableView setReachedTheEnd:!hasnextpage];
            //                [thirdView.tableView setHeaderOnly:!hasnextpage];
            
            //                [thirdView.tableView reloadData];
            [thirdView setTableData:self.jokeArray];
            
            [thirdViewCopy.tableView tableViewDidFinishedLoading];
            [thirdViewCopy.tableView setReachedTheEnd:!hasnextpage];
            //                [thirdViewCopy.tableView setHeaderOnly:!hasnextpage];
            //                [thirdViewCopy.tableView reloadData];
            [thirdViewCopy setTableData:self.jokeArray];
        }
        else
        {
            [UIAlertView showAlertViewWithTitle:@"错误" message:msg cancelTitle:@"忽略"];
        }
    } failure:^(NSError *error) {
        
    }];
}
*/

-(void)setTableData:(NSArray *)array
{
    self.thridTableData = array;
    
    if ([self.thridTableData count]>0) {
        [self.warnView dismiss];
    }
    else
    {
        [self.warnView show:kenumWarnViewTypeNullData];
    }
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.thridTableData count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"XHBKTableCell";
    
    XHBKCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XHBKCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundView:nil];
    
    [cell.backButton setTag:9900 + indexPath.row];
    [cell.backButton addTarget:self action:@selector(sendXHBKIndex:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSDictionary *dic = [_thridTableData objectAtIndex:indexPath.row];
//    int ID = [[dic valueForKey:@"id"]intValue];
    NSString *content = [dic valueForKey:@"content"];
    NSString *smallpic = [dic valueForKey:@"smallpic"];
//    NSString *largepic = [dic valueForKey:@"largepic"];
//    NSString *source = [dic valueForKey:@"source"];
//    NSString *time = [dic valueForKey:@"time"];
    
    [cell.contentTextLable setText:content];
    [cell.contentImageView setImageWithURL:[NSURL URLWithString:smallpic] placeholderImage:[UIImage imageNamed:@"delt_pic_s"]];
    
//    [cell setBackgroundColor:[UIColor clearColor]];
//    [cell setBackgroundView:nil];
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //表单动画
    /*
    if (indexPath.row == 0 || indexPath.row == [tableView numberOfRowsInSection:0]-1) {
        return;
    }
    // 1. 配置CATransform3D的内容
    CATransform3D transform;
//    transform = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    if (self.tableView.direction==kScrollerDirectionUp) {
        transform = CATransform3DMakeTranslation(0, cell.frame.size.height/5, 0);
    }
    else
        transform = CATransform3DMakeTranslation(0, -cell.frame.size.height/5, 0);
    transform.m34 = 1.0/ -600;
    
    // 2. 定义cell的初始状态
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = transform;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    // 3. 定义cell的最终状态，并提交动画
    [UIView beginAnimations:@"transform" context:NULL];
    [UIView setAnimationDuration:0.5];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    [UIView commitAnimations];
     */
}

-(void)sendXHBKIndex:(UIButton *)btn
{
    int XHBKindex = btn.tag - 9900;
    [_delegate thirdTableDidClicked:XHBKindex];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"enterXHBK" object:[NSNumber numberWithInt:XHBKindex] userInfo:nil];
//    DLog(@"--->%d",XHBKindex);
}

#pragma mark- MainThirdDelegate
//进入笑话百科详情
-(void)thirdTableDidClicked:(int)index
{
    DLog(@"===>%d<====",index);
    
    if (!self.mainVC) {
        return;
    }
    XHBKViewController * xhbkVC = [[XHBKViewController alloc]init];
    //传参
    xhbkVC.dataInfo = [self.jokeArray objectAtIndex:index];
    [self.mainVC.navigationController pushViewController:xhbkVC animated:YES];
    
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    //对tableModel进行判断
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainThirdViewreflushData)]) {
        [self.delegate mainThirdViewreflushData];
    }
}

- (void) loadMoreDataToTable
{
    //对tableModel进行判断
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainThirdViewLoadMoreData)]) {
        [self.delegate mainThirdViewLoadMoreData];
    }
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.f];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.f];
}


@end
