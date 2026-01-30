import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'charging_station.g.dart';

/// [ChargingBrand] - 充电站所属品牌枚举
enum ChargingBrand {
  @JsonValue('BAIC')
  baic,  // 北京汽车
  @JsonValue('STATE')
  state, // 国家电网
  @JsonValue('TELD')
  teld,  // 特来电
  @JsonValue('OTHER')
  other, // 其他第三方
}

/// [ChargingStation] - 充电站核心数据模型
@JsonSerializable()
class ChargingStation {
  final String id;             // 站点 ID
  final String name;           // 站点名称
  final double latitude;       // 纬度 (WGS84)
  final double longitude;      // 经度 (WGS84)
  final double distance;       // 距离当前位置（公里）
  final double price;          // 充电单价（元/度）
  final int fastChargers;      // 快充桩可用数量
  final int slowChargers;      // 慢充桩可用数量
  final ChargingBrand brand;   // 品牌归属
  final bool isOfficial;      // 是否为北汽官方合作/认证站点
  final bool isOpen;         // 是否对外开放（对社会车辆开放）
  final String? address;       // 详细地理地址
  final String? phone;         // 站点联系电话

  ChargingStation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.price,
    required this.fastChargers,
    required this.slowChargers,
    required this.brand,
    this.isOfficial = false,
    this.isOpen = true,
    this.address,
    this.phone,
  });

  /// 获取位置坐标对象 (LatLng)
  LatLng get position => LatLng(latitude, longitude);

  /// 获取该站点充电桩总数
  int get totalChargers => fastChargers + slowChargers;

  /// 获取映射后的品牌中文名称
  String get brandName {
    switch (brand) {
      case ChargingBrand.baic:
        return '北京汽车';
      case ChargingBrand.state:
        return '国家电网';
      case ChargingBrand.teld:
        return '特来电';
      case ChargingBrand.other:
        return '其他';
    }
  }

  factory ChargingStation.fromJson(Map<String, dynamic> json) =>
      _$ChargingStationFromJson(json);

  Map<String, dynamic> toJson() => _$ChargingStationToJson(this);
}
