//
//  APIClient.m
//  CarApp
//
//  Created by MacPro-Mr.Lu on 14-4-5.
//  Copyright (c) 2014年 Leno. All rights reserved.
//

#import "APIClient.h"

@implementation APIClient

+(void)networkCheckPhone:(NSString *)phoneNum success:(void (^)(Respone *respone))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:phoneNum,@"phone", nil];
    [NetTool httpPostRequest:API_POST_CheckUserPhone WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)networkCheckUserName:(NSString *)username success:(void (^)(Respone *respone))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:username,@"username", nil];
    [NetTool httpPostRequest:API_POST_CheckUserName WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)networkGetauthcodeWithPhone:(NSString *)phoneNum success:(void (^)(Respone *respone))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:phoneNum,@"phone", nil];
    [NetTool httpPostRequest:API_POST_GetAuthCode WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)networkUserRegistWithPhone:(NSString *)phone password:(NSString *)password authcode:(NSString *)authcode smsid:(long)smsid success:(void (^)(Respone *respone))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:phone,@"phone", password,@"password",[NSNumber numberWithLong:smsid],@"smsid",authcode,@"authcode",nil];
    [NetTool httpPostRequest:API_POST_Register WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)networkUserLoginWithPhone:(NSString *)phone password:(NSString *)password success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:phone,@"phone", password,@"password",nil];
    [NetTool httpPostRequest:API_POST_Login WithFormdata:formData WithSuccess:^(Respone *resultDic)
     {
         success(resultDic);
     } failure:^(NSError *error) {
         failure(error);
     }];
}


+ (void)networkLoginoutWithSuccess:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionary];
    [NetTool httpPostRequest:API_POST_LoginOut WithFormdata:formData WithSuccess:^(Respone *resultDic)
    {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)networkGetUserInfoWithuid:(long)uid success:(void (^)(Respone *respone))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:uid],@"id",nil];
    [NetTool httpPostRequest:API_POST_GetUserDetail WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+(void)networkEditUserInfo:(NSMutableDictionary *)userInfoDic success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    [NetTool httpPostRequest:API_POST_EditUserInfo WithFormdata:userInfoDic WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)networkAddCarWithid:(int)car_id license:(NSString *)license cars_1:(NSString *)cars_1 cars_2:(NSString *)cars_2 success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:license,@"license",cars_1,@"cars[]",cars_2,@"cars[]",nil];
    [NetTool httpPostRequest:API_POST_UserAddCar WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (id)networkUserGetCarsWithcar_id:(int)car_id success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    //car_id 为可选参数
    NSMutableDictionary *formData = [NSMutableDictionary dictionary];
    if (car_id >= 0) {
         [formData setObject:[NSNumber numberWithInt:car_id] forKey:@"car_id"];
    }
    [NetTool httpPostRequest:API_POST_UserGetCars WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)networkUserRealNameRequestWithid_cards_1:(NSString *)id_cars_1 id_cards_2:(NSString *)id_cars_2 success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:id_cars_1,@"id_cards[]",id_cars_2,@"id_cards[]",nil];
    [NetTool httpPostRequest:API_POST_UserRealnameRequest WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - 线路
//添加线路
+ (void)networkAdminAddLinewithName:(NSString *)name description:(NSString *)description price:(float)price success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:name,@"name",description,@"description",[NSNumber numberWithFloat:price],@"price",nil];
    [NetTool httpPostRequest:API_POST_AddLine WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
//编辑线路
+ (void)networkAdminEditLineWithLineid:(int)lineid name:(NSString *)name description:(NSString *)description price:(float)price success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:lineid],@"lineid",name,@"name",description,@"description",[NSNumber numberWithFloat:price],@"price",nil];
    [NetTool httpPostRequest:API_POST_EditLine WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
//删除线路
+ (void)networkAdminDelLineWithLineid:(int)lineid success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:lineid],@"lineid",nil];
    [NetTool httpPostRequest:API_POST_DelLine WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
//根据据点获取线路列表
+ (void)networkGetLineListByJudianId:(long)judianID page:(int)page rows:(int)rows all:(int)all success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:judianID],@"pointid",[NSNumber numberWithInt:page],@"page",[NSNumber numberWithInt:rows],@"rows",[NSNumber numberWithInt:all],@"all",nil];
    [NetTool httpPostRequest:API_POST_GetListLineByJudianID WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
//更具关键字获取线路列表
+ (void)networkGetLineListByTag:(NSString *)tag page:(int)page rows:(int)rows all:(int)all success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:tag,@"wd",[NSNumber numberWithInt:page],@"page",[NSNumber numberWithInt:rows],@"rows",nil];
    if (all >= 0) {
        [formData setObject:[NSNumber numberWithInt:all] forKey:@"all"];
    }
    [NetTool httpPostRequest:API_POST_GetListLineByTag WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
//更具id获取线路详情
+(void)networkGetListLinebyid:(int)lineid all:(int)all success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:lineid],@"lineid",nil];
    if (all >= 0) {
        [formData setValue:[NSNumber numberWithInt:all] forKey:@"all"];
    }
    [NetTool httpPostRequest:API_POST_GetlistlineByID WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)networkAddFavoriteLinebyid:(int)lineid success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:lineid],@"lineid",nil];
    [NetTool httpPostRequest:API_POST_AddFavoriteLine WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)networkGetFavoriteLineListByPage:(int)page rows:(int)rows success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:page],@"page",[NSNumber numberWithInt:rows],@"rows",nil];
    [NetTool httpPostRequest:API_POST_GetFavoriteLineList WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - 据点相关
//增加据点
+ (void)networkAdminAddPointWithName:(NSString *)name lat:(double)lat lng:(double)lng district:(NSString *)district city:(NSString *)city success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:name,@"name",[NSNumber numberWithFloat:lat],@"lat",[NSNumber numberWithFloat:lng],@"lng",district,@"district",city,@"city",nil];
    [NetTool httpPostRequest:API_POST_AddPoint WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//增加据点
+ (void)networkAdminEditPointWithPointId:(long)pointid Name:(NSString *)name lat:(double)lat lng:(double)lng district:(NSString *)district city:(NSString *)city success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:pointid],@"pointid",name,@"name",[NSNumber numberWithFloat:lat],@"lat",[NSNumber numberWithFloat:lng],@"lng",district,@"district",city,@"city",nil];
    [NetTool httpPostRequest:API_POST_EditPoint WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//删除据点
+ (void)networkAdminDelPointWithPointId:(long)pointid success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:pointid],nil];
    [NetTool httpPostRequest:API_POST_DelPoint WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
//获取据点列表
+ (void)networkGetPointListWithPage:(int)page rows:(int)rows success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:page],@"page",[NSNumber numberWithInt:rows],@"rows",nil];
    [NetTool httpPostRequest:API_POST_GetPointList WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
//根据经纬度获取据点列表
+ (void)networkGetPointListWithLat:(double)lat lng:(double)lng page:(int)page rows:(int)rows success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:lat],@"lat",[NSNumber numberWithFloat:lng],@"lng",[NSNumber numberWithInt:page],@"page",[NSNumber numberWithInt:rows],@"rows",nil];
    [NetTool httpPostRequest:API_POST_GetPointList WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - 房间
//创建房间
+ (void)networkCreatRoomWithUser_phone:(NSString *)user_phone line_id:(int)line_id price:(int)price description:(NSString *)description start_time:(NSString *)start_time max_seat_num:(int)max_seat_num success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:user_phone,@"user_id",[NSNumber numberWithInt:line_id],@"line_id",[NSNumber numberWithInt:price],@"price",description,@"description",start_time,@"start_time",[NSNumber numberWithInt:max_seat_num ],@"max_seat_num",nil];
    [NetTool httpPostRequest:API_POST_CreatRoom WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//关闭房间
+ (void)networkCloseRoomWithroom_id:(int)room_id success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:room_id],@"room_id",nil];
    [NetTool httpPostRequest:API_POST_CloseRoom WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//司机修改房间说明
+ (void)networkChangeRoomDescWithroom_id:(int)room_id desc:(NSString *)desc success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:room_id],@"room_id",desc,@"desc",nil];
    [NetTool httpPostRequest:API_POST_Changeroomdesc WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//修改房间最大座位数
+(void)networkChangemaxseatnumWithroom_id:(int)room_id max_seat_num:(int)max_seat_num success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:room_id],@"room_id",max_seat_num,@"max_seat_num",nil];
    [NetTool httpPostRequest:API_POST_Changeroommaxseatnum WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//修改房间出发时间
+ (void)networkChangestarttimeWithroom_id:(int)room_id start_time:(NSDate *)start_time success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:room_id],@"room_id",start_time,@"start_time",nil];
    [NetTool httpPostRequest:API_POST_Changestarttime WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//修改房间状态
+ (void)networkChangeroomstateWithroom_id:(int)room_id status:(int)status success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:room_id],@"room_id",status,@"status",nil];
    [NetTool httpPostRequest:API_POST_Changeroomstate WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//乘客加入房间
+ (void)networkpassengerJoinroomWithroom_id:(int)room_id user_id:(int)user_id success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:room_id],@"room_id",user_id,@"user_id",nil];
    [NetTool httpPostRequest:API_POST_RoomJoin WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//乘客退出房间
+ (void)networkpassengerQuitroomWithroom_id:(int)room_id user_id:(int)user_id success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:room_id],@"room_id",user_id,@"user_id",nil];
    [NetTool httpPostRequest:API_POST_QuitRoom WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//查询某条路线的房间列表
+ (void) networkGetlineroomsWithline_id:(int)line_id success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:line_id],@"line_id",nil];
    [NetTool httpPostRequest:API_POST_Getlinerooms WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//查询某房间的用户列表
+ (void) networkGetroomusersWithroom_id:(int)room_id success:(void (^)(Respone *respone))success failure:(void (^)(NSError * error))failure;
{
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:room_id],@"room_id",nil];
    [NetTool httpPostRequest:API_POST_Getroomusers WithFormdata:formData WithSuccess:^(Respone *resultDic) {
        success(resultDic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - 上传图片
//上传图片
+ (void)networkUpLoadImageFileByType:(int)type user_id:(long)user_id dataFile :(NSArray *)fileArray success:(void (^)(Respone *))success failure:(void (^)(NSError *))failure
{
//    {"data":[nameaddr1,nameaddr2],"formate":"png","key":"photo","name":"photo"}
    NSMutableDictionary *fileDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:fileArray,@"data",@"png",@"formate",@"file_",@"key",@"file_",@"name", nil];
    NSMutableDictionary *formData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:user_id],@"user_id",[NSNumber numberWithInt:type],@"type",nil];
    [NetTool httpPostFileAddrRequest:API_POST_UpLoadImageFile WithFileFormdata:fileDic withFormdaya:formData WithSuccess:^void(Respone *respone) {
        success(respone);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
