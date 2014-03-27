//
//  EditTimeViewController.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-26.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "EditTimeViewController.h"

@interface EditTimeViewController ()


@property (retain, nonatomic)NSMutableDictionary *dateDic;
@property (retain, nonatomic)NSDate *changeDate;
@end

@implementation EditTimeViewController

-(void)dealloc
{
    [SafetyRelease release:_timePicker];
    [SafetyRelease release:_dayPicker];
    [SafetyRelease release:_dateDic];
    [SafetyRelease release:_changeDate];
    [SafetyRelease release:_date];
    [SafetyRelease release:_dayArray];
    [SafetyRelease release:_hourArray];
    [SafetyRelease release:_minuteArray];
    [super dealloc];
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
    
    _index = 0;
    
    UIView * mainView = [[UIView alloc]initWithFrame:[AppUtility mainViewFrame]];
    [mainView setBackgroundColor:[UIColor appBackgroundColor]];
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
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 27, 200, 30)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"出发时间"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor appNavTitleColor]];
    [titleLabel setFont:[UIFont fontWithName:kFangZhengFont size:18]];
    [navBar addSubview:titleLabel];
    [titleLabel release];
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(320-70, 20, 70, 44)];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_confirm_normal@2x"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_confirm_pressed@2x"] forState:UIControlStateHighlighted];
    [saveBtn addTarget:self action:@selector(saveBtnToMain) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:saveBtn];
    
//    _dayArray = [[NSArray alloc]initWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",nil];
    _dayArray = [[NSArray alloc]initWithObjects:@"今天",@"明天",@"后天", nil];
    
    _hourArray = [[NSArray alloc]initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",
                  @"07",@"08",@"09",@"10",@"11",@"12",@"13",
                  @"14",@"15",@"16",@"17",@"18",@"19",@"20",
                  @"21",@"22",@"23", nil];
    
    _minuteArray = [[NSArray alloc]initWithObjects:@"00",@"05",@"10",@"15",@"20",@"25",
                    @"30",@"35",@"40",@"45",@"50",@"55", nil];
    
//    self.dayPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 64, 320.0, 216.0)];
//    self.dayPicker.delegate = self;
//    self.dayPicker.dataSource = self;
//    self.dayPicker.showsSelectionIndicator = YES;
//    [self.dayPicker setBackgroundColor:[UIColor whiteColor]];
//    [mainView insertSubview:self.dayPicker belowSubview:navBar];
    
    UIPickerView *timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 64, 320.0, 216.0)];
    timePicker.delegate = self;
    timePicker.dataSource = self;
    timePicker.showsSelectionIndicator = YES;
    [timePicker setBackgroundColor:[UIColor whiteColor]];
    [self setTimePicker:timePicker];
    [mainView insertSubview:timePicker belowSubview:navBar];
    [timePicker release];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,  64+216, 320, SCREEN_HEIGHT - 64 - 216) style:UITableViewStylePlain];
    [tableView setTag:22222];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)]];
    [mainView addSubview:tableView];
    [tableView release];
    
    _selectArray = [[NSMutableArray alloc] init];//用来保存选中的数据或是索引
    NSMutableDictionary *dateDic = [[NSMutableDictionary alloc]init];
    [self setDateDic:dateDic];
    [dateDic release];
    
    [self.dateDic setValue:@"00" forKey:@"hh"];
    [self.dateDic setValue:@"00" forKey:@"mm"];
    
//    _index = [_dayArray indexOfObject:[self.selectDay objectAtIndex:0]];
//    
//    NSArray *timeArray = [_selectTime componentsSeparatedByString:@":"];
//    
//    NSString *hh = [timeArray objectAtIndex:0];
//    NSString *mm = [timeArray objectAtIndex:1];
//    mm = [mm intValue] < 10 ? [NSString stringWithFormat:@"0%d",[mm intValue]-[mm intValue]%5]:[NSString stringWithFormat:@"%d",[mm intValue]-[mm intValue]%5];
//    int hhIndex = [_hourArray indexOfObject:hh];
//    int mmIndex = [_minuteArray indexOfObject:mm];
//    [self.timePicker selectRow:hhIndex inComponent:0 animated:NO];
//    [self.timePicker selectRow:mmIndex inComponent:1 animated:NO];
//    
//    [self performSelector:@selector(setCurrentDay) withObject:nil afterDelay:0.5];
    
}

-(void)setCurrentDay
{
    UITableView *tableView = (UITableView *)[self.view viewWithTag:22222];
    
    // 取消前一个选中的，就是单选啦
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_index inSection:0];
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndex];
    lastCell.accessoryView = nil;
    
    if ([[AppUtility dayStrTimeDate:self.date] isEqualToString:@"今天"]) {
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        UITableViewCell *cell  = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];    // 选中操
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_arrow"]];
        _index = 0;
    }
    if ([[AppUtility dayStrTimeDate:self.date]isEqualToString:@"明天"]) {
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        UITableViewCell *cell  = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];    // 选中操
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_arrow"]];
        _index = 1;
    }
    if ([[AppUtility dayStrTimeDate:self.date] isEqualToString:@"后天"]) {
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        UITableViewCell *cell  = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];    // 选中操
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_arrow"]];
        _index = 2;
    }
    
    NSString *timeStr = [AppUtility strFromDate:self.date withFormate:@"HH:mm"];
    NSString *HHStr = [[timeStr componentsSeparatedByString:@":"]objectAtIndex:0];
    NSString *mmStr = [[timeStr componentsSeparatedByString:@":"]objectAtIndex:1];
    
    int hourIndex = [_hourArray indexOfObject:HHStr];
    if (hourIndex <= -1 && hourIndex >26) {
        hourIndex = 0;
    }
    int mmIndex = [_minuteArray indexOfObject:mmStr];
    if (mmIndex <= -1 && mmIndex > 30) {
        mmIndex = 0;
    }

    for (int index = 0; index < [_minuteArray count]; index++) {
        if (([mmStr intValue]-[[_minuteArray objectAtIndex:index] intValue] > -5 && [mmStr intValue]-[[_minuteArray objectAtIndex:index] intValue] < 0) || [mmStr intValue]==[[_minuteArray objectAtIndex:index] intValue]) {
            mmIndex = index;
        }
    }
    
    [self.timePicker selectRow:hourIndex inComponent:0 animated:NO];
    [self.timePicker selectRow:mmIndex inComponent:1 animated:NO];
    [self.dateDic setValue:[_hourArray objectAtIndex:hourIndex] forKey:@"hh"];
    [self.dateDic setValue:[_minuteArray objectAtIndex:mmIndex] forKey:@"mm"];
    [tableView reloadData];
}

-(void)setDate:(NSDate *)date
{
    if (date) {
        [_date release];
        [date retain];
        _date = date;
    }
    DLog(@"%@",date);
    [self setCurrentDay];
}

#pragma mark -- pikerSelect
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([pickerView isEqual:self.dayPicker]) {
        return 1;
    }
    else if ([pickerView isEqual:self.timePicker])
    {
        return 2;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.dayPicker]) {
        return 3;
    }
    if ([pickerView isEqual:self.timePicker]) {
        if (component == 0) {
            return 24;
        }
        else{
            return 12;
        }
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
//    if ([pickerView isEqual:self.dayPicker]) {
//        
//        switch (row) {
//            case 0:
//                return @"今天";
//                break;
//            case 1:
//                return @"明天";
//                break;
//            case 2:
//                return @"后天";
//                break;
//            default:
//                break;
//        }
//    }
    
    if ([pickerView isEqual:self.timePicker]) {
        
        if (component == 0) {
            return [NSString stringWithFormat:@"%d点",row];
        }
        else if (component == 1)
        {
            return [NSString stringWithFormat:@"%d分",row *5];
        }
    }
    return @" ";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    if ([pickerView isEqual:self.dayPicker]) {
//        
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [UIView setAnimationDuration:0.4];//动画时间长度，单位秒，浮点数
//        self.dayPicker.frame = CGRectMake(0.0, SCREEN_HEIGHT, 320.0, 216.0);
//        [UIView commitAnimations];
//        
//        UIButton * dayBtn = (UIButton *)[self.view viewWithTag:1321];
//        [dayBtn setTitle:(NSString *)[_dayArray objectAtIndex:row] forState:UIControlStateNormal];
//        [dayBtn setTitle:(NSString *)[_dayArray objectAtIndex:row] forState:UIControlStateHighlighted];
//    }
//    
//    if ([pickerView isEqual:self.timePicker]) {
//        
//        UIButton * timeBtn = (UIButton *)[self.view viewWithTag:1322];
//        
//        NSString * before = [[timeBtn.titleLabel.text componentsSeparatedByString:@"："]objectAtIndex:0];
//        NSString * last = [[timeBtn.titleLabel.text componentsSeparatedByString:@"："]objectAtIndex:1];
//        
//        DLog(@"%@ --- %@",before,last);
//        
//        if (component == 0) {
//            [timeBtn setTitle:[NSString stringWithFormat:@"%@：%@",[_hourArray objectAtIndex:row],last] forState:UIControlStateNormal];
//            [timeBtn setTitle:[NSString stringWithFormat:@"%@：%@",[_hourArray objectAtIndex:row],last] forState:UIControlStateHighlighted];
//        }
//        else if (component == 1)
//        {
//            [timeBtn setTitle:[NSString stringWithFormat:@"%@：%@",before,[_minuteArray objectAtIndex:row]] forState:UIControlStateNormal];
//            [timeBtn setTitle:[NSString stringWithFormat:@"%@：%@",before,[_minuteArray objectAtIndex:row]] forState:UIControlStateHighlighted];
//            
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//            [UIView setAnimationDuration:0.4];//动画时间长度，单位秒，浮点数
//            self.timePicker.frame = CGRectMake(0.0, SCREEN_HEIGHT, 320.0, 216.0);
//            [UIView commitAnimations];
//        }
//    }
    if (component == 0) {
        [self.dateDic setValue:row<10?[NSString stringWithFormat:@"0%d",row]:[NSString stringWithFormat:@"%d",row] forKey:@"hh"];
    }
    if (component == 1) {
        [self.dateDic setValue:(row*5)<10?[NSString stringWithFormat:@"0%d",row]:[NSString stringWithFormat:@"%d",row*5] forKey:@"mm"];
    }
}
#pragma mark -- tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dayArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCellIdentifier = @"_weekcell";
    UITableViewCell *weekCell = nil;
    weekCell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    if (!weekCell) {
        weekCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
        [weekCell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    NSString * weekStr = [_dayArray objectAtIndex:indexPath.row];
    [weekCell.contentView setBackgroundColor:[UIColor appBackgroundColor]];
    [weekCell setBackgroundColor:[UIColor appBackgroundColor]];
    [weekCell.textLabel setText:weekStr];
    
    if (_index == indexPath.row) {
       [weekCell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_arrow"]]];
    }
    else
       [weekCell setAccessoryView:nil];
    
    return weekCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//        多选
//    UITableViewCell *oneCell = [tableView cellForRowAtIndexPath: indexPath];
//    if (oneCell.accessoryType == UITableViewCellAccessoryNone) {
//        oneCell.accessoryType = UITableViewCellAccessoryCheckmark;
//        [_selectArray addObject:[NSString stringWithFormat:@"%d", [indexPath row]]];
//    } else {
//        oneCell.accessoryType = UITableViewCellAccessoryNone;
//        [_selectArray removeObject:[NSString stringWithFormat:@"%d", [indexPath row]]];
//    }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //单选
    // 取消前一个选中的，就是单选啦
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_index inSection:0];
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndex];
    lastCell.accessoryView = nil;
    
    // 选中操作
    UITableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_arrow"]];
    
    // 保存选中的
    _index = indexPath.row;
    [tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:.5];
}

-(void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveBtnToMain
{
    NSString *day = [_dayArray objectAtIndex:_index];
    [self.dateDic setValue:day forKey:@"dd"];
    

    int daynum = [AppUtility getDayConponentFromDate:[NSDate date]];;
    daynum += _index;

    NSString *yymm = [AppUtility strFromDate:[NSDate date] withFormate:@"yyyyMM"];
    NSString *daynumStr = [NSString stringWithFormat:@"%d",daynum];
    if (daynum < 10) {
        daynumStr = [NSString stringWithFormat:@"0%d",daynum];
    }
    NSString *dateStr = [NSString stringWithFormat:@"%@%@%@%@",yymm,daynumStr,[self.dateDic valueForKey:@"hh"],[self.dateDic valueForKey:@"mm"]];
    self.changeDate = [AppUtility dateFromStr:dateStr withFormate:@"yyyyMMddHHmm"];

    if ([self.changeDate compare:[NSDate date]] == NSOrderedAscending) {
        [UIAlertView showAlertViewWithTitle:@"您的设置的时间已经设置不正确，应该大于当前时间" tag:11 cancelTitle:@"取消" ensureTitle:nil delegate:self];
    }
    else
        [UIAlertView showAlertViewWithTitle:@"是否要保存修改发车时间" tag:11 cancelTitle:@"取消" ensureTitle:@"确定" delegate:self];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {

        if (self.delegate && [self.delegate respondsToSelector:@selector(editTimeViewController:select:)]) {
            [self.delegate editTimeViewController:self select:self.changeDate];
        }
        [self performSelector:@selector(backToMain) withObject:nil afterDelay:0.0];
    }
    else
    {
        DLog(@"取消");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
