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
     @pram   phone (NSString *) 手机号
     */
    #define API_POST_CheckUserPhone [NSString stringWithFormat:@"%@server/user/checkuserphone",PHPHOST]

    /**
     检测用户名是否可用
     @pram   name (NSString *) 用户名
     */
    #define API_POST_CheckUserName [NSString stringWithFormat:@"%@server/user/checkusername",PHPHOST]

    /**
     获取验证码
     @pram phone (NSString *) 手机号
     */
    #define API_POST_GetAuthCode [NSString stringWithFormat:@"%@server/user/getauthcode",PHPHOST]

    /**
     注册
     @pram phone (NSString) 手机号
     @pram password (NSString) 密码
     @pram authcode (NSString) 验证码
     @pram smsid ()
     */
    #define API_POST_Register [NSString stringWithFormat:@"%@server/user/register",PHPHOST]

    /**
     登入
     @pram phone (NSString) 电话号码
     @pram password (NSString) 手机号
     */
    #define API_POST_Login [NSString stringWithFormat:@"%@server/user/login",PHPHOST]

    /**
     获取用户信息
     @pram uid (lond) 用户ID
     */
    #define API_POST_GetUserDetail [NSString stringWithFormat:@"%@server/user/detail",PHPHOST]

    /**
     根据ID获取路线列表
     @pram pointid (long) 聚点ID
     @pram page (int) 获取的页码
     @pram rows (int) 每页条数
     @pram all (int) 是否回去全部据点信息
     */
    #define API_POST_GetListLienByJudianID [NSString stringWithFormat:@"%@server/line/listlinebypointid",PHPHOST]

    /**
     根据关键词获取路线列表
     @pram wd (long) 关键字
     @pram page (int) 获取的页码
     @pram rows (int) 每页条数
     @pram all (int) 是否回去全部据点信息
     */
    #define API_POST_GetListLienByTag [NSString stringWithFormat:@"%@server/line/listlinebypointid",PHPHOST]

    /**
     上传图片
     参数
     type	int	1  => 车相关
                2 => 用户相关
     user_id	bigint
     file_1	FILE		文件1
     file_2	FILE		文件2
     file_3	FILE		文件3
     file_*	FILE		文件*
     */
    #define API_POST_UpLoadImageFile [NSString stringWithFormat:@"%@server/image/upload",PHPHOST]

#endif