//
//  DateSelectControl.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-26.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "DateSelectControl.h"

#define kTlableTag 20000
#define kDlableTag 30000

@implementation DateSelectControl

-(void)dealloc
{

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _canEidt = YES;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [btn setTag:8888];
        [btn setBackgroundImage:[[UIImage imageNamed:@"btn_input_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 22, 5, 22)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[[UIImage imageNamed:@"btn_input_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 22, 5, 22)] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(dateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
       
        //timeConstain
        UIView * timeConstain = [[UIView alloc]initWithFrame:CGRectMake(10, 0,self.frame.size.width-20, self.frame.size.height)];
        timeConstain.tag = 50000;
        timeConstain.center = btn.center;
        timeConstain.userInteractionEnabled = NO;
        [self addSubview:timeConstain];
        
//        [self reloadView];
        
        //定时
        NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
        dateFormate.dateFormat = @"HH:mm";
        NSString *dateStr = [dateFormate stringFromDate:[NSDate date]];
        
        
        UIImageView *timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(4, (timeConstain. frame.size.height-30)/2.0+4, 22, 22)];
        [timeImageView setImage:[UIImage imageNamed:@"ic_time_gray@2x"]];
        [timeImageView setBackgroundColor:[UIColor clearColor]];
        [timeImageView setUserInteractionEnabled:NO];
        [timeConstain addSubview:timeImageView];
        
        UILabel *dlable = [[UILabel alloc]init];
        [dlable setTag:kDlableTag];
        [dlable setFrame:CGRectMake(10, (timeConstain.frame.size.height-30)/2+5, timeConstain.frame.size.width/2.-30, 30)];
        [dlable setTextAlignment:NSTextAlignmentRight];
        [dlable setFont:[UIFont fontWithName:kFangZhengFont size:10]];
        [dlable setTextColor:[UIColor textGreenColor]];
        
        NSDate *date = [NSDate date];
        if (self.selectTime) {
            date = [AppUtility dateFromStr:_selectTime withFormate:@"HH:mm"];
        }
        
        NSInteger hours = [[[[AppUtility strFromDate:date withFormate:@"HH:mm"] componentsSeparatedByString:@":"]objectAtIndex:0]intValue];
        
//        if (self.selectDay == nil) {
//            self.selectDay = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"今天" forKey:@"dd"], nil];
//        }
        
        [dlable setText: hours <=12 ?@"上午":@"下午"];
        [dlable setBackgroundColor:[UIColor clearColor]];
        [dlable setUserInteractionEnabled:NO];
        [timeConstain addSubview:dlable];
        
        UILabel *tlable = [[UILabel alloc]init];
        [tlable setTag:kTlableTag];
        [tlable setFrame:CGRectMake(dlable.frame.origin.x+dlable.frame.size.width+5, (self.frame.size.height-30)/2, timeConstain.frame.size.width/2., 30)];
        [tlable setTextAlignment:NSTextAlignmentLeft];
        [tlable setFont:[UIFont fontWithName:kFangZhengFont size:18]];
        [tlable setTextColor:[UIColor textGreenColor]];
        [tlable setText:dateStr];
        [tlable setBackgroundColor:[UIColor clearColor]];
        [tlable setUserInteractionEnabled:NO];
        [timeConstain addSubview:tlable];

        [self refreshView];
    }
    return self;
}

-(void)setDate:(NSDate *)date
{
    if (date) {
        _date = [date copy];
    }
    NSArray * dateArray = [NSArray arrayWithObjects:[AppUtility dayStrTimeDate:self.date], nil];
    NSString * timeString = [AppUtility strFromDate:self.date withFormate:@"HH:mm"];
    [self setSelectDay:dateArray andSelectTime:timeString];
}

-(void)reloadView
{
    UIView *timeConstain = [self viewWithTag:50000];
    
    for (UIView *obj in timeConstain.subviews) {
        if (![obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }
    
    if ([_selectDay count] > 0) {
        
        UILabel *wlable = [[UILabel alloc]init];
        [wlable setFrame:CGRectMake(0, (timeConstain.frame.size.height-30)/2, timeConstain.frame.size.width/2, 30)];
        [wlable setTextAlignment:NSTextAlignmentCenter];
        [wlable setFont:[UIFont fontWithName:kFangZhengFont size:10]];
        [wlable setTextColor:[UIColor blackColor]];
        [wlable setBackgroundColor:[UIColor clearColor]];
        [wlable setText:[self stringFromNSArray:_selectDay]];
        [wlable setUserInteractionEnabled:NO];
        
        if ([self getWidthFromLable:wlable withStr:[self stringFromNSArray:_selectDay]] > timeConstain.frame.size.width/2) {
            float width = [self getWidthFromLable:wlable withStr:[self stringFromNSArray:_selectDay]];
            [wlable setFrame:CGRectMake(0, (timeConstain.frame.size.height-30)/2, width, 30)];
        }
        [timeConstain addSubview:wlable];
        
        UILabel *tlable = [[UILabel alloc]init];
        [tlable setFrame:CGRectMake(wlable.frame.size.width, (timeConstain.frame.size.height-30)/2, timeConstain.frame.size.width-wlable.frame.size.width, 30)];
        [tlable setTextAlignment:NSTextAlignmentCenter];
        [tlable setFont:[UIFont systemFontOfSize:22]];
        [tlable setTextColor:[UIColor flatGreenColor]];
        [tlable setBackgroundColor:[UIColor clearColor]];
        [tlable setText:_selectTime];
        [tlable setUserInteractionEnabled:NO];
        [timeConstain addSubview:tlable];
    }
    else
    {
        NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
        dateFormate.dateFormat = @"HH:mm";
        NSString *dateStr = [dateFormate stringFromDate:[NSDate date]];
        
        UIImageView *timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(4, (timeConstain. frame.size.height-30)/2.0+4, 22, 22)];
        [timeImageView setImage:[UIImage imageNamed:@"ic_time_gray"]];
        [timeImageView setBackgroundColor:[UIColor clearColor]];
        [timeImageView setUserInteractionEnabled:NO];
        [timeConstain addSubview:timeImageView];
        
        UILabel *dlable = [[UILabel alloc]init];
        [dlable setFrame:CGRectMake(10, (timeConstain.frame.size.height-30)/2+5, timeConstain.frame.size.width/2.-30, 30)];
        [dlable setTextAlignment:NSTextAlignmentRight];
        [dlable setFont:[UIFont fontWithName:kFangZhengFont size:10]];
        [dlable setTextColor:[UIColor flatGreenColor]];
        
        
        NSDate *date = [AppUtility dateFromStr:_selectTime withFormate:@"HH:mm"];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *weekdayComponents = [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:date];
        NSInteger hours = [weekdayComponents hour];

        [dlable setText: hours <=12 ?@"上午":@"下午"];
        [dlable setBackgroundColor:[UIColor clearColor]];
        [dlable setUserInteractionEnabled:NO];
        [timeConstain addSubview:dlable];
        
        UILabel *tlable = [[UILabel alloc]init];
        [tlable setFrame:CGRectMake(dlable.frame.origin.x+dlable.frame.size.width, (self.frame.size.height-30)/2, timeConstain.frame.size.width/2., 30)];
        [tlable setTextAlignment:NSTextAlignmentLeft];
        [tlable setFont:[UIFont systemFontOfSize:22]];
        [tlable setTextColor:[UIColor flatGreenColor]];
        [tlable setText:dateStr];
        [tlable setBackgroundColor:[UIColor clearColor]];
        [tlable setUserInteractionEnabled:NO];
        [timeConstain addSubview:tlable];
    }
}


-(void)refreshView
{
   
    if (self.selectDay) {
         UILabel *dlable = (UILabel *)[self viewWithTag:kDlableTag];
        [dlable setText:[self stringFromNSArray:_selectDay]];
    }
    
    if(self.selectTime)
    {
        UILabel *tlable = (UILabel *)[self viewWithTag:kTlableTag];
        [tlable setText:self.selectTime];
    }
}

- (float)getWidthFromLable:(UILabel *)lable withStr:(NSString *)str
{
   CGSize constraint = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
   CGSize size = [str sizeWithFont:lable.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size.width;
}

- (NSString *)stringFromNSArray:(NSArray *)array
{
    NSString *str = @"";
    for (NSString *string in array) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@" %@",string]];
    }
    return str;
}

-(void)setSelectDay:(NSArray *)selectDay andSelectTime:(NSString *)selectTime
{
    self.selectDay = selectDay;
    self.selectTime = selectTime;
    [self refreshView];
}

-(void)setCanEidt:(BOOL)canEidt
{
    _canEidt = canEidt;

    UIButton * btn = (UIButton *)[self viewWithTag:8888];
    btn.userInteractionEnabled = canEidt;
    if (!_canEidt) {
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_empty@2x"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_empty@2x"] forState:UIControlStateHighlighted];
    }
    else
    {
        [btn setBackgroundImage:[[UIImage imageNamed:@"btn_input_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 22, 5, 22)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[[UIImage imageNamed:@"btn_input_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 22, 5, 22)] forState:UIControlStateHighlighted];
    }
    
}

-(void)dateBtnAction:(UIButton *)sender
{
    if (self.target && self.btnAction) {
        [self.target performSelector:self.btnAction withObject:sender afterDelay:0];
    }
}

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    self.target = target;
    self.btnAction = action;
}

@end
