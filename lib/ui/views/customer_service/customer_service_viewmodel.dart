import 'package:flutter/foundation.dart';
import '../../../app/app.locator.dart';
import '../../../core/base/baic_base_view_model.dart';
import '../../../core/services/customer_service_service.dart';

/// [CustomerServiceViewModel] - 在线客服与即时通讯业务逻辑类
///
/// 核心职责：
/// 1. 展示客服对话流：包含机器人自动回复、人工客服消息及时间戳展示。
/// 2. 管理输入交互：实时更新输入区状态、分发快捷回复指令。
/// 3. 集成外部通讯：处理一键拨号呼叫人工热线逻辑。
class CustomerServiceViewModel extends BaicBaseViewModel {
  final ICustomerServiceService _customerServiceService = locator<ICustomerServiceService>();

  /// 历史与实时的聊天消息队列
  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  /// 当前文本框待发送的内容
  String _inputText = '';
  String get inputText => _inputText;

  /// 系统推荐的快捷问题列表（如：如何提车、保养预约等）
  List<String> _quickReplies = [];
  List<String> get quickReplies => _quickReplies;

  /// 计算属性：校验发送按钮的激活状态
  bool get canSend => _inputText.trim().isNotEmpty;

  /// 生命周期：初始化拉取首屏消息（欢迎语）与常用快捷词
  Future<void> init() async {
    setBusy(true);
    try {
      _messages = await _customerServiceService.getInitialMessages();
      _quickReplies = _customerServiceService.getQuickReplies();
      notifyListeners();
    } catch (e) {
      debugPrint('客服模块初始化异常: $e');
    } finally {
      setBusy(false);
    }
  }

  /// 状态同步：实时监听输入框文本变动
  void updateInputText(String text) {
    _inputText = text;
    notifyListeners();
  }

  /// 核心交互：正式分发用户消息，并异步拉取座席/机器人应答
  Future<void> sendMessage() async {
    if (!canSend) return;

    final messageText = _inputText.trim();
    _inputText = '';
    notifyListeners();

    // 乐观 UI 更新：先行在列表中追加用户侧消息气泡
    _messages.add(ChatMessage(
      type: MessageType.user,
      text: messageText,
      timestamp: DateTime.now(),
    ));
    notifyListeners();

    try {
      await _customerServiceService.sendMessage(messageText);
      final response = await _customerServiceService.getAgentResponse(messageText);
      _messages.add(response);
      notifyListeners();
    } catch (e) {
      debugPrint('消息收发链路异常: $e');
    }
  }

  /// 交互：点击底部快捷球直接填充并发送
  Future<void> sendQuickReply(String reply) async {
    _inputText = reply;
    notifyListeners();
    await sendMessage();
  }

  /// 交互：唤起系统拨号盘拨打 400 客服热线
  void handlePhoneCall() {
    debugPrint('执行拨号交互');
  }
}
