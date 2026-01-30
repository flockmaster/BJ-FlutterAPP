import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_typography.dart';
import 'baic_ui_kit.dart';

/// [ChatMessage] 聊天消息模型
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

/// [ConsultantModal] 在线咨询模态框组件
/// 基于原型的 AIChatModal.tsx 实现
class ConsultantModal extends StatefulWidget {
  final String? initialMessage;
  final String carName;

  const ConsultantModal({
    Key? key,
    this.initialMessage,
    required this.carName,
  }) : super(key: key);

  /// 静态显示方法
  static Future<void> show(BuildContext context, {String? initialMessage, required String carName}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ConsultantModal(
        initialMessage: initialMessage,
        carName: carName,
      ),
    );
  }

  @override
  State<ConsultantModal> createState() => _ConsultantModalState();
}

class _ConsultantModalState extends State<ConsultantModal> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 初始化欢迎消息
    _messages.add(ChatMessage(
      text: widget.initialMessage ?? '您好！我是您的专属AI顾问。我看到您对 ${widget.carName} 感兴趣，有什么我可以帮您的吗？',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// 发送消息逻辑
  void _handleSend() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _textController.clear();
      _isLoading = true;
    });

    _scrollToBottom();

    // 模拟 AI 回复
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _messages.add(ChatMessage(
          text: '这是一个模拟回复。在实际应用中，这里将调用 Gemini API 为您提供关于 ${widget.carName} 的详细专业解答。',
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    }
  }

  /// 滚动到底部
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 获取键盘高度，用于调整布局
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusL)),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(context),
          
          // Messages Area
          Expanded(
            child: Container(
              color: const Color(0xFFF7F8FA),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isLoading) {
                    return _buildTypingIndicator();
                  }
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
          ),
          
          // Input Area
          _buildInputArea(bottomInset),
        ],
      ),
    );
  }

  /// 构建头部
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusL)),
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          // Bot Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1A1A), Color(0xFF333333)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(LucideIcons.bot, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          // Title & Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI 产品顾问', style: AppTypography.headingS),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '在线',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Close Button
          BaicBounceButton(
            onPressed: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.x, size: 20, color: Color(0xFF6B7280)),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建消息气泡
  Widget _buildMessageBubble(ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: msg.isUser ? const Color(0xFF1A1A1A) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(msg.isUser ? 16 : 0),
                bottomRight: Radius.circular(msg.isUser ? 0 : 16),
              ),
              border: msg.isUser ? null : Border.all(color: const Color(0xFFF3F4F6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              msg.text,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: msg.isUser ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建正在输入指示器
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.zero,
              ),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return _TypingDot(delay: Duration(milliseconds: i * 200));
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建输入区域
  Widget _buildInputArea(double bottomInset) {
    return Container(
      color: AppColors.bgSurface,
      child: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, bottomInset > 0 ? 12 : 20),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: AppDimensions.borderRadiusFull,
                    ),
                    child: TextField(
                      controller: _textController,
                      onSubmitted: (_) => _handleSend(),
                      decoration: const InputDecoration(
                        hintText: '询问关于车型的问题...',
                        hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                BaicBounceButton(
                  onPressed: _handleSend,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1A1A1A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.send, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// [_TypingDot] 打字动画小点
class _TypingDot extends StatefulWidget {
  final Duration delay;
  const _TypingDot({required this.delay});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 5,
          height: 5,
          transform: Matrix4.translationValues(0, _animation.value, 0),
          decoration: const BoxDecoration(
            color: Color(0xFF9CA3AF),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
