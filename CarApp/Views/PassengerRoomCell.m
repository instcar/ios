//
//  PassengerRoomCell.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-29.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import "PassengerRoomCell.h"

@implementation PassengerRoomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        // Initialization code
        self.imagerView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.imagerView setFrame:CGRectMake(10, 10, 60, 60)];
        [self.imagerView setBackgroundColor:[UIColor flatGrayColor]];
        [self.imagerView.layer setCornerRadius:30];
        [self.imagerView.layer setMasksToBounds:YES];
//        [self.imagerView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//        [self.imagerView.layer setBorderWidth:1.0];
        [self.contentView addSubview:self.imagerView];
        
        self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 150, 12)];
        [self.nameLable setBackgroundColor:[UIColor clearColor]];
        [self.nameLable setTextAlignment:NSTextAlignmentLeft];
        [self.nameLable setTextColor:[UIColor colorWithRed:36.0/255.0 green:36.0/255.0 blue:36.0/255.0 alpha:1]];
        [self.nameLable setFont:[UIFont fontWithName:kFangZhengFont size:12]];
        [self.nameLable setClipsToBounds:NO];
        [self.contentView addSubview:self.nameLable];
        
        /*
        self.dayLable = [[[UILabel alloc]initWithFrame:CGRectMake(80, 37, 60, 12)]autorelease];
        [self.dayLable setBackgroundColor:[UIColor clearColor]];
        [self.dayLable setTextAlignment:NSTextAlignmentLeft];
        [self.dayLable setTextColor:[UIColor colorWithRed:21./255.0 green:191.0/255.0 blue:211.0/255.0 alpha:1]];
        [self.dayLable setFont:[UIFont fontWithName:kFangZhengFont size:12]];
        [self.contentView addSubview:self.dayLable];
         */
        UILabel *timeDes = [[UILabel alloc]initWithFrame:CGRectMake(250, 10, 60, 12)];
        [timeDes setBackgroundColor:[UIColor clearColor]];
        [timeDes setTextAlignment:NSTextAlignmentLeft];
        [timeDes setTextColor:UIColorFromRGB(0x999999)];
        [timeDes setFont:[UIFont fontWithName:kFangZhengFont size:10]];
        [timeDes setText:@"出发时间:"];
        [timeDes setClipsToBounds:NO];
        
        [self.contentView addSubview:timeDes];
        
        self.timeLable = [[UILabel alloc]initWithFrame:CGRectMake(250, 27, 150, 22)];
        [self.timeLable setBackgroundColor:[UIColor clearColor]];
        [self.timeLable setTextAlignment:NSTextAlignmentLeft];
        [self.timeLable setTextColor:[UIColor appTimerColor:kTimerColorDep0]];
        [self.timeLable setFont:[UIFont boldSystemFontOfSize:24]];
        [self.contentView addSubview:self.timeLable];
        
        self.desLable = [[UITextView alloc]initWithFrame:CGRectMake(80, 30, 160, 30)];
        [self.desLable setBackgroundColor:[UIColor clearColor]];
        [self.desLable setTextAlignment:NSTextAlignmentLeft];
        [self.desLable setTextColor:UIColorFromRGB(0x666666)];
//        [self.desLable setLineBreakMode:NSLineBreakByCharWrapping];
        if (kDeviceVersion >= 7.0) {
            [self.desLable setTextContainerInset:UIEdgeInsetsMake(0, -5, 0, -5)];
        }
        [self.desLable setUserInteractionEnabled:NO];
        [self.desLable setFont:[UIFont fontWithName:kFangZhengFont size:11]];
        [self.desLable setClipsToBounds:NO];
        [self.contentView addSubview:self.desLable];
        
        UILabel *lastSeatTextLable = [[UILabel alloc]initWithFrame:CGRectMake(250, 60, 80, 10)];
        [lastSeatTextLable setBackgroundColor:[UIColor clearColor]];
        [lastSeatTextLable setTextAlignment:NSTextAlignmentLeft];
        [lastSeatTextLable setTextColor:UIColorFromRGB(0x999999)];
        [lastSeatTextLable setFont:[UIFont fontWithName:kFangZhengFont size:10]];
        [lastSeatTextLable setText:@"空位:"];
        [self.contentView addSubview:lastSeatTextLable];
        
        self.lastSeatLable = [[UILabel alloc]initWithFrame:CGRectMake(278, 50, 50, 20)];
        [self.lastSeatLable setBackgroundColor:[UIColor clearColor]];
        [self.lastSeatLable setTextAlignment:NSTextAlignmentLeft];
        [self.lastSeatLable setTextColor:UIColorFromRGB(0x333333)];
        [self.lastSeatLable setFont:[UIFont boldSystemFontOfSize:20]];
        [self.lastSeatLable setClipsToBounds:NO];
        [self.contentView addSubview:self.lastSeatLable];
        
        self.pubTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(80, 60, 80, 10)];
        [self.pubTimeLable setBackgroundColor:[UIColor clearColor]];
        [self.pubTimeLable setTextAlignment:NSTextAlignmentLeft];
        [self.pubTimeLable setTextColor:UIColorFromRGB(0x999999)];
        [self.pubTimeLable setFont:[UIFont fontWithName:kFangZhengFont size:10]];
        [self.pubTimeLable setClipsToBounds:NO];
        [self.contentView addSubview:self.pubTimeLable];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
