// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coupon _$CouponFromJson(Map<String, dynamic> json) => Coupon(
      id: json['id'] as String,
      type: $enumDecode(_$CouponTypeEnumMap, json['type']),
      amount: json['amount'] as String,
      unit: json['unit'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      expiry: json['expiry'] as String,
      status: $enumDecode(_$CouponStatusEnumMap, json['status']),
      minAmount: (json['minAmount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CouponToJson(Coupon instance) => <String, dynamic>{
      'id': instance.id,
      'type': _$CouponTypeEnumMap[instance.type]!,
      'amount': instance.amount,
      'unit': instance.unit,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'expiry': instance.expiry,
      'status': _$CouponStatusEnumMap[instance.status]!,
      'minAmount': instance.minAmount,
    };

const _$CouponTypeEnumMap = {
  CouponType.discount: 'discount',
  CouponType.service: 'service',
  CouponType.charging: 'charging',
};

const _$CouponStatusEnumMap = {
  CouponStatus.valid: 'valid',
  CouponStatus.expired: 'expired',
  CouponStatus.used: 'used',
};
