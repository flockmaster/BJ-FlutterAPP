import 'package:json_annotation/json_annotation.dart';

part 'coupon.g.dart';

/// [CouponType] - 优惠券类型枚举
enum CouponType {
  @JsonValue('discount')
  discount,  // 折扣券（如：8折、立减额度）
  @JsonValue('service')
  service,   // 服务券（如：免费洗车、保养券）
  @JsonValue('charging')
  charging,  // 充电券（如：度数抵扣）
}

/// [CouponStatus] - 优惠券状态枚举
enum CouponStatus {
  @JsonValue('valid')
  valid,     // 可使用（在有效期内且未核销）
  @JsonValue('expired')
  expired,   // 已过期
  @JsonValue('used')
  used,      // 已使用（已核销）
}

/// [Coupon] - 优惠券实体模型
@JsonSerializable()
class Coupon {
  final String id;              // 优惠券唯一标识
  final CouponType type;        // 优惠券类型
  final String amount;          // 面值/折扣数值（字符串格式，如 "50", "0.8"）
  final String unit;            // 单位（如 "元", "折", "度"）
  final String title;           // 优惠券主标题
  final String subtitle;        // 副标题描述/使用限制说明
  final String expiry;          // 有效期描述字符串
  final CouponStatus status;    // 当前状态
  final int? minAmount;         // 最低消费门槛（单位：分），为 null 表示无门槛

  const Coupon({
    required this.id,
    required this.type,
    required this.amount,
    required this.unit,
    required this.title,
    required this.subtitle,
    required this.expiry,
    required this.status,
    this.minAmount,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);
  Map<String, dynamic> toJson() => _$CouponToJson(this);

  /// 是否可用
  bool get isValid => status == CouponStatus.valid;
  /// 是否已过期
  bool get isExpired => status == CouponStatus.expired;
  /// 是否已核销
  bool get isUsed => status == CouponStatus.used;
}
