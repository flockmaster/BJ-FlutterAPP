import 'package:car_owner_app/core/base/baic_base_view_model.dart';
import '../../../app/app.locator.dart';
import '../../../core/services/points_service.dart';
import '../../../core/models/points_models.dart';

/// 积分明细页面ViewModel
/// [PointsHistoryViewModel] - 积分变动明细（流水账单）业务逻辑类
///
/// 核心职责：
/// 1. 展示用户的积分收支概览：包含账户总额、即将过期的积分等统计。
/// 2. 管理流水分类过滤：支持“全部”、“收入”、“支出”三个维度的实时切片。
/// 3. 提供转化导流：引导用户进入积分商城消费或进入任务中心赚取。
class PointsHistoryViewModel extends BaicBaseViewModel {
  final _pointsService = locator<IPointsService>();

  /// 积分关键指标统计（总额、冻结额等）
  PointsStats? _stats;
  PointsStats? get stats => _stats;

  /// 全量积分交易流水
  List<PointsTransaction> _transactions = [];
  List<PointsTransaction> get transactions => _transactions;

  /// 当前选中的过滤类型 Tab
  String _activeTab = 'all';
  String get activeTab => _activeTab;

  /// 计算属性：过滤出符合当前 Tab 类型（Earn/Spend）的交易项
  List<PointsTransaction> get filteredTransactions {
    if (_activeTab == 'all') {
      return _transactions;
    } else if (_activeTab == 'earn') {
      return _transactions.where((t) => t.type == PointsTransactionType.earn).toList();
    } else {
      return _transactions.where((t) => t.type == PointsTransactionType.spend).toList();
    }
  }

  /// 生命周期：初始化同步流水与账户统计
  Future<void> init() async {
    await loadData();
  }

  /// 业务加载：聚合检索积分元数据
  Future<void> loadData() async {
    setBusy(true);
    
    try {
      final stats = await _pointsService.getPointsStats();
      final transactions = await _pointsService.getTransactions();
      
      _stats = stats;
      _transactions = transactions;
      
      notifyListeners();
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  /// 交互：切换收支列表过滤器
  void setActiveTab(String tab) {
    _activeTab = tab;
    notifyListeners();
  }

  /// 导航：回退
  void navigateBack() {
    goBack();
  }

  /// 交互：唤起积分获取/有效期规则弹窗
  void showHelp() {
    dialogService.showDialog(
       title: '积分规则',
       description: '这里是详细的积分获取与使用规则说明...',
    );
  }

  /// 导航：前往商城（积分核销出口）
  void navigateToStore() {
    goBack();
  }

  /// 导航：前往任务中心（积分生产入口）
  void navigateToTasks() {
    goBack();
  }
}
