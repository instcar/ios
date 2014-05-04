//
//  LocationServer.m
//  WPWProject
//
//  Created by Mr.Lu on 13-7-10.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import "LocationServer.h"

static LocationServer *locationServer = nil;

@implementation LocationServer


+ (LocationServer *)shareInstance
{
	@synchronized(self) {
		if (locationServer == nil) {
			locationServer = [[LocationServer alloc]init];
		}
	}
	return locationServer;
}

#pragma mark
#pragma mark -- 启动定位
-(void)startLocation
{
    self.locate = CLLocationCoordinate2DMake(0.0f, 0.0f);
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];//创建位置管理器
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=1000.0f;
    
    //启动位置更新
    [locationManager startUpdatingLocation];
    self.locationManager = locationManager;

}

/**定位成功调用的代理**/
/**IOS 6.0 以下**/
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
        self.locate  = manager.location.coordinate;
        [self.locationManager stopUpdatingLocation];
        self.locationManager = nil;
        
        //数据存储
        User *user = [User shareInstance];
        user.lon = self.locate.longitude;
        user.lat = self.locate.latitude;
}

/**IOS 6.0 **/
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
        self.locate  = manager.location.coordinate;
        [self.locationManager stopUpdatingLocation];
        self.locationManager = nil;
        
        //数据存储
        User *user = [User shareInstance];
        user.lon = self.locate.longitude;
        user.lat = self.locate.latitude;
        
        //进行网页位置解析
        [self requestWebAnalyze];
}

/**定位失败调用的代理**/
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorString;
    [manager stopUpdatingLocation];
    DLog(@"error:%@, Error: %@ ErrorCode:%d",error,[error localizedDescription],[error code]);
    switch([error code]) {
        case kCLErrorDenied:
        {
            errorString = @"Access to Location Services denied by user";
            UIAlertView * alertView = nil;
            if (kDeviceVersion <= 5.1 && kDeviceVersion >=5.0) {
               alertView  = [[UIAlertView alloc]initWithTitle:@"您的定位服务没有开启,将导致定位相关功能无法正常使用" message:nil delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"去设置", nil];
            }
            else
            {
               alertView = [[UIAlertView alloc]initWithTitle:@"您的定位服务没有开启,将导致定位相关功能无法正常使用" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            }
            [alertView show];
            break;
        }
        case kCLErrorLocationUnknown:
        {
            errorString = @"Location data unavailable";
            break;
        }
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
    manager = nil;
}

#pragma mark - 解析位置
/**ip定位需要用户的外网mac地址，暂时没有加入**/
//+(NSString *)locateIP
//{
//    @try {
//        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.map.baidu.com/location/ip?ak=%@&ip=%@&coor=bd09ll",kBaiDuIpAK,@"202.198.16.3"]]];
//        AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
//           {
//               DLog(@"%@",JSON);
//               if([JSON isKindOfClass:[NSDictionary class]])
//               {
//                   int ret = [[JSON objectForKey:@"flag"] intValue];
//                   if (ret)
//                   {
//                       DLog(@"Success");
//                   }
//                   else
//                   {
//                       DLog(@"result error");
//                   }
//               }
//           }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
//           {
//               DLog(@"error is  %@",error);
//           }];
//        [operation start];
//    }
//}

/**定位成功之后进行位置点的解析操作**/
-(void)requestWebAnalyze
{
    if (self.locate.longitude == 0.0 && self.locate.longitude == 0.0) {
        return;
    }
    
//    [NetWorkManager networkGetUserAddressWithLongitude:self.locate.longitude latitude:self.locate.latitude success:^(BOOL flag, NSDictionary *addressInfo) {
//        /**百度api取得的样例数据，参照解析出来**/
//               /**
//                {
//                "status":"OK",
//                "result":{
//                "location":{
//                "lng":118.17759,
//                "lat":24.491939
//                },
//                "formatted_address":"福建省厦门市思明区吕岭路",
//                "business":"前埔医院,莲前,金山小区",
//                "addressComponent":{
//                "city":"厦门市",
//                "district":"思明区",
//                "province":"福建省",
//                "street":"吕岭路",
//                "street_number":""
//                },
//                "cityCode":194
//                }
//                }
//                **/
//        if (flag) {
//
//               if([addressInfo isKindOfClass:[NSDictionary class]])
//               {
//                   //解析出所需要要的数据，城市/以及街道
//                   NSDictionary * result = addressInfo;
//                   NSDictionary * addressComponent = [result objectForKey:@"addressComponent"];
//                   NSString * city = [addressComponent valueForKey:@"city"];
//                   NSString *province = [addressComponent valueForKey:@"province"];
//                   NSString * area = [addressComponent valueForKey:@"district"];
//                   NSString * street = [addressComponent valueForKey:@"street"];
//                   NSString * addressStr = [NSString stringWithFormat:@"%@,%@,%@,%@",province,city,area,street];
//
//                   NSDictionary * location = [result objectForKey:@"location"];
//                   double lng = [[location objectForKey:@"lng"]doubleValue];
//                   double lat = [[location objectForKey:@"lat"]doubleValue];
//                   
//                   if ((lng==0.0 && lat==0.0) || [addressStr isEqualToString:@""]) {
//                       return;
//                   }
//                   
//                   //数据存储
//                   User *user = [User shareInstance];
//                   user.lon = self.locate.longitude;
//                   user.lat = self.locate.latitude;
//                   user.address = addressStr;
//                   
//                   [NetWorkManager networkUserLocateAddWithuid:[User shareInstance].userId address:addressStr longitude:lng latitude:lat success:^(BOOL flag, NSDictionary *userDic, NSString *msg) {
//                       if (flag) {
//                           DLog(@"%@",userDic);
//                       }
//                   } failure:^(NSError *error) {
//                       
//                   }];
//                   
////                       /*解析成服务器上的id*/
////                      [self analyzeAddressStringToId];
//               }
//            
//        }
//
//    } failure:^(NSError *error) {
//        
//    }];
}


#pragma mark--
#pragma mark-- uialertViewdelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSURL*url=[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
