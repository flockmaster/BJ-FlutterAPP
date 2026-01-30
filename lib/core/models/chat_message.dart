import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

/// [ChatMessage] - 即时通讯消息实体模型
@JsonSerializable()
class ChatMessage {
  final String id;              // 消息唯一标识
  final bool isMe;              // 是否由当前用户发出（用于 UI 左右对齐）
  final String text;            // 消息正文文本
  final DateTime time;          // 消息发送/接收的时间戳
  final String? type;           // 消息扩展类型（如：'vehicle_card', 'image'）
  final Map<String, dynamic>? data; // 与特殊类型消息关联的原始数据

  const ChatMessage({
    required this.id,
    required this.isMe,
    required this.text,
    required this.time,
    this.type,
    this.data,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  /// 快捷复制并修改部分属性的方法
  ChatMessage copyWith({
    String? id,
    bool? isMe,
    String? text,
    DateTime? time,
    String? type,
    Map<String, dynamic>? data,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      isMe: isMe ?? this.isMe,
      text: text ?? this.text,
      time: time ?? this.time,
      type: type ?? this.type,
      data: data ?? this.data,
    );
  }
}