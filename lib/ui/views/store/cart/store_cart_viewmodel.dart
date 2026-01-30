import 'package:flutter/material.dart'; // Keeping temporarily if needed by other logic, though context should be gone
import 'package:car_owner_app/core/base/baic_base_view_model.dart';
import '../../../../app/app.locator.dart';
import '../../../../core/services/cart_service.dart';
import '../../../../core/models/cart_item.dart';
// Correct Router Import for Stacked

class StoreCartViewModel extends BaicBaseViewModel {
  final _cartService = locator<ICartService>();

  List<CartItem> _items = [];
  List<CartItem> get items => _items;

  bool _isEditMode = false;
  bool get isEditMode => _isEditMode;

  Future<void> init() async {
    setBusy(true);
    try {
      await _loadCartItems();
    } catch (e) {
      print('购物车加载错误: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> _loadCartItems() async {
    _items = await _cartService.getCartItems();
    notifyListeners();
  }

  void toggleEditMode() {
    _isEditMode = !_isEditMode;
    notifyListeners();
  }

  void toggleSelect(String cartId) {
    final index = _items.indexWhere((item) => item.cartId == cartId);
    if (index != -1) {
      _items[index] = _items[index].copyWith(selected: !_items[index].selected);
      _cartService.updateCartItem(_items[index]);
      notifyListeners();
    }
  }

  void toggleSelectAll() {
    final newValue = !isAllSelected;
    _items = _items.map((item) => item.copyWith(selected: newValue)).toList();
    for (var item in _items) {
      _cartService.updateCartItem(item);
    }
    notifyListeners();
  }

  Future<void> updateQuantity(String cartId, int delta) async {
    final index = _items.indexWhere((item) => item.cartId == cartId);
    if (index != -1) {
      final newQuantity = (_items[index].quantity + delta).clamp(1, 99);
      _items[index] = _items[index].copyWith(quantity: newQuantity);
      await _cartService.updateCartItem(_items[index]);
      notifyListeners();
    }
  }

  Future<void> deleteSelected() async {
    final result = await dialogService.showConfirmationDialog(
      title: '确认删除',
      description: '确定要删除选中的商品吗？',
      confirmationTitle: '删除',
      cancelTitle: '取消',
    );

    if (result?.confirmed == true) {
      final selectedIds = selectedItems.map((item) => item.cartId).toList();
      await _cartService.removeMultiple(selectedIds);
      await _loadCartItems();
      _isEditMode = false;
      notifyListeners();
    }
  }

  // Pure Logic Checkout - No Context
  Future<void> checkout() async {
    // 构造参数
    final List<Map<String, dynamic>> checkoutItems = selectedItems.map((item) => {
          'product': item.product,
          'spec': item.selectedSpec,
          'quantity': item.quantity,
          'selections': item.selections,
        }).toList();
    
    // 使用 MapsTo 跳转
    await MapsTo(
      Routes.storeCheckoutView, 
      arguments: StoreCheckoutViewArguments(items: checkoutItems),
    );
  }

  // Deprecated: Removed checkoutWithContext
  void checkoutWithContext(BuildContext context) {
    checkout();
  }

  // 重写 goBack，虽然基类有，但这里可能只是为了覆盖行为（虽然没必要）
  // 既然基类有，这里可以删除，或者保留调用基类
  // 其实基类的 goBack 参数有所不同，这里原版是 void goBack() { _navigationService.back(); }
  // 基类是 void goBack({dynamic result})
  // 所以我们可以直接删除这个方法，使用基类的。

  // 计算属性
  List<CartItem> get selectedItems => _items.where((item) => item.selected).toList();

  bool get isAllSelected => _items.isNotEmpty && _items.every((item) => item.selected);

  int get totalCount => selectedItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice {
    return selectedItems.fold(0.0, (sum, item) {
      return sum + item.totalPrice;
    });
  }
}
