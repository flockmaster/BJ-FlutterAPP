import 'package:json_annotation/json_annotation.dart';

part 'points_models.g.dart';

/// [PointsTransactionType] - 积分交易类型枚举
enum PointsTransactionType {
  @JsonValue('earn')
  earn, // 获取积分（如：签到、任务奖励）
  
  @JsonValue('spend')
  spend, // 消耗积分（如：兑换商品、抵扣费用）
}

/// [PointsCategory] - 积分交易关联的业务分类
enum PointsCategory {
  @JsonValue('checkin')
  checkin, // 签到业务
  
  @JsonValue('shop')
  shop, // 商城兑换/抵扣
  
  @JsonValue('task')
  task, // 每日/成长任务
  
  @JsonValue('community')
  community, // 社区互动（发帖、精华等）
  
  @JsonValue('activity')
  activity, // 线下/线上活动
  
  @JsonValue('invite')
  invite, // 邀请好友奖励
  
  @JsonValue('service')
  service, // 车辆服务记录
  
  @JsonValue('other')
  other, // 其他杂项
}

/// [PointsTransaction] - 单条积分交易流水记录
@JsonSerializable()
class PointsTransaction {
  final String id;              // 交易流水唯一标识
  final String title;           // 交易描述性标题
  final String time;            // 交易发生时间（字符串格式）
  final int amount;             // 积分变动数值（正数为获取，负数为消耗）
  final PointsTransactionType type; // 交易类型（获取/消耗）
  final PointsCategory category; // 业务分类

  PointsTransaction({
    required this.id,
    required this.title,
    required this.time,
    required this.amount,
    required this.type,
    required this.category,
  });

  factory PointsTransaction.fromJson(Map<String, dynamic> json) =>
      _$PointsTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$PointsTransactionToJson(this);
}

/// [PointsStats] - 用户积分资产统计信息
@JsonSerializable()
class PointsStats {
  final int totalPoints;        // 累计获得的积分总和
  final int availablePoints;    // 当前可用的积分余额
  final int usedPoints;         // 累计已消耗的积分总数
  final int expiredPoints;      // 已过期失效的积分总数
  final String vipLevel;        // 会员等级名称（如：资深车友）
  final int vipLevelNum;        // 会员等级数值（用于 UI 展示或逻辑判断，如：VIP 2）

  PointsStats({
    required this.totalPoints,
    required this.availablePoints,
    required this.usedPoints,
    required this.expiredPoints,
    required this.vipLevel,
    required this.vipLevelNum,
  });

  factory PointsStats.fromJson(Map<String, dynamic> json) =>
      _$PointsStatsFromJson(json);

  Map<String, dynamic> toJson() => _$PointsStatsToJson(this);
}
