import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';

import '../../../core/models/store_models.dart';
import '../../../core/models/cart_item.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/services/store_service.dart';
import '../../../core/base/baic_base_view_model.dart';

enum SkuModalMode {
  addToCart,
  buyNow,
  both,
}

class ProductDetailViewModel extends BaicBaseViewModel {
  final _cartService = locator<ICartService>();
  final _storeService = locator<IStoreService>();

  final int productId;
  ProductDetailViewModel({required this.productId});

  StoreProduct? _product;
  StoreProduct? get product => _product;

  bool _isScrolled = false;
  bool get isScrolled => _isScrolled;

  bool _isFavorited = false;
  bool get isFavorited => _isFavorited;

  int _cartCount = 0;
  int get cartCount => _cartCount;

  // Gallery State
  final PageController galleryController = PageController();
  int _currentGalleryIndex = 1;
  int get currentGalleryIndex => _currentGalleryIndex;

  // Modal State
  bool _showSkuModal = false;
  bool get showSkuModal => _showSkuModal;

  SkuModalMode _skuModalMode = SkuModalMode.both;
  SkuModalMode get skuModalMode => _skuModalMode;

  bool _buyNowMode = false;
  bool get buyNowMode => _buyNowMode;

  // SKU Selection State
  Map<String, ProductSpecOption> _selections = {};
  Map<String, ProductSpecOption> get selections => _selections;

  int _quantity = 1;
  int get quantity => _quantity;

  // 详情图片流 - 优先从商品加载，否则使用默认
  List<String> get detailImages => _product?.detailImages ?? _defaultDetailImages;

  static const List<String> _defaultDetailImages = [
    'https://i.imgs.ovh/2025/12/25/CG5HDa.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG52Fe.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5JIt.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5oaq.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG545C.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5EE4.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5l0A.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5tbN.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5K2H.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5pXU.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5hFX.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5GDQ.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5mhF.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5xam.jpeg',
    'https://i.imgs.ovh/2025/12/25/CG5B59.jpeg',
  ];

  // 画廊图片（顶部轮播图）：优先使用 gallery 字段，其次是 detailImages 的前几张，最后是主图
  List<String> get galleryImages {
    // 1. 优先使用专门的轮播图字段
    if (_product?.gallery != null && _product!.gallery!.isNotEmpty) {
      return _product!.gallery!;
    }
    // 2. 备选使用详情图（兼容老数据）
    if (_product?.detailImages != null && _product!.detailImages!.isNotEmpty) {
      return _product!.detailImages!;
    }
    // 3. 最后使用主图
    if (_product != null) {
      return [_product!.image];
    }
    return _defaultDetailImages.take(5).toList();
  }

  Future<void> init() async {
    setBusy(true);
    
    // 加载商品数据
    _product = await _storeService.getProductById(productId.toString());
    
    // 加载购物车数量
    final cartItems = await _cartService.getCartItems();
    _cartCount = cartItems.length;

    // 默认选择第一个规格
    if (_product?.specifications != null) {
      for (var spec in _product!.specifications!) {
        if (spec.options.isNotEmpty) {
          _selections[spec.id] = spec.options.first;
        }
      }
    }
    
    setBusy(false);
  }

  void onScroll(double offset) {
    bool scrolled = offset > 100;
    if (_isScrolled != scrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }

  void onGalleryPageChanged(int index) {
    _currentGalleryIndex = index + 1;
    notifyListeners();
  }

  void openSkuModal({required SkuModalMode mode}) {
    _skuModalMode = mode;
    // If opening in specific mode, set the internal confirm behavior
    if (mode == SkuModalMode.buyNow) {
      _buyNowMode = true;
    } else if (mode == SkuModalMode.addToCart) {
      _buyNowMode = false;
    }
    _showSkuModal = true;
    notifyListeners();
  }

  void handleSkuAction({required bool buyNow}) {
    print('⚡ handleSkuAction called, buyNow: $buyNow');
    _buyNowMode = buyNow;
    print('⚡ _buyNowMode set to: $_buyNowMode');
    confirmAction();
  }

  void closeSkuModal() {
    _showSkuModal = false;
    notifyListeners();
  }

  void selectOption(String specId, ProductSpecOption option) {
    _selections[specId] = option;
    notifyListeners();
  }

  void updateQuantity(int delta) {
    int newQty = _quantity + delta;
    if (newQty >= 1) {
      _quantity = newQty;
      notifyListeners();
    }
  }

  // Calculation Logic
  double get basePrice {
    return _product?.price ?? 0.0;
  }

  double get specPrice {
    if (_product == null) return 0.0;
    double base = _product!.price;
    double mod = 0.0;
    
    // Check 'spec' specifically for price mod as per React code
    if (_selections.containsKey('spec')) {
      mod = _selections['spec']?.priceMod ?? 0.0;
    }
    return base + mod;
  }

  String get selectionText {
    // E.g. "经典黑 · 标准版 · 1件"
    List<String> parts = [];
    _selections.values.forEach((opt) => parts.add(opt.label));
    parts.add('$_quantity件');
    return parts.join(' · ');
  }

  Future<void> confirmAction() async {
    print('🔍 confirmAction called, buyNowMode: $_buyNowMode');
    
    if (_buyNowMode) {
      // 立即购买 - 关闭模态框并导航到结算页面
      print('🛒 立即购买模式 - 准备导航到结算页面');
      
      _showSkuModal = false;
      notifyListeners();
      
      // 等待模态框动画完成
      await Future.delayed(const Duration(milliseconds: 350));
      
      print('🚀 开始导航到结算页面');
      print('📦 商品数据: ${createCheckoutItem()}');
      
      // 使用 NavigationService 导航到结算页面
      try {
        await navigationService.navigateToStoreCheckoutView(
          items: [createCheckoutItem()],
        );
        print('✅ 导航成功');
      } catch (e) {
        print('❌ 导航失败: $e');
      }
    } else {
      // 加入购物车
      print('🛍️ 加入购物车模式');
      
      final cartItem = CartItem(
        cartId: 'cart_${DateTime.now().millisecondsSinceEpoch}',
        product: _product!,
        selectedSpec: selectionText,
        selections: _selections.map((key, value) => MapEntry(key, value.value)),
        quantity: _quantity,
        selected: true,
      );
      
      await _cartService.addToCart(cartItem);
      _cartCount++;
      
      closeSkuModal();
      notifyListeners();
      
      print('✅ 已加入购物车');
    }
  }

  Map<String, dynamic> createCheckoutItem() {
    return {
      'product': _product,
      'spec': selectionText,
      'quantity': _quantity,
      'selections': _selections.map((key, value) => MapEntry(key, value.value)),
    };
  }

  void toggleFavorite() {
    _isFavorited = !_isFavorited;
    notifyListeners();
  }

  void goToCart() {
    navigationService.navigateToStoreCartView();
  }

  @override
  void dispose() {
    galleryController.dispose();
    super.dispose();
  }
}
