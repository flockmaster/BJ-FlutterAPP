import 'package:car_owner_app/core/base/baic_base_view_model.dart';
import 'package:car_owner_app/core/models/follow_models.dart';
import 'package:car_owner_app/core/services/follow_service.dart';
import 'package:car_owner_app/app/app.locator.dart';

/// 关注列表ViewModel
/// 遵循MVVM架构，数据从Service层获取
/// [FollowListViewModel] - 社交关系列表（关注/粉丝）业务逻辑类
///
/// 核心职责：
/// 1. 展示用户的社交网络：支持“我的关注”与“我的粉丝”两种模式的动态切换。
/// 2. 处理即时关注/取关交互，并与 [IFollowService] 同步云端关系链。
class FollowListViewModel extends BaicBaseViewModel {
  final IFollowService _followService = locator<IFollowService>();
  
  /// 当前展示的用户列表（包含基本资料与互关状态）
  List<FollowUser> _users = [];
  List<FollowUser> get users => _users;

  /// 列表类型标识：'following'（关注中） 或 'followers'（被关注）
  final String type;

  FollowListViewModel({this.type = 'following'});

  /// 生命周期：初始化时根据类型拉取差异化社交名单
  Future<void> init() async {
    setBusy(true);
    try {
      if (type == 'following') {
        _users = await _followService.getFollowingList();
      } else {
        _users = await _followService.getFollowersList();
      }
      notifyListeners();
    } catch (e) {
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }

  /// 交互：执行关注/取消关注动作
  /// 采用乐观 UI 更新策略：先响应本地列表状态，再异步同步至服务端。
  Future<void> toggleFollow(int id) async {
    final index = _users.indexWhere((u) => u.id == id);
    if (index != -1) {
      final user = _users[index];
      final updatedUser = user.copyWith(isFollowing: !user.isFollowing);
      _users[index] = updatedUser;
      notifyListeners();
      
      await _followService.toggleFollow(id);
    }
  }

  /// 辅助：获取当前页面的多语言标题
  String get title => type == 'following' ? '我的关注' : '我的粉丝';
}

