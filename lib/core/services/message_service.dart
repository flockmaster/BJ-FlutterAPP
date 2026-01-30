import 'package:injectable/injectable.dart';

/// [IMessageService] - 消息通知中心服务接口
/// 
/// 负责管理：系统通知、服务提醒、社交互动的消息获取与状态（已读/未读）更新。
abstract class IMessageService {
  /// 获取消息列表，支持按类型（如：system, service, social）过滤
  Future<List<Message>> getMessages({String? type});
  
  /// 将单条消息标记为已读
  Future<bool> markAsRead(String messageId);
  
  /// 将所有未读消息一键置为已读
  Future<bool> markAllAsRead();
}

/// [MessageService] - 消息中心具体实现
@LazySingleton(as: IMessageService)
class MessageService implements IMessageService {
  @override
  Future<List<Message>> getMessages({String? type}) async {
    // 模拟网络请求耗时
    await Future.delayed(const Duration(milliseconds: 500));
    
    final allMessages = [
      Message(
        id: '1',
        type: MessageType.service,
        title: '保养预约确认',
        description: '您的BJ40预约保养已确认，请于1月20日 10:00前往北京汽车朝阳4S店。',
        time: '10:30',
        isRead: false,
      ),
      Message(
        id: '2',
        type: MessageType.system,
        title: '双11特惠活动开启',
        description: '越野配件低至5折，限时抢购！点击查看详情。',
        time: '昨天',
        isRead: false,
      ),
      Message(
        id: '3',
        type: MessageType.social,
        title: '越野老炮 赞了你的动态',
        description: '"周末去山里撒野..."',
        time: '昨天',
        isRead: true,
      ),
      Message(
        id: '4',
        type: MessageType.service,
        title: '车辆体检报告生成',
        description: '您的爱车体检已完成，各项指标正常。',
        time: '1月15日',
        isRead: true,
      ),
      Message(
        id: '5',
        type: MessageType.system,
        title: '版本更新通知',
        description: 'App v2.1.0 已发布，优化了部分体验。',
        time: '1月10日',
        isRead: true,
      ),
    ];
    
    if (type == null || type == 'all') {
      return allMessages;
    }
    
    final messageType = _getMessageType(type);
    return allMessages.where((m) => m.type == messageType).toList();
  }

  @override
  Future<bool> markAsRead(String messageId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
  
  /// 辅助方法：将字符串类型转换为 MessageType 枚举
  MessageType _getMessageType(String type) {
    switch (type) {
      case 'system':
        return MessageType.system;
      case 'service':
        return MessageType.service;
      case 'social':
        return MessageType.social;
      default:
        return MessageType.system;
    }
  }
}

/// [Message] - 消息实体模型
class Message {
  final String id;           // 消息唯一标识
  final MessageType type;    // 消息类别
  final String title;        // 消息标题
  final String description;  // 消息正文/摘要
  final String time;         // 相对时间描述（如：昨天, 10:30）
  final bool isRead;         // 阅读状态

  Message({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.time,
    required this.isRead,
  });
}

/// [MessageType] - 消息类别枚举
enum MessageType {
  system,  // 系统公告/通知
  service, // 服务提醒（维保、车辆状态）
  social,  // 社交互动（点赞、评论、关注）
}
