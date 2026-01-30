import '../../../app/app.locator.dart';
import '../../../core/base/baic_base_view_model.dart';
import '../../../core/services/discovery_service.dart';
import '../../../core/models/discovery_models.dart';

/// [DiscoveryDetailViewModel] - 发现详情页面的业务逻辑类
class DiscoveryDetailViewModel extends BaicBaseViewModel {
  final _discoveryService = locator<IDiscoveryService>();

  /// 获取当前资讯详情实例
  DiscoveryItem? _item;
  DiscoveryItem? get item => _item;

  String? _itemId;

  /// 初始化详情页数据
  Future<void> init(String itemId) async {
    _itemId = itemId;
    setBusy(true);
    await _loadItem();
    setBusy(false);
  }

  /// 异步加载资讯主体及关联的评论信息
  Future<void> _loadItem() async {
    if (_itemId == null) return;
    
    try {
      _item = await _discoveryService.getItemById(_itemId!);
      notifyListeners();
    } catch (e) {
      setError('加载内容失败: ${e.toString()}');
    }
  }

  /// 刷新详情页数据
  Future<void> refresh() async {
    await _loadItem();
  }
}