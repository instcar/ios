//
//  RouteAnnotation.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-5-3.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "BMKPointAnnotation.h"

@interface RouteAnnotation : BMKPointAnnotation
{
	int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点 6:自定义点 7.聚点
	int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@property (strong, nonatomic) NSString *subTitle;//
@end
