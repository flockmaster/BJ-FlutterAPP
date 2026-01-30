import 'package:json_annotation/json_annotation.dart';

part 'finance_models.g.dart';

/// [FinanceCalculation] - 金融贷款方案计算结果模型
@JsonSerializable()
class FinanceCalculation {
  final double basePrice;       // 车辆总价/裸车价
  final double downPayment;     // 首付款金额
  final double loanAmount;      // 贷款总额
  final double totalInterest;   // 预估利息总额
  final double monthlyPayment;  // 预估月供
  final int term;               // 贷款期限（单位：月）
  final double downPaymentRatio; // 首付比例（如：0.2 表示 20%）
  final double interestRate;     // 年化利率（如：0.03 等）

  const FinanceCalculation({
    required this.basePrice,
    required this.downPayment,
    required this.loanAmount,
    required this.totalInterest,
    required this.monthlyPayment,
    required this.term,
    required this.downPaymentRatio,
    required this.interestRate,
  });

  factory FinanceCalculation.fromJson(Map<String, dynamic> json) =>
      _$FinanceCalculationFromJson(json);

  Map<String, dynamic> toJson() => _$FinanceCalculationToJson(this);

  /// 获取含息总价（车价 + 总利息）
  double get totalPrice => basePrice + totalInterest;
}
