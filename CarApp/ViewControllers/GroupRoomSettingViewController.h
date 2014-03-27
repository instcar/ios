//
//  GroupRoomSettingViewController.h
//  PRJ_MrLu_GroupChat
//
//  Created by MacPro-Mr.Lu on 13-11-25.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTimeViewController.h"
#import "PListSettingView.h"

@protocol GroupRoomSettingVCDelegate;

@interface GroupRoomSettingViewController : UIViewController<UIAlertViewDelegate,BMKMapViewDelegate>
{
    int _currentPeople;

    NSArray * _dayArray;
    NSArray * _hourArray;
    NSArray * _minuteArray;
    
    BOOL _editBtnState;
}

@property (assign, nonatomic) long roomid;
@property (assign, nonatomic) BOOL isroomMaster;
@property (assign, nonatomic) id<GroupRoomSettingVCDelegate> delegate;
@property (assign, nonatomic) UIViewController *groupVC;

//@property(retain,nonatomic)NSArray * usersArray;
//@property(retain,nonatomic)Line *line;
//@property(retain,nonatomic)Room *room;

@end

@protocol GroupRoomSettingVCDelegate<NSObject>

-(void)groupRoomSettingVC:(GroupRoomSettingViewController *)groupRoomSettingVC sanderMessageEvent:(kPListEvent)event;

@end

