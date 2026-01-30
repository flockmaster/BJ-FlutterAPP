import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../optimized_image.dart';
import 'package:car_owner_app/core/theme/app_colors.dart';

/// 充电服务组件
class ChargingService extends StatelessWidget {
  final VoidCallback? onMapTap;
  final VoidCallback? onScanTap;
  final VoidCallback? onPileTap;
  final VoidCallback? onOrdersTap;

  const ChargingService({
    super.key,
    this.onMapTap,
    this.onScanTap,
    this.onPileTap,
    this.onOrdersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // 顶部图片区域
            Stack(
              children: [
                const SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: OptimizedImage(
                    imageUrl: 'https://p.sda1.dev/29/d11d2775070be000a33612d78f3b187b/13.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                // 渐变遮罩
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ),
                ),
                // 标题
                const Positioned(
                  top: 20,
                  left: 20,
                  child: Text(
                    '充电服务',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            // 底部操作按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionBtn(LucideIcons.map, '充电地图', onMapTap),
                  _buildActionBtn(LucideIcons.scanLine, '扫码充电', onScanTap),
                  _buildActionBtn(LucideIcons.zap, '私桩管理', onPileTap),
                  _buildActionBtn(LucideIcons.history, '充电订单', onOrdersTap),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String label, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 28, color: AppColors.brandDark),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
