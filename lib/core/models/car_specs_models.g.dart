// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_specs_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecItem _$SpecItemFromJson(Map<String, dynamic> json) => SpecItem(
      label: json['label'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$SpecItemToJson(SpecItem instance) => <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
    };

SpecGroup _$SpecGroupFromJson(Map<String, dynamic> json) => SpecGroup(
      name: json['name'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => SpecItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SpecGroupToJson(SpecGroup instance) => <String, dynamic>{
      'name': instance.name,
      'items': instance.items,
    };
