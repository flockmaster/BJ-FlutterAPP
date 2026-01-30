// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charging_station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChargingStation _$ChargingStationFromJson(Map<String, dynamic> json) =>
    ChargingStation(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      fastChargers: (json['fastChargers'] as num).toInt(),
      slowChargers: (json['slowChargers'] as num).toInt(),
      brand: $enumDecode(_$ChargingBrandEnumMap, json['brand']),
      isOfficial: json['isOfficial'] as bool? ?? false,
      isOpen: json['isOpen'] as bool? ?? true,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$ChargingStationToJson(ChargingStation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'distance': instance.distance,
      'price': instance.price,
      'fastChargers': instance.fastChargers,
      'slowChargers': instance.slowChargers,
      'brand': _$ChargingBrandEnumMap[instance.brand]!,
      'isOfficial': instance.isOfficial,
      'isOpen': instance.isOpen,
      'address': instance.address,
      'phone': instance.phone,
    };

const _$ChargingBrandEnumMap = {
  ChargingBrand.baic: 'BAIC',
  ChargingBrand.state: 'STATE',
  ChargingBrand.teld: 'TELD',
  ChargingBrand.other: 'OTHER',
};
