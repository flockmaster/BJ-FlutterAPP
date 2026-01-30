// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAddress _$UserAddressFromJson(Map<String, dynamic> json) => UserAddress(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      contactName: json['contact_name'] as String,
      contactPhone: json['contact_phone'] as String,
      province: json['province'] as String,
      city: json['city'] as String,
      district: json['district'] as String,
      detailAddress: json['detail_address'] as String,
      isDefault: json['is_default'] as bool,
      tag: json['tag'] as String?,
    );

Map<String, dynamic> _$UserAddressToJson(UserAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'contact_name': instance.contactName,
      'contact_phone': instance.contactPhone,
      'province': instance.province,
      'city': instance.city,
      'district': instance.district,
      'detail_address': instance.detailAddress,
      'is_default': instance.isDefault,
      'tag': instance.tag,
    };
