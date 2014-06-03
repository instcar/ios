//
//  SelectPassengerNumPicker.m
//  CarApp
//
//  Created by Mac_ZL on 14-5-22.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "SelectPassengerNumPicker.h"

//Editable constants
static const float NUM_PICKER_VALUE_HEIGHT = 40.0;
static const float NUM_PICKER_SV_WIDTH = 100.0;
//Editable values
float NUM_PICKER_HEIGHT = 80.0;
NSString *NUM_PICKER_FONT_NAME = @"HelveticaNeue";
//Static macros and constants
#define SELECTOR_ORIGIN (NUM_PICKER_HEIGHT/2.0-NUM_PICKER_VALUE_HEIGHT/2.0)
#define NUM_PICKER_ORIGIN_Y 0
#define BAR_SEL_ORIGIN_Y NUM_PICKER_HEIGHT/2.0-NUM_PICKER_VALUE_HEIGHT/2.0

//Editable macros
#define TEXT_COLOR [UIColor colorWithWhite:0.5 alpha:1.0]
#define SELECTED_TEXT_COLOR [UIColor whiteColor]
#define MAX_COUNT 4

@interface PickerScrollView ()

@property (nonatomic, strong) NSArray *arrValues;
@property (nonatomic, strong) UIFont *cellFont;
@property (nonatomic, assign, getter = isScrolling) BOOL scrolling;

@end


@implementation PickerScrollView

//Constants
const float NUM_PICKER_LBL_BORDER_OFFSET = 8.0;

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
        
        _cellFont = [UIFont fontWithName:NUM_PICKER_FONT_NAME size:txtSize];
        
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

@interface SelectPassengerNumPicker()

@property(strong, nonatomic) NSArray *passengerNumArray;
@property(strong, nonatomic) PickerScrollView *passengerSV;
@property(strong, nonatomic) UIView *passengerView;

@end
@implementation SelectPassengerNumPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        /*
         * 修改 MAX_COUNT 就可改变乘客数
         */
        NSMutableArray *tmpArray =[[NSMutableArray alloc] initWithCapacity:0];
        for (int i=1; i<=MAX_COUNT; i++)
        {
            [tmpArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _passengerNumArray = [NSArray arrayWithArray:tmpArray];
        
        UIImageView *pickerView = [[UIImageView alloc] initWithFrame:CGRectMake(self.current_w/2-150, NUM_PICKER_ORIGIN_Y, 300, NUM_PICKER_HEIGHT)];
        [pickerView setImage:[UIImage imageNamed:@"bg_user@2x.png"]];
        [pickerView setUserInteractionEnabled:YES];
        
        //Create bar selector
        UILabel *barSel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, BAR_SEL_ORIGIN_Y, 40, NUM_PICKER_VALUE_HEIGHT)];
        [barSel setFont:[UIFont systemFontOfSize:14]];
        [barSel setText:@"人"];
        [barSel setTextColor:SELECTED_TEXT_COLOR];
        [barSel setBackgroundColor:[UIColor clearColor]];
        
        
        //Create the first column (moments) of the picker
        _passengerSV = [[PickerScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, NUM_PICKER_SV_WIDTH, NUM_PICKER_HEIGHT) andValues:_passengerNumArray withTextAlign:NSTextAlignmentCenter andTextSize:25.0];
        _passengerSV.tag = 0;
        [_passengerSV setDelegate:self];
        [_passengerSV setDataSource:self];
        
        _passengerView = [[UIView alloc] initWithFrame:CGRectMake(_passengerSV.current_x_w, 0, pickerView.current_w-_passengerSV.current_w, NUM_PICKER_HEIGHT)];
        [_passengerView setBackgroundColor:[UIColor clearColor]];
        
        //Add pickerView
        [self addSubview:pickerView];
    
        //Add the bar selector
        [pickerView addSubview:barSel];
        
        //Add scrollViews
        [pickerView addSubview:_passengerSV];
        [pickerView addSubview:_passengerView];
        
        UIImageView *shadowImgView = [[UIImageView alloc] initWithFrame:pickerView.frame];
        [shadowImgView setImage:[UIImage imageNamed:@"bg_passenger_shadow@2x.png"]];
        [self addSubview:shadowImgView];
        
        [self setUserInteractionEnabled:YES];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
//Set the PassengerNum automatically
- (void)setPassengerNum:(int) num
{
    //Set the tableViews
    [_passengerSV dehighlightLastCell];
    
    //Center the other field
    [self centerCellWithIndexPathRow:num-1 forScrollView:_passengerSV];
    

}
- (int)getPassengetNum
{
    return [_passengerNumArray[_passengerSV.tagLastSelected] intValue];
}
- (void) changePassengerViewWithPassengerNum:(int) num
{
    
    if (num > MAX_COUNT )
    {
        num = MAX_COUNT;
        
    }
    for (UIView *view in [_passengerView subviews])
    {
        [view removeFromSuperview];
    }
    for (int i = 0; i<MAX_COUNT; i++)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*50, 0, 50, 80)];
        NSString *imgName = i<num?@"ic_seat_done@2x.png":@"ic_seat_empty@2x.png";
        [imgView setImage:[UIImage imageNamed:imgName]];
        [_passengerView addSubview:imgView];
    }
    
}


//Center the value in the bar selector
- (void)centerValueForScrollView:(PickerScrollView *)scrollView {
    
    //Takes the actual offset
    float offset = scrollView.contentOffset.y;
    
    //Removes the contentInset and calculates the prcise value to center the nearest cell
    offset += scrollView.contentInset.top;
    int mod = (int)offset%(int)NUM_PICKER_VALUE_HEIGHT;
    float newValue = (mod >= NUM_PICKER_VALUE_HEIGHT/2.0) ? offset+(NUM_PICKER_VALUE_HEIGHT-mod) : offset-mod;
    
    //Calculates the indexPath of the cell and set it in the object as property
    NSInteger indexPathRow = (int)(newValue/NUM_PICKER_VALUE_HEIGHT);
    
    //Center the cell
    [self centerCellWithIndexPathRow:indexPathRow forScrollView:scrollView];
}

//Center phisically the cell
- (void)centerCellWithIndexPathRow:(NSUInteger)indexPathRow forScrollView:(PickerScrollView *)scrollView {
    
    if(indexPathRow >= [scrollView.arrValues count]) {
        indexPathRow = [scrollView.arrValues count]-1;
    }
    
    float newOffset = indexPathRow*NUM_PICKER_VALUE_HEIGHT;
    
    //Re-add the contentInset and set the new offset
    newOffset -= BAR_SEL_ORIGIN_Y;
    
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        //Highlight the cell
        [scrollView highlightCellWithIndexPathRow:indexPathRow];
        
        [scrollView setUserInteractionEnabled:YES];
        [scrollView setAlpha:1.0];
    }];
    
    [scrollView setContentOffset:CGPointMake(0.0, newOffset) animated:YES];
    
    [CATransaction commit];
    
    [self changePassengerViewWithPassengerNum:indexPathRow+1];
    
}
#pragma - UITableViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (![scrollView isDragging]) {
        NSLog(@"didEndDragging");
        [(PickerScrollView *)scrollView setScrolling:NO];
        [self centerValueForScrollView:(PickerScrollView *)scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"didEndDecelerating");
    [(PickerScrollView *)scrollView setScrolling:NO];
    [self centerValueForScrollView:(PickerScrollView *)scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    PickerScrollView *sv = (PickerScrollView *)scrollView;
    [sv setScrolling:YES];
    [sv dehighlightLastCell];
}

#pragma - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PickerScrollView *sv = (PickerScrollView *)tableView;
    return [sv.arrValues count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"reusableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    PickerScrollView *sv = (PickerScrollView *)tableView;
    
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
    return NUM_PICKER_VALUE_HEIGHT;
}

@end
