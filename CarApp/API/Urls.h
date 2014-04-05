//
//  RequestManager.h
//  CarApp
//
//  Created by MacPro-Mr.Lu on 13-11-13.
//  Copyright (c) 2013年 Leno. All rights reserved.
//

#ifndef Temp_Pro_Urls_h
#define Temp_Pro_Urls_h

    #define HOST @"http://115.28.231.132:8080/"
    #define PHPHOST @"http://qd00.shopbigbang.com:8086/"
    /**
     *@brief api
     */
    //段子: GET

    //得到用户信息
    #define api_getUserInfo(uid,sign)  [NSString stringWithFormat:@"%@yx/api/user/detail?appkey=%@&uid=%ld&sign=%@",HOST,APPKEY,uid,sign]

    //得到用户中心信息
    #define api_getUserCenterInfo(uid,sign) [NSString stringWithFormat:@"%@yx/api/user/infocenter?appkey=%@&uid=%ld&sign=%@",HOST,APPKEY,uid,sign]

    //得到settingAd
    #define api_Setting_Ad(page,rows,sign)  [NSString stringWithFormat:@"%@yx/api/ad/list?appkey=%@&page=%d&rows=%d&sign=%@",HOST,APPKEY,page,rows,sign]

    //得到房间列表
    #define api_getRoomsWithuid(page,rows,uid,sign) [NSString stringWithFormat:@"%@yx/api/room/listbyuid?appkey=%@&page=%d&rows=%d&uid=%ld&sign=%@",HOST,APPKEY,page,rows,uid,sign]

    //得到据点信息
    #define api_getJudianListWithLocate(lat,lng,page,rows,sign) [NSString stringWithFormat:@"%@yx/judian/api/nearestlist?appkey=%@&lat=%lf&lng=%lf&page=%d&rows=%d&sign=%@",HOST,APPKEY,lat,lng,page,rows,sign]

    //得到线路信息by tag
    #define api_getLineListbyTag(page,rows,tag,sign) [NSString stringWithFormat:@"%@yx/line/listbytag?appkey=%@&page=%d&rows=%d&tag=%@&sign=%@",HOST,APPKEY,page,rows,tag,sign]

    //得到线路信息by judianid
    #define api_getLineListbyjudianid(judianID,page,rows,sign) [NSString stringWithFormat:@"%@yx/line/listbyjudian?appkey=%@&judianid=%ld&page=%d&rows=%d&sign=%@",HOST,APPKEY,judianID,page,rows,sign]

    //得到常用路线列表
    #define api_getUserfavlineList(page,rows,uid,sign) [NSString stringWithFormat:@"%@yx/api/userfavline/list?appkey=%@&page=%d&rows=%d&uid=%ld&sign=%@",HOST,APPKEY,page,rows,uid,sign]

    //    #define api_get
    /**
     *@brief api
     */
    //段子: post


//PHPServer RequestUrl
    /**
     检测手机号是否可用
     @pram   phone (NSString *)
     */
    #define API_POST_CheckUserPhone [NSString stringWithFormat:@"%@server/user/checkuserphone",PHPHOST]

    /**
     检测用户名是否可用
     @pram   phone (NSString *)
     */
    #define API_POST_CheckUserName [NSString stringWithFormat:@"%@server/user/checkusername",PHPHOST]

    /**
     获取验证码
     @pram phone (NSString *)
     */
    #define API_POST_GetAuthCode [NSString stringWithFormat:@"%@server/user/getauthcode",PHPHOST]

    /**
     获取用户信息
     @pram uid (lond)
     */
    #define API_POST_GetUserDetail [NSString stringWithFormat:@"%@server/user/detail",PHPHOST]

#endif