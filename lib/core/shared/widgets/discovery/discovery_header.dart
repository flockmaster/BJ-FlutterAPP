import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:car_owner_app/core/theme/app_colors.dart';
import 'package:car_owner_app/core/theme/app_dimensions.dart';
import 'package:car_owner_app/core/theme/app_typography.dart';
import 'package:car_owner_app/core/components/baic_ui_kit.dart';

class DiscoveryHeader extends StatelessWidget {
  final TabController tabController;
  final List<String> tabs;
  final VoidCallback onSearchTap;
  final VoidCallback onPublishTap;

  const DiscoveryHeader({
    super.key,
    required this.tabController,
    required this.tabs,
    required this.onSearchTap,
    required this.onPublishTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgSurface,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 2),
              child: Row(
                children: [
                  Expanded(
                    child: TabBar(
                      controller: tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      labelColor: AppColors.textTitle,
                      unselectedLabelColor: AppColors.textSecondary,
                      labelStyle: AppTypography.headingS.copyWith(fontSize: 18),
                      unselectedLabelStyle: AppTypography.headingS.copyWith(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          color: AppColors.brandOrange,
                          width: 4,
                        ),
                        insets: const EdgeInsets.only(bottom: 0, left: 10, right: 10),
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                      dividerColor: Colors.transparent,
                      tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      _buildActionButton(LucideIcons.search, onSearchTap),
                      const SizedBox(width: 8),
                      _buildActionButton(LucideIcons.plus, onPublishTap, isPrimary: true),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap, {bool isPrimary = false}) {
    return BaicBounceButton(
      onPressed: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.brandBlack : AppColors.bgFill,
          borderRadius: AppDimensions.borderRadiusFull,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isPrimary ? AppColors.textInverse : AppColors.textTitle,
        ),
      ),
    );
  }
}
