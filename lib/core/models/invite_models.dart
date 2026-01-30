import 'package:json_annotation/json_annotation.dart';

part 'invite_models.g.dart';

/// [InviteStatus] - 邀请状态枚举
enum InviteStatus {
  @JsonValue('pending')
  pending, // 待注册（已发送邀请但对方尚未建立账号）
  
  @JsonValue('success')
  success, // 邀请成功（对方已激活账号）
  
  @JsonValue('expired')
  expired, // 已过期（邀请链接或状态已失效）
}

/// [InviteRecord] - 单条邀请记录模型
@JsonSerializable()
class InviteRecord {
  final String id;              // 记录唯一标识
  final String name;            // 被邀请人姓名/脱敏手机号
  final String? avatar;         // 被邀请人头像（若有）
  final String date;            // 邀请发起日期描述
  final InviteStatus status;    // 当前邀请状态
  final int reward;             // 该笔邀请产生的奖励积分数值

  InviteRecord({
    required this.id,
    required this.name,
    this.avatar,
    required this.date,
    required this.status,
    required this.reward,
  });

  factory InviteRecord.fromJson(Map<String, dynamic> json) =>
      _$InviteRecordFromJson(json);

  Map<String, dynamic> toJson() => _$InviteRecordToJson(this);
}

/// [InviteData] - 邀请页面综合数据模型
@JsonSerializable()
class InviteData {
  final String inviteCode;              // 用户专属邀请码
  final List<InviteRecord> inviteList;  // 历史邀请记录列表
  final int successfulInvites;          // 累计成功邀请人数
  final int totalRewards;               // 累计获得的奖励总积分

  InviteData({
    required this.inviteCode,
    required this.inviteList,
    required this.successfulInvites,
    required this.totalRewards,
  });

  factory InviteData.fromJson(Map<String, dynamic> json) =>
      _$InviteDataFromJson(json);

  Map<String, dynamic> toJson() => _$InviteDataToJson(this);
}

/// [InviteStats] - 邀请统计简报模型
@JsonSerializable()
class InviteStats {
  final int totalInvites;       // 总邀请次数
  final int successfulInvites;   // 成功激活人数
  final int pendingInvites;      // 待处理/进行中人数
  final int totalRewards;        // 总积分收益

  InviteStats({
    required this.totalInvites,
    required this.successfulInvites,
    required this.pendingInvites,
    required this.totalRewards,
  });

  factory InviteStats.fromJson(Map<String, dynamic> json) =>
      _$InviteStatsFromJson(json);

  Map<String, dynamic> toJson() => _$InviteStatsToJson(this);
}
