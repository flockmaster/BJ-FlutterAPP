import 'package:flutter/material.dart';
import 'package:car_owner_app/core/base/baic_base_view_model.dart';
import 'package:car_owner_app/core/models/car_model.dart';

/// 选项数据模型
class ConfigOption {
  final String id;
  final String name;
  final double price;
  final String? hex;

  const ConfigOption({
    required this.id,
    required this.name,
    required this.price,
    this.hex,
  });
}

/// 步骤数据模型
class OrderStep {
  final int id;
  final String title;
  final String key;

  const OrderStep({
    required this.id,
    required this.title,
    required this.key,
  });
}

class CarOrderViewModel extends BaicBaseViewModel {
  final CarModel car;
  final String? initialVersionId;

  CarOrderViewModel({
    required this.car,
    this.initialVersionId,
  });

  // 1. 静态配置数据 (从原型提取)
  static const List<OrderStep> steps = [
    OrderStep(id: 0, title: '版本', key: 'version'),
    OrderStep(id: 1, title: '外观', key: 'exterior'),
    OrderStep(id: 2, title: '内饰', key: 'interior'),
    OrderStep(id: 3, title: '轮毂', key: 'wheel'),
    OrderStep(id: 4, title: '确认', key: 'summary'),
  ];

  final List<ConfigOption> colors = const [
    ConfigOption(id: 'orange', name: '熔岩橙', hex: '#F18921', price: 0),
    ConfigOption(id: 'black', name: '极夜黑', hex: '#2A2A2A', price: 0),
    ConfigOption(id: 'white', name: '雪域白', hex: '#EBEBEB', price: 2000),
    ConfigOption(id: 'green', name: '极地绿', hex: '#4A5D48', price: 0),
  ];

  final List<ConfigOption> interiorColors = const [
    ConfigOption(id: 'black', name: '暗夜黑', hex: '#222222', price: 0),
    ConfigOption(id: 'brown', name: '摩卡棕', hex: '#6D4C41', price: 0),
  ];

  final List<ConfigOption> wheels = const [
    ConfigOption(id: '17', name: '17英寸熏黑轮毂', price: 0),
    ConfigOption(id: '18', name: '18英寸AT防脱圈', price: 3000),
  ];

  // 2. 状态变量
  int _currentStep = 0;
  int get currentStep => _currentStep;

  late CarVersion _selectedTrim;
  CarVersion get selectedTrim => _selectedTrim;

  late ConfigOption _selectedColor;
  ConfigOption get selectedColor => _selectedColor;

  late ConfigOption _selectedInterior;
  ConfigOption get selectedInterior => _selectedInterior;

  late ConfigOption _selectedWheel;
  ConfigOption get selectedWheel => _selectedWheel;

  bool _isFinanceExpanded = false;
  bool get isFinanceExpanded => _isFinanceExpanded;

  // 3. 初始化
  void init() {
    setBusy(true);
    
    // 初始化选中的版本
    if (initialVersionId != null && car.versions.containsKey(initialVersionId)) {
      _selectedTrim = car.versions[initialVersionId]!;
    } else if (car.versions.isNotEmpty) {
      _selectedTrim = car.versions.values.first;
    } else {
      // 备选方案 (Fall-back)
      _selectedTrim = const CarVersion(
        name: '标准版',
        price: 159800,
        features: ['2.0T+8AT', '倒车影像'],
      );
    }

    _selectedColor = colors[0];
    _selectedInterior = interiorColors[0];
    _selectedWheel = wheels[0];

    // 模拟加载
    Future.delayed(const Duration(milliseconds: 800), () {
      setBusy(false);
    });
  }

  // 4. 业务逻辑
  void selectTrim(CarVersion trim) {
    _selectedTrim = trim;
    notifyListeners();
  }

  void selectColor(ConfigOption color) {
    _selectedColor = color;
    notifyListeners();
  }

  void selectInterior(ConfigOption interior) {
    _selectedInterior = interior;
    notifyListeners();
  }

  void selectWheel(ConfigOption wheel) {
    _selectedWheel = wheel;
    notifyListeners();
  }

  void toggleFinanceExpanded() {
    _isFinanceExpanded = !_isFinanceExpanded;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < steps.length - 1) {
      _currentStep++;
      notifyListeners();
    } else {
      // 提交订单逻辑
      debugPrint('订单已提交！');
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    } else {
      goBack();
    }
  }

  // 5. 计算属性
  double get totalPrice => 
      _selectedTrim.price + 
      _selectedColor.price + 
      _selectedInterior.price + 
      _selectedWheel.price;

  double get downPayment => totalPrice * 0.1;

  double get monthlyPayment => ((totalPrice * 0.9) / 36 * 1.04).floorToDouble();

  void saveToWishlist() {
    debugPrint('已保存到心愿单：${car.name} - ${_selectedTrim.name}');
    // 实际项目中会调用心愿单服务
  }
}
