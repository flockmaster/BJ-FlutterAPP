import 'package:car_owner_app/core/base/baic_base_view_model.dart';
import 'package:car_owner_app/core/models/car_model.dart';
import 'package:car_owner_app/core/models/car_specs_models.dart';

/// 参数配置页面 ViewModel
class CarSpecsViewModel extends BaicBaseViewModel {
  final CarModel car;
  
  CarSpecsViewModel(this.car);

  String _activeGroup = '动力';
  String get activeGroup => _activeGroup;

  /// 模拟参数配置数据（从原型中提取）
  final Map<String, List<SpecItem>> _specsData = {
    '动力': [
      const SpecItem(label: '发动机', value: '2.0T 224马力 L4'),
      const SpecItem(label: '最大功率(kW)', value: '165'),
      const SpecItem(label: '最大扭矩(N·m)', value: '380'),
      const SpecItem(label: '变速箱', value: '8挡手自一体'),
      const SpecItem(label: '0-100km/h(s)', value: '10.5'),
    ],
    '底盘': [
      const SpecItem(label: '驱动方式', value: '前置四驱'),
      const SpecItem(label: '四驱形式', value: '分时四驱'),
      const SpecItem(label: '车体结构', value: '非承载式'),
    ],
    '越野': [
      const SpecItem(label: '接近角(°)', value: '37'),
      const SpecItem(label: '离去角(°)', value: '31'),
      const SpecItem(label: '涉水深度(mm)', value: '750'),
    ],
  };

  /// 获取所有分组
  List<String> get groups => _specsData.keys.toList();

  /// 获取当前分组的参数列表
  List<SpecItem> get currentSpecs => _specsData[_activeGroup] ?? [];

  /// 切换分组
  void setActiveGroup(String group) {
    _activeGroup = group;
    notifyListeners();
  }

  /// 初始化
  Future<void> init() async {
    setBusy(true);
    await Future.delayed(const Duration(milliseconds: 300));
    setBusy(false);
  }
}
