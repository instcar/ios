//
//  PListSettingView.h
//  PRJ_MrLu_GroupChat
//
//  Created by MacPro-Mr.Lu on 13-11-25.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kPListEventClose = 10,
    kPListEventOpened = 11,
    kPListEventNull =12,
    kplistEventChangerTime = 13
}kPListEvent;

@protocol PListSettingViewDelegate;

@interface PListSettingView : UIView

@property (assign, nonatomic) BOOL canEdit;
@property (retain, nonatomic) NSArray *personArray;
@property (retain, nonatomic) NSDictionary *roomMaster;
@property (assign, nonatomic) int seatNum;
@property (assign, nonatomic) id<PListSettingViewDelegate> delegate;

-(void)setPersonArray:(NSArray *)personArray RoomMaster:(NSDictionary *)roomMaster Seats:(int)seatNum;

@end

@protocol PListSettingViewDelegate<NSObject>

/**
 *	按钮点击事件
 *
 *	@param	plistSettingView	视图
 *	@param	index	那个对象
 *	@param	event	操作类型 1关闭 2踢出去
 */
-(void)PListSettingViewDelegate:(PListSettingView *)plistSettingView index:(int)index event:(kPListEvent)event;

@end