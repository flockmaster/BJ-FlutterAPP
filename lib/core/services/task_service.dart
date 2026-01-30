
/// [TaskStatus] - 任务状态枚举
enum TaskStatus {
  todo,   // 待完成
  done,   // 已完成
  locked, // 待解锁（需满足前置条件）
}

/// [TaskItem] - 任务实体模型
class TaskItem {
  final String id;           // 任务唯一标识
  final String title;        // 任务标题
  final String description;  // 任务描述
  final int reward;          // 奖励分值（积分/经验）
  final TaskStatus status;   // 当前状态
  final String? actionRoute; // 任务跳转路径（点击“去完成”后的目标页）

  TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.reward,
    required this.status,
    this.actionRoute,
  });

  TaskItem copyWith({
    String? id,
    String? title,
    String? description,
    int? reward,
    TaskStatus? status,
    String? actionRoute,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      reward: reward ?? this.reward,
      status: status ?? this.status,
      actionRoute: actionRoute ?? this.actionRoute,
    );
  }
}

/// [ITaskService] - 任务系统业务服务接口
/// 
/// 负责处理：用户每日任务、成长任务的加载、任务状态变更（完成任务）以及积分统计。
abstract class ITaskService {
  /// 获取所有每日任务列表
  List<TaskItem> getDailyTasks();

  /// 获取所有成长任务列表
  List<TaskItem> getGrowthTasks();

  /// 提交并完成一个指定的任务
  /// 返回 true 表示操作成功并获得了奖励
  Future<bool> completeTask(String taskId);

  /// 获取当前累计的任务积分
  int getUserPoints();
}

/// [TaskService] - 任务服务本地 Mock 实现
class TaskService implements ITaskService {
  // 模拟内存数据库
  int _userPoints = 1250;
  final List<TaskItem> _dailyTasks = [];
  final List<TaskItem> _growthTasks = [];

  TaskService() {
    _initializeTasks();
  }

  /// 初始化任务数据种子
  void _initializeTasks() {
    // 每日任务初始化
    _dailyTasks.addAll([
      TaskItem(
        id: 'daily_checkin',
        title: '每日签到',
        description: '连续签到奖励更多',
        reward: 10,
        status: TaskStatus.done,
        actionRoute: '/check-in',
      ),
      TaskItem(
        id: 'daily_browse_store',
        title: '浏览商城',
        description: '浏览推荐商品 30 秒',
        reward: 20,
        status: TaskStatus.todo,
        actionRoute: '/store',
      ),
      TaskItem(
        id: 'daily_share',
        title: '分享动态',
        description: '分享精彩生活到社区',
        reward: 50,
        status: TaskStatus.todo,
        actionRoute: '/discovery',
      ),
    ]);

    // 成长任务初始化
    _growthTasks.addAll([
      TaskItem(
        id: 'growth_profile',
        title: '完善个人信息',
        description: '填写昵称、头像等资料',
        reward: 100,
        status: TaskStatus.done,
        actionRoute: '/profile/detail',
      ),
      TaskItem(
        id: 'growth_bind_vehicle',
        title: '绑定车辆',
        description: '认证成为车主',
        reward: 500,
        status: TaskStatus.todo,
        actionRoute: '/my-vehicles',
      ),
      TaskItem(
        id: 'growth_first_maintenance',
        title: '首次保养',
        description: '完成首次车辆保养服务',
        reward: 300,
        status: TaskStatus.locked,
        actionRoute: '/service',
      ),
    ]);
  }

  @override
  List<TaskItem> getDailyTasks() {
    return List.unmodifiable(_dailyTasks);
  }

  @override
  List<TaskItem> getGrowthTasks() {
    return List.unmodifiable(_growthTasks);
  }

  @override
  Future<bool> completeTask(String taskId) async {
    // 模拟服务端原子性校验
    await Future.delayed(const Duration(milliseconds: 500));

    // 搜索每日任务列表
    final dailyIndex = _dailyTasks.indexWhere((t) => t.id == taskId);
    if (dailyIndex != -1) {
      final task = _dailyTasks[dailyIndex];
      if (task.status == TaskStatus.todo) {
        _dailyTasks[dailyIndex] = task.copyWith(status: TaskStatus.done);
        _userPoints += task.reward;
        return true;
      }
    }

    // 搜索成长任务列表
    final growthIndex = _growthTasks.indexWhere((t) => t.id == taskId);
    if (growthIndex != -1) {
      final task = _growthTasks[growthIndex];
      if (task.status == TaskStatus.todo) {
        _growthTasks[growthIndex] = task.copyWith(status: TaskStatus.done);
        _userPoints += task.reward;
        return true;
      }
    }

    return false;
  }

  @override
  int getUserPoints() {
    return _userPoints;
  }
}
