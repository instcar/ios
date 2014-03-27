//
//  NSObject+Helper.m
//  TestDemo
//
//  Created by YDJ on 12-11-22.
//  Copyright (c) 2012年 jingyoutimes. All rights reserved.
//

#import "NSObject+Helper.h"
#import <objc/runtime.h>

@implementation NSObject (Helper)



-(id)getDataForit:(id)_obj
{

    
    if([[_obj class] isSubclassOfClass:[UIImage class]]||[[_obj class] isSubclassOfClass:[UIView class]]||[[_obj class] isSubclassOfClass:[UIViewController class]]||[[_obj class] isSubclassOfClass:[UIControl class]])
    {
        return nil;
    }
    
    NSString * __vClassName=NSStringFromClass([_obj class]);
    
    if ([__vClassName isEqual:@"__NSCFConstantString"]||[__vClassName isEqual:@"__NSCFNumber"]||[__vClassName isEqual:@"NSNull"]||[__vClassName isEqual:@"NSString"]||[__vClassName isEqual:@"__NSCFString"]) {
       
        return _obj;
    }
    else if ([__vClassName isEqual:@"__NSArrayI"]||[__vClassName isEqual:@"__NSArrayM"]){
                
        NSMutableArray * array__=[NSMutableArray array];
        for (id value__ in _obj) {
            id value__my=[self getDataForit:value__];
            if (value__my!=nil) {
                [array__ addObject:value__my];
            }
        }
        
        return array__;
        
    }
    else if([__vClassName isEqual:@"__NSDictionaryI"]||[__vClassName isEqual:@"__NSDictionaryM"]){
        
        NSDictionary * valueDic__=_obj;
        
        NSMutableDictionary  * dic___=[[NSMutableDictionary alloc] init];
        
        NSArray * array__d=[valueDic__ allKeys];
        
        for (NSString * str__ in array__d) {
            
            id dic__value=[valueDic__ objectForKey:str__];
            
            id result=[self getDataForit:dic__value];
            
            if (result!=nil) {
                [dic___ setObject:result forKey:str__];
            }
            
        }
        
        return dic___;
        
    }
    else{
    
      return  [_obj properties_aps];
    }
    
}

//对象转字典
- (NSDictionary *)properties_aps {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t  property = properties[i];
        const char* propertyName_c = property_getName(property);
        
        const char *attDes= property_getAttributes(property);
        
        NSString * classDes=[NSString stringWithUTF8String:attDes];
        
        NSArray * tempArray = [classDes componentsSeparatedByString:@"\""];
        
        classDes = [[classDes componentsSeparatedByString:@","]objectAtIndex:0];
        
        classDes =[[classDes componentsSeparatedByString:@"T"]objectAtIndex:1];
        
        NSString * nameForClass=nil;
        
        @try {
            if ([classDes isEqual:@"i"]) {
                nameForClass = @"NSNumber";
            }
            if ([classDes isEqual:@"f"]) {
                nameForClass = @"NSNumber";
            }
            if ([classDes hasPrefix:@"@"]) {
                nameForClass=[tempArray objectAtIndex:1];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception:%@",exception.description);
            continue;
        }
        @finally {
           
        }
        
        Class myClass=NSClassFromString(nameForClass);
        
        if([myClass isSubclassOfClass:[UIImage class]]||[myClass isSubclassOfClass:[UIView class]]||[myClass isSubclassOfClass:[UIViewController class]]||[myClass isSubclassOfClass:[UIControl class]])
        {
            continue;
        }
        
        NSString * propertyName=[NSString stringWithUTF8String:propertyName_c];
        id propertyValue = [self valueForKey:propertyName];
        
        if (propertyValue) {
            
            if ([myClass isSubclassOfClass:[NSString class]]||[myClass isSubclassOfClass:[NSNull class]]||[myClass isSubclassOfClass:[NSNumber class]]) {
                [props setObject:propertyValue forKey:propertyName];
            }
            else if ([myClass isSubclassOfClass:[NSArray class]]||[myClass isSubclassOfClass:[NSDictionary class]]){
                 id tempArray__=[self getDataForit:propertyValue];
                if (tempArray) {
                    [props setObject:tempArray__ forKey:propertyName];
                }
            }
            else{
                
                NSDictionary * proDictionary= [propertyValue properties_aps];
                if (proDictionary) {
                    [props setObject:proDictionary forKey:propertyName];
                }
                else{
                    [props setObject:[NSNull null] forKey:propertyName];
                }
            }
        }
        else{
            [props setObject:[NSNull null] forKey:propertyName];
        }
        
    }
    free(properties);
    return props;
}

@end
