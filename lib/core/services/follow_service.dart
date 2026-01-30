import '../models/follow_models.dart';
import 'mock_data/mock_follow_data.dart';

/// [IFollowService] - 社区社交关注服务接口
/// 
/// 负责处理：用户间的关注与粉丝列表获取、以及切换关注状态（关注/取关）业务。
abstract class IFollowService {
  /// 获取当前用户的关注列表
  Future<List<FollowUser>> getFollowingList();
  
  /// 获取当前用户的粉丝列表
  Future<List<FollowUser>> getFollowersList();
  
  /// 切换关注状态
  /// [userId]：目标用户 ID
  /// 返回 true 表示操作成功
  Future<bool> toggleFollow(int userId);
}

/// [FollowService] - 关注服务具体实现
class FollowService implements IFollowService {
  @override
  Future<List<FollowUser>> getFollowingList() async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));
    return MockFollowData.followingUsers;
  }

  @override
  Future<List<FollowUser>> getFollowersList() async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));
    return MockFollowData.followerUsers;
  }

  @override
  Future<bool> toggleFollow(int userId) async {
    // 模拟异步网络请求
    await Future.delayed(const Duration(milliseconds: 300));
    // 实际业务中应在此处调用 ApiClient 进行持久化
    return true;
  }
}
