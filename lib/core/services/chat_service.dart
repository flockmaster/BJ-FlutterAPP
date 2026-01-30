import '../models/chat_message.dart';

/// [IChatService] - 即时通讯与客户服务接口
/// 
/// 负责处理：建立会话、发送消息、自动回复以及车辆卡片等交互逻辑。
abstract class IChatService {
  /// 获取初始欢迎消息
  /// [carInfo]：当前关联的车辆信息，用于个性化欢迎语
  Future<List<ChatMessage>> getInitialMessages(Map<String, dynamic> carInfo);
  
  /// 发送一条用户消息
  Future<ChatMessage> sendMessage(String text);
  
  /// 获取系统的自动回复消息（模拟 AI 或专家回复）
  Future<ChatMessage> getAutoReply(String userMessage);
  
  /// 创建一条包含车辆详细资料的可交互卡片消息
  ChatMessage createCarCard(Map<String, dynamic> carInfo);
}

/// [ChatService] - 即时通讯服务具体实现
class ChatService implements IChatService {
  @override
  Future<List<ChatMessage>> getInitialMessages(Map<String, dynamic> carInfo) async {
    final messages = <ChatMessage>[];
    
    // 1. 生成系统欢迎语
    final carName = carInfo['name'] ?? '北京汽车';
    messages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      isMe: false,
      text: '尊贵的$carName车主，您好！我是您的专属产品专家，很高兴为您服务。请问有什么可以帮您？',
      time: DateTime.now(),
    ));
    
    // 2. 如果提供了车辆信息，则自动发送一张车型卡片作为沟通上下文
    if (carInfo.isNotEmpty) {
      messages.add(createCarCard(carInfo));
    }
    
    return messages;
  }

  @override
  Future<ChatMessage> sendMessage(String text) async {
    // 封装用户发送的消息模型
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      isMe: true,
      text: text,
      time: DateTime.now(),
    );
  }

  @override
  Future<ChatMessage> getAutoReply(String userMessage) async {
    // 模拟网络延迟与专家的异步回复过程
    await Future.delayed(const Duration(seconds: 1));
    
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      isMe: false,
      text: '收到您的消息，专家正在输入中...',
      time: DateTime.now(),
    );
  }

  @override
  ChatMessage createCarCard(Map<String, dynamic> carInfo) {
    // 构建特殊类型的消息：车辆咨询卡片
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      isMe: true, // 习惯上由用户发起咨询，故设为 isMe
      text: '我想咨询这款车',
      time: DateTime.now(),
      type: 'car_card',
      data: carInfo,
    );
  }
}