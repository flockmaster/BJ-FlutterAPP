import '../models/service_models.dart';

/// Service模块数据仓库
/// 
/// 负责获取服务相关数据，包括车辆信息、充电站、门店等
class ServiceRepository {
  /// 获取用户车辆信息
  Future<VehicleInfo?> getMyVehicle() async {
    // TODO: 替换为实际API调用
    await Future.delayed(const Duration(milliseconds: 300));
    
    return const VehicleInfo(
      id: 'v001',
      name: '北京BJ40 PLUS',
      plateNumber: '京A·12345',
      imageUrl: 'https://p.sda1.dev/29/0c0cc4449ea2a1074412f6052330e4c4/63999cc7e598e7dc1e84445be0ba70eb-Photoroom.png',
      fuelLevel: 85,
      mileage: 8521,
      nextMaintenanceKm: 2000,
      dataRemaining: 8.5,
      insuranceExpiry: '2025.06.15',
      lastMaintenanceDate: '2024.06.15',
      healthStatus: '健康',
    );
  }

  /// 获取附近充电站列表
  Future<List<ChargeStation>> getChargeStations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return const [
      ChargeStation(
        id: 'cs001',
        name: '国家电网充电站',
        address: '北京市朝阳区建国路88号',
        distance: 0.5,
        availableSlots: 8,
        totalSlots: 12,
        pricePerKwh: 1.2,
      ),
      ChargeStation(
        id: 'cs002',
        name: '特来电充电站',
        address: '北京市朝阳区望京SOHO',
        distance: 1.2,
        availableSlots: 5,
        totalSlots: 20,
        pricePerKwh: 1.5,
      ),
    ];
  }

  /// 获取附近门店列表
  Future<List<NearbyStore>> getNearbyStores() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return const [
      NearbyStore(
        id: 'store001',
        name: '北京汽车朝阳4S店',
        address: '北京市朝阳区东三环中路',
        phone: '010-88888888',
        distance: 2.5,
        imageUrl: 'https://images.unsplash.com/photo-1567449303078-57ad995bd329?w=400',
        rating: 4.8,
        services: ['维修保养', '钣金喷漆', '配件销售'],
      ),
      NearbyStore(
        id: 'store002',
        name: '北京汽车海淀服务中心',
        address: '北京市海淀区中关村大街',
        phone: '010-66666666',
        distance: 5.8,
        imageUrl: 'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?w=400',
        rating: 4.5,
        services: ['维修保养', '道路救援'],
      ),
    ];
  }

  /// 获取出行服务列表
  Future<List<TravelService>> getTravelServices() async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    return const [
      TravelService(
        id: 'travel001',
        label: '加油',
        iconName: 'fuel',
        imageUrl: 'https://images.unsplash.com/photo-1527018601619-a508a2be00cd?w=400',
      ),
      TravelService(
        id: 'travel002',
        label: '洗车',
        iconName: 'droplet',
        imageUrl: 'https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=400',
      ),
      TravelService(
        id: 'travel003',
        label: '停车',
        iconName: 'parking_circle',
        imageUrl: 'https://images.unsplash.com/photo-1506521781263-d8422e82f27a?w=400',
      ),
      TravelService(
        id: 'travel004',
        label: '代驾',
        iconName: 'user',
        imageUrl: 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=400',
      ),
    ];
  }

  /// 获取核心服务列表
  List<CoreServiceItem> getCoreServices() {
    return const [
      CoreServiceItem(
        id: 'core001',
        title: '道路救援',
        subtitle: '24小时极速响应',
        imageUrl: 'https://p.sda1.dev/29/ccf10533e046e59cb78877c9c14144a6/c696f5542502642a9e01aec18f8eeca4.jpg',
      ),
      CoreServiceItem(
        id: 'core002',
        title: '预约保养',
        subtitle: '省时省心',
        imageUrl: 'https://p.sda1.dev/29/ae3ed8bbc50175c27a2798406f77be37/d54f2febf1d2139c8791c1a472ceed79.jpg',
      ),
      CoreServiceItem(
        id: 'core003',
        title: '故障报修',
        subtitle: '在线诊断',
        imageUrl: 'https://p.sda1.dev/29/f5cbce1cb2aae7be70f8cd26d1e422f1/7bf05d8c5794b1a908c1bd70e1de7b26.jpg',
      ),
    ];
  }
}
