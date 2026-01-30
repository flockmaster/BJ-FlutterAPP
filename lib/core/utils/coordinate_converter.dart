import 'dart:math';
import 'package:latlong2/latlong.dart';

/// 坐标系转换工具类
/// 
/// 支持 WGS84、GCJ02、BD09 三种坐标系之间的相互转换
/// 
/// 坐标系说明：
/// - WGS84: GPS 原始坐标系（国际标准）- OpenStreetMap、Geolocator 使用
/// - GCJ02: 火星坐标系（国测局加密）- 高德地图、腾讯地图使用
/// - BD09: 百度坐标系（百度加密）- 百度地图使用
class CoordinateConverter {
  // 常量定义
  static const double _pi = 3.1415926535897932384626;
  static const double _a = 6378245.0; // 长半轴
  static const double _ee = 0.00669342162296594323; // 偏心率平方

  /// 判断坐标是否在中国境内
  /// 
  /// 中国境外的坐标不需要进行偏移
  static bool _isInChina(double lat, double lon) {
    return lon >= 72.004 && lon <= 137.8347 && lat >= 0.8293 && lat <= 55.8271;
  }

  /// 转换纬度
  static double _transformLat(double x, double y) {
    double ret = -100.0 +
        2.0 * x +
        3.0 * y +
        0.2 * y * y +
        0.1 * x * y +
        0.2 * sqrt(x.abs());
    ret += (20.0 * sin(6.0 * x * _pi) + 20.0 * sin(2.0 * x * _pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * _pi) + 40.0 * sin(y / 3.0 * _pi)) * 2.0 / 3.0;
    ret +=
        (160.0 * sin(y / 12.0 * _pi) + 320 * sin(y * _pi / 30.0)) * 2.0 / 3.0;
    return ret;
  }

  /// 转换经度
  static double _transformLon(double x, double y) {
    double ret = 300.0 +
        x +
        2.0 * y +
        0.1 * x * x +
        0.1 * x * y +
        0.1 * sqrt(x.abs());
    ret += (20.0 * sin(6.0 * x * _pi) + 20.0 * sin(2.0 * x * _pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * _pi) + 40.0 * sin(x / 3.0 * _pi)) * 2.0 / 3.0;
    ret +=
        (150.0 * sin(x / 12.0 * _pi) + 300.0 * sin(x / 30.0 * _pi)) * 2.0 / 3.0;
    return ret;
  }

  /// WGS84 转 GCJ02（火星坐标系）
  /// 
  /// 用于：高德地图、腾讯地图
  /// 
  /// 示例：
  /// ```dart
  /// LatLng wgs84 = LatLng(39.9042, 116.4074);
  /// LatLng gcj02 = CoordinateConverter.wgs84ToGcj02(wgs84);
  /// ```
  static LatLng wgs84ToGcj02(LatLng wgs84) {
    double lat = wgs84.latitude;
    double lon = wgs84.longitude;

    // 中国境外不进行偏移
    if (!_isInChina(lat, lon)) {
      return wgs84;
    }

    double dLat = _transformLat(lon - 105.0, lat - 35.0);
    double dLon = _transformLon(lon - 105.0, lat - 35.0);
    double radLat = lat / 180.0 * _pi;
    double magic = sin(radLat);
    magic = 1 - _ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((_a * (1 - _ee)) / (magic * sqrtMagic) * _pi);
    dLon = (dLon * 180.0) / (_a / sqrtMagic * cos(radLat) * _pi);

    double mgLat = lat + dLat;
    double mgLon = lon + dLon;

    return LatLng(mgLat, mgLon);
  }

  /// GCJ02（火星坐标系）转 WGS84
  /// 
  /// 用于：将高德/腾讯坐标转回 GPS 坐标
  /// 
  /// 示例：
  /// ```dart
  /// LatLng gcj02 = LatLng(39.9087, 116.4134);
  /// LatLng wgs84 = CoordinateConverter.gcj02ToWgs84(gcj02);
  /// ```
  static LatLng gcj02ToWgs84(LatLng gcj02) {
    double lat = gcj02.latitude;
    double lon = gcj02.longitude;

    // 中国境外不进行偏移
    if (!_isInChina(lat, lon)) {
      return gcj02;
    }

    double dLat = _transformLat(lon - 105.0, lat - 35.0);
    double dLon = _transformLon(lon - 105.0, lat - 35.0);
    double radLat = lat / 180.0 * _pi;
    double magic = sin(radLat);
    magic = 1 - _ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((_a * (1 - _ee)) / (magic * sqrtMagic) * _pi);
    dLon = (dLon * 180.0) / (_a / sqrtMagic * cos(radLat) * _pi);

    double mgLat = lat - dLat;
    double mgLon = lon - dLon;

    return LatLng(mgLat, mgLon);
  }

  /// GCJ02（火星坐标系）转 BD09（百度坐标系）
  /// 
  /// 用于：百度地图
  /// 
  /// 示例：
  /// ```dart
  /// LatLng gcj02 = LatLng(39.9087, 116.4134);
  /// LatLng bd09 = CoordinateConverter.gcj02ToBd09(gcj02);
  /// ```
  static LatLng gcj02ToBd09(LatLng gcj02) {
    double lat = gcj02.latitude;
    double lon = gcj02.longitude;

    double z = sqrt(lon * lon + lat * lat) + 0.00002 * sin(lat * _pi * 3000.0 / 180.0);
    double theta = atan2(lat, lon) + 0.000003 * cos(lon * _pi * 3000.0 / 180.0);
    double bdLon = z * cos(theta) + 0.0065;
    double bdLat = z * sin(theta) + 0.006;

    return LatLng(bdLat, bdLon);
  }

  /// BD09（百度坐标系）转 GCJ02（火星坐标系）
  /// 
  /// 用于：将百度坐标转为高德/腾讯坐标
  /// 
  /// 示例：
  /// ```dart
  /// LatLng bd09 = LatLng(39.9152, 116.4204);
  /// LatLng gcj02 = CoordinateConverter.bd09ToGcj02(bd09);
  /// ```
  static LatLng bd09ToGcj02(LatLng bd09) {
    double lat = bd09.latitude;
    double lon = bd09.longitude;

    double x = lon - 0.0065;
    double y = lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * _pi * 3000.0 / 180.0);
    double theta = atan2(y, x) - 0.000003 * cos(x * _pi * 3000.0 / 180.0);
    double gcjLon = z * cos(theta);
    double gcjLat = z * sin(theta);

    return LatLng(gcjLat, gcjLon);
  }

  /// WGS84 转 BD09（百度坐标系）
  /// 
  /// 用于：百度地图（直接转换）
  /// 
  /// 示例：
  /// ```dart
  /// LatLng wgs84 = LatLng(39.9042, 116.4074);
  /// LatLng bd09 = CoordinateConverter.wgs84ToBd09(wgs84);
  /// ```
  static LatLng wgs84ToBd09(LatLng wgs84) {
    LatLng gcj02 = wgs84ToGcj02(wgs84);
    return gcj02ToBd09(gcj02);
  }

  /// BD09（百度坐标系）转 WGS84
  /// 
  /// 用于：将百度坐标转回 GPS 坐标
  /// 
  /// 示例：
  /// ```dart
  /// LatLng bd09 = LatLng(39.9152, 116.4204);
  /// LatLng wgs84 = CoordinateConverter.bd09ToWgs84(bd09);
  /// ```
  static LatLng bd09ToWgs84(LatLng bd09) {
    LatLng gcj02 = bd09ToGcj02(bd09);
    return gcj02ToWgs84(gcj02);
  }

  /// 计算两点之间的距离（米）
  /// 
  /// 使用 Haversine 公式计算球面距离
  /// 
  /// 示例：
  /// ```dart
  /// LatLng point1 = LatLng(39.9042, 116.4074);
  /// LatLng point2 = LatLng(39.9087, 116.4134);
  /// double distance = CoordinateConverter.calculateDistance(point1, point2);
  /// print('距离: ${distance.toStringAsFixed(2)} 米');
  /// ```
  static double calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // 地球半径（米）

    double lat1Rad = point1.latitude * _pi / 180;
    double lat2Rad = point2.latitude * _pi / 180;
    double deltaLat = (point2.latitude - point1.latitude) * _pi / 180;
    double deltaLon = (point2.longitude - point1.longitude) * _pi / 180;

    double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(deltaLon / 2) * sin(deltaLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// 获取坐标系名称
  static String getCoordinateSystemName(CoordinateSystem system) {
    switch (system) {
      case CoordinateSystem.wgs84:
        return 'WGS84 (GPS)';
      case CoordinateSystem.gcj02:
        return 'GCJ02 (火星坐标)';
      case CoordinateSystem.bd09:
        return 'BD09 (百度坐标)';
    }
  }
}

/// 坐标系枚举
enum CoordinateSystem {
  /// WGS84 - GPS 原始坐标系
  wgs84,

  /// GCJ02 - 火星坐标系（国测局加密）
  gcj02,

  /// BD09 - 百度坐标系
  bd09,
}
