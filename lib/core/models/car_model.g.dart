// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreInfo _$StoreInfoFromJson(Map<String, dynamic> json) => StoreInfo(
      name: json['name'] as String,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$StoreInfoToJson(StoreInfo instance) => <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
    };

CarVersion _$CarVersionFromJson(Map<String, dynamic> json) => CarVersion(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String?,
      specs: json['specs'] as Map<String, dynamic>?,
      badge: json['badge'] as String?,
      badgeColor: json['badgeColor'] as String?,
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CarVersionToJson(CarVersion instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'badge': instance.badge,
      'badgeColor': instance.badgeColor,
      'features': instance.features,
      'description': instance.description,
      'specs': instance.specs,
    };

PreviewFeature _$PreviewFeatureFromJson(Map<String, dynamic> json) =>
    PreviewFeature(
      title: json['title'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$PreviewFeatureToJson(PreviewFeature instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'icon': instance.icon,
    };

CarModel _$CarModelFromJson(Map<String, dynamic> json) => CarModel(
      id: CarModel._idFromJson(json['id']),
      modelKey: json['model_key'] as String,
      name: json['name'] as String,
      fullName: json['full_name'] as String,
      subtitle: json['subtitle'] as String,
      price: (json['price'] as num).toDouble(),
      priceUnit: json['price_unit'] as String?,
      backgroundImage: json['background_image'] as String,
      promoPrice: json['promo_price'] as String?,
      highlightImage: json['highlight_image'] as String?,
      highlightText: json['highlight_text'] as String?,
      vrImage: json['vr_image'] as String?,
      store: json['store'] == null
          ? null
          : StoreInfo.fromJson(json['store'] as Map<String, dynamic>),
      isPreview: json['is_preview'] == null
          ? false
          : CarModel._boolFromInt(json['is_preview']),
      releaseDate: json['release_date'] == null
          ? null
          : DateTime.parse(json['release_date'] as String),
      versions: json['versions'] == null
          ? const {}
          : CarModel._versionsFromJson(json['versions']),
      previewFeatures: (json['preview_features'] as List<dynamic>?)
          ?.map((e) => PreviewFeature.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CarModelToJson(CarModel instance) => <String, dynamic>{
      'id': instance.id,
      'model_key': instance.modelKey,
      'name': instance.name,
      'full_name': instance.fullName,
      'subtitle': instance.subtitle,
      'price': instance.price,
      'price_unit': instance.priceUnit,
      'background_image': instance.backgroundImage,
      'promo_price': instance.promoPrice,
      'highlight_image': instance.highlightImage,
      'highlight_text': instance.highlightText,
      'vr_image': instance.vrImage,
      'store': instance.store,
      'is_preview': instance.isPreview,
      'release_date': instance.releaseDate?.toIso8601String(),
      'versions': instance.versions,
      'preview_features': instance.previewFeatures,
      'created_at': instance.createdAt?.toIso8601String(),
    };
