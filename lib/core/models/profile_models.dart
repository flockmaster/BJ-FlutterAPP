import 'package:json_annotation/json_annotation.dart';

part 'profile_models.g.dart';

/// [UserProfile] - 核心用户资料模型
@JsonSerializable()
class UserProfile {
  final String id;              // 用户唯一标识
  final String username;        // 系统用户名
  final String? email;          // 邮箱地址（可选）
  final String? phone;          // 绑定手机号
  final String? avatar;         // 用户头像 URL
  final String? nickname;       // 显示昵称
  final int? followingCount;    // 关注人数
  final int? followersCount;    // 粉丝人数
  final int? postsCount;        // 发布动态总数
  final int? likesCount;        // 获赞总数
  final int vipLevel;           // 会员等级（数字）
  final bool hasVehicle;        // 名下是否已绑定/拥有车辆
  final bool phoneVerified;     // 手机号是否已通过验证
  final bool isUpdated;         // 资料是否为近期更新状态
  final DateTime? createdAt;    // 账号注册/创建日期

  const UserProfile({
    required this.id,
    required this.username,
    this.email,
    this.phone,
    this.avatar,
    this.nickname,
    this.followingCount = 0,
    this.followersCount = 0,
    this.postsCount = 0,
    this.likesCount = 0,
    this.vipLevel = 0,
    this.hasVehicle = false,
    this.phoneVerified = false,
    this.isUpdated = false,
    this.createdAt,
  });

  /// 获取显示名称逻辑：优先显示 [nickname]，若无则显示 [username]
  String get displayName => nickname ?? username;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile copyWith({
    String? id,
    String? username,
    String? email,
    String? phone,
    String? avatar,
    String? nickname,
    int? followingCount,
    int? followersCount,
    int? postsCount,
    int? likesCount,
    int? vipLevel,
    bool? hasVehicle,
    bool? phoneVerified,
    bool? isUpdated,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      nickname: nickname ?? this.nickname,
      followingCount: followingCount ?? this.followingCount,
      followersCount: followersCount ?? this.followersCount,
      postsCount: postsCount ?? this.postsCount,
      likesCount: likesCount ?? this.likesCount,
      vipLevel: vipLevel ?? this.vipLevel,
      hasVehicle: hasVehicle ?? this.hasVehicle,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      isUpdated: isUpdated ?? this.isUpdated,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// [UserVehicle] - 用户车辆关联模型
@JsonSerializable()
class UserVehicle {
  final String id;              // 车辆唯一标识
  final String name;            // 车型显示名称（如：BJ40 城市猎人版）
  final String? plateNumber;    // 车牌号
  final String? vin;            // 车辆识别代号 (VIN)
  final String? imageUrl;       // 车辆展示图片 URL
  final bool? isPrimary;        // 是否设置为首选/主车辆
  final String? status;         // 绑定状态：'active' (已激活), 'review' (审核中), 'inactive' (未激活)
  final DateTime? createdAt;    // 车辆绑定日期

  const UserVehicle({
    required this.id,
    required this.name,
    this.plateNumber,
    this.vin,
    this.imageUrl,
    this.isPrimary,
    this.status,
    this.createdAt,
  });

  factory UserVehicle.fromJson(Map<String, dynamic> json) =>
      _$UserVehicleFromJson(json);

  Map<String, dynamic> toJson() => _$UserVehicleToJson(this);

  UserVehicle copyWith({
    String? id,
    String? name,
    String? plateNumber,
    String? vin,
    String? imageUrl,
    bool? isPrimary,
    String? status,
    DateTime? createdAt,
  }) {
    return UserVehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      plateNumber: plateNumber ?? this.plateNumber,
      vin: vin ?? this.vin,
      imageUrl: imageUrl ?? this.imageUrl,
      isPrimary: isPrimary ?? this.isPrimary,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// [ServiceStatus] - 服务记录流转状态枚举
enum ServiceStatus {
  pending,      // 待处理/待确认
  inProgress,   // 进行中/施工中
  completed,    // 已完成/已交车
  cancelled,    // 已取消
}

/// [ServiceRecord] - 车辆售后/维保服务记录模型
@JsonSerializable()
class ServiceRecord {
  final String id;              // 记录唯一标识
  final String userId;          // 关联用户 ID
  final String? vehicleId;      // 关联车辆 ID（若有）
  final String serviceType;     // 服务类型（如：常规保养、故障维修）
  final String? description;    // 车主报修描述
  @JsonKey(fromJson: _parseStatus, toJson: _statusToString)
  final ServiceStatus status;   // 当前服务状态
  final DateTime? scheduledDate; // 预约日期
  final DateTime? completedDate; // 施工完成日期
  final String? storeName;      // 服务门店名称
  final String? storeAddress;   // 门店详细地址
  final double? cost;           // 本次服务产生的费用
  final String? notes;          // 技师备注/结单说明
  final DateTime? createdAt;    // 记录创建时间戳

  const ServiceRecord({
    required this.id,
    required this.userId,
    this.vehicleId,
    required this.serviceType,
    this.description,
    this.status = ServiceStatus.pending,
    this.scheduledDate,
    this.completedDate,
    this.storeName,
    this.storeAddress,
    this.cost,
    this.notes,
    this.createdAt,
  });

  /// 获取状态显示文本
  String get statusText {
    switch (status) {
      case ServiceStatus.pending:
        return '待处理';
      case ServiceStatus.inProgress:
        return '进行中';
      case ServiceStatus.completed:
        return '已完成';
      case ServiceStatus.cancelled:
        return '已取消';
    }
  }

  static ServiceStatus _parseStatus(String? status) {
    switch (status) {
      case 'pending':
        return ServiceStatus.pending;
      case 'in_progress':
      case 'inProgress':
        return ServiceStatus.inProgress;
      case 'completed':
        return ServiceStatus.completed;
      case 'cancelled':
        return ServiceStatus.cancelled;
      default:
        return ServiceStatus.pending;
    }
  }

  static String _statusToString(ServiceStatus status) => status.name;

  factory ServiceRecord.fromJson(Map<String, dynamic> json) =>
      _$ServiceRecordFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceRecordToJson(this);
}