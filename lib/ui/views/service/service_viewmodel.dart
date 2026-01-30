import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../core/services/service_service.dart';
import '../../../core/models/service_models.dart';
import '../charging_map/charging_map_view.dart';
import 'roadside_assistance/roadside_assistance_view.dart';
import 'fault_reporting/fault_reporting_view.dart';
import 'nearby_stores/nearby_stores_view.dart';
import 'maintenance_booking_view.dart';
import '../../../core/base/baic_base_view_model.dart';
import '../../../core/services/map_navigation_service.dart';
import '../../../core/services/profile_service.dart';

/// Service页面ViewModel
/// 
/// 管理服务页面的业务状态和数据
class ServiceViewModel extends BaicBaseViewModel {
  final IServiceService _serviceService = locator<IServiceService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final IProfileService _profileService = locator<IProfileService>();

  // 状态数据
  VehicleInfo? _vehicleInfo;
  List<ChargeStation> _chargeStations = [];
  List<NearbyStore> _nearbyStores = [];
  List<TravelService> _travelServices = [];
  List<CoreServiceItem> _coreServices = [];
  bool _isVehicleExpanded = false;
  
  @override
  List<ListenableServiceMixin> get listenableServices => [_profileService];

  // Getters
  VehicleInfo? get vehicleInfo => _vehicleInfo;
  List<ChargeStation> get chargeStations => _chargeStations;
  List<NearbyStore> get nearbyStores => _nearbyStores;
  List<TravelService> get travelServices => _travelServices;
  List<CoreServiceItem> get coreServices => _coreServices;
  bool get isVehicleExpanded => _isVehicleExpanded;
  bool get isLoggedIn => _profileService.isLoggedIn;
  bool get hasVehicle => _profileService.currentUser?.hasVehicle ?? false;

  /// 切换车辆卡片展开状态
  void toggleVehicleExpansion() {
    _isVehicleExpanded = !_isVehicleExpanded;
    notifyListeners();
  }

  /// 初始化加载所有数据
  @override
  Future<void> init({bool showLoading = true}) async {
    if (isBusy) return;
    
    if (showLoading) setBusy(true);
    
    try {
      // 并行加载所有数据
      await Future.wait([
        _loadVehicleInfo(),
        _loadChargeStations(),
        _loadNearbyStores(),
        _loadTravelServices(),
      ]);
      
      // 同步加载核心服务（本地数据）
      _coreServices = _serviceService.getCoreServices();
      
    } catch (e) {
      setError('加载服务数据失败: $e');
    } finally {
      if (showLoading) setBusy(false);
    }
  }

  /// 加载车辆信息
  Future<void> _loadVehicleInfo() async {
    try {
      _vehicleInfo = await _serviceService.getMyVehicle();
    } catch (e) {
      // 错误已在 init 方法中统一处理
    }
  }

  /// 加载充电站数据
  Future<void> _loadChargeStations() async {
    try {
      _chargeStations = await _serviceService.getChargeStations();
    } catch (e) {
      // 错误已在 init 方法中统一处理
    }
  }

  /// 加载附近门店
  Future<void> _loadNearbyStores() async {
    try {
      _nearbyStores = await _serviceService.getNearbyStores();
    } catch (e) {
      // 错误已在 init 方法中统一处理
    }
  }

  /// 加载出行服务
  Future<void> _loadTravelServices() async {
    try {
      _travelServices = await _serviceService.getTravelServices();
    } catch (e) {
      // 错误已在 init 方法中统一处理
    }
  }

  /// 刷新所有数据
  Future<void> refresh() async {
    await init(showLoading: false);
  }

  /// 刷新车辆信息
  Future<void> refreshVehicle() async {
    await _loadVehicleInfo();
    notifyListeners();
  }

  /// 刷新门店列表
  Future<void> refreshStores() async {
    await _loadNearbyStores();
    notifyListeners();
  }

  // 事件处理方法
  Future<void> handleVehicleTap() async {
    await _serviceService.handleVehicleTap();
  }

  Future<void> handleChargingMapTap() async {
    // 导航到充电地图页面
    await _navigationService.navigateToView(
      const ChargingMapView(),
    );
  }

  Future<void> handleScanChargeTap() async {
    if (!isLoggedIn) {
      navigateToLogin();
      return;
    }
    await _serviceService.handleScanChargeTap();
  }

  Future<void> handleViewAllStoresTap() async {
    _navigationService.navigateWithTransition(
      const NearbyStoresView(),
    );
  }

  void navigateToLogin() {
    _navigationService.navigateTo(Routes.loginView);
  }

  Future<void> handleUsedCarTap() async {
    await _serviceService.handleUsedCarTap();
  }

  Future<void> handleStoreNavigateTap(NearbyStore store) async {
    await MapNavigationService.showMapSelectionDialog(
      context: _navigationService.navigatorKey!.currentContext!,
      latitude: 39.9042, // 这里实际应从 store 对象获取坐标
      longitude: 116.4074,
      destinationName: store.name,
    );
  }

  Future<void> handleSupportTap() async {
    await _serviceService.handleSupportTap();
  }

  Future<void> handleRescueTap() async {
    if (!isLoggedIn) {
      navigateToLogin();
      return;
    }
    // 导航到道路救援页面
    await _navigationService.navigateToView(
      const RoadsideAssistanceView(),
    );
  }

  Future<void> handleRepairTap() async {
    if (!isLoggedIn) {
      navigateToLogin();
      return;
    }
    // 导航到故障报修页面
    await _navigationService.navigateToView(
      const FaultReportingView(),
    );
  }

  Future<void> handleMaintenanceTap() async {
    if (!isLoggedIn) {
      navigateToLogin();
      return;
    }
    // 导航到保养预约页面
    await _navigationService.navigateToView(
      const MaintenanceBookingView(),
    );
  }
}