import 'package:json_annotation/json_annotation.dart';

part 'car_specs_models.g.dart';

/// [SpecItem] - 具体的参数/配置项模型
@JsonSerializable()
class SpecItem {
  final String label; // 参数项名称（如：最大功率）
  final String value; // 参数项数值或描述（如：185kW）

  const SpecItem({
    required this.label,
    required this.value,
  });

  factory SpecItem.fromJson(Map<String, dynamic> json) =>
      _$SpecItemFromJson(json);

  Map<String, dynamic> toJson() => _$SpecItemToJson(this);
}

/// [SpecGroup] - 参数配置分组模型
/// 
/// 用于将相似的参数项归类（如：动力系统、车身尺寸）。
@JsonSerializable()
class SpecGroup {
  final String name;             // 分组名称（如：发动机参数）
  final List<SpecItem> items;    // 该组下的所有配置项

  const SpecGroup({
    required this.name,
    required this.items,
  });

  factory SpecGroup.fromJson(Map<String, dynamic> json) =>
      _$SpecGroupFromJson(json);

  Map<String, dynamic> toJson() => _$SpecGroupToJson(this);
}
