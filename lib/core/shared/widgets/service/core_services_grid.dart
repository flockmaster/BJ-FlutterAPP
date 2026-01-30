import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui';
import '../optimized_image.dart';
import 'package:car_owner_app/core/theme/app_dimensions.dart';
import 'package:car_owner_app/core/theme/app_typography.dart';
import 'package:car_owner_app/ui/views/service/maintenance_booking_view.dart';

/// 核心服务网格组件
/// 
/// 显示道路救援、预约保养、故障报修等核心服务卡片
class CoreServicesGrid extends StatelessWidget {
  final VoidCallback? onRescueTap;
  final VoidCallback? onMaintenanceTap;
  final VoidCallback? onRepairTap;

  const CoreServicesGrid({
    super.key,
    this.onRescueTap,
    this.onMaintenanceTap,
    this.onRepairTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 280,
        child: Row(
          children: [
            // 左侧大卡片 - 道路救援
            Expanded(
              child: _buildLargeCard(
                title: '道路救援',
                subtitle: '24小时极速响应',
                icon: LucideIcons.truck,
                imageUrl: 'https://p.sda1.dev/29/ccf10533e046e59cb78877c9c14144a6/c696f5542502642a9e01aec18f8eeca4.jpg',
                onTap: onRescueTap,
              ),
            ),
            const SizedBox(width: 12),
            // 右侧小卡片列
            Expanded(
              child: Column(
                children: [
                  _buildSmallCard(
                    title: '预约保养',
                    subtitle: '省时省心',
                    imageUrl: 'https://p.sda1.dev/29/ae3ed8bbc50175c27a2798406f77be37/d54f2febf1d2139c8791c1a472ceed79.jpg',
                    onTap: onMaintenanceTap,
                    context: context,
                  ),
                  const SizedBox(height: 12),
                  _buildSmallCard(
                    title: 'AI 故障识别',
                    subtitle: '拍图速查仪表指示灯',
                    imageUrl: 'https://p.sda1.dev/29/f5cbce1cb2aae7be70f8cd26d1e422f1/7bf05d8c5794b1a908c1bd70e1de7b26.jpg',
                    onTap: onRepairTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String imageUrl,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          borderRadius: AppDimensions.borderRadiusL,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            OptimizedImage(imageUrl: imageUrl, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Center(
                          child: Icon(icon, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    title,
                    style: AppTypography.headingMInverse.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallCard({
    required String title,
    required String subtitle,
    required String imageUrl,
    VoidCallback? onTap,
    BuildContext? context,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap();
          } else if (context != null && title == '预约保养') {
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => const MaintenanceBookingView(),
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppDimensions.borderRadiusL,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              OptimizedImage(imageUrl: imageUrl, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: const Center(
                        child: Icon(LucideIcons.chevronRight, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.headingSInverse.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTypography.captionPrimary.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
