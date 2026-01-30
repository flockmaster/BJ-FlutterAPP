/// [ICustomerServiceService] - 客户服务会话接口
/// 
/// 负责处理：建立客服会话、消息收发、自动回复匹配及获取快捷回复语。
abstract class ICustomerServiceService {
  /// 获取会话初始化时的消息列表（通常包含系统语和欢迎语）
  Future<List<ChatMessage>> getInitialMessages();
  
  /// 用户向客服发送一条文本消息
  Future<void> sendMessage(String message);
  
  /// 获取客服座席（或 AI）针对用户消息的回复
  Future<ChatMessage> getAgentResponse(String userMessage);
  
  /// 获取当前业务场景下的快捷回复模板（如：“保养政策”、“道路救援”）
  List<String> getQuickReplies();
}

/// [CustomerServiceService] - 客户服务功能具体实现
class CustomerServiceService implements ICustomerServiceService {
  // 内存中缓存的当前会话消息记录
  final List<ChatMessage> _messages = [];

  @override
  Future<List<ChatMessage>> getInitialMessages() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      ChatMessage(
        type: MessageType.system,
        text: '您好，欢迎联系北京汽车专属客服。',
        timestamp: DateTime.now(),
      ),
      ChatMessage(
        type: MessageType.agent,
        text: '我是金牌客服小北，很高兴为您服务。请问有什么可以帮您？',
        timestamp: DateTime.now(),
      ),
    ];
  }

  @override
  Future<void> sendMessage(String message) async {
    _messages.add(ChatMessage(
      type: MessageType.user,
      text: message,
      timestamp: DateTime.now(),
    ));
  }

  @override
  Future<ChatMessage> getAgentResponse(String userMessage) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // 基础的关键词匹配逻辑，用于模拟智能客服回复
    String response;
    if (userMessage.contains('保养') || userMessage.contains('维修')) {
      response = '关于保养服务，我们提供全国联保服务。您可以通过APP预约保养，享受上门取送车服务。请问您需要预约保养吗？';
    } else if (userMessage.contains('救援') || userMessage.contains('道路')) {
      response = '我们提供24小时道路救援服务，全国范围内免费救援。如需紧急救援，请拨打400-810-8100，或在APP服务页面一键呼叫救援。';
    } else if (userMessage.contains('升级') || userMessage.contains('OTA') || userMessage.contains('车机')) {
      response = '关于车机升级，您可以在车辆设置中检查OTA更新。如遇到升级问题，请提供您的车辆VIN码，我会为您详细查询。';
    } else if (userMessage.contains('积分') || userMessage.contains('兑换')) {
      response = '积分可在商城兑换商品，也可抵扣保养费用。您当前的积分余额可在"我的-积分"中查看。需要帮您查询积分明细吗？';
    } else {
      response = '好的，我已收到您的提问，正在为您联系相关部门查询，请稍等片刻...';
    }
    
    return ChatMessage(
      type: MessageType.agent,
      text: response,
      timestamp: DateTime.now(),
    );
  }

  @override
  List<String> getQuickReplies() {
    return ['保养政策', '道路救援', '车机升级', '积分兑换'];
  }
}

/// [MessageType] - 消息发布者类型枚举
enum MessageType {
  system, // 系统通知或时间线分割
  agent,  // 座席/人工客服
  user,   // 终端用户
}

/// [ChatMessage] - 简单的客服消息实体模型
class ChatMessage {
  final MessageType type;   // 消息来源
  final String text;        // 消息文字内容
  final DateTime timestamp; // 消息产生时间

  ChatMessage({
    required this.type,
    required this.text,
    required this.timestamp,
  });
}
