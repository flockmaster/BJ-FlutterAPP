import 'package:json_annotation/json_annotation.dart';

part 'car_model.g.dart';

/// [StoreInfo] - 车型关联的店铺信息模型
@JsonSerializable()
class StoreInfo {
  final String name;     // 店铺/经销商名称
  final String? address; // 详细地址
  final String? phone;   // 联系电话

  const StoreInfo({
    required this.name,
    this.address,
    this.phone,
  });

  factory StoreInfo.fromJson(Map<String, dynamic> json) =>
      _$StoreInfoFromJson(json);

  Map<String, dynamic> toJson() => _$StoreInfoToJson(this);
}

/// [CarVersion] - 车型版本与配置细节模型
@JsonSerializable()
class CarVersion {
  final String name;             // 版本名称（如：尊享版）
  final double price;            // 售价（单位见 CarModel.priceUnit）
  final String? badge;           // 标签文字（如：热门, 限时）
  final String? badgeColor;      // 标签背景色（十六进制码）
  final List<String> features;   // 核心卖点/功能点列表
  final String? description;      // 版本简介
  final Map<String, dynamic>? specs; // 详细技术参数字典

  const CarVersion({
    required this.name,
    required this.price,
    this.description,
    this.specs,
    this.badge,
    this.badgeColor,
    this.features = const [],
  });

  factory CarVersion.fromJson(Map<String, dynamic> json) =>
      _$CarVersionFromJson(json);

  Map<String, dynamic> toJson() => _$CarVersionToJson(this);
}

/// [PreviewFeature] - 即将上市车型的亮点预览模型
@JsonSerializable()
class PreviewFeature {
  final String title;       // 亮点标题（如：超长续航）
  final String? description; // 亮点详细描述
  final String? icon;        // 亮点展示图标 URL

  const PreviewFeature({
    required this.title,
    this.description,
    this.icon,
  });

  factory PreviewFeature.fromJson(Map<String, dynamic> json) =>
      _$PreviewFeatureFromJson(json);

  Map<String, dynamic> toJson() => _$PreviewFeatureToJson(this);
}

/// [CarModel] - 全局车型核心数据模型
/// 
/// 承载：车型基础信息、售价、多媒体资源（背景图、VR）、版本配置以及上市预览特性。
@JsonSerializable()
class CarModel {
  @JsonKey(fromJson: _idFromJson)
  final String id;              // 数据库唯一标识
  @JsonKey(name: 'model_key')
  final String modelKey;        // 车型业务 Key（用于路由或资源匹配）
  final String name;            // 车型简称（如：BJ40）
  @JsonKey(name: 'full_name')
  final String fullName;        // 车型全名
  final String subtitle;        // 车型标语/副标题
  final double price;           // 起售价/标称售价
  @JsonKey(name: 'price_unit')
  final String? priceUnit;      // 价格单位（默认：万）
  @JsonKey(name: 'background_image')
  final String backgroundImage; // 列表或详情页大背景图 URL
  @JsonKey(name: 'promo_price')
  final String? promoPrice;     // 优惠价/起售价描述文本
  @JsonKey(name: 'highlight_image')
  final String? highlightImage; // 特点展示图/高亮图
  @JsonKey(name: 'highlight_text')
  final String? highlightText;  // 特点描述文本
  @JsonKey(name: 'vr_image')
  final String? vrImage;        // 360/VR 看车入口图 URL
  final StoreInfo? store;       // 关联的销售/展示店铺
  @JsonKey(name: 'is_preview', fromJson: _boolFromInt)
  final bool isPreview;         // 是否为预览/预售状态（未上市车型）
  @JsonKey(name: 'release_date')
  final DateTime? releaseDate;  // 上市日期
  @JsonKey(fromJson: _versionsFromJson)
  final Map<String, CarVersion> versions; // 不同配置版本的映射表
  @JsonKey(name: 'preview_features')
  final List<PreviewFeature>? previewFeatures; // 预售期亮点（仅 isPreview 为 true 时有效）
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;    // 车型录入时间

  const CarModel({
    required this.id,
    required this.modelKey,
    required this.name,
    required this.fullName,
    required this.subtitle,
    required this.price,
    this.priceUnit,
    required this.backgroundImage,
    this.promoPrice,
    this.highlightImage,
    this.highlightText,
    this.vrImage,
    this.store,
    this.isPreview = false,
    this.releaseDate,
    this.versions = const {},
    this.previewFeatures,
    this.createdAt,
  });

  /// 获取格式化后的售价字符串 (如: ¥19.88万)
  String get formattedPrice {
    final unit = priceUnit ?? '万';
    return '¥${price.toStringAsFixed(2)}$unit';
  }

  /// 转换逻辑：将原始 JSON 字典安全映射为 CarVersion 映射表
  static Map<String, CarVersion> _versionsFromJson(dynamic json) {
    if (json == null) return {};
    if (json is! Map) return {};
    return json.map((key, value) {
      return MapEntry(
        key.toString(),
        CarVersion.fromJson(Map<String, dynamic>.from(value as Map)),
      );
    });
  }

  /// 转换逻辑：统一 ID 为 String 类型
  static String _idFromJson(dynamic id) => id.toString();

  /// 转换逻辑：后端整型 (0/1) 转布尔
  static bool _boolFromInt(dynamic value) => value == 1;

  factory CarModel.fromJson(Map<String, dynamic> json) =>
      _$CarModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarModelToJson(this);

  CarModel copyWith({
    String? id,
    String? modelKey,
    String? name,
    String? fullName,
    String? subtitle,
    double? price,
    String? priceUnit,
    String? backgroundImage,
    String? promoPrice,
    String? highlightImage,
    String? highlightText,
    String? vrImage,
    StoreInfo? store,
    bool? isPreview,
    DateTime? releaseDate,
    Map<String, CarVersion>? versions,
    List<PreviewFeature>? previewFeatures,
    DateTime? createdAt,
  }) {
    return CarModel(
      id: id ?? this.id,
      modelKey: modelKey ?? this.modelKey,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      subtitle: subtitle ?? this.subtitle,
      price: price ?? this.price,
      priceUnit: priceUnit ?? this.priceUnit,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      promoPrice: promoPrice ?? this.promoPrice,
      highlightImage: highlightImage ?? this.highlightImage,
      highlightText: highlightText ?? this.highlightText,
      vrImage: vrImage ?? this.vrImage,
      store: store ?? this.store,
      isPreview: isPreview ?? this.isPreview,
      releaseDate: releaseDate ?? this.releaseDate,
      versions: versions ?? this.versions,
      previewFeatures: previewFeatures ?? this.previewFeatures,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}