import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:car_owner_app/core/theme/app_colors.dart';
import 'package:car_owner_app/core/theme/app_dimensions.dart';

/// 出行服务组件
class TravelServices extends StatelessWidget {
  final VoidCallback? onWashTap;
  final VoidCallback? onDriverTap;
  final VoidCallback? onFuelTap;
  final VoidCallback? onParkingTap;

  const TravelServices({
    super.key,
    this.onWashTap,
    this.onDriverTap,
    this.onFuelTap,
    this.onParkingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              '出行服务',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.brandDark,
              ),
            ),
          ),
          Row(
            children: [
              _buildCard(
                label: '洗车',
                icon: LucideIcons.sparkles,
                onTap: onWashTap,
              ),
              const SizedBox(width: 12),
              _buildCard(
                label: '代驾',
                icon: LucideIcons.user,
                onTap: onDriverTap,
              ),
              const SizedBox(width: 12),
              _buildCard(
                label: '加油',
                icon: LucideIcons.fuel,
                onTap: onFuelTap,
              ),
              const SizedBox(width: 12),
              _buildCard(
                label: '停车',
                icon: LucideIcons.parkingCircle,
                onTap: onParkingTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String label,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: const Color(0xFFF9FAFB)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F7FA),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.brandDark, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.brandDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
