// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointsTransaction _$PointsTransactionFromJson(Map<String, dynamic> json) =>
    PointsTransaction(
      id: json['id'] as String,
      title: json['title'] as String,
      time: json['time'] as String,
      amount: (json['amount'] as num).toInt(),
      type: $enumDecode(_$PointsTransactionTypeEnumMap, json['type']),
      category: $enumDecode(_$PointsCategoryEnumMap, json['category']),
    );

Map<String, dynamic> _$PointsTransactionToJson(PointsTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'time': instance.time,
      'amount': instance.amount,
      'type': _$PointsTransactionTypeEnumMap[instance.type]!,
      'category': _$PointsCategoryEnumMap[instance.category]!,
    };

const _$PointsTransactionTypeEnumMap = {
  PointsTransactionType.earn: 'earn',
  PointsTransactionType.spend: 'spend',
};

const _$PointsCategoryEnumMap = {
  PointsCategory.checkin: 'checkin',
  PointsCategory.shop: 'shop',
  PointsCategory.task: 'task',
  PointsCategory.community: 'community',
  PointsCategory.activity: 'activity',
  PointsCategory.invite: 'invite',
  PointsCategory.service: 'service',
  PointsCategory.other: 'other',
};

PointsStats _$PointsStatsFromJson(Map<String, dynamic> json) => PointsStats(
      totalPoints: (json['totalPoints'] as num).toInt(),
      availablePoints: (json['availablePoints'] as num).toInt(),
      usedPoints: (json['usedPoints'] as num).toInt(),
      expiredPoints: (json['expiredPoints'] as num).toInt(),
      vipLevel: json['vipLevel'] as String,
      vipLevelNum: (json['vipLevelNum'] as num).toInt(),
    );

Map<String, dynamic> _$PointsStatsToJson(PointsStats instance) =>
    <String, dynamic>{
      'totalPoints': instance.totalPoints,
      'availablePoints': instance.availablePoints,
      'usedPoints': instance.usedPoints,
      'expiredPoints': instance.expiredPoints,
      'vipLevel': instance.vipLevel,
      'vipLevelNum': instance.vipLevelNum,
    };
