//
//  MGConferenceDatePicker.m
//  MGConferenceDatePicker
//
//  Created by Matteo Gobbi on 09/02/14.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import "MGConferenceDatePicker.h"
#import "MGConferenceDatePickerDelegate.h"
//Check screen macros
#define IS_WIDESCREEN (fabs ( (double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 )
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

//Editable macros
#define TEXT_COLOR [UIColor colorWithWhite:0.5 alpha:1.0]
#define SELECTED_TEXT_COLOR [UIColor whiteColor]
#define LINE_COLOR [UIColor colorWithWhite:0.80 alpha:1.0]
#define SAVE_AREA_COLOR [UIColor colorWithWhite:0.95 alpha:1.0]
#define BAR_SEL_COLOR [UIColor colorWithRed:76.0f/255.0f green:172.0f/255.0f blue:239.0f/255.0f alpha:0.8]
#define DATE_FORMATTER @"yyyyMMddHHmmss"
//Editable constants
static const float VALUE_HEIGHT = 40.0;
static const float SAVE_AREA_HEIGHT = 70.0;
static const float SAVE_AREA_MARGIN_TOP = 20.0;
static const float SV_MOMENTS_WIDTH = 100.0;
static const float SV_HOURS_WIDTH = 100.0;
static const float SV_MINUTES_WIDTH = 100.0;
static const float SV_MERIDIANS_WIDTH = 70.0;

//Editable values
float PICKER_HEIGHT = 80.0;
NSString *FONT_NAME = @"HelveticaNeue";
NSString *NOW = @"Now";

//Static macros and constants
#define SELECTOR_ORIGIN (PICKER_HEIGHT/2.0-VALUE_HEIGHT/2.0)
#define SAVE_AREA_ORIGIN_Y self.bounds.size.height-SAVE_AREA_HEIGHT
#define PICKER_ORIGIN_Y 0
#define BAR_SEL_ORIGIN_Y PICKER_HEIGHT/2.0-VALUE_HEIGHT/2.0
static const NSInteger SCROLLVIEW_MOMENTS_TAG = 0;

//Custom scrollView
@interface MGPickerScrollView ()

@property (nonatomic, strong) NSArray *arrValues;
@property (nonatomic, strong) UIFont *cellFont;
@property (nonatomic, assign, getter = isScrolling) BOOL scrolling;

@end


@implementation MGPickerScrollView

//Constants
const float LBL_BORDER_OFFSET = 8.0;

//Configure the tableView
- (id)initWithFrame:(CGRect)frame andValues:(NSArray *)arrayValues
      withTextAlign:(NSTextAlignment)align andTextSize:(float)txtSize {
    
    if(self = [super initWithFrame:frame]) {
        [self setScrollEnabled:YES];
        [self setShowsVerticalScrollIndicator:NO];
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setContentInset:UIEdgeInsetsMake(BAR_SEL_ORIGIN_Y, 0.0, BAR_SEL_ORIGIN_Y, 0.0)];
        
        _cellFont = [UIFont fontWithName:FONT_NAME size:txtSize];
        
        if(arrayValues)
            _arrValues = [arrayValues copy];
    }
    return self;
}


//Dehighlight the last cell
- (void)dehighlightLastCell {
    NSArray *paths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_tagLastSelected inSection:0], nil];
    [self setTagLastSelected:-1];
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
}

//Highlight a cell
- (void)highlightCellWithIndexPathRow:(NSUInteger)indexPathRow {
    [self setTagLastSelected:indexPathRow];
    NSArray *paths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_tagLastSelected inSection:0], nil];
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
}

@end



//Custom Data Picker
@interface MGConferenceDatePicker ()

@property (nonatomic, strong) NSArray *arrMoments;
@property (nonatomic, strong) NSArray *arrHours;
@property (nonatomic, strong) NSArray *arrMinutes;
@property (nonatomic, strong) NSArray *arrMeridians;

@property (nonatomic, strong) MGPickerScrollView *svMoments;
@property (nonatomic, strong) MGPickerScrollView *svHours;
@property (nonatomic, strong) MGPickerScrollView *svMins;

@end


@implementation MGConferenceDatePicker

-(void)drawRect:(CGRect)rect {
    [self initialize];
    [self buildControl];
}

- (void)initialize {
    //Set the height of picker if isn't an iPhone 5 or 5s
    //[self checkScreenSize];
    
    //Create array Moments and create the dictionary MOMENT -> TIME
    _arrMoments = @[@"今天",
                    @"明天",
                    @"后天",
                    ];
    //Create array Meridians
    _arrMeridians = @[@"AM", @"PM"];
    
    //Create array Hours
    NSMutableArray *arrHours = [[NSMutableArray alloc] initWithCapacity:24];
    for(int i=0; i<24; i++) {
        [arrHours addObject:[NSString stringWithFormat:@"%@%d",(i<10) ? @"0":@"", i]];
    }
    _arrHours = [NSArray arrayWithArray:arrHours];
    
    //Create array Minutes
    NSMutableArray *arrMinutes = [[NSMutableArray alloc] initWithCapacity:60];
    for(int i=0; i<60; i++) {
        [arrMinutes addObject:[NSString stringWithFormat:@"%@%d",(i<10) ? @"0":@"", i]];
    }
    _arrMinutes = [NSArray arrayWithArray:arrMinutes];
    
    //Set the acutal date
    //_selectedDate = [NSDate date];
}


- (void)buildControl {
    //Create a view as base of the picker
    UIImageView *pickerView = [[UIImageView alloc] initWithFrame:CGRectMake(self.current_w/2-150, PICKER_ORIGIN_Y, 300, PICKER_HEIGHT)];
    [pickerView setImage:[UIImage imageNamed:@"bg_time@2x.png"]];
    [pickerView setUserInteractionEnabled:YES];
    
    //Create bar selector
    UIView *barSel = [[UIView alloc] initWithFrame:CGRectMake(0.0, BAR_SEL_ORIGIN_Y, self.frame.size.width, VALUE_HEIGHT)];
    [barSel setBackgroundColor:[UIColor clearColor]];
    
    
    //Create the first column (moments) of the picker
    _svMoments = [[MGPickerScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, SV_MOMENTS_WIDTH, PICKER_HEIGHT) andValues:_arrMoments withTextAlign:NSTextAlignmentCenter andTextSize:25.0];
    _svMoments.tag = 0;
    [_svMoments setDelegate:self];
    [_svMoments setDataSource:self];
    
    //Create the second column (hours) of the picker
    _svHours = [[MGPickerScrollView alloc] initWithFrame:CGRectMake(SV_MOMENTS_WIDTH, 0.0, SV_HOURS_WIDTH, PICKER_HEIGHT) andValues:_arrHours withTextAlign:NSTextAlignmentCenter  andTextSize:25.0];
    _svHours.tag = 1;
    [_svHours setDelegate:self];
    [_svHours setDataSource:self];
    
    //Create the third column (minutes) of the picker
    _svMins = [[MGPickerScrollView alloc] initWithFrame:CGRectMake(_svHours.frame.origin.x+SV_HOURS_WIDTH, 0.0, SV_MINUTES_WIDTH, PICKER_HEIGHT) andValues:_arrMinutes withTextAlign:NSTextAlignmentCenter andTextSize:25.0];
    _svMins.tag = 2;
    [_svMins setDelegate:self];
    [_svMins setDataSource:self];
   
    //Add pickerView
    [self addSubview:pickerView];
    
    //Add the bar selector
    [pickerView addSubview:barSel];
    
    //Add scrollViews
    [pickerView addSubview:_svMoments];
    [pickerView addSubview:_svHours];
    [pickerView addSubview:_svMins];
    //[pickerView addSubview:_svMeridians];
    UIImageView *shadowImgView = [[UIImageView alloc] initWithFrame:pickerView.frame];
    [shadowImgView setImage:[UIImage imageNamed:@"bg_time_shadow@2x.png"]];
    [self addSubview:shadowImgView];
    
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.current_w/2-150, pickerView.current_h/2-5, 300, 10)];
    [lineImgView setImage:[UIImage imageNamed:@"bg_time_line@2x.png"]];
    [self addSubview:lineImgView];
    
    //Set the time to now
    [self setTime:NOW];
    //[self switchToDay:0];
    
    [self setUserInteractionEnabled:YES];
}



#pragma mark - Other methods

//Save button pressed
- (void)saveDate {
    
    //Create date
    NSDate *date = [self createDateWithFormat:DATE_FORMATTER andDateString:@"%@%@:%@:00"];
    
    //Send the date to the delegate
    if([_delegate respondsToSelector:@selector(conferenceDatePicker:saveDate:)])
        [_delegate conferenceDatePicker:self saveDate:date];
}
//Get Date
- (NSDate *)getCurrentDate
{
    return [self createDateWithFormat:DATE_FORMATTER andDateString:@"%@%@%@00"];
}
//Center the value in the bar selector
- (void)centerValueForScrollView:(MGPickerScrollView *)scrollView {
    
    //Takes the actual offset
    float offset = scrollView.contentOffset.y;
    
    //Removes the contentInset and calculates the prcise value to center the nearest cell
    offset += scrollView.contentInset.top;
    int mod = (int)offset%(int)VALUE_HEIGHT;
    float newValue = (mod >= VALUE_HEIGHT/2.0) ? offset+(VALUE_HEIGHT-mod) : offset-mod;
    
    //Calculates the indexPath of the cell and set it in the object as property
    NSInteger indexPathRow = (int)(newValue/VALUE_HEIGHT);
    
    //Center the cell
    [self centerCellWithIndexPathRow:indexPathRow forScrollView:scrollView];
}

//Center phisically the cell
- (void)centerCellWithIndexPathRow:(NSUInteger)indexPathRow forScrollView:(MGPickerScrollView *)scrollView {
    
    if(indexPathRow >= [scrollView.arrValues count]) {
        indexPathRow = [scrollView.arrValues count]-1;
    }
    
    float newOffset = indexPathRow*VALUE_HEIGHT;
    
    //Re-add the contentInset and set the new offset
    newOffset -= BAR_SEL_ORIGIN_Y;
    
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        if (![_svMins isScrolling] && ![_svHours isScrolling]) {
            [_svMoments setUserInteractionEnabled:YES];
            [_svMoments setAlpha:1.0];
        }
        //Highlight the cell
        [scrollView highlightCellWithIndexPathRow:indexPathRow];
        
        [scrollView setUserInteractionEnabled:YES];
        [scrollView setAlpha:1.0];
    }];
    
    [scrollView setContentOffset:CGPointMake(0.0, newOffset) animated:YES];
    
    [CATransaction commit];
    
}

//Return a date from a string
- (NSDate *)createDateWithFormat:(NSString *)format andDateString:(NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:locale];
    formatter.dateFormat = format;
    NSDate *selectDate;
    switch (_svMoments.tagLastSelected)
    {
        case 0:
            selectDate = [NSDate date];
            break;
        case 1:
            selectDate = [self switchToDay:1 ByDate:[NSDate date]];
            break;
        case 2:
            selectDate = [self switchToDay:2 ByDate:[NSDate date]];
            break;
        default:
            break;
    }
    NSString *dateStr =[NSString stringWithFormat:dateString,
                        [self stringFromDate:selectDate withFormat:@"yyyyMMdd"],
                        _arrHours[_svHours.tagLastSelected],
                        _arrMinutes[_svMins.tagLastSelected]
                        ];
    return [formatter dateFromString:dateStr
            ];
}


//Return a string from a date
- (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:locale];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

//Set the time automatically
- (void)setTime:(NSString *)time {
    //Get the string
    NSString *strTime;
    if([time isEqualToString:NOW])
        strTime = [self stringFromDate:[NSDate date] withFormat:@"HH:mm "];
    else
        strTime = (NSString *)time;
    
    //Split
    NSArray *comp = [strTime componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" :"]];
    
    //Set the tableViews
    [_svHours dehighlightLastCell];
    [_svMins dehighlightLastCell];
    
    //Center the other field
    [self centerCellWithIndexPathRow:[comp[0] intValue] forScrollView:_svHours];
    [self centerCellWithIndexPathRow:[comp[1] intValue] forScrollView:_svMins];
}

//Switch to the previous or next day
- (NSDate *)switchToDay:(NSInteger)dayOffset ByDate:(NSDate *)date{
    //Calculate and save the new date
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [NSDateComponents new];
    
    //Set the offset
    [offsetComponents setDay:dayOffset];
    
    NSDate *newDate = [gregorian dateByAddingComponents:offsetComponents toDate:date options:0];
    return newDate;
    
}
//Check the screen size
- (void)checkScreenSize {
    if(IS_WIDESCREEN) {
        PICKER_HEIGHT = 80;
    } else {
        PICKER_HEIGHT = 80;
    }
}

- (void)setSelectedDate:(NSDate *)date {
    _selectedDate = date;
    //[self switchToDay:0];
    
    NSString *strTime = [self stringFromDate:date withFormat:@"HH:mm"];
    [self setTime:strTime];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_svMoments setUserInteractionEnabled:NO];
    [_svMoments setAlpha:0.5];
    
//    if (scrollView == _svMoments) {
//        [_svMins setUserInteractionEnabled:NO];
//        [_svHours setUserInteractionEnabled:NO];
//        
//        [_svMins setAlpha:0.5];
//        [_svHours setAlpha:0.5];
//    }
    
    if (![scrollView isDragging]) {
        NSLog(@"didEndDragging");
        [(MGPickerScrollView *)scrollView setScrolling:NO];
        [self centerValueForScrollView:(MGPickerScrollView *)scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"didEndDecelerating");
    [(MGPickerScrollView *)scrollView setScrolling:NO];
    [self centerValueForScrollView:(MGPickerScrollView *)scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    MGPickerScrollView *sv = (MGPickerScrollView *)scrollView;
    [sv setScrolling:YES];
    [sv dehighlightLastCell];
}

#pragma - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MGPickerScrollView *sv = (MGPickerScrollView *)tableView;
    return [sv.arrValues count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"reusableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    MGPickerScrollView *sv = (MGPickerScrollView *)tableView;
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setFont:sv.cellFont];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell.textLabel setTextColor:(indexPath.row == sv.tagLastSelected) ? SELECTED_TEXT_COLOR : TEXT_COLOR];
    [cell.textLabel setText:sv.arrValues[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return VALUE_HEIGHT;
}

@end
