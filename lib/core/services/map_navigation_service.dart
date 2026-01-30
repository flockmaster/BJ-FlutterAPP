import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';
import '../utils/coordinate_converter.dart';

/// [MapNavigationService] - 地图导航服务类
/// 
/// 负责处理：检测系统安装的地图 App（高德、百度、腾讯、Apple 地图）、弹出地图选择器、以及根据不同地图平台的协议调起导航逻辑。
class MapNavigationService {
  /// 应用内支持调起的第三方地图应用预设列表
  static const List<MapApp> _mapApps = [
    MapApp(
      name: '高德地图',
      icon: Icons.map,
      iosScheme: 'iosamap://',
      androidPackage: 'com.autonavi.minimap',
    ),
    MapApp(
      name: '百度地图',
      icon: Icons.map,
      iosScheme: 'baidumap://',
      androidPackage: 'com.baidu.BaiduMap',
    ),
    MapApp(
      name: '腾讯地图',
      icon: Icons.map,
      iosScheme: 'qqmap://',
      androidPackage: 'com.tencent.map',
    ),
    MapApp(
      name: 'Apple 地图',
      icon: Icons.map,
      iosScheme: 'maps://',
      androidPackage: null, // 仅 iOS 可用
    ),
  ];

  /// 显示地图选择底部弹窗
  /// [context]：构建上下文
  /// [latitude] & [longitude]：目标位置的 WGS84 坐标（由于国内地图商使用火星/百度坐标系，服务内部会自动进行转换）
  /// [destinationName]：目的地显示的名称
  static Future<void> showMapSelectionDialog({
    required BuildContext context,
    required double latitude,
    required double longitude,
    required String destinationName,
  }) async {
    // 1. 动态过滤出当前设备上真正已安装且可用的地图 App
    final availableMaps = await getAvailableMaps();

    if (availableMaps.isEmpty) {
      // 2. 如果未检测到任何 App，兜底方案：提示用户并在系统浏览器中打开网页版地图
      if (context.mounted) {
        _showNoMapDialog(context, latitude, longitude, destinationName);
      }
      return;
    }

    if (!context.mounted) return;

    // 3. 弹出样式统一的底部选择面板
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _MapSelectionSheet(
        maps: availableMaps,
        latitude: latitude,
        longitude: longitude,
        destinationName: destinationName,
      ),
    );
  }

  /// 探测当前设备可用的地图 App
  static Future<List<MapApp>> getAvailableMaps() async {
    final List<MapApp> available = [];

    for (final map in _mapApps) {
      // iOS: 通过 canLaunchUrl 检查 URL Scheme
      if (Platform.isIOS && map.iosScheme != null) {
        final uri = Uri.parse(map.iosScheme!);
        if (await canLaunchUrl(uri)) {
          available.add(map);
        }
      }
      // Android: 当前主要添加常用地图，进阶实现可结合 AppCheck 插件检查包名
      else if (Platform.isAndroid && map.androidPackage != null) {
        available.add(map);
      }
    }

    return available;
  }

  /// 无地图 App 时的警告对话框
  static void _showNoMapDialog(
    BuildContext context,
    double latitude,
    double longitude,
    String destinationName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('提示'),
        content: const Text('未检测到可用的地图应用，是否使用浏览器打开？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openInBrowser(latitude, longitude, destinationName);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 兜底：在浏览器中打开 Web 版高德地图
  static Future<void> _openInBrowser(
    double latitude,
    double longitude,
    String destinationName,
  ) async {
    // WGS84 转 GCJ02 (高德网页版要求火星坐标系)
    final gcj02 = CoordinateConverter.wgs84ToGcj02(LatLng(latitude, longitude));
    final url = 'https://uri.amap.com/marker?position=${gcj02.longitude},${gcj02.latitude}&name=$destinationName';
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// 调起高德地图
  static Future<bool> openAMap({
    required double latitude,
    required double longitude,
    required String destinationName,
  }) async {
    try {
      final gcj02 = CoordinateConverter.wgs84ToGcj02(LatLng(latitude, longitude));
      
      if (Platform.isIOS) {
        final url = 'iosamap://navi?sourceApplication=车主APP&poiname=$destinationName&lat=${gcj02.latitude}&lon=${gcj02.longitude}&dev=0&style=2';
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return true;
        }
      } else if (Platform.isAndroid) {
        final url = 'amapuri://route/plan/?dlat=${gcj02.latitude}&dlon=${gcj02.longitude}&dname=$destinationName&dev=0&t=0';
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return true;
        }
      }
    } catch (e) {
      debugPrint('调起高德地图异常: $e');
    }
    return false;
  }

  /// 调起百度地图
  static Future<bool> openBaiduMap({
    required double latitude,
    required double longitude,
    required String destinationName,
  }) async {
    try {
      // 转换坐标为百度坐标系 BD-09
      final bd09 = CoordinateConverter.wgs84ToBd09(LatLng(latitude, longitude));
      
      final url = 'baidumap://map/direction?destination=name:$destinationName|latlng:${bd09.latitude},${bd09.longitude}&mode=driving&coord_type=bd09ll';
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
    } catch (e) {
      debugPrint('调起百度地图异常: $e');
    }
    return false;
  }

  /// 调起腾讯地图
  static Future<bool> openTencentMap({
    required double latitude,
    required double longitude,
    required String destinationName,
  }) async {
    try {
      final gcj02 = CoordinateConverter.wgs84ToGcj02(LatLng(latitude, longitude));
      
      final url = 'qqmap://map/routeplan?type=drive&to=$destinationName&tocoord=${gcj02.latitude},${gcj02.longitude}&referer=车主APP';
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
    } catch (e) {
      debugPrint('调起腾讯地图异常: $e');
    }
    return false;
  }

  /// 调起 Apple 原生地图 (iOS 专属)
  static Future<bool> openAppleMap({
    required double latitude,
    required double longitude,
    required String destinationName,
  }) async {
    try {
      if (Platform.isIOS) {
        final url = 'maps://?daddr=$latitude,$longitude&q=$destinationName';
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return true;
        }
      }
    } catch (e) {
      debugPrint('调起 Apple 地图异常: $e');
    }
    return false;
  }
}

/// [MapApp] - 地图 App 信息模型
class MapApp {
  final String name;             // 地图名称
  final IconData icon;           // 列表展示的图标
  final String? iosScheme;       // iOS 调起协议头
  final String? androidPackage; // Android 应用包名

  const MapApp({
    required this.name,
    required this.icon,
    this.iosScheme,
    this.androidPackage,
  });
}

/// [_MapSelectionSheet] - 私有组件：地图选择底部面板
class _MapSelectionSheet extends StatelessWidget {
  final List<MapApp> maps;
  final double latitude;
  final double longitude;
  final String destinationName;

  const _MapSelectionSheet({
    required this.maps,
    required this.latitude,
    required this.longitude,
    required this.destinationName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 顶部拖动装饰
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                '选择导航',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111111)),
              ),
            ),
            
            // 地图列表
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: maps.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final map = maps[index];
                return ListTile(
                  leading: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(12)),
                    child: Icon(map.icon, color: const Color(0xFF111111), size: 24),
                  ),
                  title: Text(map.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC)),
                  onTap: () async {
                    Navigator.pop(context);
                    await _openMap(context, map);
                  },
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // 取消按钮项
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity, height: 48,
                  decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(16)),
                  child: const Center(child: Text('取消', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF666666)))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 封装具体的地图打开逻辑
  Future<void> _openMap(BuildContext context, MapApp map) async {
    bool success = false;

    switch (map.name) {
      case '高德地图':
        success = await MapNavigationService.openAMap(latitude: latitude, longitude: longitude, destinationName: destinationName);
        break;
      case '百度地图':
        success = await MapNavigationService.openBaiduMap(latitude: latitude, longitude: longitude, destinationName: destinationName);
        break;
      case '腾讯地图':
        success = await MapNavigationService.openTencentMap(latitude: latitude, longitude: longitude, destinationName: destinationName);
        break;
      case 'Apple 地图':
        success = await MapNavigationService.openAppleMap(latitude: latitude, longitude: longitude, destinationName: destinationName);
        break;
    }

    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('调起${map.name}失败')),
      );
    }
  }
}
