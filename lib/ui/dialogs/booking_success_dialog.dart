import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class BookingSuccessDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const BookingSuccessDialog({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget build(BuildContext context) {
    // Expecting customData to have specific fields
    final data = request.customData as Map<String, dynamic>? ?? {};
    final packageName = data['packageName'] ?? '';
    final storeName = data['storeName'] ?? '';
    final timeStr = data['timeStr'] ?? '';
    final price = data['price'] ?? 0;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        '预约成功',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF111827),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '系统已为您锁定工位',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('保养套餐', packageName),
          _buildInfoRow('服务门店', storeName),
          _buildInfoRow('到店时间', timeStr),
          _buildInfoRow('预计费用', '¥$price'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => completer(DialogResponse(confirmed: true)),
          child: const Text(
            '确定',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
