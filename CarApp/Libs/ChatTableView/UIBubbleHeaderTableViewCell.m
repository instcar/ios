//
//  UIBubbleHeaderTableViewCell.m
//  UIBubbleTableViewExample
//
//  Created by MacPro-Mr.Lu on 13-11-21.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import "UIBubbleHeaderTableViewCell.h"

@interface UIBubbleHeaderTableViewCell ()

@property (nonatomic, retain) UILabel *timerlable;

@end

@implementation UIBubbleHeaderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _timerlable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, [UIBubbleHeaderTableViewCell height])];
        [_timerlable setFont:[UIFont fontWithName:kFangZhengFont size:12]];
        [_timerlable setBackgroundColor:[UIColor clearColor]];
        [_timerlable setTextColor:[UIColor lightGrayColor]];
        [_timerlable setBackgroundColor:[UIColor clearColor]];
        [_timerlable setTextAlignment:NSTextAlignmentCenter];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_timerlable];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

+ (CGFloat)height
{
    return 20.0;
}

-(void)setDate:(NSDate *)date
{
    if (date) {
        _date = date;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm "];
//    DLog(@"date count:%d",_date.retainCount);
    NSString *dateStr = [dateFormatter stringFromDate:_date];
    [self.timerlable setText:dateStr];
}


-(void)setLocate:(CLLocationCoordinate2D)locate
{
//    NSString * distance = @"";
//    //显示定位信息
//    if (locate.longitude != 0.0 && locate.latitude != 0.0)
//    {
//        if([[NSUserDefaults standardUserDefaults]valueForKey:@"location"])
//        {
//            //计算相距多少远距离
//            if (locate.longitude != 0.0 && locate.latitude != 0.0) {
//                float lon1 = locate.longitude;
//                float lat1 = locate.latitude;
//                NSDictionary * locationDic = [[NSUserDefaults standardUserDefaults]valueForKey:@"location"];
//                float lon2 = [[locationDic valueForKey:@"lng"]floatValue];
//                float lat2 = [[locationDic valueForKey:@"lat"]floatValue];
//                distance = [XYCommon LantitudeLongitudeDist:lon1 other_Lat:lat1 self_Lon:lon2 self_Lat:lat2];
//            }
//            else
//            {
//                distance = @"";
//            }
//            
//        }else
//        {
//            distance = @"";
//        }
//
//    }
//
//    self.timerlable.text  = [self.timerlable.text stringByAppendingString:[NSString stringWithFormat:@"     %@",distance]];
}

@end
