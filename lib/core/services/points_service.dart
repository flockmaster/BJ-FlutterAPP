import '../models/points_models.dart';

/// [IPointsService] - 用户积分与等级服务接口
/// 
/// 负责管理：查询总积分、查看积分收支明细、获取会员等级信息等业务。
abstract class IPointsService {
  /// 获取积分统计信息（总计、可用、已用、过期及会员等级描述）
  Future<PointsStats> getPointsStats();
  
  /// 分页获取积分交易记录
  /// [type]：过滤类型（收入/支出）
  /// [page] & [pageSize]：分页参数
  Future<List<PointsTransaction>> getTransactions({
    PointsTransactionType? type,
    int page = 1,
    int pageSize = 20,
  });
  
  /// 快捷获取当前用户的可用积分余额
  Future<int> getAvailablePoints();
}

/// [PointsService] - 积分服务具体实现
class PointsService implements IPointsService {
  @override
  Future<PointsStats> getPointsStats() async {
    // 模拟从 API 获取数据
    await Future.delayed(const Duration(milliseconds: 500));
    
    return PointsStats(
      totalPoints: 5200,
      availablePoints: 2450,
      usedPoints: 2500,
      expiredPoints: 250,
      vipLevel: '钻石会员',
      vipLevelNum: 5,
    );
  }

  @override
  Future<List<PointsTransaction>> getTransactions({
    PointsTransactionType? type,
    int page = 1,
    int pageSize = 20,
  }) async {
    // 模拟交易记录数据源
    await Future.delayed(const Duration(milliseconds: 500));
    
    final allTransactions = [
      PointsTransaction(
        id: '1',
        title: '每日签到',
        time: '今天 08:30',
        amount: 10,
        type: PointsTransactionType.earn,
        category: PointsCategory.checkin,
      ),
      PointsTransaction(
        id: '2',
        title: '商城兑换-车载吸尘器',
        time: '昨天 14:20',
        amount: -1200,
        type: PointsTransactionType.spend,
        category: PointsCategory.shop,
      ),
      PointsTransaction(
        id: '3',
        title: '完成完善资料任务',
        time: '1月12日 10:00',
        amount: 50,
        type: PointsTransactionType.earn,
        category: PointsCategory.task,
      ),
      PointsTransaction(
        id: '4',
        title: '发布精选动态奖励',
        time: '1月10日 18:45',
        amount: 200,
        type: PointsTransactionType.earn,
        category: PointsCategory.community,
      ),
      PointsTransaction(
        id: '5',
        title: '参与车主活动报名',
        time: '1月05日 09:15',
        amount: -500,
        type: PointsTransactionType.spend,
        category: PointsCategory.activity,
      ),
      PointsTransaction(
        id: '6',
        title: '邀请好友注册',
        time: '2023-12-28',
        amount: 500,
        type: PointsTransactionType.earn,
        category: PointsCategory.invite,
      ),
      PointsTransaction(
        id: '7',
        title: '预约保养完成',
        time: '2023-12-20',
        amount: 300,
        type: PointsTransactionType.earn,
        category: PointsCategory.service,
      ),
      PointsTransaction(
        id: '8',
        title: '购买车载充气床',
        time: '2023-12-15',
        amount: -600,
        type: PointsTransactionType.spend,
        category: PointsCategory.shop,
      ),
      PointsTransaction(
        id: '9',
        title: '完成新手任务',
        time: '2023-12-10',
        amount: 100,
        type: PointsTransactionType.earn,
        category: PointsCategory.task,
      ),
      PointsTransaction(
        id: '10',
        title: '参与问卷调查',
        time: '2023-12-05',
        amount: 50,
        type: PointsTransactionType.earn,
        category: PointsCategory.other,
      ),
    ];
    
    // 逻辑：根据收支类型进行列表过滤
    if (type != null) {
      return allTransactions.where((t) => t.type == type).toList();
    }
    
    return allTransactions;
  }

  @override
  Future<int> getAvailablePoints() async {
    final stats = await getPointsStats();
    return stats.availablePoints;
  }
}
