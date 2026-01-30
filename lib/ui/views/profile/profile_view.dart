import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/components/baic_ui_kit.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/profile_skeleton.dart';
import 'profile_viewmodel.dart';
import 'package:car_owner_app/core/shared/widgets/optimized_image.dart';
import '../profile_detail/medal_widget.dart';
import 'widgets/tire_track_background.dart';

/// [ProfileView] - 个人中心（我的）主页面入口
/// 
/// 核心特性：
/// 1. 响应式布局：根据 ViewModel 数据实时驱动 UI 渲染。
/// 2. 状态分级展示：区分未登录态快捷引导与已登录态个人资料展示。
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) {
        return ProfilePageView(viewModel: viewModel);
      },
    );
  }
}

class ProfilePageView extends StatefulWidget {
  final ProfileViewModel viewModel;
  
  const ProfilePageView({super.key, required this.viewModel});

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  final ScrollController _scrollController = ScrollController();
  Timer? _msgTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _msgTimer?.cancel();
    super.dispose();
  }

  /// 滚动监听：
  /// 仅在 CustomScrollView 滚动时计算顶部导航栏容器的背景透明度，
  /// 实现沉浸式背景向实色背景的平滑过渡效果。
  void _onScroll() {
    final scrollTop = _scrollController.offset;
    final opacity = (scrollTop / 100).clamp(0.0, 1.0);
    if (opacity != widget.viewModel.headerOpacity) {
      widget.viewModel.updateHeaderOpacity(opacity);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.viewModel.isBusy) {
      return Scaffold(
        backgroundColor: AppColors.bgCanvas,
        body: ProfileSkeleton(),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Stack(
        children: [
          EasyRefresh(
            onRefresh: widget.viewModel.refresh,
            header: const ClassicHeader(
              dragText: '下拉刷新',
              armedText: '释放刷新',
              readyText: '正在刷新...',
              processingText: '正在刷新...',
              processedText: '刷新完成',
              noMoreText: '没有更多',
              failedText: '刷新失败',
              messageText: '上次更新于 %T',
              textStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                 SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 110, 20, 100),
                    child: Column(
                      children: [
                        _buildUserProfile(),
                        const SizedBox(height: 32),
                        _buildSocialStats(),
                        const SizedBox(height: 32),
                        _buildNotificationCard(),
                        const SizedBox(height: 16),
                        _buildMyVehicleCard(),
                        const SizedBox(height: 16),
                        _buildAssetsGrid(),
                        const SizedBox(height: 16),
                        _buildInviteCard(),
                        const SizedBox(height: 24),
                        _buildListMenu(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100, 
              padding: const EdgeInsets.only(top: 40, right: 20),
              decoration: BoxDecoration(
                color: AppColors.bgSurface.withOpacity(widget.viewModel.headerOpacity),
                boxShadow: widget.viewModel.headerOpacity > 0.9 
                  ? [BoxShadow(color: AppColors.shadowLight, blurRadius: 2, offset: const Offset(0, 1))]
                  : [],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BaicBounceButton(
                    onPressed: widget.viewModel.navigateToScanner,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.5)),
                      ),
                      child: const Icon(LucideIcons.scanLine, color: Color(0xFF111827), size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  BaicBounceButton(
                    onPressed: widget.viewModel.navigateToMyQRCode,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.5)),
                      ),
                      child: const Icon(LucideIcons.qrCode, color: Color(0xFF111827), size: 20),
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
  Widget _buildUserProfile() {
    if (!widget.viewModel.isLoggedIn) {
      return Row(
        children: [
          GestureDetector(
            onTap: widget.viewModel.navigateToLogin,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE5E7EB),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(LucideIcons.userCircle, size: 48, color: Color(0xFF9CA3AF)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: widget.viewModel.navigateToLogin,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '登录 / 注册',
                        style: AppTypography.headingL.copyWith(
                          color: AppColors.textTitle,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(LucideIcons.chevronRight, size: 18, color: Color(0xFFD1D5DB)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '登录解锁更多精彩内容',
                    style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          _buildCheckInButton(),
        ],
      );
    }

    return Row(
      children: [
        _buildAvatarWithMedal(),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: widget.viewModel.navigateToProfileDetail,
                child: Row(
                  children: [
                    Text(
                      widget.viewModel.displayName,
                      style: AppTypography.headingL.copyWith(
                        color: AppColors.textTitle,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(LucideIcons.chevronRight, size: 18, color: Color(0xFFD1D5DB)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary, // #374151
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.shieldCheck, size: 10, color: AppColors.brandGold),
                        const SizedBox(width: 4),
                        Text(
                          widget.viewModel.userProfile?.hasVehicle == true ? '认证车主' : '普通用户',
                          style: AppTypography.captionSecondary.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brandGold, // #D4B08C
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                    ),
                    child: Text(
                      'LV.${widget.viewModel.userProfile?.vipLevel ?? 0}',
                      style: AppTypography.captionSecondary.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildCheckInButton(),
      ],
    );
  }

  Widget _buildCheckInButton() {
    return BaicBounceButton(
      onPressed: widget.viewModel.isLoggedIn 
          ? widget.viewModel.navigateToCheckIn 
          : widget.viewModel.navigateToLogin,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.calendarCheck, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              '签到',
              style: AppTypography.label.copyWith(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarWithMedal() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipOval(
            child: OptimizedImage(
              imageUrl: widget.viewModel.avatarUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (widget.viewModel.wornMedalId != null)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: MedalWidget(
                id: widget.viewModel.wornMedalId!,
                size: 22,
              ),
            ),
          ),
      ],
    );
  }

  /// 构建用户状态统计行 (关注/粉丝/动态/赞)
  Widget _buildSocialStats() {
    final isLoggedIn = widget.viewModel.isLoggedIn;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSocialStatItem('关注', isLoggedIn ? widget.viewModel.followingCount : '-', widget.viewModel.handleFollowingTap),
          _buildSocialStatItem('粉丝', isLoggedIn ? widget.viewModel.followersCount : '-', widget.viewModel.handleFollowersTap),
          _buildSocialStatItem('动态', isLoggedIn ? widget.viewModel.postsCount : '-', widget.viewModel.handlePostsTap),
          _buildSocialStatItem('赞过', isLoggedIn ? widget.viewModel.likesCount : '-', widget.viewModel.handleFavoritesTap),
        ],
      ),
    );
  }

  Widget _buildSocialStatItem(String label, String value, VoidCallback onTap) {
    return BaicBounceButton(
      onPressed: onTap,
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Oswald',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              height: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold, // Bold 粗细
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建消息通知卡片 (集成 AnimatedSwitcher 的竖向跑马灯)
  Widget _buildNotificationCard() {
    return BaicBounceButton(
      onPressed: widget.viewModel.navigateToMessageCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(16), // 对标：20 -> 16
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.bgFill.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.bell, size: 16, color: AppColors.textTitle),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  widget.viewModel.currentMessage,
                  key: ValueKey<int>(widget.viewModel.currentMessageIndex),
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 14,
                    fontWeight: FontWeight.w600, // 字重加粗一级：w500 -> w600
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (widget.viewModel.messageCount > 0)
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2), // 向上补偿：数字偏下时增加底部内边距向上顶
                    child: Text(
                      widget.viewModel.messageCount.toString(),
                      style: AppTypography.dataDisplayXS.copyWith(
                        color: AppColors.white,
                        fontSize: 10,
                        height: 1.0, // 恢复紧凑行高，由 Padding 控制绝对位置
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 4),
            const Icon(LucideIcons.chevronRight, size: 14, color: AppColors.textDisabled),
          ],
        ),
      ),
    );
  }

  /// 构建“我的车库”卡片 (含登录态验证与空状态提示)
  Widget _buildMyVehicleCard() {
    final isLoggedIn = widget.viewModel.isLoggedIn;
    final hasVehicle = widget.viewModel.userProfile?.hasVehicle == true;

    return BaicBounceButton(
      onPressed: isLoggedIn ? widget.viewModel.navigateToMyVehicles : widget.viewModel.navigateToLogin,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(16),
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
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              const TireTrackBackground(),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '我的车库',
                          style: TextStyle(
                            color: Color(0xFF111111),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '查看全部',
                              style: TextStyle(
                                color: const Color(0xFF6B7280),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(LucideIcons.chevronRight, size: 14, color: Color(0xFFD1D5DB)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (isLoggedIn && hasVehicle)
                      Row(
                        children: [
                          Container(
                            width: 120,
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFFF5F7FA),
                            ),
                            child: Center(
                              child: OptimizedImage(
                                imageUrl: 'https://p.sda1.dev/29/0c0cc4449ea2a1074412f6052330e4c4/63999cc7e598e7dc1e84445be0ba70eb-Photoroom.png',
                                width: 100,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.viewModel.vehicleName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF111111),
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F7FA),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        widget.viewModel.vehiclePlate,
                                        style: const TextStyle(
                                          color: Color(0xFF6B7280),
                                          fontFamily: 'Oswald',
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF0FDF4),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(LucideIcons.shieldCheck, size: 12, color: Color(0xFF22C55E)),
                                          const SizedBox(width: 4),
                                          const Text(
                                            '在线',
                                            style: TextStyle(
                                              color: Color(0xFF22C55E),
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
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
                      )
                    else
                      Column(
                        children: [
                          Text(
                            isLoggedIn ? '您尚未绑定车辆，立即绑定开启智能车联' : '登录后管理爱车，查看车辆状态',
                            style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: Text(
                              isLoggedIn ? '立即绑定' : '立即登录',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
      ),
    );
  }

  /// 构建资产信息网格 (订单、积分、卡券、任务)
  Widget _buildAssetsGrid() {
    final isLoggedIn = widget.viewModel.isLoggedIn;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: AppDimensions.borderRadiusL, 
        border: Border.all(color: const Color(0xFFF9FAFB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildAssetItem(LucideIcons.shoppingBag, '我的订单', 'orders'),
          _buildAssetItem(LucideIcons.coins, '可用积分', 'points'),
          _buildAssetItem(LucideIcons.ticket, '优惠券', 'coupons'),
          _buildAssetItem(LucideIcons.clipboardList, '任务中心', 'tasks'),
        ],
      ),
    );
  }

  Widget _buildAssetItem(IconData icon, String label, String assetType, {String? sub}) {
    return BaicBounceButton(
      onPressed: () => widget.viewModel.handleAssetTap(assetType),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F7FA),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: const Color(0xFF111827)),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF111111),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (sub != null) ...[
            const SizedBox(height: 2),
            Text(
              sub,
              style: const TextStyle(
                color: Color(0xFFFF6B00),
                fontSize: 10,
                fontFamily: 'Oswald',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInviteCard() {
    return BaicBounceButton(
      onPressed: widget.viewModel.navigateToInviteFriends,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: AppDimensions.borderRadiusL,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: AppDimensions.borderRadiusL,
          child: Stack(
            fit: StackFit.expand,
            children: [
              OptimizedImage(
                imageUrl: 'https://youke3.picui.cn/s1/2026/01/07/695dfffc2e905.jpg',
                fit: BoxFit.cover,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '无兄弟，不越野',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '速速邀请兄弟入伙！',
                            style: TextStyle(
                              color: AppColors.brandOrange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(LucideIcons.chevronRight, size: 14, color: AppColors.brandOrange),
                        ],
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

  Widget _buildListMenu() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: AppDimensions.borderRadiusL,
        border: Border.all(color: const Color(0xFFF9FAFB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildListItem(LucideIcons.headphones, '专属在线客服', 'customer_service'),
          _buildListItem(LucideIcons.helpCircle, '帮助与反馈', 'help_center'),
          _buildListItem(LucideIcons.settings, '设置', 'settings'),
        ],
      ),
    );
  }

  Widget _buildListItem(IconData icon, String label, String menuType) {
    return BaicBounceButton(
      onPressed: () => widget.viewModel.handleMenuTap(menuType),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppColors.textTitle.withOpacity(0.9)),
                const SizedBox(width: 14),
                Text(
                  label,
                  style: AppTypography.bodyPrimary.copyWith(
                    color: AppColors.textTitle,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFFE5E7EB)),
          ],
        ),
      ),
    );
  }

}
