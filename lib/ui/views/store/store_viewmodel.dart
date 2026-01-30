import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/base/baic_base_view_model.dart';
import '../../../core/services/store_service.dart';
import '../../../core/services/mock_data/mock_store_data.dart';
import '../../../core/models/store_models.dart';

/// [StoreViewModel] - 精品商城（改装与周边）核心业务逻辑类
///
/// 核心职责：
/// 1. 管理商城的分类体系、特色推荐位、热卖榜单及主题专区数据。
/// 2. 处理极具沉浸感的首页 UI 交互状态：动态 Header 透明度、全屏搜索蒙层显示逻辑。
/// 3. 管理本地化搜索历史（持久化暂缓）及购物车简易角标状态。
class StoreViewModel extends BaicBaseViewModel {
  final _storeService = locator<IStoreService>();

  /// 商品分类列表（含轮播、特色位、推荐商品等嵌套结构）
  List<StoreCategory> _categories = [];
  List<StoreCategory> get categories => _categories;

  /// 本次会话的搜索历史项
  List<String> _searchHistory = ['BJ60脚垫', '露营灯'];
  List<String> get searchHistory => _searchHistory;

  /// 热门搜索词云（源自 Mock 数据或后端下发）
  List<String> get trendingSearches => MockStoreData.trendingSearches;

  /// 购物车简易项计数（用于控制角标显隐）
  List<dynamic> _cartItems = [];
  List<dynamic> get cartItems => _cartItems;

  /// 首页是否处于滚动激活态（用于切换深浅色图标/文字）
  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  /// 搜索遮罩层显示状态
  bool _searchVisible = false;
  bool get searchVisible => _searchVisible;

  /// 生命周期：初始化页面分类数据
  Future<void> init({bool showLoading = true}) async {
    if (showLoading) setBusy(true);
    await loadCategories();
    if (showLoading) setBusy(false);
  }

  /// 业务：下拉刷新商城全局数据
  Future<void> refresh() async {
    await init(showLoading: false);
  }

  /// 业务加载：从远程服务拉取层次化分类定义
  Future<void> loadCategories() async {
    try {
      _categories = await _storeService.getCategories();
    } catch (e) {
      setError('加载商城分类失败');
    }
    notifyListeners();
  }

  /// 导航：导向商品详情页
  void navigateToProductDetail(int productId) {
    MapsTo(Routes.productDetailView, arguments: ProductDetailViewArguments(productId: productId));
  }

  /// 导航：导向购物车详情
  void navigateToCart() {
    MapsTo(Routes.storeCartView);
  }

  // --- UI 构建辅助逻辑 ---

  /// 设置滚动高度标识（废弃，目前 View 层已通过偏移量动态计算）
  void setIsScrolled(bool value) {
    if (_isScrolled != value) {
      _isScrolled = value;
      notifyListeners();
    }
  }

  /// 启动全屏搜索模式
  void openSearch() {
    _searchVisible = true;
    notifyListeners();
  }

  /// 关闭全屏搜索模式
  void closeSearch() {
    _searchVisible = false;
    notifyListeners();
  }

  /// 业务：添加并维护搜索历史记录
  void addSearchHistory(String term) {
    if (!_searchHistory.contains(term)) {
      _searchHistory = [term, ..._searchHistory].take(10).toList();
      notifyListeners();
    }
    closeSearch();
  }

  /// 业务：清空本地历史记录
  void clearSearchHistory() {
    _searchHistory = [];
    notifyListeners();
  }
}
