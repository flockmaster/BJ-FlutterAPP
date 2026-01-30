import '../../../app/app.locator.dart';
import '../../../core/base/baic_base_view_model.dart';
import '../../../core/services/message_service.dart';

/// [MessageCenterViewModel] - 消息中心（全量通知管理）业务逻辑类
///
/// 核心职责：
/// 1. 分类展示用户接收的所有通知：涉及系统通知、服务通知及社区互动（点赞/评论）。
/// 2. 管理消息的已读/未读状态流。
/// 3. 提供“一键已读”清理交互。
class MessageCenterViewModel extends BaicBaseViewModel {
  final _messageService = locator<IMessageService>();

  /// 当前选中的消息分类 Tab ID
  String _activeTab = 'all';
  String get activeTab => _activeTab;

  /// 全量或分类后的消息实体列表
  List<Message> _messages = [];
  List<Message> get messages => _messages;

  /// 下标页签定义（全部、系统、服务、互动）
  final List<MessageTab> tabs = [
    MessageTab(id: 'all', label: '全部'),
    MessageTab(id: 'system', label: '系统'),
    MessageTab(id: 'service', label: '服务'),
    MessageTab(id: 'social', label: '互动'),
  ];

  /// 生命周期：初始化加载全量消息
  Future<void> init() async {
    await loadMessages();
  }

  /// 业务加载：从 [IMessageService] 拉取指定分类的消息流
  Future<void> loadMessages() async {
    setBusy(true);
    
    try {
      final type = _activeTab == 'all' ? null : _activeTab;
      _messages = await _messageService.getMessages(type: type);
      notifyListeners();
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  /// 交互：切换消息分类 Tab 并重载数据
  void setActiveTab(String tabId) {
    if (_activeTab == tabId) return;
    
    _activeTab = tabId;
    notifyListeners();
    loadMessages();
  }

  /// 交互：标记单条消息为已读并刷新本地状态
  Future<void> markAsRead(String messageId) async {
    try {
      await _messageService.markAsRead(messageId);
      
      final index = _messages.indexWhere((m) => m.id == messageId);
      if (index != -1) {
        await loadMessages();
      }
    } catch (e) {
      setError(e);
    }
  }

  /// 交互：抹除当前分类下的所有未读红点
  Future<void> markAllAsRead() async {
    setBusy(true);
    
    try {
      await _messageService.markAllAsRead();
      await loadMessages();
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  /// 统计：计算当前展示列表中的未读消息总数
  int get unreadCount => _messages.where((m) => !m.isRead).length;
}

class MessageTab {
  final String id;
  final String label;

  MessageTab({
    required this.id,
    required this.label,
  });
}
