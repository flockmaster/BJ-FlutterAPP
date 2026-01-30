import '../../../app/app.locator.dart';

import '../../../core/base/baic_base_view_model.dart';
import '../../../core/services/user_content_service.dart';
import '../../../core/models/discovery_models.dart';

/// 收藏类型
enum FavoriteType {
  content, // 内容
  product, // 商品
}

/// 我的收藏页面ViewModel
/// [MyFavoritesViewModel] - 个人收藏夹（多维内容集合）业务逻辑类
///
/// 核心职责：
/// 1. 分类展示用户收藏的社区内容（帖子/资讯）与商城商品。
/// 2. 分发跳转指令：进入详情页、直接加入购物车、以及批量/单个取消收藏。
class MyFavoritesViewModel extends BaicBaseViewModel {
  final _userContentService = locator<IUserContentService>();

  /// 当前选中的收藏分类（内容 vs 商品）
  FavoriteType _activeTab = FavoriteType.content;
  FavoriteType get activeTab => _activeTab;

  /// 已收藏的社区内容流
  List<DiscoveryItem> _favoriteContents = [];
  List<DiscoveryItem> get favoriteContents => _favoriteContents;

  /// 已收藏的商城商品列表
  List<Map<String, dynamic>> _favoriteProducts = [];
  List<Map<String, dynamic>> get favoriteProducts => _favoriteProducts;

  /// 生命周期：初始化时并发加载两个维度的收藏数据
  Future<void> init() async {
    await Future.wait([
      loadFavoriteContents(),
      loadFavoriteProducts(),
    ]);
  }

  /// 交互：在内容与商品 Tab 间切换，驱动 UI 列表重绘
  void switchTab(FavoriteType type) {
    _activeTab = type;
    notifyListeners();
  }

  /// 业务加载：获取社区维度的收藏项
  Future<void> loadFavoriteContents() async {
    setBusy(true);
    
    try {
      const userId = 'current_user';
      _favoriteContents = await _userContentService.getFavoriteContents(userId);
      notifyListeners();
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  /// 业务加载：获取商城维度的收藏项
  Future<void> loadFavoriteProducts() async {
    try {
      const userId = 'current_user';
      _favoriteProducts = await _userContentService.getFavoriteProducts(userId);
      notifyListeners();
    } catch (e) {
      setError(e);
    }
  }

  /// 交互：点击收藏的内容导向社区详情
  void handleContentTap(DiscoveryItem content) {
    MapsTo(
      Routes.discoveryDetailView,
      arguments: DiscoveryDetailViewArguments(itemId: content.id),
    );
  }

  /// 交互：点击收藏的商品导向详情或 SKU 选择
  void handleProductTap(Map<String, dynamic> product) {
    final productId = product['id'];
    if (productId != null) {
      final int? id = productId is int 
          ? productId 
          : (productId is String ? int.tryParse(productId) : null);
      
      if (id != null) {
        MapsTo(
          Routes.productDetailView,
          arguments: ProductDetailViewArguments(productId: id),
        );
      }
    }
  }

  /// 交互：唤起全局/收藏夹内部搜索
  void handleSearch() {
  }

  /// 指令：在收藏列表直接唤起快捷加车逻辑
  Future<void> addToCart(Map<String, dynamic> product) async {
    try {
      final productId = product['id'] as String;
      final success = await _userContentService.addToCart(productId, 1);
      
      if (success) {
      }
    } catch (e) {
      setError(e);
    }
  }

  /// 业务：单条移除内容收藏
  Future<void> removeFavoriteContent(String contentId) async {
    try {
      final success = await _userContentService.removeFavorite(contentId, 'content');
      if (success) {
        _favoriteContents.removeWhere((item) => item.id == contentId);
        notifyListeners();
      }
    } catch (e) {
      setError(e);
    }
  }

  /// 业务：单条移除商品收藏
  Future<void> removeFavoriteProduct(String productId) async {
    try {
      final success = await _userContentService.removeFavorite(productId, 'product');
      if (success) {
        _favoriteProducts.removeWhere((item) => item['id'] == productId);
        notifyListeners();
      }
    } catch (e) {
      setError(e);
    }
  }
}
