import 'package:json_annotation/json_annotation.dart';

part 'user_address.g.dart';

/// [UserAddress] - 用户收货地址实体模型
@JsonSerializable()
class UserAddress {
  final int id;                 // 地址唯一 ID
  @JsonKey(name: 'user_id')
  final int userId;             // 所属用户 ID
  @JsonKey(name: 'contact_name')
  final String contactName;     // 收货人姓名
  @JsonKey(name: 'contact_phone')
  final String contactPhone;    // 收货人联系电话
  final String province;        // 省份
  final String city;            // 城市
  final String district;        // 区/县
  @JsonKey(name: 'detail_address')
  final String detailAddress;   // 详细街道门牌号
  @JsonKey(name: 'is_default')
  final bool isDefault;         // 是否设置为默认地址
  final String? tag;            // 地址标签（如：家、公司）

  UserAddress({
    required this.id,
    required this.userId,
    required this.contactName,
    required this.contactPhone,
    required this.province,
    required this.city,
    required this.district,
    required this.detailAddress,
    required this.isDefault,
    this.tag,
  });

  /// 获取拼装后的完整省市区街道地址
  String get fullAddress => '$province$city$district$detailAddress';
  
  /// 对收货电话进行脱敏处理 (例如: 138****1234)
  String get maskedPhone => contactPhone.length > 7 
      ? contactPhone.replaceRange(3, 7, '****') 
      : contactPhone;

  factory UserAddress.fromJson(Map<String, dynamic> json) => _$UserAddressFromJson(json);
  Map<String, dynamic> toJson() => _$UserAddressToJson(this);
}
