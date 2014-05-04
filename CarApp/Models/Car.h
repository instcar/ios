//
//  Car.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-28.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Car : NSObject

@property (assign, nonatomic) int ID;                           //id
@property (assign, nonatomic) long user_id;                     //用户id
@property (copy, nonatomic) NSString *license;                  //车辆序号
@property (assign, nonatomic) int car_id;                       //车辆id
@property (strong, nonatomic) NSDictionary *info;                     //信息
@property (assign, nonatomic) int status;                       //审核状态 0通过 1审核中 2拒绝
@property (copy, nonatomic) NSString *name;                     //品牌
@property (copy, nonatomic) NSString *picture;                  //图片

//@property (copy, nonatomic) NSString *addtime;
//@property (copy, nonatomic) NSString *modtime;

- (id)initWithDic:(NSDictionary *)dic;

+ (NSArray *)initWithArray:(NSArray *)array;
@end
