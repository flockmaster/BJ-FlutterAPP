import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:async';
import '../../../../core/theme/app_dimensions.dart';

/// 支付方式选择底部弹窗 - 收银台
class PaymentMethodSheet extends StatefulWidget {
  final double amount;
  final DateTime expiryTime;
  final String? selectedMethod;
  final VoidCallback onClose;

  const PaymentMethodSheet({
    super.key,
    required this.amount,
    required this.expiryTime,
    this.selectedMethod,
    required this.onClose,
  });

  @override
  State<PaymentMethodSheet> createState() => _PaymentMethodSheetState();
}

class _PaymentMethodSheetState extends State<PaymentMethodSheet> {
  String _selectedMethod = 'wechat';
  Timer? _timer;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.selectedMethod ?? 'wechat';
    _updateRemainingTime();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    final remaining = widget.expiryTime.difference(now);
    
    if (remaining.isNegative) {
      _timer?.cancel();
      setState(() {
        _remainingTime = Duration.zero;
      });
      // 支付超时，关闭弹窗
      Future.delayed(Duration.zero, () {
        if (mounted) {
          Navigator.pop(context, null);
        }
      });
    } else {
      setState(() {
        _remainingTime = remaining;
      });
    }
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // 头部
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
            ),
            child: Column(
              children: [
                // 拖动条
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                // 标题和关闭按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context, null),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          LucideIcons.x,
                          size: 20,
                          color: Color(0xFF111111),
                        ),
                      ),
                    ),
                    const Text(
                      '收银台',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(width: 32),
                  ],
                ),
              ],
            ),
          ),

          // 内容区域
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // 支付剩余时间
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        LucideIcons.clock,
                        size: 16,
                        color: Color(0xFFFF6B00),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '支付剩余时间',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFFF6B00),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(_remainingTime),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Oswald',
                          color: Color(0xFFFF6B00),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),

                  // 支付金额
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text(
                        '¥',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Oswald',
                          color: Color(0xFF111111),
                        ),
                      ),
                      Text(
                        widget.amount.toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Oswald',
                          color: Color(0xFF111111),
                          height: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // 支付方式列表
                  _buildPaymentOption(
                    icon: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF07C160),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LucideIcons.messageCircle,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                    title: '微信支付',
                    subtitle: '推荐使用，安全快捷',
                    value: 'wechat',
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildPaymentOption(
                    icon: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1677FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LucideIcons.creditCard,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                    title: '支付宝',
                    subtitle: '数亿用户的选择',
                    value: 'alipay',
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildPaymentOption(
                    icon: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF111111),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LucideIcons.users,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                    title: '找人代付',
                    subtitle: '发送给好友帮忙买单',
                    value: 'proxy',
                  ),
                ],
              ),
            ),
          ),

          // 底部确认按钮
          Container(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 16,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(top: BorderSide(color: Color(0xFFF0F0F0))),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () => Navigator.pop(context, _selectedMethod),
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: AppDimensions.borderRadiusFull,
                  color: const Color(0xFF111111),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '确认支付 ¥${widget.amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required Widget icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    final isSelected = _selectedMethod == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF111111) : const Color(0xFFF0F0F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF111111) : Colors.white,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF111111)
                      : const Color(0xFFE5E7EB),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      LucideIcons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
