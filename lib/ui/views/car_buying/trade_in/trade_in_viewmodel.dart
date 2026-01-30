import 'package:car_owner_app/core/base/baic_base_view_model.dart';
import 'package:car_owner_app/core/models/trade_in_models.dart';

/// 置换估值 ViewModel
class TradeInViewModel extends BaicBaseViewModel {
  /// 当前步骤：form（表单）或 result（结果）
  String _step = 'form';
  String get step => _step;

  /// 表单数据
  String _brand = '';
  String get brand => _brand;

  String _year = '';
  String get year => _year;

  String _mileage = '';
  String get mileage => _mileage;

  /// 估值结果
  TradeInEstimation? _estimation;
  TradeInEstimation? get estimation => _estimation;

  /// 是否正在加载
  bool _isEstimating = false;
  bool get isEstimating => _isEstimating;

  /// 品牌列表（从原型中提取）
  final List<String> brands = [
    '大众',
    '丰田',
    '本田',
    '北京',
    '别克',
    '福特',
    '吉利',
    '长安',
  ];

  /// 年份列表
  final List<String> years = ['2023', '2022', '2021', '2020', '2019'];

  /// 设置品牌
  void setBrand(String value) {
    _brand = value;
    notifyListeners();
  }

  /// 设置年份
  void setYear(String value) {
    _year = value;
    notifyListeners();
  }

  /// 设置里程
  void setMileage(String value) {
    _mileage = value;
    notifyListeners();
  }

  /// 检查表单是否完整
  bool get isFormComplete => _brand.isNotEmpty && _year.isNotEmpty;

  /// 开始估值
  Future<void> startEstimation() async {
    if (!isFormComplete) return;

    _isEstimating = true;
    notifyListeners();

    // 模拟网络请求
    await Future.delayed(const Duration(milliseconds: 1500));

    // 生成模拟估值结果
    _estimation = TradeInEstimation(
      minValue: 8.5,
      maxValue: 9.2,
      brand: _brand,
      year: _year,
      mileage: _mileage.isEmpty ? '5' : _mileage,
    );

    _isEstimating = false;
    _step = 'result';
    notifyListeners();
  }

  /// 重新估值
  void resetEstimation() {
    _step = 'form';
    _estimation = null;
    notifyListeners();
  }

  /// 预约卖车
  Future<void> scheduleAppointment() async {
    // TODO: 实现预约逻辑
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// 初始化
  Future<void> init() async {
    setBusy(true);
    await Future.delayed(const Duration(milliseconds: 300));
    setBusy(false);
  }
}
