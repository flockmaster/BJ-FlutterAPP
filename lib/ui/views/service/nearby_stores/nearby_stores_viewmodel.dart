import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import '../../../../core/base/baic_base_view_model.dart';
import '../../../../core/models/service_models.dart';
import '../../../../core/services/map_navigation_service.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../../app/app.locator.dart';

class NearbyStoresViewModel extends BaicBaseViewModel {
  final MapController mapController = MapController();
  final TextEditingController searchController = TextEditingController();

  LatLng _currentPosition = const LatLng(39.9042, 116.4074); // 北京中心
  LatLng get currentPosition => _currentPosition;

  List<NearbyStore> _stores = [
    const NearbyStore(
      id: '1',
      name: '北京汽车越野4S店（朝阳）',
      address: '北京市朝阳区建国路88号',
      distance: 2.3,
      rating: 4.9,
    ),
    const NearbyStore(
      id: '2',
      name: '北京汽车特约维修中心（海淀）',
      address: '北京市海淀区中关村大街1号',
      distance: 5.6,
      rating: 4.7,
    ),
    const NearbyStore(
      id: '3',
      name: '北京汽车体验中心（亦庄）',
      address: '北京市大兴区经济技术开发区',
      distance: 12.8,
      rating: 4.8,
    ),
    const NearbyStore(
      id: '4',
      name: '北京汽车城市展厅（三里屯）',
      address: '北京市朝阳区三里屯路19号',
      distance: 3.1,
      rating: 4.6,
    ),
  ];

  List<NearbyStore> get stores => _stores;

  NearbyStore? _selectedStore;
  NearbyStore? get selectedStore => _selectedStore;

  String _viewMode = 'map'; // 'map' or 'list'
  String get viewMode => _viewMode;

  @override
  Future<void> init() async {
    _selectedStore = _stores.first;
    notifyListeners();
  }

  void selectStore(NearbyStore store) {
    _selectedStore = store;
    notifyListeners();
  }

  void toggleViewMode() {
    _viewMode = _viewMode == 'map' ? 'list' : 'map';
    notifyListeners();
  }

  void clearSelection() {
    _selectedStore = null;
    notifyListeners();
  }

  Future<void> handleNavigate(NearbyStore store) async {
    // 这里使用模拟坐标，实际应从 store 对象获取
    // 由于 NearbyStore 模型暂无坐标，我们根据 ID 模拟一下
    double lat = 39.9042;
    double lng = 116.4074;
    
    if (store.id == '1') { lat = 39.9142; lng = 116.4274; }
    else if (store.id == '2') { lat = 39.8942; lng = 116.3874; }
    else if (store.id == '3') { lat = 39.9242; lng = 116.4474; }
    else if (store.id == '4') { lat = 39.9342; lng = 116.4574; }

    await MapNavigationService.showMapSelectionDialog(
      context: locator<NavigationService>().navigatorKey!.currentContext!, // 改进：使用 locator 获取 context
      latitude: lat,
      longitude: lng,
      destinationName: store.name,
    );
  }

  Future<void> handleCall(NearbyStore store) async {
    // TODO: 拨打电话
  }
}
