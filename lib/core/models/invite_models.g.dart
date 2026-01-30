// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InviteRecord _$InviteRecordFromJson(Map<String, dynamic> json) => InviteRecord(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      date: json['date'] as String,
      status: $enumDecode(_$InviteStatusEnumMap, json['status']),
      reward: (json['reward'] as num).toInt(),
    );

Map<String, dynamic> _$InviteRecordToJson(InviteRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
      'date': instance.date,
      'status': _$InviteStatusEnumMap[instance.status]!,
      'reward': instance.reward,
    };

const _$InviteStatusEnumMap = {
  InviteStatus.pending: 'pending',
  InviteStatus.success: 'success',
  InviteStatus.expired: 'expired',
};

InviteData _$InviteDataFromJson(Map<String, dynamic> json) => InviteData(
      inviteCode: json['inviteCode'] as String,
      inviteList: (json['inviteList'] as List<dynamic>)
          .map((e) => InviteRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      successfulInvites: (json['successfulInvites'] as num).toInt(),
      totalRewards: (json['totalRewards'] as num).toInt(),
    );

Map<String, dynamic> _$InviteDataToJson(InviteData instance) =>
    <String, dynamic>{
      'inviteCode': instance.inviteCode,
      'inviteList': instance.inviteList,
      'successfulInvites': instance.successfulInvites,
      'totalRewards': instance.totalRewards,
    };

InviteStats _$InviteStatsFromJson(Map<String, dynamic> json) => InviteStats(
      totalInvites: (json['totalInvites'] as num).toInt(),
      successfulInvites: (json['successfulInvites'] as num).toInt(),
      pendingInvites: (json['pendingInvites'] as num).toInt(),
      totalRewards: (json['totalRewards'] as num).toInt(),
    );

Map<String, dynamic> _$InviteStatsToJson(InviteStats instance) =>
    <String, dynamic>{
      'totalInvites': instance.totalInvites,
      'successfulInvites': instance.successfulInvites,
      'pendingInvites': instance.pendingInvites,
      'totalRewards': instance.totalRewards,
    };
