import '../../../app/app.locator.dart';
import '../../../core/base/baic_base_view_model.dart';
import '../../../core/services/check_in_service.dart';

/// [CheckInViewModel] - 每日签到与积分激励业务逻辑类
///
/// 核心职责：
/// 1. 展示用户的积分资产、连续签到天数及当周签到热力图。
/// 2. 处理每日签到动作：与 [ICheckInService] 交互，并在成功后本地更新积分额度。
/// 3. 关联展示积分任务列表，指引用户通过互动获取更多权益。
class CheckInViewModel extends BaicBaseViewModel {
  final _checkInService = locator<ICheckInService>();

  /// 用户当前的累计积分总额
  int _points = 0;
  int get points => _points;

  /// 本周期内的连续签到天数
  int _consecutiveDays = 0;
  int get consecutiveDays => _consecutiveDays;

  /// 状态锁：今日是否已完成签到动作
  bool _checkedInToday = false;
  bool get checkedInToday => _checkedInToday;

  /// 本周签到状态序列（用于渲染 7 天进度条）
  List<DayCheckIn> _weekDays = [];
  List<DayCheckIn> get weekDays => _weekDays;

  /// 积分任务列表（如：发表动态、完善资料等）
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  /// 弹窗控制：是否展示签到规则说明
  bool _showRules = false;
  bool get showRules => _showRules;

  /// 生命周期：载入全量签到元数据与任务流
  Future<void> init() async {
    await loadData();
  }

  /// 业务加载：聚合调用服务层获取签到进度与任务详情
  Future<void> loadData() async {
    setBusy(true);
    
    try {
      final data = await _checkInService.getCheckInData();
      _points = data.points;
      _consecutiveDays = data.consecutiveDays;
      _checkedInToday = data.checkedInToday;
      _weekDays = data.weekDays;
      
      final tasks = await _checkInService.getTasks();
      _tasks = tasks;
      
      notifyListeners();
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  /// 核心交互：执行签到动作
  /// 逻辑：校验防重复提交，调用服务层成功后触发本地积分增长动画状态。
  Future<void> performCheckIn() async {
    if (_checkedInToday) return;
    
    setBusy(true);
    
    try {
      final success = await _checkInService.performCheckIn();
      if (success) {
        _checkedInToday = true;
        _points += 10; // TODO: 动态根据后端返回的增量积分更新
        notifyListeners();
      }
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  /// 交互：切换签到规则 H5 或弹窗的可见性
  void toggleRules() {
    _showRules = !_showRules;
    notifyListeners();
  }

  /// 交互：显式关闭规则面板
  void closeRules() {
    _showRules = false;
    notifyListeners();
  }
}
