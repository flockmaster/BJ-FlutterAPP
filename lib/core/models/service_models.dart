import 'package:json_annotation/json_annotation.dart';

part 'service_models.g.dart';

/// [VehicleInfo] - 车辆状态实时数据模型
@JsonSerializable()
class VehicleInfo {
  final String id;              // 车辆唯一标识
  final String name;            // 车型名称
  final String plateNumber;     // 车牌号
  final String imageUrl;        // 车辆外观图片 URL
  final int fuelLevel;          // 剩余油量/电量百分比
  final int mileage;            // 累计行驶总里程
  final int nextMaintenanceKm;   // 距离下次保养剩余公里数
  final double dataRemaining;    // 当前剩余娱乐流量 (GB)
  final String insuranceExpiry;  // 保险到期日期描述
  final String lastMaintenanceDate; // 上次进店维保日期
  final String healthStatus;      // 车辆自检健康状态描述

  const VehicleInfo({
    required this.id,
    required this.name,
    required this.plateNumber,
    required this.imageUrl,
    this.fuelLevel = 0,
    this.mileage = 0,
    this.nextMaintenanceKm = 0,
    this.dataRemaining = 0.0,
    this.insuranceExpiry = '',
    this.lastMaintenanceDate = '',
    this.healthStatus = '健康',
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) =>
      _$VehicleInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleInfoToJson(this);
}

/// [ChargeStation] - 充电站/加注站基础信息模型
@JsonSerializable()
class ChargeStation {
  final String id;              // 站点唯一标识
  final String name;            // 站点名称
  final String address;         // 详细地址描述
  final double distance;        // 距离当前位置的公里数
  final int availableSlots;     // 当前空闲可用桩/位数
  final int totalSlots;         // 总计桩/位数
  final double pricePerKwh;     // 每度电/单位收取的服务单价

  const ChargeStation({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    this.availableSlots = 0,
    this.totalSlots = 0,
    this.pricePerKwh = 0.0,
  });

  factory ChargeStation.fromJson(Map<String, dynamic> json) =>
      _$ChargeStationFromJson(json);

  Map<String, dynamic> toJson() => _$ChargeStationToJson(this);
}

/// [NearbyStore] - 附近服务门店/ 4S 店模型
@JsonSerializable()
class NearbyStore {
  final String id;              // 门店唯一标识
  final String name;            // 门店全称
  final String address;         // 门店地理位置描述
  final String phone;           // 门店联系电话
  final double distance;        // 距离当前位置的距离 (km)
  final String imageUrl;        // 门店门头/实景图 URL
  final double rating;          // 门店评分 (0.0 - 5.0)
  final List<String> services;  // 门店提供的业务标签（如：销售、售后、配件）

  const NearbyStore({
    required this.id,
    required this.name,
    required this.address,
    this.phone = '',
    required this.distance,
    this.imageUrl = '',
    this.rating = 0.0,
    this.services = const [],
  });

  factory NearbyStore.fromJson(Map<String, dynamic> json) =>
      _$NearbyStoreFromJson(json);

  Map<String, dynamic> toJson() => _$NearbyStoreToJson(this);
}

/// [TravelService] - 出行类增值服务模型（如：代驾、洗车）
@JsonSerializable()
class TravelService {
  final String id;              // 服务条目唯一标识
  final String label;           // 服务名称标签
  final String iconName;        // 关联的本地图标资源名
  final String imageUrl;        // 关联的线上图标/插画 URL
  final String route;           // 点击后跳转的应用内路由路径

  const TravelService({
    required this.id,
    required this.label,
    required this.iconName,
    this.imageUrl = '',
    this.route = '',
  });

  factory TravelService.fromJson(Map<String, dynamic> json) =>
      _$TravelServiceFromJson(json);

  Map<String, dynamic> toJson() => _$TravelServiceToJson(this);
}

/// 核心服务项模型
@JsonSerializable()
class CoreServiceItem {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String route;

  const CoreServiceItem({
    required this.id,
    required this.title,
    this.subtitle = '',
    required this.imageUrl,
    this.route = '',
  });

  factory CoreServiceItem.fromJson(Map<String, dynamic> json) =>
      _$CoreServiceItemFromJson(json);

  Map<String, dynamic> toJson() => _$CoreServiceItemToJson(this);
}