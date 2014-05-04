//
//  ProfileViewController.h
//  CarApp
//
//  Created by leno on 13-10-9.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface ProfileViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    BOOL _isEditing; //
    UITableView  *_profileTable;
}
@property (strong, nonatomic) NSMutableDictionary *formData;    //请求参数变化

@property(assign,nonatomic)float uid; //查看的时候本人的还是 他人的，自己的显示编辑按钮 不是自己的不显示编辑按钮

@property(assign,nonatomic)int state; //1、不显示退出退出按钮 2、显示退出按钮 1状态实现单人聊天

@end
