import 'package:json_annotation/json_annotation.dart';

part 'trade_in_models.g.dart';

/// [TradeInFormData] - 二手车置换估值申请表单数据模型
@JsonSerializable()
class TradeInFormData {
  final String brand;           // 车辆品牌型号
  final String year;            // 首次上牌年份
  final String mileage;         // 行使里程数描述

  const TradeInFormData({
    required this.brand,
    required this.year,
    required this.mileage,
  });

  factory TradeInFormData.fromJson(Map<String, dynamic> json) =>
      _$TradeInFormDataFromJson(json);

  Map<String, dynamic> toJson() => _$TradeInFormDataToJson(this);

  /// 检查表单关键项（品牌和年份）是否已填写完整
  bool get isComplete => brand.isNotEmpty && year.isNotEmpty;
}

/// [TradeInEstimation] - 二手车置换预估价格结果模型
@JsonSerializable()
class TradeInEstimation {
  final double minValue;        // 预估最低回收价
  final double maxValue;        // 预估最高回收价
  final String brand;           // 对应的车辆品牌
  final String year;            // 对应的上牌年份
  final String mileage;         // 对应的里程描述

  const TradeInEstimation({
    required this.minValue,
    required this.maxValue,
    required this.brand,
    required this.year,
    required this.mileage,
  });

  factory TradeInEstimation.fromJson(Map<String, dynamic> json) =>
      _$TradeInEstimationFromJson(json);

  Map<String, dynamic> toJson() => _$TradeInEstimationToJson(this);

  /// 获取格式化的估值区间文字描述
  String get formattedRange => '$minValue - $maxValue';
}
