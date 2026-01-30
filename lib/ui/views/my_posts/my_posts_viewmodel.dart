import '../../../app/app.locator.dart';

import '../../../core/base/baic_base_view_model.dart';
import '../../../core/services/user_content_service.dart';
import '../../../core/models/discovery_models.dart';

/// 我的发布页面ViewModel
/// [MyPostsViewModel] - 个人发布历史（动态归档）业务逻辑类
///
/// 核心职责：
/// 1. 展示当前登录用户在社区发布的所有历史内容（DiscoveryItems）。
/// 2. 分发管理指令：查看详情、编辑、以及单条发布的物理删除。
class MyPostsViewModel extends BaicBaseViewModel {
  final _userContentService = locator<IUserContentService>();

  /// 用户的历史发帖集
  List<DiscoveryItem> _posts = [];
  List<DiscoveryItem> get posts => _posts;

  /// 生命周期：加载用户创作的内容流
  Future<void> init() async {
    await loadPosts();
  }

  /// 业务加载：从内容服务中筛选出归属于当前账号的动态
  Future<void> loadPosts() async {
    setBusy(true);
    
    try {
      const userId = 'current_user';
      _posts = await _userContentService.getUserPosts(userId);
      notifyListeners();
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  /// 交互：点击历史贴子跳转至社区详情页查看互动与评论
  void handlePostTap(DiscoveryItem post) {
    MapsTo(
      Routes.discoveryDetailView,
      arguments: DiscoveryDetailViewArguments(itemId: post.id),
    );
  }

  /// 交互：展示更多发泄（如下载、隐藏、删除）
  void handleMore() {
  }

  /// 业务：物理删除指定的帖子，并实时回推本地列表刷新
  Future<void> deletePost(String postId) async {
    try {
      final success = await _userContentService.deletePost(postId);
      if (success) {
        _posts.removeWhere((post) => post.id == postId);
        notifyListeners();
      }
    } catch (e) {
      setError(e);
    }
  }
}
