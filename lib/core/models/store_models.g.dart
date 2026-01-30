// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCategory _$ProductCategoryFromJson(Map<String, dynamic> json) =>
    ProductCategory(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$ProductCategoryToJson(ProductCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
    };

StoreProduct _$StoreProductFromJson(Map<String, dynamic> json) => StoreProduct(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      image: json['image_url'] as String,
      categoryId: (json['category_id'] as num?)?.toInt(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      specifications: (json['specifications'] as List<dynamic>?)
          ?.map((e) => ProductSpec.fromJson(e as Map<String, dynamic>))
          .toList(),
      points: (json['points'] as num?)?.toInt(),
      stockQuantity: (json['stock_quantity'] as num?)?.toInt() ?? 0,
      salesCount: (json['sales_count'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      type: json['type'] as String?,
      gallery:
          (json['gallery'] as List<dynamic>?)?.map((e) => e as String).toList(),
      detailImages: (json['detail_images'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$StoreProductToJson(StoreProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'original_price': instance.originalPrice,
      'image_url': instance.image,
      'category_id': instance.categoryId,
      'tags': instance.tags,
      'specifications': instance.specifications,
      'points': instance.points,
      'stock_quantity': instance.stockQuantity,
      'sales_count': instance.salesCount,
      'is_active': instance.isActive,
      'is_featured': instance.isFeatured,
      'type': instance.type,
      'gallery': instance.gallery,
      'detail_images': instance.detailImages,
      'created_at': instance.createdAt?.toIso8601String(),
    };

ProductSpec _$ProductSpecFromJson(Map<String, dynamic> json) => ProductSpec(
      id: json['id'] as String,
      name: json['name'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => ProductSpecOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductSpecToJson(ProductSpec instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'options': instance.options,
    };

ProductSpecOption _$ProductSpecOptionFromJson(Map<String, dynamic> json) =>
    ProductSpecOption(
      label: json['label'] as String,
      value: json['value'] as String,
      priceMod: (json['priceMod'] as num?)?.toDouble(),
      image: json['image'] as String?,
    );

Map<String, dynamic> _$ProductSpecOptionToJson(ProductSpecOption instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
      'priceMod': instance.priceMod,
      'image': instance.image,
    };

HeroSlide _$HeroSlideFromJson(Map<String, dynamic> json) => HeroSlide(
      image: json['image'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
    );

Map<String, dynamic> _$HeroSlideToJson(HeroSlide instance) => <String, dynamic>{
      'image': instance.image,
      'title': instance.title,
      'subtitle': instance.subtitle,
    };

StoreFeature _$StoreFeatureFromJson(Map<String, dynamic> json) => StoreFeature(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      image: json['image'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$StoreFeatureToJson(StoreFeature instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'image': instance.image,
      'type': instance.type,
    };

StoreSection _$StoreSectionFromJson(Map<String, dynamic> json) => StoreSection(
      id: json['id'] as String,
      title: json['title'] as String,
      bannerImage: json['bannerImage'] as String,
      products: (json['products'] as List<dynamic>)
          .map((e) => StoreProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoreSectionToJson(StoreSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'bannerImage': instance.bannerImage,
      'products': instance.products,
    };

StoreCategory _$StoreCategoryFromJson(Map<String, dynamic> json) =>
    StoreCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      slides: (json['slides'] as List<dynamic>)
          .map((e) => HeroSlide.fromJson(e as Map<String, dynamic>))
          .toList(),
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => StoreFeature.fromJson(e as Map<String, dynamic>))
          .toList(),
      hotProducts: (json['hotProducts'] as List<dynamic>?)
          ?.map((e) => StoreProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      sections: (json['sections'] as List<dynamic>?)
          ?.map((e) => StoreSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoreCategoryToJson(StoreCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slides': instance.slides,
      'features': instance.features,
      'hotProducts': instance.hotProducts,
      'sections': instance.sections,
    };
