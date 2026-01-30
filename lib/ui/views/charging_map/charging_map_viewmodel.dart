import 'package:flutter/material.dart'; // For TextEditingController
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:car_owner_app/core/base/baic_base_view_model.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.bottomsheets.dart'; // Import BottomSheetType
import '../../../core/models/charging_station.dart';
import '../../../core/services/map_navigation_service.dart';

/// [ChargingMapViewModel] - 充电地图页面的业务逻辑与状态管理类
///
/// 核心职责：
/// 1. 管理用户当前位置获取逻辑。
/// 2. 加载与显示附近的充电站（当前为 MOCK 数据）。
/// 3. 处理地图交互（缩放、定位、选中站点）。
/// 4. 驱动多地图（高德、百度等）外部导航跳转。
class ChargingMapViewModel extends BaicBaseViewModel {
  final MapController mapController = MapController();
  final TextEditingController searchController = TextEditingController();
  final _bottomSheetService = locator<BottomSheetService>();

  // 当前位置（默认北京）
  LatLng _currentPosition = const LatLng(39.9042, 116.4074);
  LatLng get currentPosition => _currentPosition;

  // 充电站列表
  List<ChargingStation> _stations = [];
  List<ChargingStation> get stations => _stations;

  // 选中的充电站
  ChargingStation? _selectedStation;
  ChargingStation? get selectedStation => _selectedStation;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  /// 初始化
  Future<void> init() async {
    setBusy(true);
    
    try {
      // 获取当前位置
      await _getCurrentLocation();
      
      // 加载充电站数据
      await _loadStations();
      
      // 默认选中第一个充电站
      if (_stations.isNotEmpty) {
        _selectedStation = _stations.first;
      }
    } catch (e) {
      setError('加载充电站数据失败: $e');
    } finally {
      setBusy(false);
    }
  }

  /// 获取当前位置
  Future<void> _getCurrentLocation() async {
    try {
      // 检查位置权限
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      // 获取当前位置
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      
      _currentPosition = LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('获取位置失败: $e');
    }
  }

  /// 加载充电站数据（模拟数据）
  Future<void> _loadStations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    _stations = [
      ChargingStation(
        id: '1',
        name: '北京汽车超级充电站(朝阳)',
        latitude: 39.9142,
        longitude: 116.4274,
        distance: 0.8,
        price: 1.2,
        fastChargers: 12,
        slowChargers: 4,
        brand: ChargingBrand.baic,
        isOfficial: true,
        isOpen: true,
        address: '北京市朝阳区建国路88号',
        phone: '400-810-8100',
      ),
      ChargingStation(
        id: '2',
        name: '国家电网公共充电站',
        latitude: 39.8942,
        longitude: 116.3874,
        distance: 1.5,
        price: 1.5,
        fastChargers: 8,
        slowChargers: 8,
        brand: ChargingBrand.state,
        isOfficial: false,
        isOpen: true,
        address: '北京市朝阳区东三环中路',
        phone: '95598',
      ),
      ChargingStation(
        id: '3',
        name: '特来电充电站(SOHO)',
        latitude: 39.9242,
        longitude: 116.4474,
        distance: 2.1,
        price: 1.8,
        fastChargers: 20,
        slowChargers: 0,
        brand: ChargingBrand.teld,
        isOfficial: false,
        isOpen: true,
        address: '北京市朝阳区光华路SOHO',
        phone: '400-186-7766',
      ),
      ChargingStation(
        id: '4',
        name: '北京汽车充电站(海淀)',
        latitude: 39.9842,
        longitude: 116.3174,
        distance: 3.2,
        price: 1.2,
        fastChargers: 10,
        slowChargers: 6,
        brand: ChargingBrand.baic,
        isOfficial: true,
        isOpen: true,
        address: '北京市海淀区中关村大街',
        phone: '400-810-8100',
      ),
      ChargingStation(
        id: '5',
        name: '特来电充电站(三里屯)',
        latitude: 39.9342,
        longitude: 116.4574,
        distance: 1.8,
        price: 1.6,
        fastChargers: 15,
        slowChargers: 5,
        brand: ChargingBrand.teld,
        isOfficial: false,
        isOpen: true,
        address: '北京市朝阳区三里屯路',
        phone: '400-186-7766',
      ),
    ];
  }

  /// 在地图上选中特定充电站并移动镜头
  void selectStation(ChargingStation station) {
    _selectedStation = station;
    mapController.move(station.position, 15.0); // 焦距调整为 15 级
    notifyListeners();
  }

  /// 清除当前地图上的选中状态
  void clearSelection() {
    _selectedStation = null;
    notifyListeners();
  }

  /// 下发远程指令：降低充电位地锁
  Future<void> lowerLock(ChargingStation station) async {
    // TODO: 实现 IoT 远程下发逻辑
    debugPrint('执行降地锁指令: ${station.name}');
  }

  /// 发起前往特定站点的导航流程
  /// 会自动检测系统已安装的应用并在底部弹性组件中供用户选择
  Future<void> navigateToStation(ChargingStation station) async {
    final availableMaps = await MapNavigationService.getAvailableMaps();
    
    if (availableMaps.isEmpty) {
        await dialogService.showDialog(
          title: '提示',
          description: '您的手机未检测到主流地图应用（高德/百度/腾讯等）',
        );
        return;
    }

    // 调用全局底层服务弹出地图选择器
    final response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.mapSelection,
      customData: availableMaps,
    );
    
    if (response != null && response.confirmed && response.data is MapApp) {
      await _openMap(response.data as MapApp, station);
    }
  }
  
  Future<void> _openMap(MapApp map, ChargingStation station) async {
     bool success = false;
      switch (map.name) {
      case '高德地图':
        success = await MapNavigationService.openAMap(
          latitude: station.latitude,
          longitude: station.longitude,
          destinationName: station.name,
        );
        break;
      case '百度地图':
        success = await MapNavigationService.openBaiduMap(
          latitude: station.latitude,
          longitude: station.longitude,
          destinationName: station.name,
        );
        break;
      case '腾讯地图':
        success = await MapNavigationService.openTencentMap(
          latitude: station.latitude,
          longitude: station.longitude,
          destinationName: station.name,
        );
        break;
      case 'Apple 地图':
        success = await MapNavigationService.openAppleMap(
          latitude: station.latitude,
          longitude: station.longitude,
          destinationName: station.name,
        );
        break;
    }
    
    if (!success) {
      dialogService.showDialog(title: '打开失败', description: '无法打开${map.name}');
    }
  }

  /// 显示筛选对话框
  Future<void> showFilterDialog() async {
    debugPrint('显示筛选对话框');
  }

  /// 搜索充电站
  void searchStations(String query) {
    debugPrint('搜索: $query');
  }
}
