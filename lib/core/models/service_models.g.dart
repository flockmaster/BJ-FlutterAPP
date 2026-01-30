// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleInfo _$VehicleInfoFromJson(Map<String, dynamic> json) => VehicleInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      plateNumber: json['plateNumber'] as String,
      imageUrl: json['imageUrl'] as String,
      fuelLevel: (json['fuelLevel'] as num?)?.toInt() ?? 0,
      mileage: (json['mileage'] as num?)?.toInt() ?? 0,
      nextMaintenanceKm: (json['nextMaintenanceKm'] as num?)?.toInt() ?? 0,
      dataRemaining: (json['dataRemaining'] as num?)?.toDouble() ?? 0.0,
      insuranceExpiry: json['insuranceExpiry'] as String? ?? '',
      lastMaintenanceDate: json['lastMaintenanceDate'] as String? ?? '',
      healthStatus: json['healthStatus'] as String? ?? '健康',
    );

Map<String, dynamic> _$VehicleInfoToJson(VehicleInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'plateNumber': instance.plateNumber,
      'imageUrl': instance.imageUrl,
      'fuelLevel': instance.fuelLevel,
      'mileage': instance.mileage,
      'nextMaintenanceKm': instance.nextMaintenanceKm,
      'dataRemaining': instance.dataRemaining,
      'insuranceExpiry': instance.insuranceExpiry,
      'lastMaintenanceDate': instance.lastMaintenanceDate,
      'healthStatus': instance.healthStatus,
    };

ChargeStation _$ChargeStationFromJson(Map<String, dynamic> json) =>
    ChargeStation(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      distance: (json['distance'] as num).toDouble(),
      availableSlots: (json['availableSlots'] as num?)?.toInt() ?? 0,
      totalSlots: (json['totalSlots'] as num?)?.toInt() ?? 0,
      pricePerKwh: (json['pricePerKwh'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$ChargeStationToJson(ChargeStation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'distance': instance.distance,
      'availableSlots': instance.availableSlots,
      'totalSlots': instance.totalSlots,
      'pricePerKwh': instance.pricePerKwh,
    };

NearbyStore _$NearbyStoreFromJson(Map<String, dynamic> json) => NearbyStore(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String? ?? '',
      distance: (json['distance'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$NearbyStoreToJson(NearbyStore instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'distance': instance.distance,
      'imageUrl': instance.imageUrl,
      'rating': instance.rating,
      'services': instance.services,
    };

TravelService _$TravelServiceFromJson(Map<String, dynamic> json) =>
    TravelService(
      id: json['id'] as String,
      label: json['label'] as String,
      iconName: json['iconName'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      route: json['route'] as String? ?? '',
    );

Map<String, dynamic> _$TravelServiceToJson(TravelService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'iconName': instance.iconName,
      'imageUrl': instance.imageUrl,
      'route': instance.route,
    };

CoreServiceItem _$CoreServiceItemFromJson(Map<String, dynamic> json) =>
    CoreServiceItem(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      imageUrl: json['imageUrl'] as String,
      route: json['route'] as String? ?? '',
    );

Map<String, dynamic> _$CoreServiceItemToJson(CoreServiceItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'imageUrl': instance.imageUrl,
      'route': instance.route,
    };
