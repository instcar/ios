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
#pragma mark - 用户
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
     登出
     @pram phone (NSString) 电话号码
     @pram password (NSString) 手机号
     */
    #define API_POST_LoginOut [NSString stringWithFormat:@"%@server/user/logout",PHPHOST]

    /**
     获取用户信息
     @pram uid (lond) 用户ID
     */
    #define API_POST_GetUserDetail [NSString stringWithFormat:@"%@server/user/detail",PHPHOST]

    /**
     编辑用户信息
     */
    #define API_POST_EditUserInfo [NSString stringWithFormat:@"%@server/user/edit",PHPHOST]

    /**
     用户新增车辆信息
     */
    #define API_POST_UserAddCar [NSString stringWithFormat:@"%@server/user/addcar",PHPHOST]

    /**
     获取用户全部车辆
     */
    #define API_POST_UserGetCars [NSString stringWithFormat:@"%@server/user/getcars",PHPHOST]
    /**
     用户实名请求
     */
    #define API_POST_UserRealnameRequest [NSString stringWithFormat:@"%@server/user/realnamerequest",PHPHOST]

#pragma mark - 车辆相关

#define API_POST_GetCatList [NSString stringWithFormat:@"%@server/car/list",PHPHOST]

#pragma mark - 管理员/用户自主管理线路<暂未使用>
    /**
     新增线路基本信息
     */
    #define API_POST_AddLine [NSString stringWithFormat:@"%@server/line/addline",PHPHOST]

    /**
     编辑线路
     */
    #define API_POST_EditLine [NSString stringWithFormat:@"%@ server/line/editline",PHPHOST]

    /**
     删除路线
     */
    #define API_POST_DelLine [NSString stringWithFormat:@"%@ server/line/delline",PHPHOST]

#pragma mark - 据点
    /**
     根据据点ID获取路线列表
     @pram pointid (long) 聚点ID
     @pram page (int) 获取的页码
     @pram rows (int) 每页条数
     @pram all (int) 是否回去全部据点信息
     */
    #define API_POST_GetListLineByJudianID [NSString stringWithFormat:@"%@server/line/listlinebypointid",PHPHOST]

    /**
     根据关键词获取路线列表
     @pram wd (long) 关键字
     @pram page (int) 获取的页码
     @pram rows (int) 每页条数
     @pram all (int) 是否回去全部据点信息
     */
    #define API_POST_GetListLineByTag [NSString stringWithFormat:@"%@server/line/listline",PHPHOST]
    /**
     根据线路ID获取线路详情
     */
    #define API_POST_GetlistlineByID [NSString stringWithFormat:@"%@server/line/listlinebyid",PHPHOST]

    /**
     收藏路线
     */
    #define API_POST_AddFavoriteLine [NSString stringWithFormat:@"%@server/line/favorite",PHPHOST]

    /**
     获取用户收藏线路列表
     */
    #define API_POST_GetFavoriteLineList [NSString stringWithFormat:@"%@server/line/favoritelist",PHPHOST]

#pragma mark - 用户管理据点<暂时不使用>

    /**
     新增聚点
     */
    #define API_POST_AddPoint [NSString stringWithFormat:@"%@server/point/add",PHPHOST]

    /**
     编辑据点
     */
    #define API_POST_EditPoint [NSString stringWithFormat:@"%@server/point/edit",PHPHOST]

    /**
     删除据点
     */
    #define API_POST_DelPoint  [NSString stringWithFormat:@"%@server/point/del",PHPHOST]

    /**
     获取聚点分页数据
     */
    #define API_POST_GetPointList [NSString stringWithFormat:@"%@server/point/list",PHPHOST]

    /**
     根据经纬度获取最近的聚点分页数据
     */
    #define API_POST_GetNearestList [NSString stringWithFormat:@"%@server/point/nearestlist",PHPHOST]

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

#pragma mark - 房间
    /**
     创建房间
     */
    #define API_POST_CreatRoom [NSString stringWithFormat:@"%@server/room/create",PHPHOST]

    /**
     删除房间
     */
    #define API_POST_CloseRoom [NSString stringWithFormat:@"%@server/room/close",PHPHOST]

    /**
     司机修改房间说明
     */
    #define API_POST_Changeroomdesc [NSString stringWithFormat:@"%@server/room/changeroomdesc",PHPHOST]

    /**
     司机修改出发时间
     */
    #define API_POST_Changestarttime [NSString stringWithFormat:@"%@server/room/changestarttime",PHPHOST]

    /**
     司机修改最大座位数目
     */
    #define API_POST_Changeroommaxseatnum [NSString stringWithFormat:@"%@server/room/changemaxseatnum",PHPHOST]

    /**
     司机修改房间状态
     */
    #define API_POST_Changeroomstate [NSString stringWithFormat:@"%@server/room/changestate",PHPHOST]

    /**
     乘客加入房间
     */
    #define API_POST_RoomJoin [NSString stringWithFormat:@"%@server/room/join",PHPHOST]

    /**
     乘客退出房间
     */
    #define API_POST_QuitRoom [NSString stringWithFormat:@"%@server/room/quit",PHPHOST]
    /**
     查询房间信息
     */
    #define API_POST_Getroom [NSString stringWithFormat:@"%@server/room/getroominfo",PHPHOST]
    /**
     查询某条路线的房间列表
     */
    #define API_POST_Getlinerooms [NSString stringWithFormat:@"%@server/room/getlinerooms",PHPHOST]

    /**
     查询某房间的用户列表
     */
    #define API_POST_Getroomusers [NSString stringWithFormat:@"%@server/room/getroomusers",PHPHOST]

    /**
     查询静态全景图
     */
    #define API_POST_Getpanorama(lng,lat) [NSString stringWithFormat:@"http://api.map.baidu.com/panorama?width=320&height=150&location=%f,%f&fov=360&ak=IYgKop9i0EVOLwKIf5GQHBei",lng,lat];

#endif