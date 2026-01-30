// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      nickname: json['nickname'] as String?,
      followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
      followersCount: (json['followersCount'] as num?)?.toInt() ?? 0,
      postsCount: (json['postsCount'] as num?)?.toInt() ?? 0,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      vipLevel: (json['vipLevel'] as num?)?.toInt() ?? 0,
      hasVehicle: json['hasVehicle'] as bool? ?? false,
      phoneVerified: json['phoneVerified'] as bool? ?? false,
      isUpdated: json['isUpdated'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'nickname': instance.nickname,
      'followingCount': instance.followingCount,
      'followersCount': instance.followersCount,
      'postsCount': instance.postsCount,
      'likesCount': instance.likesCount,
      'vipLevel': instance.vipLevel,
      'hasVehicle': instance.hasVehicle,
      'phoneVerified': instance.phoneVerified,
      'isUpdated': instance.isUpdated,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

UserVehicle _$UserVehicleFromJson(Map<String, dynamic> json) => UserVehicle(
      id: json['id'] as String,
      name: json['name'] as String,
      plateNumber: json['plateNumber'] as String?,
      vin: json['vin'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isPrimary: json['isPrimary'] as bool?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$UserVehicleToJson(UserVehicle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'plateNumber': instance.plateNumber,
      'vin': instance.vin,
      'imageUrl': instance.imageUrl,
      'isPrimary': instance.isPrimary,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

ServiceRecord _$ServiceRecordFromJson(Map<String, dynamic> json) =>
    ServiceRecord(
      id: json['id'] as String,
      userId: json['userId'] as String,
      vehicleId: json['vehicleId'] as String?,
      serviceType: json['serviceType'] as String,
      description: json['description'] as String?,
      status: json['status'] == null
          ? ServiceStatus.pending
          : ServiceRecord._parseStatus(json['status'] as String?),
      scheduledDate: json['scheduledDate'] == null
          ? null
          : DateTime.parse(json['scheduledDate'] as String),
      completedDate: json['completedDate'] == null
          ? null
          : DateTime.parse(json['completedDate'] as String),
      storeName: json['storeName'] as String?,
      storeAddress: json['storeAddress'] as String?,
      cost: (json['cost'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ServiceRecordToJson(ServiceRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'vehicleId': instance.vehicleId,
      'serviceType': instance.serviceType,
      'description': instance.description,
      'status': ServiceRecord._statusToString(instance.status),
      'scheduledDate': instance.scheduledDate?.toIso8601String(),
      'completedDate': instance.completedDate?.toIso8601String(),
      'storeName': instance.storeName,
      'storeAddress': instance.storeAddress,
      'cost': instance.cost,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
