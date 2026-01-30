import 'package:flutter/material.dart';
import '../../../app/app.locator.dart';
import '../../../core/base/baic_base_view_model.dart';
import '../../../core/models/chat_message.dart';
import '../../../core/services/chat_service.dart';

/// [ConsultantChatViewModel] - 产品顾问在线咨询聊天界面的业务逻辑类
class ConsultantChatViewModel extends BaicBaseViewModel {
  /// 聊天数据接口，负责核心消息的收发与模拟逻辑
  final IChatService _chatService = locator<IChatService>();
  
  /// 消息输入框控制器
  final TextEditingController messageController = TextEditingController();
  
  /// 当前会话中的所有消息列表
  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;
  
  /// 当前咨询关联的车型上下文信息
  Map<String, dynamic> _carInfo = {};
  Map<String, dynamic> get carInfo => _carInfo;
  
  /// 初始化聊天界面
  /// [carInfo]: 从上一页面传入的车型详细数据，用于初始化上下文消息
  void initialize(Map<String, dynamic> carInfo) async {
    _carInfo = carInfo;
    setBusy(true);
    
    try {
      // 加载首屏消息（通常包含 AI 欢迎语或车型卡片）
      final initialMessages = await _chatService.getInitialMessages(carInfo);
      _messages.addAll(initialMessages);
      notifyListeners();
    } catch (e) {
      debugPrint('初始化聊天失败: $e');
    } finally {
      setBusy(false);
    }
  }
  
  /// 发送文本消息逻辑
  void sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return; // 拦截空消息
    
    try {
      // 1. 同步将用户消息插入列表并清空输入框，提升体验
      final userMessage = await _chatService.sendMessage(text);
      _messages.add(userMessage);
      messageController.clear();
      notifyListeners();
      
      // 2. 模拟/获取智能顾问的自动回复
      final autoReply = await _chatService.getAutoReply(text);
      _messages.add(autoReply);
      notifyListeners();
    } catch (e) {
      debugPrint('发送消息失败: $e');
    }
  }
  
  @override
  void dispose() {
    messageController.dispose(); // 释放资源，防止内存溢出
    super.dispose();
  }
}