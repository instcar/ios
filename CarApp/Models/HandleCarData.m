//
//  HandleCityData.m
//  GaoDeMap
//
//  Created by cty on 14-2-20.
//  Copyright (c) 2014年 cty. All rights reserved.
//

#import "HandleCarData.h"

//按字母排序方法
NSInteger nickNameSort(id user1, id user2, void *context)
{
    CarD *u1,*u2;
    //类型转换
    u1 = (CarD*)user1;
    u2 = (CarD*)user2;
    return  [u1.letter localizedCompare:u2.letter];
}
@implementation HandleCarData
-(NSArray *)carDataDidHandled
{
    storeCars = [[NSMutableArray alloc] init];
    //读取本地文件
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"cardict" ofType:@"plist"];
    NSArray *result = [CarD initWithArray:[NSArray arrayWithContentsOfFile:filePath]];
    
    for (int i = 0; i < [result count]; i++) {
        
        CarD *car = [result objectAtIndex:i];
        //汉字转拼音，比较排序时候用
        NSMutableString *ms = [[NSMutableString alloc] initWithString:car.name];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
        }
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
            car.letter = ms;
        }
        //都放在存储数组里
        [storeCars addObject:car];
    }

    //排序后的数组初始化
    NSArray * newArr = [[NSArray alloc] init];
    //排序
    newArr = [storeCars sortedArrayUsingFunction:nickNameSort context:NULL];
    //分组数组初始化
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    //开头字母初始化
    _sectionHeadsKeys = [[NSMutableArray alloc] init];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    for(int index = 0; index < [newArr count]; index++)
    {
        CarD *chineseStr = (CarD *)[newArr objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.letter];
        //取首字母
        NSString *sr= [strchar substringToIndex:1];
        //bNSLog(@"%@",sr);        //sr containing here the first character of each string
        //检查数组内是否有该首字母，没有就创建
        if(![_sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            //不存在就添加进去
            [_sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] initWithObjects:nil];
            checkValueAtIndex = NO;
        }
        //有就把数据添加进去
        if([_sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[newArr objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    NSArray * array = [NSArray arrayWithObjects:_sectionHeadsKeys,arrayForArrays,storeCars, nil];
    return array;
}
@end
