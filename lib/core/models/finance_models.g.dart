// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinanceCalculation _$FinanceCalculationFromJson(Map<String, dynamic> json) =>
    FinanceCalculation(
      basePrice: (json['basePrice'] as num).toDouble(),
      downPayment: (json['downPayment'] as num).toDouble(),
      loanAmount: (json['loanAmount'] as num).toDouble(),
      totalInterest: (json['totalInterest'] as num).toDouble(),
      monthlyPayment: (json['monthlyPayment'] as num).toDouble(),
      term: (json['term'] as num).toInt(),
      downPaymentRatio: (json['downPaymentRatio'] as num).toDouble(),
      interestRate: (json['interestRate'] as num).toDouble(),
    );

Map<String, dynamic> _$FinanceCalculationToJson(FinanceCalculation instance) =>
    <String, dynamic>{
      'basePrice': instance.basePrice,
      'downPayment': instance.downPayment,
      'loanAmount': instance.loanAmount,
      'totalInterest': instance.totalInterest,
      'monthlyPayment': instance.monthlyPayment,
      'term': instance.term,
      'downPaymentRatio': instance.downPaymentRatio,
      'interestRate': instance.interestRate,
    };
