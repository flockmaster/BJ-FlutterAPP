import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../optimized_image.dart';
import 'package:car_owner_app/core/models/service_models.dart';
import 'package:car_owner_app/core/theme/app_colors.dart';
import 'package:car_owner_app/core/theme/app_typography.dart';
import 'package:car_owner_app/core/theme/app_dimensions.dart';
import 'package:car_owner_app/ui/views/profile/widgets/tire_track_background.dart';

/// 车辆信息卡片组件
class VehicleCard extends StatelessWidget {
  final VehicleInfo? vehicleInfo;
  final bool isExpanded;
  final bool isLoggedIn;
  final VoidCallback? onToggle;
  final VoidCallback? onLoginTap;

  const VehicleCard({
    super.key,
    this.vehicleInfo,
    this.isExpanded = false,
    this.isLoggedIn = true,
    this.onToggle,
    this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    final vehicle = vehicleInfo ?? const VehicleInfo(
      id: 'v001',
      name: '北京BJ40 PLUS',
      plateNumber: '京A·12345',
      imageUrl: 'https://p.sda1.dev/29/0c0cc4449ea2a1074412f6052330e4c4/63999cc7e598e7dc1e84445be0ba70eb-Photoroom.png',
      mileage: 8521,
      nextMaintenanceKm: 2000,
      lastMaintenanceDate: '2024.06.15',
    );

    return GestureDetector(
      onTap: isLoggedIn ? onToggle : onLoginTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white),
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
          children: [
            // 背景胎印
            const TireTrackBackground(),

            if (isLoggedIn)
              Column(
                children: [
                  // 主显示区域（常驻）
                  _buildMainContent(vehicle),
                  
                  // 展开内容区域
                  _buildCollapsibleContent(vehicle),

                  // 底部展开指示器
                  _buildExpansionIndicator(),
                ],
              )
            else
              _buildLoggedOutContent(),

            // 车辆图片（绝对定位，支持动画）
            if (isLoggedIn)
              _buildAnimatedCarImage(vehicle.imageUrl)
            else
              Positioned(
                right: -20,
                top: 40,
                width: 180,
                child: OptimizedImage(
                  imageUrl: vehicle.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoggedOutContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我的车库',
            style: TextStyle(
              color: Color(0xFF111111),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            '登录后管理爱车\n查看车辆实时状态',
            style: TextStyle(
              color: Color(0xFF111111),
              fontSize: 18,
              fontWeight: FontWeight.w900,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '立即登录',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildMainContent(VehicleInfo vehicle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0), // 移除底部内边距，改由间距控制
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 头部信息
                // 头部信息
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: vehicle.name.substring(0, 2), // "北京"
                        style: const TextStyle(
                          fontFamily: 'PingFang SC', // 核心：使用刚才注册的成功字体
                          fontSize: 22,
                          fontWeight: FontWeight.w900, // 核心：使用最重的权重
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: vehicle.name.substring(2), // "BJ40 PLUS"
                        style: AppTypography.headingL.oswald.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w700, // Oswald 700 已经足够匹配
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.bgCanvas,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.bgFill),
                      ),
                      child: Text(
                        vehicle.plateNumber,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textPrimary, // 改为 textPrimary 增加识别度，原型中对应的 bg-[#F5F7FA] 背景上文字较深
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w600, // 降级 w900 -> w600
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6FFFA),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.shieldCheck, size: 10, color: Color(0xFF00B894)),
                          const SizedBox(width: 4),
                          Text(
                            vehicle.healthStatus,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF00B894),
                              fontWeight: FontWeight.w700, // 降级 w900 -> w700
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // 从 24 缩小到 20

                // 保养进度
                const Text(
                  '距离下次保养',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary, // textTertiary -> textSecondary，解决看着太浅的问题
                    fontWeight: FontWeight.w700, // w900 -> w700
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                      Text(
                        _formatNumber(vehicle.nextMaintenanceKm),
                        style: AppTypography.dataDisplayXL.copyWith(
                          fontSize: 36,
                          color: AppColors.brandDark,
                        ),
                      ),
                    const SizedBox(width: 4),
                    const Text(
                      'km',
                      style: TextStyle(
                        fontSize: 14, 
                        color: AppColors.textSecondary, // textTertiary -> textSecondary
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // 进度条
                SizedBox(
                  width: 140,
                  height: 6,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.bgFill,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.2, // Mock 20%
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00B894), Color(0xFF00A884)],
                            ),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00B894).withOpacity(0.3),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 上次维保
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFF9FAFB)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.clock, size: 10, color: AppColors.textSecondary), // textTertiary -> textSecondary
                      const SizedBox(width: 6),
                      Text(
                        '上次维保: ${vehicle.lastMaintenanceDate}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary, // textTertiary -> textSecondary
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w500, // bold -> w500 还原原型 medium 感
                        ),
                      ),
                    ],
                  ),
                ),
                // 移除此处额外的 SizedBox，减少间距
              ],
            ),
          ),
          const Spacer(flex: 4),
        ],
      ),
    );
  }

  Widget _buildCollapsibleContent(VehicleInfo vehicle) {
    return ClipRect(
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        heightFactor: isExpanded ? 1.0 : 0.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
              const SizedBox(height: 16), // 缩小此处间距 (原来24)
              
              // 基础信息行
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF3F4F6)),
                ),
                child: Row(
                  children: [
                    _buildDetailItem('总里程', '${_formatNumber(vehicle.mileage)} km'),
                    Container(width: 1, height: 24, color: AppColors.borderPrimary),
                    _buildDetailItem('剩余流量', '${vehicle.dataRemaining} GB'),
                    Container(width: 1, height: 24, color: AppColors.borderPrimary),
                    _buildDetailItem('保险到期', vehicle.insuranceExpiry),
                  ],
                ),
              ),
              const SizedBox(height: 20), // 缩小此处间距 (原来24)

              // 功能网格
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 16, // 缩小行间距 (原来24)
                crossAxisSpacing: 8,
                childAspectRatio: 0.9, // 调整宽高比使布局更紧凑
                padding: EdgeInsets.zero,
                children: const [
                  _VehicleFuncIcon(icon: LucideIcons.activity, label: '用车报告'),
                  _VehicleFuncIcon(icon: LucideIcons.history, label: '维保记录'),
                  _VehicleFuncIcon(icon: LucideIcons.bookOpen, label: '用车手册'),
                  _VehicleFuncIcon(icon: LucideIcons.alertTriangle, label: '违章查询'),
                  _VehicleFuncIcon(icon: LucideIcons.fileText, label: '保险单据'),
                  _VehicleFuncIcon(icon: LucideIcons.gauge, label: '油耗统计'),
                  _VehicleFuncIcon(icon: LucideIcons.smartphone, label: '流量充值'),
                  _VehicleFuncIcon(icon: LucideIcons.settings, label: '车辆设置'),
                ],
              ),
              const SizedBox(height: 8), // 底部留白减少
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textTertiary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF111111),
              fontWeight: FontWeight.w900,
              fontFamily: 'Oswald',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionIndicator() {
    return _BouncingIndicator(isExpanded: isExpanded);
  }

  Widget _buildAnimatedCarImage(String imageUrl) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      right: -32,
      top: 65, // 固定在顶部附近，与“距离下次保养”对齐
      width: 210,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: isExpanded ? 0.3 : 1.0, // 展开时稍微淡化，避免遮挡功能区
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: isExpanded ? 4.0 : 0.0, // 展开时适度模糊
            sigmaY: isExpanded ? 4.0 : 0.0,
          ),
          child: OptimizedImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

class _BouncingIndicator extends StatefulWidget {
  final bool isExpanded;

  const _BouncingIndicator({required this.isExpanded});

  @override
  State<_BouncingIndicator> createState() => _BouncingIndicatorState();
}

class _BouncingIndicatorState extends State<_BouncingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -6.0).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 50),
    ]).animate(_controller);

    if (!widget.isExpanded) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant _BouncingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.stop();
        _controller.reset();
      } else {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, widget.isExpanded ? 0 : _animation.value),
              child: child,
            );
          },
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 500),
            turns: widget.isExpanded ? 0.5 : 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: widget.isExpanded ? const Color(0xFFF3F4F6) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF0F0F0).withOpacity(0.5)),
                boxShadow: [
                  if (!widget.isExpanded)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Icon(
                LucideIcons.chevronDown,
                size: 16,
                color: widget.isExpanded ? const Color(0xFF4B5563) : const Color(0xFF9CA3AF),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VehicleFuncIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _VehicleFuncIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Color(0xFFF5F7FA),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF111111)),
        ),
        const SizedBox(height: 4), // 缩小此处间距 (原来8)
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF111111),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
