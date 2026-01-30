import '../base/base_state.dart';
import '../models/invite_models.dart';

/// [IInviteService] - 邀请好友与转推荐服务接口
/// 
/// 负责处理：获取用户专属邀请码、查询邀请记录统计、发送邀请链接、以及验证好友填写的邀请码。
abstract class IInviteService {
  /// 获取邀请页面所需的详细数据（包含代码、列表、累计奖励等）
  Future<Result<InviteData>> getInviteData();
  
  /// 仅获取邀请进度的统计摘要
  Future<Result<InviteStats>> getInviteStats();
  
  /// 执行发送邀请操作
  /// [method]：分享渠道（如：微信、朋友圈）
  /// [target]：目标标识
  Future<Result<bool>> sendInvite(String method, String target);
  
  /// 验证并绑定邀请码逻辑
  /// [code]：填写的邀请码
  Future<Result<bool>> validateInviteCode(String code);
}

/// [InviteService] - 邀请服务实现
/// 
/// 遵循 [IInviteService] 接口，目前包含 Mock 返回逻辑。
class InviteService implements IInviteService {
  @override
  Future<Result<InviteData>> getInviteData() async {
    try {
      // 模拟后端 API 网络延迟
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockData = InviteData(
        inviteCode: 'BJ8888',
        inviteList: [
          InviteRecord(
            id: '1',
            name: '微信好友_OldWang',
            avatar: 'https://randomuser.me/api/portraits/men/11.jpg',
            date: '2023-12-28',
            status: InviteStatus.success,
            reward: 500,
          ),
          InviteRecord(
            id: '2',
            name: 'Lisa',
            avatar: 'https://randomuser.me/api/portraits/women/23.jpg',
            date: '2023-12-25',
            status: InviteStatus.success,
            reward: 500,
          ),
          InviteRecord(
            id: '3',
            name: '大漠孤烟',
            avatar: 'https://randomuser.me/api/portraits/men/45.jpg',
            date: '2023-12-20',
            status: InviteStatus.pending,
            reward: 0,
          ),
        ],
        successfulInvites: 2,
        totalRewards: 1000,
      );
      
      return Result.success(mockData);
    } catch (e) {
      return Result.failure('获取邀请数据失败: ${e.toString()}');
    }
  }

  @override
  Future<Result<InviteStats>> getInviteStats() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final mockStats = InviteStats(
        totalInvites: 3,
        successfulInvites: 2,
        pendingInvites: 1,
        totalRewards: 1000,
      );
      
      return Result.success(mockStats);
    } catch (e) {
      return Result.failure('获取邀请统计失败: ${e.toString()}');
    }
  }

  @override
  Future<Result<bool>> sendInvite(String method, String target) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return Result.success(true);
    } catch (e) {
      return Result.failure('发送邀请失败: ${e.toString()}');
    }
  }

  @override
  Future<Result<bool>> validateInviteCode(String code) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // 基础校验规则：不为空且长度合理
      if (code.isEmpty || code.length < 4) {
        return Result.failure('邀请码格式不正确');
      }
      
      return Result.success(true);
    } catch (e) {
      return Result.failure('验证邀请码失败: ${e.toString()}');
    }
  }
}
