// ============================================================================
// BAIC Architecture - My Vehicles View
// ============================================================================
// 架构规范:
// - ViewModel: 继承 BaicBaseViewModel
// - View: 使用 ViewModelBuilder<T>.reactive() 构建
// - 颜色: 只使用 AppColors.xxx (禁止硬编码)
// - 按钮: 必须使用 BaicBounceButton 包裹
// - 导航: 使用 viewModel.goBack() 而非 context.pop()
// ============================================================================

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'my_vehicles_viewmodel.dart';
import '../../../app/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/components/baic_ui_kit.dart';
import 'package:car_owner_app/core/shared/widgets/optimized_image.dart';
import '../profile/widgets/tire_track_background.dart';

/// [MyVehiclesView] - 我的爱车（车库管理页）
/// 
/// 核心布局：卡片化展示车辆状态（油耗/电量、里程、车牌），并集成解绑防误触交互流程。
class MyVehiclesView extends StackedView<MyVehiclesViewModel> {
  const MyVehiclesView({super.key});

  @override
  Widget builder(BuildContext context, MyVehiclesViewModel viewModel, Widget? child) {
    if (viewModel.isBusy) {
      return _buildLoadingSkeleton();
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              // Header
              _buildHeader(context, viewModel),
              
              // Scrollable Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 40),
                  children: [
                    _buildPageTitle(viewModel),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Active Vehicles
                          ...viewModel.activeVehicles.map((vehicle) => 
                            _buildActiveVehicleCard(context, viewModel, vehicle)
                          ),
                          
                          // Under Review Vehicles
                          ...viewModel.reviewVehicles.map((vehicle) => 
                            _buildReviewVehicleCard(vehicle)
                          ),
                          
                          // Add Vehicle Entry
                          _buildAddVehicleCard(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Long Press Tooltip
          if (viewModel.showUnbindHint)
            _buildLongPressTooltip(),

          // Unbind Dialog
          if (viewModel.showUnbindModal)
            _buildUnbindDialog(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          // Header Skeleton
          Container(
            padding: const EdgeInsets.fromLTRB(20, 54, 20, 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(16))),
                Container(width: 128, height: 24, decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(4))),
                Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(16))),
              ],
            ),
          ),
          
          // Content Skeleton
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(width: 110, height: 70, decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(12))),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(width: double.infinity, height: 20, decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(4))),
                                  const SizedBox(height: 12),
                                  Container(width: 100, height: 16, decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(4))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MyVehiclesViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 54, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BaicBounceButton(
            onPressed: () => viewModel.goBack(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(LucideIcons.arrowLeft, size: 24, color: Color(0xFF111111)),
            ),
          ),
          const Text(
            '我的车辆',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111111),
            ),
          ),
          BaicBounceButton(
            onPressed: () => context.push(AppRoutes.bindVehicle),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(LucideIcons.plus, size: 24, color: Color(0xFF111111)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageTitle(MyVehiclesViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '我的车库',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '管理您的 ${viewModel.totalVehicleCount} 辆北京汽车',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                viewModel.totalMileage,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Oswald',
                  color: Color(0xFF111111),
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'MILEAGE (KM)',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF9CA3AF),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveVehicleCard(BuildContext context, MyVehiclesViewModel viewModel, VehicleInfo vehicle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: AppDimensions.borderRadiusL,
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppDimensions.borderRadiusL,
        child: Stack(
          children: [
            // Subtle Active Glow
            if (vehicle.isPrimary)
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED).withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            
            // Tires track background decoration
            if (vehicle.isPrimary)
               const TireTrackBackground(),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFFF9FAFB))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      vehicle.name,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF111111),
                                      ),
                                    ),
                                  ),
                                  if (vehicle.isPrimary) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF111111),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(LucideIcons.star, size: 8, color: Color(0xFFE5C07B)),
                                          const SizedBox(width: 4),
                                          Text(
                                            '主驾',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFE5C07B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF9FAFB),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: const Color(0xFFF3F4F6)),
                                    ),
                                    child: Text(
                                      vehicle.plateNumber,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Oswald',
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE6FFFA),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(LucideIcons.shieldCheck, size: 12, color: Color(0xFF00B894)),
                                        const SizedBox(width: 4),
                                        Text(
                                          '认证车主',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF00B894),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(LucideIcons.settings, size: 18, color: Color(0xFF9CA3AF)),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Vehicle Image and Stats
                  Row(
                    children: [
                      // Vehicle Image
                      Container(
                        width: 110,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: OptimizedImage(
                            imageUrl: vehicle.imageUrl,
                            width: 100,
                            fit: BoxFit.contain,
                            errorWidget: const Icon(LucideIcons.car, size: 40, color: Color(0xFFD1D5DB)),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 20),
                      
                      // Stats Grid
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '剩余油量',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        vehicle.fuelLevel.toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Oswald',
                                          color: Color(0xFF111111),
                                        ),
                                      ),
                                      const Text(
                                        '%',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '总计里程',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        vehicle.mileageFormatted,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Oswald',
                                          color: Color(0xFF111111),
                                        ),
                                      ),
                                      const Text(
                                        'km',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Action Buttons
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Color(0xFFF9FAFB))),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: BaicBounceButton(
                            onPressed: () => viewModel.handleRemoteControl(vehicle.id),
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFF111111),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  '车辆远程控制',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onLongPressStart: (_) => viewModel.startUnbindTimer(vehicle.id),
                          onLongPressEnd: (_) => viewModel.cancelUnbindTimer(),
                          onLongPressCancel: () => viewModel.cancelUnbindTimer(),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: const Icon(LucideIcons.trash2, size: 20, color: Color(0xFFD1D5DB)),
                          ),
                        ),
                      ],
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

  Widget _buildReviewVehicleCard(VehicleInfo vehicle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: AppDimensions.borderRadiusL,
        border: Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Opacity(
        opacity: 0.6,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            vehicle.plateNumber,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Oswald',
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.clock, size: 12, color: Color(0xFFF59E0B)),
                                const SizedBox(width: 4),
                                Text(
                                  '审核中',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF59E0B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            Row(
              children: [
                Container(
                  width: 110,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Opacity(
                    opacity: 0.3,
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                      child: Center(
                        child: OptimizedImage(
                          imageUrl: vehicle.imageUrl,
                          width: 100,
                          fit: BoxFit.contain,
                          errorWidget: const Icon(LucideIcons.car, size: 40, color: Color(0xFFD1D5DB)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    '车辆绑定审核预计在 24 小时内完成，请耐心等待。',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddVehicleCard(BuildContext context) {
    return BaicBounceButton(
      onPressed: () => context.push(AppRoutes.bindVehicle),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: AppDimensions.borderRadiusL,
          border: Border.all(color: const Color(0xFFE5E7EB), width: 2, style: BorderStyle.none), // Dashed border usually requires CustomPainter in Flutter
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16), // 保持圆形按钮样式
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(LucideIcons.plus, size: 24, color: Color(0xFFD1D5DB)),
            ),
            const SizedBox(height: 12),
            const Text(
              '添加我的车辆',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '认证车主，解锁专属权益',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLongPressTooltip() {
    return Positioned(
      bottom: 112,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.85),
            borderRadius: AppDimensions.borderRadiusFull,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.mousePointer2, size: 16, color: AppColors.warning),
              const SizedBox(width: 8),
              Text(
                '长按按钮 1 秒以发起解绑',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnbindDialog(BuildContext context, MyVehiclesViewModel viewModel) {
    return Positioned.fill(
      child: BaicBounceButton(
        onPressed: () => viewModel.cancelUnbind(),
        child: Container(
          color: AppColors.black.withValues(alpha: 0.6),
          child: Center(
            child: BaicBounceButton(
              onPressed: () {}, // Prevent tap through
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.dangerLight,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Icon(LucideIcons.alertTriangle, size: 32, color: AppColors.danger),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '确认解除绑定？',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '解绑后您将无法使用该车辆的手机远程控制、维保预约等数字化功能。',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Column(
                      children: [
                        BaicBounceButton(
                          onPressed: () => viewModel.confirmUnbind(),
                          child: Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.textPrimary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '确认解除',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        BaicBounceButton(
                          onPressed: () => viewModel.cancelUnbind(),
                          child: Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '暂不解除',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  MyVehiclesViewModel viewModelBuilder(BuildContext context) => MyVehiclesViewModel();

  @override
  void onViewModelReady(MyVehiclesViewModel viewModel) => viewModel.init();
}
