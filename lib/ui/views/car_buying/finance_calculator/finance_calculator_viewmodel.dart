import 'package:car_owner_app/core/base/baic_base_view_model.dart';
import 'package:car_owner_app/core/models/car_model.dart';
import 'package:car_owner_app/core/models/finance_models.dart';

/// 金融计算器 ViewModel
class FinanceCalculatorViewModel extends BaicBaseViewModel {
  final CarModel car;

  FinanceCalculatorViewModel(this.car);

  double _downPaymentRatio = 0.3;
  double get downPaymentRatio => _downPaymentRatio;

  int _term = 36;
  int get term => _term;

  final double _interestRate = 0.04;

  /// 获取基础价格（万元转为元）
  double get basePrice => car.price * 10000;

  /// 计算金融方案
  FinanceCalculation get calculation {
    final downPayment = basePrice * _downPaymentRatio;
    final loanAmount = basePrice - downPayment;
    final totalInterest = loanAmount * _interestRate * (_term / 12);
    final monthlyPayment = (loanAmount + totalInterest) / _term;

    return FinanceCalculation(
      basePrice: basePrice,
      downPayment: downPayment,
      loanAmount: loanAmount,
      totalInterest: totalInterest,
      monthlyPayment: monthlyPayment,
      term: _term,
      downPaymentRatio: _downPaymentRatio,
      interestRate: _interestRate,
    );
  }

  /// 设置首付比例
  void setDownPaymentRatio(double ratio) {
    _downPaymentRatio = ratio;
    notifyListeners();
  }

  /// 设置分期期限
  void setTerm(int months) {
    _term = months;
    notifyListeners();
  }

  /// 申请金融方案
  Future<void> applyFinance() async {
    // TODO: 实现申请逻辑
    await Future.delayed(const Duration(milliseconds: 500));
    // 可以导航到申请页面或显示成功提示
  }

  /// 初始化
  Future<void> init() async {
    setBusy(true);
    await Future.delayed(const Duration(milliseconds: 300));
    setBusy(false);
  }
}
