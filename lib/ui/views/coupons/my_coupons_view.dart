import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' hide SkeletonLoader;
import 'package:lucide_icons/lucide_icons.dart';
import 'my_coupons_viewmodel.dart';
import '../../../core/models/coupon.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/skeleton_loader.dart';

class MyCouponsView extends StatelessWidget {
  const MyCouponsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MyCouponsViewModel>.reactive(
      viewModelBuilder: () => MyCouponsViewModel(),
      onViewModelReady: (viewModel) => viewModel.initialize(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return const _SkeletonView();
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.only(
                  top: 54,
                  left: 12,
                  right: 20,
                  bottom: 12,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFF3F4F6),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: viewModel.goBack,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          LucideIcons.arrowLeft,
                          size: 24,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                    const Text(
                      '我的卡券',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(width: 36),
                  ],
                ),
              ),

              // Tab Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                color: const Color(0xFFF5F7FA),
                child: Row(
                  children: [
                    _buildTab(
                      context,
                      viewModel,
                      CouponTab.valid,
                      '未使用',
                    ),
                    const SizedBox(width: 32),
                    _buildTab(
                      context,
                      viewModel,
                      CouponTab.expired,
                      '已失效',
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: viewModel.filteredCoupons.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: viewModel.filteredCoupons.length,
                        itemBuilder: (context, index) {
                          final coupon = viewModel.filteredCoupons[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildCouponCard(
                              context,
                              viewModel,
                              coupon,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTab(
    BuildContext context,
    MyCouponsViewModel viewModel,
    CouponTab tab,
    String label,
  ) {
    final isActive = viewModel.activeTab == tab;
    return GestureDetector(
      onTap: () => viewModel.switchTab(tab),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isActive ? const Color(0xFF111827) : const Color(0xFF9CA3AF),
        ),
      ),
    );
  }

  Widget _buildCouponCard(
    BuildContext context,
    MyCouponsViewModel viewModel,
    Coupon coupon,
  ) {
    final isValid = coupon.isValid;
    final bgColor = isValid ? Colors.white : const Color(0xFFF3F4F6);
    final opacity = isValid ? 1.0 : 0.7;

    Color leftBgColor;
    if (!isValid) {
      leftBgColor = const Color(0xFF9CA3AF);
    } else {
      switch (coupon.type) {
        case CouponType.discount:
          leftBgColor = const Color(0xFFFF6B00);
          break;
        case CouponType.service:
          leftBgColor = const Color(0xFF111827);
          break;
        case CouponType.charging:
          leftBgColor = const Color(0xFF00B894);
          break;
      }
    }

    String typeLabel;
    switch (coupon.type) {
      case CouponType.discount:
        typeLabel = '代金券';
        break;
      case CouponType.service:
        typeLabel = '折扣券';
        break;
      case CouponType.charging:
        typeLabel = '兑换券';
        break;
    }

    return Opacity(
      opacity: opacity,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Side - Amount
            Container(
              width: 100,
              decoration: BoxDecoration(
                color: leftBgColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        coupon.amount,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Oswald',
                        ),
                      ),
                      Text(
                        coupon.unit,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Oswald',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    typeLabel,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Right Side - Info
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coupon.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              coupon.subtitle,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 8),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xFFF3F4F6),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            '有效期至 ${coupon.expiry}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF9CA3AF),
                              fontFamily: 'Oswald',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Punch hole
                  Positioned(
                    left: -6,
                    top: 50,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F7FA),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Use button
                  if (isValid)
                    Positioned(
                      right: 16,
                      top: 50,
                      child: GestureDetector(
                        onTap: () => viewModel.useCoupon(coupon.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B00),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF6B00).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            '去使用',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.ticket,
            size: 48,
            color: const Color(0xFF9CA3AF).withValues(alpha: 0.5),
          ),
          const SizedBox(height: 8),
          const Text(
            '暂无卡券',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonView extends StatelessWidget {
  const _SkeletonView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SkeletonLoader(
        child: Column(
          children: [
            // Header Skeleton
            Container(
              padding: const EdgeInsets.only(
                top: 54,
                left: 12,
                right: 20,
                bottom: 12,
              ),
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SkeletonCircle(size: 36),
                  SkeletonBox(width: 80, height: 24),
                  SizedBox(width: 36),
                ],
              ),
            ),
            
            // Tab Skeleton
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: const Color(0xFFF5F7FA),
              child: const Row(
                children: [
                  SkeletonBox(width: 50, height: 20),
                  SizedBox(width: 32),
                  SkeletonBox(width: 50, height: 20),
                ],
              ),
            ),
            
            // List Skeleton
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: 4,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    height: 100,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        // Left
                        SkeletonBox(
                          width: 100,
                          height: 100,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        
                        // Right
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SkeletonBox(width: 120, height: 20),
                                    SizedBox(height: 8),
                                    SkeletonBox(width: 80, height: 14),
                                  ],
                                ),
                                SkeletonBox(width: 100, height: 12),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
