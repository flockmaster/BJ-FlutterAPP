import 'package:json_annotation/json_annotation.dart';
import 'store_models.dart';

part 'cart_item.g.dart';

/// [CartItem] - 购物车详情条目模型
/// 
/// 承载：商品基本信息、用户选择的规格组合（如：颜色、尺寸）、购买数量以及单项勾选状态。
@JsonSerializable()
class CartItem {
  final String cartId;                  // 购物车条目唯一 ID（非商品 ID）
  final StoreProduct product;           // 关联的商城商品对象
  final String selectedSpec;            // 汇总的选定规格文字描述（如：“黑色, L码”）
  final Map<String, String> selections; // 具体的规格键值对（如：{color: 'black', size: 'std'}）
  final int quantity;                   // 选购数量
  final bool selected;                  // 是否在结算页被勾选

  const CartItem({
    required this.cartId,
    required this.product,
    required this.selectedSpec,
    required this.selections,
    required this.quantity,
    this.selected = true,
  });

  /// 计算单项商品的总计价格（原价 + 规格加价）* 数量
  double get totalPrice {
    double basePrice = product.price;
    
    // 逻辑：遍历选中的规格，累加每个选项对应的价格调整值 (priceMod)
    if (product.specifications != null) {
      for (var spec in product.specifications!) {
        final selectedValue = selections[spec.id];
        if (selectedValue != null) {
          final option = spec.options.firstWhere(
            (opt) => opt.value == selectedValue,
            orElse: () => spec.options.first,
          );
          if (option.priceMod != null) {
            basePrice += option.priceMod!;
          }
        }
      }
    }
    
    return basePrice * quantity;
  }

  CartItem copyWith({
    String? cartId,
    StoreProduct? product,
    String? selectedSpec,
    Map<String, String>? selections,
    int? quantity,
    bool? selected,
  }) {
    return CartItem(
      cartId: cartId ?? this.cartId,
      product: product ?? this.product,
      selectedSpec: selectedSpec ?? this.selectedSpec,
      selections: selections ?? this.selections,
      quantity: quantity ?? this.quantity,
      selected: selected ?? this.selected,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
