// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      id: json['id'] as String,
      isMe: json['isMe'] as bool,
      text: json['text'] as String,
      time: DateTime.parse(json['time'] as String),
      type: json['type'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isMe': instance.isMe,
      'text': instance.text,
      'time': instance.time.toIso8601String(),
      'type': instance.type,
      'data': instance.data,
    };
