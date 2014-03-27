当前版本为：iOS SDK v2.1.1

较上个版本的功能升级点如下：

新增：
1.新增调启百度地图导航的接口（百度地图导航和Web端导航）
在BMKNavigation中新增类枚举类型的数据结构NAVI_TYPE来定义调起导航的两种类型：NAVI_TYPE_NATIVE(调起客户端导航)和NAVI_TYPE_WEB(调起web导航)
在BMKNavigation中新增类NaviPara来管理调起导航时传入的参数
在类NaviPara中新增属性@property (nonatomic, retain) BMKPlanNode* startPoint;定义导航的起点
在类NaviPara中新增属性@property (nonatomic, retain) BMKPlanNode* endPoint;定义导航的终点
在类NaviPara中新增属性@property (nonatomic, assign) NAVI_TYPE naviType;定义导航的类型
在类NaviPara中新增属性@property (nonatomic, retain) NSString* appScheme;定义应用返回scheme
在类NaviPara中新增属性@property (nonatomic, retain) NSString* appName;定义应用名称
在BMKNavigation中新增接口+ (void)openBaiduMapNavigation:;根据传入的参数调启导航

2.几何图形绘制中，增加弧线绘制方法
在BMKArcline中新增接口+ (BMKArcline *)arclineWithPoints:;根据指定坐标点生成一段圆弧
在BMKArcline中新增接口+ (BMKArcline *)arclineWithCoordinates:;根据指定经纬度生成一段圆弧
在类BMKArclineView中新增属性@property (nonatomic, readonly) BMKArcline *arcline;来定义该View对应的圆弧数据对象
在BMKArclineView中新增接口- (id)initWithArcline:;根据指定的弧线生成一个圆弧View

3.几何图形绘制中，扩增凹多边形绘制能力

4.新增Key验证返回值
在BMKMapManager中新增枚举数据类型EN_PERMISSION_STATUS类来定义key验证错误码
服务端具体返回的错误码请参见http://developer.baidu.com/map/lbs-appendix.htm#.appendix2

5.新增公交换乘查询中的结果字段
在类BMKLine中新增属性@property (nonatomic) int zonePrice;定义路段价格
在类BMKLine中新增属性@property (nonatomic) int totalPrice;定义线路总价格
在类BMKLine中新增属性@property (nonatomic) int time;定义线路耗时，单位：秒
在类BMKRoute中新增属性@property (nonatomic) int time;定义此路段的消耗时间，单位：秒

优化：
	优化Key鉴权认证策略
	优化几何图形绘制中，折线段绘制末端圆滑
	提升添加、删除几何图形覆盖物的效率
修复：
	修复iOS7系统下，定位图层拖图时卡顿的bug
	修复POI检索结果中，结果页索引始终为0的bug
	修复驾车线路规划中，最后一个节点提示信息有误的bug

