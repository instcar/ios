��ǰ�汾Ϊ��iOS SDK v2.1.1

���ϸ��汾�Ĺ������������£�

������
1.���������ٶȵ�ͼ�����Ľӿڣ��ٶȵ�ͼ������Web�˵�����
��BMKNavigation��������ö�����͵����ݽṹNAVI_TYPE��������𵼺����������ͣ�NAVI_TYPE_NATIVE(����ͻ��˵���)��NAVI_TYPE_WEB(����web����)
��BMKNavigation��������NaviPara��������𵼺�ʱ����Ĳ���
����NaviPara����������@property (nonatomic, retain) BMKPlanNode* startPoint;���嵼�������
����NaviPara����������@property (nonatomic, retain) BMKPlanNode* endPoint;���嵼�����յ�
����NaviPara����������@property (nonatomic, assign) NAVI_TYPE naviType;���嵼��������
����NaviPara����������@property (nonatomic, retain) NSString* appScheme;����Ӧ�÷���scheme
����NaviPara����������@property (nonatomic, retain) NSString* appName;����Ӧ������
��BMKNavigation�������ӿ�+ (void)openBaiduMapNavigation:;���ݴ���Ĳ�����������

2.����ͼ�λ����У����ӻ��߻��Ʒ���
��BMKArcline�������ӿ�+ (BMKArcline *)arclineWithPoints:;����ָ�����������һ��Բ��
��BMKArcline�������ӿ�+ (BMKArcline *)arclineWithCoordinates:;����ָ����γ������һ��Բ��
����BMKArclineView����������@property (nonatomic, readonly) BMKArcline *arcline;�������View��Ӧ��Բ�����ݶ���
��BMKArclineView�������ӿ�- (id)initWithArcline:;����ָ���Ļ�������һ��Բ��View

3.����ͼ�λ����У�����������λ�������

4.����Key��֤����ֵ
��BMKMapManager������ö����������EN_PERMISSION_STATUS��������key��֤������
����˾��巵�صĴ�������μ�http://developer.baidu.com/map/lbs-appendix.htm#.appendix2

5.�����������˲�ѯ�еĽ���ֶ�
����BMKLine����������@property (nonatomic) int zonePrice;����·�μ۸�
����BMKLine����������@property (nonatomic) int totalPrice;������·�ܼ۸�
����BMKLine����������@property (nonatomic) int time;������·��ʱ����λ����
����BMKRoute����������@property (nonatomic) int time;�����·�ε�����ʱ�䣬��λ����

�Ż���
	�Ż�Key��Ȩ��֤����
	�Ż�����ͼ�λ����У����߶λ���ĩ��Բ��
	������ӡ�ɾ������ͼ�θ������Ч��
�޸���
	�޸�iOS7ϵͳ�£���λͼ����ͼʱ���ٵ�bug
	�޸�POI��������У����ҳ����ʼ��Ϊ0��bug
	�޸��ݳ���·�滮�У����һ���ڵ���ʾ��Ϣ�����bug

