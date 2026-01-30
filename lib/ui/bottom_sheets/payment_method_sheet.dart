import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class PaymentMethodSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const PaymentMethodSheet({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget build(BuildContext context) {
    final data = request.customData as Map<String, dynamic>;
    final double amount = data['amount'] ?? 0.0;
    final String selectedMethod = data['selectedMethod'] ?? 'wechat';
    final DateTime expiryTime = data['expiryTime'] ?? DateTime.now().add(const Duration(minutes: 15));

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '确认支付',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => completer(SheetResponse(confirmed: false)),
                ),
              ],
            ),
            
            // Amount
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  '¥${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oswald', // Assuming mechanical font
                  ),
                ),
              ),
            ),
            
            // Methods
            _buildMethodItem(
              icon: Icons.chat_bubble, // WeChat fake icon
              iconColor: Colors.green,
              name: '微信支付',
              isSelected: selectedMethod == 'wechat',
              onTap: () => completer(SheetResponse(confirmed: true, data: 'wechat')),
            ),
            const SizedBox(height: 12),
            _buildMethodItem(
              icon: Icons.account_balance_wallet, // Alipay fake icon
              iconColor: Colors.blue,
              name: '支付宝支付',
              isSelected: selectedMethod == 'alipay',
              onTap: () => completer(SheetResponse(confirmed: true, data: 'alipay')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodItem({
    required IconData icon,
    required Color iconColor,
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6B00) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? const Color(0xFFFFF5EB) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFFFF6B00)),
          ],
        ),
      ),
    );
  }
}
