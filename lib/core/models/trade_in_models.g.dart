// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade_in_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TradeInFormData _$TradeInFormDataFromJson(Map<String, dynamic> json) =>
    TradeInFormData(
      brand: json['brand'] as String,
      year: json['year'] as String,
      mileage: json['mileage'] as String,
    );

Map<String, dynamic> _$TradeInFormDataToJson(TradeInFormData instance) =>
    <String, dynamic>{
      'brand': instance.brand,
      'year': instance.year,
      'mileage': instance.mileage,
    };

TradeInEstimation _$TradeInEstimationFromJson(Map<String, dynamic> json) =>
    TradeInEstimation(
      minValue: (json['minValue'] as num).toDouble(),
      maxValue: (json['maxValue'] as num).toDouble(),
      brand: json['brand'] as String,
      year: json['year'] as String,
      mileage: json['mileage'] as String,
    );

Map<String, dynamic> _$TradeInEstimationToJson(TradeInEstimation instance) =>
    <String, dynamic>{
      'minValue': instance.minValue,
      'maxValue': instance.maxValue,
      'brand': instance.brand,
      'year': instance.year,
      'mileage': instance.mileage,
    };
