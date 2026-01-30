// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreOrder _$StoreOrderFromJson(Map<String, dynamic> json) => StoreOrder(
      id: (json['id'] as num).toInt(),
      orderNo: json['order_no'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      freightAmount: (json['freight_amount'] as num).toDouble(),
      discountAmount: (json['discount_amount'] as num).toDouble(),
      finalAmount: (json['final_amount'] as num).toDouble(),
      status: json['status'] as String,
      items: (json['order_items'] as List<dynamic>?)
          ?.map((e) => StoreOrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoreOrderToJson(StoreOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_no': instance.orderNo,
      'total_amount': instance.totalAmount,
      'freight_amount': instance.freightAmount,
      'discount_amount': instance.discountAmount,
      'final_amount': instance.finalAmount,
      'status': instance.status,
      'order_items': instance.items,
    };

StoreOrderItem _$StoreOrderItemFromJson(Map<String, dynamic> json) =>
    StoreOrderItem(
      id: (json['id'] as num).toInt(),
      productTitle: json['product_title'] as String,
      productImage: json['product_image'] as String?,
      specName: json['spec_name'] as String?,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$StoreOrderItemToJson(StoreOrderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_title': instance.productTitle,
      'product_image': instance.productImage,
      'spec_name': instance.specName,
      'price': instance.price,
      'quantity': instance.quantity,
    };
