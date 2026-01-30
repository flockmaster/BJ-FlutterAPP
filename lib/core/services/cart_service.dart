import 'package:injectable/injectable.dart';
import '../models/cart_item.dart';
import '../models/store_models.dart';

/// [ICartService] - 购物车业务服务接口
/// 
/// 负责管理用户在商城中选购的商品项，包括添加、更新数量、移除及清空购物车等操作。
abstract class ICartService {
  /// 获取购物车中的所有商品项列表
  Future<List<CartItem>> getCartItems();
  
  /// 将商品添加到购物车
  /// [item]：待添加的购物车商品项
  Future<void> addToCart(CartItem item);
  
  /// 更新购物车中已有商品的状态（如：调整购买数量、修改规格等）
  Future<void> updateCartItem(CartItem item);
  
  /// 从购物车中移除指定的商品项
  /// [cartId]：购物车项的唯一标识符
  Future<void> removeFromCart(String cartId);
  
  /// 清空当前用户的所有购物车商品
  Future<void> clearCart();
  
  /// 批量从购物车中移除多个商品项（常用于勾选后批量删除）
  /// [cartIds]：待删除的购物车项 ID 列表
  Future<void> removeMultiple(List<String> cartIds);
}

/// [CartService] - 购物车服务具体实现
/// 
/// 当前版本为本地内存维护方案，后续可扩展为对接 ApiClient 实现远端同步。
@LazySingleton(as: ICartService)
class CartService implements ICartService {
  // 内存存储：购物车商品列表
  final List<CartItem> _cartItems = [];

  @override
  Future<List<CartItem>> getCartItems() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_cartItems); // 返回副本以防外部意外修改私有状态
  }

  @override
  Future<void> addToCart(CartItem item) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cartItems.add(item);
  }

  @override
  Future<void> updateCartItem(CartItem item) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _cartItems.indexWhere((i) => i.cartId == item.cartId);
    if (index != -1) {
      _cartItems[index] = item;
    }
  }

  @override
  Future<void> removeFromCart(String cartId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cartItems.removeWhere((i) => i.cartId == cartId);
  }

  @override
  Future<void> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cartItems.clear();
  }

  @override
  Future<void> removeMultiple(List<String> cartIds) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cartItems.removeWhere((i) => cartIds.contains(i.cartId));
  }
}
