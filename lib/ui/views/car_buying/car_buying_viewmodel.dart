import 'package:car_owner_app/core/base/baic_base_view_model.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';

import '../../../core/services/car_service.dart';
import '../../../core/models/car_model.dart';
import 'car_specs/car_specs_view.dart';
import '../service/nearby_stores/nearby_stores_view.dart';
import 'package:flutter/material.dart';

/// [CarBuyingViewModel] - 购车频道（选车/定购）核心入口业务逻辑类
///
/// 核心职责：
/// 1. 加载及维护全局车型列表，区分“预售”与“在售”车型。
/// 2. 注入模拟的车型版本数据（仅用于 UI 开发阶段）。
/// 3. 处理复杂的页面跳转，如试驾申请、车型对比、支付定金等。
class CarBuyingViewModel extends BaicBaseViewModel {
  final _carService = locator<ICarService>();

  /// 原始车型列表
  List<CarModel> _carModels = [];
  List<CarModel> get carModels => _carModels;

  /// 预售车型过滤列表
  List<CarModel> get previewModels => _carModels.where((c) => c.isPreview).toList();
  /// 正式在售车型过滤列表
  List<CarModel> get availableModels => _carModels.where((c) => !c.isPreview).toList();

  bool get isEmpty => _carModels.isEmpty;

  /// 初始化逻辑
  Future<void> init({bool showLoading = true}) async {
    await loadCarModels(showLoading: showLoading);
  }

  /// 加载车型列表数据
  Future<void> loadCarModels({bool showLoading = true}) async {
    if (showLoading) setBusy(true);
    clearErrors();

    try {
      // 通过底层服务获取车型，支持 mock 与实接口切换
      final result = await _carService.getCarModels();
      
      result.when(
        success: (data) {
          // 1. 按车型 Key 进行字母排序，保证展示顺序一致性
          data.sort((a, b) => a.modelKey.compareTo(b.modelKey));

          // 2. 核心补完：为每个基本车型注入开发所需的 mock 版本信息（如：城市猎人版、刀锋英雄版等）
          final processedData = _injectMockVersions(data);

          _carModels = processedData;
        },
        failure: (error) {
          setError(error);
        },
      );
    } catch (e) {
      setError('加载车型失败: ${e.toString()}');
    } finally {
      if (showLoading) setBusy(false);
    }
  }

  /// 安全注入：返回包含 mock 版本信息的新车型列表
  /// 该逻辑仅在开发阶段用于填充 UI 内容
  List<CarModel> _injectMockVersions(List<CarModel> data) {
    return data.map((car) {
      final key = car.modelKey.toLowerCase();
      Map<String, CarVersion>? newVersions;

      // 根据不同的 modelKey 映射对应的版本 mock 数据
      if (key.contains('bj40')) {
        newVersions = {
          'city_hunter': const CarVersion(
            name: '城市猎人版',
            price: 17.98,
            badge: '热销车型',
            badgeColor: 'linear-gradient(135deg, #D4A574 0%, #C89860 100%)',
            features: ['2.0T+8AT黄金动力组合', 'L2.5级智能驾驶辅助', '女王副驾/哈曼卡顿音响', '涉水感应系统'],
            description: '全能配置',
          ),
          'offroad': const CarVersion(
            name: '刀锋英雄版',
            price: 19.98,
            badge: '硬核越野',
            badgeColor: 'linear-gradient(135deg, #434343 0%, #000000 100%)',
            features: ['三把锁+4.0大速比分动器', '专业越野底盘调校', '可拆卸车顶/防滚架', '全地形蠕行模式'],
            description: '硬核越野',
          ),
        };
      } else if (key.contains('bj60')) {
        newVersions = {
          'five_seat': const CarVersion(
            name: '五座版',
            price: 23.98,
            badge: '豪华舒适',
            badgeColor: 'linear-gradient(135deg, #FF9966 0%, #FF5E62 100%)',
            features: ['非承载车身+四轮独悬', 'L2+级智能辅助驾驶', '豪华真皮座椅/座椅按摩', '全景天窗/三温区空调'],
            description: '舒适家用',
          ),
          'seven_seat': const CarVersion(
            name: '七座版',
            price: 24.58,
            badge: '全家出游',
            badgeColor: 'linear-gradient(135deg, #7F7FD5 0%, #86A8E7 50%, #91EAE4 100%)',
            features: ['2+3+2 灵活座椅布局', '三排独立出风口', '超大后备箱空间', '专属家庭娱乐系统'],
            description: '多座实用',
          ),
        };
      } else if (key.contains('bj30')) {
        newVersions = {
          'magic_core': const CarVersion(
            name: '魔核电驱版',
            price: 11.99,
            badge: '超低油耗',
            badgeColor: 'linear-gradient(135deg, #4CAF50 0%, #2E7D32 100%)',
            features: ['魔核1.5T电驱系统', '综合续航 1000km+', '10.25英寸液晶仪表', 'L2级智能驾驶'],
            description: '节能首选',
          ),
          'air': const CarVersion(
            name: '轻野版',
            price: 10.99,
            badge: '性价比首选',
            badgeColor: 'linear-gradient(135deg, #66A6FF 0%, #89F7FE 100%)',
            features: ['1.5T 涡轮增压', '7DCT湿式双离合', '全景天窗', '倒车影像'],
            description: '轻度越野',
          ),
        };
      } else if (key.contains('bj80')) {
        newVersions = {
          'supreme': const CarVersion(
            name: '至尊荣誉版',
            price: 35.80,
            badge: '国宾级座驾',
            badgeColor: 'linear-gradient(135deg, #CF1623 0%, #850209 100%)',
            features: ['3.0T V6 双涡轮增压', '非承载式车身结构', 'Nappa真皮奢华座椅', '后排独立娱乐系统'],
            description: '尊贵体验',
          ),
          'glory': const CarVersion(
            name: '珠峰版',
            price: 39.80,
            badge: '顶配旗舰',
            badgeColor: 'linear-gradient(135deg, #D4A574 0%, #C89860 100%)',
            features: ['专属珠峰白车漆', '20寸锻造轮毂', '全时四驱系统', '顶级Hi-Fi音响'],
            description: '巅峰之作',
          ),
        };
      }

      if (newVersions != null) {
        return car.copyWith(versions: newVersions);
      }
      return car;
    }).toList();
  }

  /// 刷新车型列表
  Future<void> refresh() async {
    await init(showLoading: false);
  }

  /// 导航至预约试驾页面
  void navigateToTestDrive(CarModel car) {
    MapsTo(Routes.testDriveView, arguments: TestDriveViewArguments(car: car));
  }

  /// 导航至车型对比页面
  void navigateToCarCompare(CarModel car) {
    MapsTo(
      Routes.carCompareView,
      arguments: CarCompareViewArguments(
        initialModel: car,
        allModels: availableModels,
      ),
    );
  }
  
  /// 导航至购车订单填写页面
  void navigateToCarOrder(CarModel car) {
    MapsTo(
      Routes.carOrderView,
      arguments: CarOrderViewArguments(car: car),
    );
  }

  /// 导航至详细参数配置页面
  void navigateToCarSpecs(CarModel car) {
    // 采用底层导航服务进行非路由表跳转
    locator<NavigationService>().navigateWithTransition(
      CarSpecsView(car: car),
    );
  }

  /// 导航至“附近门店”地图页
  void navigateToNearbyStores() {
    locator<NavigationService>().navigateWithTransition(
       const NearbyStoresView(),
    );
  }

  /// 导航至车型沉浸式详情页
  void navigateToCarDetail(CarModel car) {
    MapsTo(
      Routes.carDetailView,
      arguments: CarDetailViewArguments(car: car),
    );
  }
}
