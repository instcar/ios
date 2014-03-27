//
//  CarImageViewController.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-3-6.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarImageViewController : UIViewController<UIScrollViewDelegate>

// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;

// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
@property (nonatomic, strong) NSArray *photoDics;

// 显示
//- (void)show;

@end
