import '../models/service_models.dart';
import '../repositories/service_repository.dart';

/// [IServiceService] - 服务页面（车之友）业务逻辑接口
/// 
/// 负责处理：车辆信息展示、周边充电站与门店搜索、自驾游服务聚合，以及各项服务点击交互（报修、救援等）。
abstract class IServiceService {
  /// 获取当前用户的爱车信息（用于服务页顶卡展示）
  Future<VehicleInfo?> getMyVehicle();
  
  /// 获取推荐的充电站列表
  Future<List<ChargeStation>> getChargeStations();
  
  /// 获取附近的 4S 店/服务门店列表
  Future<List<NearbyStore>> getNearbyStores();
  
  /// 获取自驾游、路线等出行服务推荐
  Future<List<TravelService>> getTravelServices();
  
  /// 获取服务页核心功能入口配置（如：一键增值、精选配件）
  List<CoreServiceItem> getCoreServices();
  
  // ----------------------------------------------------------------------
  // 交互处理器 (Interaction Handlers)
  // ----------------------------------------------------------------------
  
  /// 点击车辆卡片后的处理
  Future<void> handleVehicleTap();
  
  /// 点击“充电地图”
  Future<void> handleChargingMapTap();
  
  /// 点击“扫码充电”
  Future<void> handleScanChargeTap();
  
  /// 点击“查看全部门店”
  Future<void> handleViewAllStoresTap();
  
  /// 点击“二手车评估”
  Future<void> handleUsedCarTap();
  
  /// 点击“专属客服”
  Future<void> handleSupportTap();
  
  /// 点击“道路救援”
  Future<void> handleRescueTap();
  
  /// 点击“故障报修”
  Future<void> handleRepairTap();
}

/// [ServiceService] - 服务页面业务逻辑标准实现
/// 
/// 桥接 [ServiceRepository] 层获取持久化或 API 数据。
class ServiceService implements IServiceService {
  final ServiceRepository _repository;

  ServiceService({ServiceRepository? repository})
      : _repository = repository ?? ServiceRepository();

  @override
  Future<VehicleInfo?> getMyVehicle() async {
    return await _repository.getMyVehicle();
  }

  @override
  Future<List<ChargeStation>> getChargeStations() async {
    return await _repository.getChargeStations();
  }

  @override
  Future<List<NearbyStore>> getNearbyStores() async {
    return await _repository.getNearbyStores();
  }

  @override
  Future<List<TravelService>> getTravelServices() async {
    return await _repository.getTravelServices();
  }

  @override
  List<CoreServiceItem> getCoreServices() {
    return _repository.getCoreServices();
  }

  @override
  Future<void> handleVehicleTap() async {
    // 逻辑：导航至车辆监控与详细状态页
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<void> handleChargingMapTap() async {
    // 逻辑：调起地图服务并过滤充电站图层
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<void> handleScanChargeTap() async {
    // 逻辑：唤起系统扫码器
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<void> handleViewAllStoresTap() async {
    // 逻辑：打开门店搜索列表页
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<void> handleUsedCarTap() async {
    // 逻辑：进入二手车在线置换评估流程
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<void> handleSupportTap() async {
    // 逻辑：由于涉及客服，通常导航至 Chat 页面
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<void> handleRescueTap() async {
    // 逻辑：紧急操作，可能包含确认弹窗或直接拨号
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<void> handleRepairTap() async {
    // 逻辑：进入故障反馈与工单预约流程
    await Future.delayed(const Duration(milliseconds: 100));
  }
}

/// Mock 服务实现
class MockServiceService implements IServiceService {
  final ServiceRepository _repository;

  MockServiceService({ServiceRepository? repository})
      : _repository = repository ?? ServiceRepository();

  @override
  Future<VehicleInfo?> getMyVehicle() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return await _repository.getMyVehicle();
  }

  @override
  Future<List<ChargeStation>> getChargeStations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return await _repository.getChargeStations();
  }

  @override
  Future<List<NearbyStore>> getNearbyStores() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return await _repository.getNearbyStores();
  }

  @override
  Future<List<TravelService>> getTravelServices() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return await _repository.getTravelServices();
  }

  @override
  List<CoreServiceItem> getCoreServices() {
    return _repository.getCoreServices();
  }

  @override
  Future<void> handleVehicleTap() async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Mock implementation
  }

  @override
  Future<void> handleChargingMapTap() async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Mock implementation
  }

  @override
  Future<void> handleScanChargeTap() async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Mock implementation
  }

  @override
  Future<void> handleViewAllStoresTap() async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Mock implementation
  }

  @override
  Future<void> handleUsedCarTap() async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Mock implementation
  }

  @override
  Future<void> handleSupportTap() async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Mock implementation
  }

  @override
  Future<void> handleRescueTap() async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Mock implementation
  }

  @override
  Future<void> handleRepairTap() async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Mock implementation
  }
}