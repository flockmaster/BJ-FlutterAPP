// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
      cartId: json['cartId'] as String,
      product: StoreProduct.fromJson(json['product'] as Map<String, dynamic>),
      selectedSpec: json['selectedSpec'] as String,
      selections: Map<String, String>.from(json['selections'] as Map),
      quantity: (json['quantity'] as num).toInt(),
      selected: json['selected'] as bool? ?? true,
    );

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'cartId': instance.cartId,
      'product': instance.product,
      'selectedSpec': instance.selectedSpec,
      'selections': instance.selections,
      'quantity': instance.quantity,
      'selected': instance.selected,
    };
