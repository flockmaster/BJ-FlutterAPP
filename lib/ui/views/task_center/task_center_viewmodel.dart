import '../../../app/app.locator.dart';
import '../../../core/base/baic_base_view_model.dart';
import '../../../core/services/task_service.dart';

/// [TaskCenterViewModel] - 任务中心（成长体系与会员权益）业务逻辑类
///
/// 核心职责：
/// 1. 聚合用户的每日任务、成长任务及实时积分余额数据。
/// 2. 分发任务指令：根据任务状态引导用户前往特定页面（如去发帖、去完善资料等）。
/// 3. 与 [ITaskService] 集成，提供任务列表的查询与状态维护。
class TaskCenterViewModel extends BaicBaseViewModel {
  final _taskService = locator<ITaskService>();

  /// 每日可重复领取的任务
  List<TaskItem> _dailyTasks = [];
  /// 随账号成长阶段解锁的一次性任务
  List<TaskItem> _growthTasks = [];
  /// 当前账号可用积分总额
  int _points = 0;

  List<TaskItem> get dailyTasks => _dailyTasks;
  List<TaskItem> get growthTasks => _growthTasks;
  int get points => _points;

  /// 生命周期：初始化时全量加载任务体系数据
  void init() {
    _loadTasks();
  }

  /// 业务加载：从任务服务层同步最新的任务状态与积分
  void _loadTasks() {
    _dailyTasks = _taskService.getDailyTasks();
    _growthTasks = _taskService.getGrowthTasks();
    _points = _taskService.getUserPoints();
    notifyListeners();
  }

  /// 指令处理：根据任务当前状态决定交互行为
  /// - 已完成/已锁定：无动作返回。
  /// - 待完成：若包含路由信息，则导向具体业务页面进行任务操作。
  Future<void> handleTaskAction(TaskItem task) async {
    if (task.status == TaskStatus.done || task.status == TaskStatus.locked) {
      return;
    }

    if (task.actionRoute != null) {
      // 优雅退出任务中心并跳转，避免多层页面栈堆叠
      goBack();
      await Future.delayed(const Duration(milliseconds: 100));
      await MapsTo(task.actionRoute!);
    }
  }
}
