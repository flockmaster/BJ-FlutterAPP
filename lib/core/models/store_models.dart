import 'package:json_annotation/json_annotation.dart';
export 'store_order.dart';

part 'store_models.g.dart';

/// [ProductCategory] - 商城商品分类模型
@JsonSerializable()
class ProductCategory {
  final int id;                 // 分类唯一 ID
  final String name;            // 分类名称（如：精选周边、户外用品）
  final String? description;    // 分类描述
  final String? icon;           // 分类图标 URL
  final int sortOrder;          // 排序权重
  final bool isActive;          // 是否启用

  const ProductCategory({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ProductCategoryToJson(this);
}

/// [StoreProduct] - 商城商品核心模型
@JsonSerializable()
class StoreProduct {
  final int id;                 // 商品唯一 ID
  final String title;           // 商品标题
  final String? description;    // 商品简短描述/卖点
  final double price;           // 当前售价（单位：元）
  @JsonKey(name: 'original_price')
  final double? originalPrice;  // 划线价/原价
  @JsonKey(name: 'image_url')
  final String image;           // 商品主图 URL
  @JsonKey(name: 'category_id')
  final int? categoryId;        // 所属分类 ID
  final List<String>? tags;      // 商品标签列表（如：热销、新品）
  final List<ProductSpec>? specifications; // 商品规格配置
  final int? points;            // 购买可获得积分/可用积分抵扣额度
  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;      // 当前库存数量
  @JsonKey(name: 'sales_count')
  final int salesCount;         // 累计销量
  @JsonKey(name: 'is_active')
  final bool isActive;          // 商品是否上架
  @JsonKey(name: 'is_featured')
  final bool isFeatured;        // 是否为推荐商品
  final String? type;           // 商品类型：'physical' (实物), 'virtual' (虚拟), 'service' (服务)
  final List<String>? gallery;  // 详情页顶部轮播图列表
  @JsonKey(name: 'detail_images')
  final List<String>? detailImages; // 详情页底部图文详情图片列表
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;    // 上架日期

  const StoreProduct({
    required this.id,
    required this.title,
    this.description,
    required this.price,
    this.originalPrice,
    required this.image,
    this.categoryId,
    this.tags,
    this.specifications,
    this.points,
    this.stockQuantity = 0,
    this.salesCount = 0,
    this.isActive = true,
    this.isFeatured = false,
    this.type,
    this.gallery,
    this.detailImages,
    this.createdAt,
  });

  /// 检查商品是否有折扣
  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  /// 计算折扣百分比
  int get discountPercent {
    if (!hasDiscount) return 0;
    return ((1 - price / originalPrice!) * 100).round();
  }

  factory StoreProduct.fromJson(Map<String, dynamic> json) =>
      _$StoreProductFromJson(json);

  Map<String, dynamic> toJson() => _$StoreProductToJson(this);
}

/// [ProductSpec] - 商品规格类目模型（如：颜色、尺寸）
@JsonSerializable()
class ProductSpec {
  final String id;              // 规格 ID
  final String name;            // 规格分类名称
  final List<ProductSpecOption> options; // 可选的规格项列表

  ProductSpec({
    required this.id,
    required this.name,
    required this.options,
  });

  factory ProductSpec.fromJson(Map<String, dynamic> json) => _$ProductSpecFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSpecToJson(this);
}

/// [ProductSpecOption] - 具体规格选项模型
@JsonSerializable()
class ProductSpecOption {
  final String label;           // 选项展示文字（如：白色、XL）
  final String value;           // 选项对应的值
  final double? priceMod;       // 规格引起的价格波动（加价或减价）
  final String? image;          // 该规格对应的预览图 URL

  ProductSpecOption({
    required this.label,
    required this.value,
    this.priceMod,
    this.image,
  });

  factory ProductSpecOption.fromJson(Map<String, dynamic> json) => _$ProductSpecOptionFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSpecOptionToJson(this);
}

/// [HeroSlide] - 商城首页大屏轮播图模型
@JsonSerializable()
class HeroSlide {
  final String image;           // 背景预览图 URL
  final String title;           // 轮播图主标题
  final String subtitle;        // 副标题描述

  const HeroSlide({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  factory HeroSlide.fromJson(Map<String, dynamic> json) =>
      _$HeroSlideFromJson(json);

  Map<String, dynamic> toJson() => _$HeroSlideToJson(this);
}

/// [StoreFeature] - 商城特色功能/入口块模型
@JsonSerializable()
class StoreFeature {
  final String id;              // 功能 ID
  final String title;           // 展示标题
  final String subtitle;        // 副标题/活动描述
  final String image;           // 背景/图标图 URL
  final String type;            // 展示布局类型：'large' 或 'small'

  const StoreFeature({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.type,
  });

  factory StoreFeature.fromJson(Map<String, dynamic> json) =>
      _$StoreFeatureFromJson(json);

  Map<String, dynamic> toJson() => _$StoreFeatureToJson(this);
}

/// [StoreSection] - 商城业务频道中的商品分组模块
@JsonSerializable()
class StoreSection {
  final String id;              // 分组 ID
  final String title;           // 分组标题（如：猜你喜欢）
  final String bannerImage;     // 分组顶部的宣传图 URL
  final List<StoreProduct> products; // 该分组下的商品列表

  const StoreSection({
    required this.id,
    required this.title,
    required this.bannerImage,
    required this.products,
  });

  factory StoreSection.fromJson(Map<String, dynamic> json) =>
      _$StoreSectionFromJson(json);

  Map<String, dynamic> toJson() => _$StoreSectionToJson(this);
}

/// [StoreCategory] - 商城频道的综合数据聚合模型
@JsonSerializable()
class StoreCategory {
  final String id;
  final String name;
  final List<HeroSlide> slides;
  final List<StoreFeature>? features;
  final List<StoreProduct>? hotProducts;
  final List<StoreSection>? sections;

  const StoreCategory({
    required this.id,
    required this.name,
    required this.slides,
    this.features,
    this.hotProducts,
    this.sections,
  });

  factory StoreCategory.fromJson(Map<String, dynamic> json) =>
      _$StoreCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoreCategoryToJson(this);
}