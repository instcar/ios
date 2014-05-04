//
//  CarType.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-5-1.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarType : NSObject

@property (assign, nonatomic) int ID; //id
@property(copy, nonatomic) NSString *name;//名称
@property(copy, nonatomic) NSString *picture;//头像
@property(copy, nonatomic) NSString *parent_brand;//父类
@property (copy, nonatomic) NSString *brand;//品牌
@property (copy, nonatomic) NSString *series;//系列

- (id)initWithDic:(NSDictionary *)dic;
+ (NSArray *)initWithArray:(NSArray *)array;

@end
