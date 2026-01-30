import 'package:car_owner_app/core/base/baic_base_view_model.dart';
import 'package:car_owner_app/core/base/base_state.dart';
import 'package:car_owner_app/core/models/discovery_models.dart';
import 'package:car_owner_app/core/services/discovery_service.dart';
import 'package:car_owner_app/app/app.locator.dart';

/// [DiscoveryViewModel] - 发现页（社区/社交）核心业务逻辑类
///
/// 承载了：
/// 1. 多频道数据加载（关注、推荐、车型、官方、去野等）。
/// 2. 状态映射（转换 Stacked 基类状态为 UI 层需要的 ViewState）。
/// 3. 分页刷新与后台预加载逻辑。
class DiscoveryViewModel extends BaicBaseViewModel {
  final _discoveryService = locator<IDiscoveryService>();

  /// 推荐流数据列表
  List<DiscoveryItem> _items = [];
  List<DiscoveryItem> get items => _items;

  /// “官方”频道聚合数据
  OfficialData? _officialData;
  OfficialData? get officialData => _officialData;

  /// “去野”频道活动数据
  GoWildData? _goWildData;
  GoWildData? get goWildData => _goWildData;

  /// 已关注用户的动态流
  List<DiscoveryItem> _followItems = [];
  List<DiscoveryItem> get followItems => _followItems;

  /// 缓存的特定车型动态列表 (Key: 车型 ID/名称)
  final Map<String, List<DiscoveryItem>> _modelFeeds = {};

  /// 下拉刷新入口
  Future<void> refresh() => onRefresh();

  /// 页面生命周期初始化
  /// [showLoading]: 是否触发展示全屏骨架屏，刷新时设为 false
  Future<void> init({bool showLoading = true}) async {
    if (showLoading) setBusy(true);
    // 并行获取各频道首屏数据，优化启动速度
    await Future.wait([
      _fetchDiscoveryItems(),
      _fetchFollowItems(),
      _fetchOfficialData(),
      _fetchGoWildData(),
    ]);
    if (showLoading) setBusy(false);
  }

  /// 处理下拉刷新事件
  Future<void> onRefresh() async {
    _modelFeeds.clear();
    await init(showLoading: false);
  }

  /// 获取指定车型的动态流
  /// 若缓存不存在则触发后台拉取
  List<DiscoveryItem> getModelFeed(String model) {
    if (_modelFeeds.containsKey(model)) {
      return _modelFeeds[model]!;
    }
    _fetchModelFeed(model);
    return []; 
  }

  /// 异步拉取特定车型动态并更新 UI
  Future<void> _fetchModelFeed(String model) async {
    if (_modelFeeds.containsKey(model)) return;
    final items = await _discoveryService.getModelFeed(model);
    _modelFeeds[model] = items;
    notifyListeners();
  }

  Future<void> _fetchDiscoveryItems() async {
    _items = await _discoveryService.getDiscoveryItems();
    notifyListeners();
  }

  Future<void> _fetchFollowItems() async {
    _followItems = await _discoveryService.getFollowItems();
    notifyListeners();
  }

  Future<void> _fetchOfficialData() async {
    _officialData = await _discoveryService.getOfficialData();
    notifyListeners();
  }

  Future<void> _fetchGoWildData() async {
    _goWildData = await _discoveryService.getGoWildData();
    notifyListeners();
  }

  /// 为了兼容性手动处理的状态映射
  ViewState get state {
    if (isBusy) return ViewState.loading;
    if (hasError) return ViewState.error;
    if (_items.isNotEmpty) return ViewState.success;
    return ViewState.idle;
  }
  
  bool get isEmpty => _items.isEmpty;
}
