import 'package:json_annotation/json_annotation.dart';

part 'store_order.g.dart';

/// [StoreOrder] - 商品订单摘要模型
@JsonSerializable()
class StoreOrder {
  final int id;                 // 订单唯一 ID
  @JsonKey(name: 'order_no')
  final String orderNo;         // 订单流水号
  @JsonKey(name: 'total_amount')
  final double totalAmount;     // 订单总金额（优惠前）
  @JsonKey(name: 'freight_amount')
  final double freightAmount;   // 运费金额
  @JsonKey(name: 'discount_amount')
  final double discountAmount;  // 已优惠/抵扣金额
  @JsonKey(name: 'final_amount')
  final double finalAmount;     // 最终实付金额
  final String status;          // 订单状态（如：pending_payment, paid, shipped, completed, cancelled）
  
  @JsonKey(name: 'order_items')
  final List<StoreOrderItem>? items; // 订单包含的商品明细列表

  StoreOrder({
    required this.id,
    required this.orderNo,
    required this.totalAmount,
    required this.freightAmount,
    required this.discountAmount,
    required this.finalAmount,
    required this.status,
    this.items,
  });

  factory StoreOrder.fromJson(Map<String, dynamic> json) => _$StoreOrderFromJson(json);
  Map<String, dynamic> toJson() => _$StoreOrderToJson(this);
}

/// [StoreOrderItem] - 订单单项商品条目模型
@JsonSerializable()
class StoreOrderItem {
  final int id;                         // 条目 ID
  @JsonKey(name: 'product_title')
  final String productTitle;            // 商品名称
  @JsonKey(name: 'product_image')
  final String? productImage;           // 商品快照图 URL
  @JsonKey(name: 'spec_name')
  final String? specName;               // 购买时的规格描述（如：颜色:白色;尺寸:XL）
  final double price;                   // 下单时的单价
  final int quantity;                   // 购买数量

  StoreOrderItem({
    required this.id,
    required this.productTitle,
    this.productImage,
    this.specName,
    required this.price,
    required this.quantity,
  });

  factory StoreOrderItem.fromJson(Map<String, dynamic> json) => _$StoreOrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$StoreOrderItemToJson(this);
}
