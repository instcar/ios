//
//  City.h
//  GaoDeMap
//
//  Created by cty on 14-2-17.
//  Copyright (c) 2014年 cty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarD : NSObject

@property(copy, nonatomic) NSString *name;//名称
@property(copy, nonatomic) NSString *letter;//拼音
@property(copy, nonatomic) NSString *icon;//头像
@property(copy, nonatomic) NSString *aliasname;//别名

- (id)initWithDic:(NSDictionary *)dic;
+ (NSArray *)initWithArray:(NSArray *)array;

@end
