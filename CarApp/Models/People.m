//
//  People.m
//  WPWProject
//
//  Created by Mr.Lu on 13-7-1.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import "People.h"
#import "NSDictionary+IsExitKey.h"
#import "PeopleManager.h"

@implementation PeopleDetail

-(PeopleDetail *)initFromDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.home_addr = [dic utilityValueForKey:@"home_addr"];
        self.comp_addr = [dic utilityValueForKey:@"comp_addr"];
        self.id_number = [dic utilityValueForKey:@"id_number"];
        self.signature = [dic utilityValueForKey:@"signature"];
        self.show_comp_addr = [dic isExitKey:@"show_comp_addr"]?[(NSString *)[dic valueForKey:@"show_comp_addr"] intValue]:0;
        self.show_home_addr = [dic isExitKey:@"show_home_addr"]?[(NSString *)[dic valueForKey:@"show_home_addr"] intValue]:0;
        self.info = (NSDictionary *)[[dic utilityValueForKey:@"info"] objectFromJSONString];
    }
    return self;
}

@end

@implementation People

//初始话对象
-(People *)initFromDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.ID = [dic isExitKey:@"id"]?[(NSString *)[dic valueForKey:@"id"] longLongValue]:0;
        self.headpic = [dic utilityValueForKey:@"headpic"];
        self.name = [dic utilityValueForKey:@"name"];
        self.phone = [dic utilityValueForKey:@"phone"];
        self.email = [dic utilityValueForKey:@"email"];
        self.status = [dic isExitKey:@"status"]?[(NSString *)[dic valueForKey:@"status"] intValue]:0;
        self.sex = [dic utilityValueForKey:@"sex"];
        self.age = [dic isExitKey:@"age"]?[[dic valueForKey:@"age"]integerValue]:0;
        self.password = [dic utilityValueForKey:@"password"];
        self.detail = [dic isExitKey:@"detail"]?[[PeopleDetail alloc]initFromDic:[dic valueForKey:@"detail"]]:nil;
        
//        self.realName = [dic utilityValueForKey:@"realname"];
//        self.lastcoord = [dic utilityValueForKey:@"lastcoord"];
//        self.lastloginTime = [dic utilityValueForKey:@"lastloginTime"];
//        self.addTime = [AppUtility dateFromStr:[dic objectForKey:@"addtime"] withFormate:@"yyyy-MM-dd HH:mm:ss"];
//        self.modTime = [AppUtility dateFromStr:[dic objectForKey:@"addtime"] withFormate:@"yyyy-MM-dd HH:mm:ss"];
//        self.des = [dic utilityValueForKey:@"des"];
//        self.phonemac = [dic utilityValueForKey:@"phonemac"];
//        self.phonetype = [dic utilityValueForKey:@"phonetype"];
//        self.phoneuuid = [dic utilityValueForKey:@"phoneuuid"];
//        self.cityID = [dic isExitKey:@"cityID"]?[[dic valueForKey:@"cityID"]intValue]:0;
//        self.areaID = [dic isExitKey:@"areaID"]?[[dic valueForKey:@"areaID"]intValue]:0;
//        self.lastarea = [dic utilityValueForKey:@"lastarea"];
//        self.lastcoord = [dic utilityValueForKey:@"lastcoord"];
//        self.lastloginTime = [dic utilityValueForKey:@"lastloginTime"];
//        self.jifen = [dic isExitKey:@"jifen"]?[[dic valueForKey:@"jifen"]intValue]:0;
//        self.credit = [dic isExitKey:@"credit"]?[[dic valueForKey:@"credit"]intValue]:0;
//        self.registtime = [dic utilityValueForKey:@"registtime"];
//        self.registarea = [dic utilityValueForKey:@"registarea"];
//        self.devicetoken = [dic utilityValueForKey:@"devicetoken"];
//        
//        self.realName = [dic utilityValueForKey:@"realname"];
//        self.lastcoord = [dic utilityValueForKey:@"lastcoord"];
//        self.lastloginTime = [dic utilityValueForKey:@"lastloginTime"];

    }
    return self;
}

//从网络获取对象
+(NSArray *)arrayWithArrayDic:(NSArray *)array;
{
    NSMutableArray * mutableArray = [[NSMutableArray alloc]init];
    [mutableArray removeAllObjects];
    for (NSDictionary * dic in array) {
        People *room = [[People alloc]initFromDic:dic];
        [mutableArray addObject:room];
    }
    return mutableArray;
}

////从网络获取好友列表
//+(void)FriendFormServerRequestWithMoreId:(int)moreId success:(void (^)(NSArray *peoples, id json))block failure:(void (^)(void))failureblock
//{
//    @try {
//        int uid = [XYCommon appDelegate].myInfo.ID;
//        NSString * requestString = [NSString stringWithFormat:@"mt/friend/list?uid=%d&moreid=%d&rows=%@",uid,moreId,@"20"];
//        NSURLRequest * request = [XYCommon formateRequestUrl:requestString];
//        AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
//           {
//                DLog(@"%@",JSON);
//                NSMutableArray *mutablePeople = [NSMutableArray arrayWithCapacity:[JSON count]];
//                int ret = [[JSON objectForKey:@"flag"] intValue];
//                if (ret)
//                {
//                    if([[JSON objectForKey:@"data"] count] > 0)
//                    {
//                        //备份到数据库
//                        for (NSDictionary * peopleDic in [JSON objectForKey:@"data"]){
//                           People * people = [[People alloc] PeopleFromDic:peopleDic];
//                           [PeopleManager insertPeopleShortInfo:people];
//                           [mutablePeople addObject:people];
//                        }
//                    }
//                }
//                else
//                {
//                 DLog(@"result error");
//                }
//               if(block){
//                   block([NSArray arrayWithArray:mutablePeople],JSON);
//               }
//           }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
//           {
//               DLog(@"error is  %@",error);
//               if(failureblock){
//                   failureblock();
//               }
//           }];
//        [operation start];
//    }
//    @catch (NSException *exception)
//    {
//        [exception popAlert];
//    }
//    @finally{
//        
//    }
//}
//
////从网络获取好友删选
//+(void)ScreenFriendFormServerRequestWithMoreId:(int)moreId searchKeyWord:(NSString *)keyWord success:(void (^)(NSArray *peoples, id json))block failure:(void (^)(void))failureblock
//{
//    @try {
//        int uid = [XYCommon appDelegate].myInfo.ID;
//        NSString * requestString = [NSString stringWithFormat:@"mt/friend/search?uid=%d&moreid=%d&rows=%d&searchkey=%@",uid,moreId,20,keyWord];
//        NSURLRequest * request = [XYCommon formateRequestUrl:requestString];
//        DLog(@"url is %@",request);
//        AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
//       {
//           DLog(@"%@",JSON);
//            NSMutableArray *mutablePeople = [NSMutableArray arrayWithCapacity:[JSON count]];
//           int ret = [[JSON objectForKey:@"flag"] intValue];
//           if (ret)
//           {
//               if([[JSON objectForKey:@"data"] count] > 0)
//               {
//                   for (NSDictionary *peopleDic in [JSON objectForKey:@"data"]) {
//                       People *people = [[People alloc] PeopleFromDic:peopleDic];
//                       [mutablePeople addObject:people];
//                   }
//               }
//            }
//           else
//           {
//               DLog(@"result error");
//           }
//        
//           if(block){
//               block([NSArray arrayWithArray:mutablePeople],JSON);
//           }
//       }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
//       {
//           DLog(@"error is  %@",error);
//           if(failureblock){
//               failureblock();
//           }
//       }];
//        [operation start];
//    }
//    @catch (NSException *exception)
//    {
//        [exception popAlert];
//    }
//    @finally{
//        
//    }
//}


@end
