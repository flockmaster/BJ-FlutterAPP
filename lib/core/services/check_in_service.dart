import 'package:injectable/injectable.dart';

/// [ICheckInService] - 签到与任务系统服务接口
/// 
/// 负责处理：获取签到状态、执行签到动作、以及获取积分任务列表等功能。
abstract class ICheckInService {
  /// 获取当前用户的签到概览数据（包含累计积分、连续天数及周签到记录）
  Future<CheckInData> getCheckInData();
  
  /// 执行当日签到操作
  /// 返回 true 表示签到成功，false 表示已签到或失败
  Future<bool> performCheckIn();
  
  /// 获取当前的日常/活动任务列表
  Future<List<Task>> getTasks();
}

/// [CheckInService] - 签到服务具体实现
/// 
/// 用于模拟签到系统的业务逻辑。
@LazySingleton(as: ICheckInService)
class CheckInService implements ICheckInService {
  @override
  Future<CheckInData> getCheckInData() async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));
    
    return CheckInData(
      points: 2450,
      consecutiveDays: 3,
      checkedInToday: false,
      weekDays: [
        DayCheckIn(day: '一', status: CheckInStatus.checked, points: 5),
        DayCheckIn(day: '二', status: CheckInStatus.checked, points: 5),
        DayCheckIn(day: '三', status: CheckInStatus.today, points: 10),
        DayCheckIn(day: '四', status: CheckInStatus.pending, points: 5),
        DayCheckIn(day: '五', status: CheckInStatus.pending, points: 5),
        DayCheckIn(day: '六', status: CheckInStatus.pending, points: 20),
        DayCheckIn(day: '日', status: CheckInStatus.pending, points: 50),
      ],
    );
  }

  @override
  Future<bool> performCheckIn() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  @override
  Future<List<Task>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return [
      Task(
        id: '1',
        title: '完善个人资料',
        reward: 50,
        completed: true,
      ),
      Task(
        id: '2',
        title: '发布一条动态',
        reward: 20,
        completed: false,
      ),
      Task(
        id: '3',
        title: '浏览商城 30秒',
        reward: 10,
        completed: false,
      ),
      Task(
        id: '4',
        title: '分享活动给好友',
        reward: 50,
        completed: false,
      ),
    ];
  }
}

/// [CheckInData] - 签到概览数据模型
class CheckInData {
  final int points;                // 用户当前积分总数
  final int consecutiveDays;       // 连续签到天数
  final bool checkedInToday;       // 今日是否已领奖
  final List<DayCheckIn> weekDays; // 本周每日签到状态列表

  CheckInData({
    required this.points,
    required this.consecutiveDays,
    required this.checkedInToday,
    required this.weekDays,
  });
}

/// [DayCheckIn] - 每日签到记录详情
class DayCheckIn {
  final String day;             // 星期简称（如：“一”）
  final CheckInStatus status;   // 签到状态
  final int points;             // 该日签到可得积分

  DayCheckIn({
    required this.day,
    required this.status,
    required this.points,
  });
}

/// [CheckInStatus] - 签到状态枚举
enum CheckInStatus {
  checked, // 已签到
  today,   // 今日待签到（高亮显示）
  pending, // 未来/未签到
}

/// [Task] - 积分任务模型
class Task {
  final String id;        // 任务唯一 ID
  final String title;     // 任务标题描述
  final int reward;       // 完成奖励的积分额度
  final bool completed;   // 是否已完成

  Task({
    required this.id,
    required this.title,
    required this.reward,
    required this.completed,
  });
}
