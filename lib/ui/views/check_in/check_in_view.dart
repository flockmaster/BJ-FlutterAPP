import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' hide SkeletonLoader;
import 'package:lucide_icons/lucide_icons.dart';
import 'check_in_viewmodel.dart';
import '../../../core/services/check_in_service.dart';
import '../../../core/theme/app_typography.dart';
import '../../../app/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/components/baic_ui_kit.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/skeleton_loader.dart';

/// 每日签到页面 - 严格遵循 BAIC 架构规范
/// 架构规范: .rules (Stacked MVVM + AppColors + BaicBounceButton)
class CheckInView extends StackedView<CheckInViewModel> {
  const CheckInView({super.key});

  @override
  Widget builder(BuildContext context, CheckInViewModel viewModel, Widget? child) {
    if (viewModel.isBusy) {
      return const _SkeletonView();
    }

    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              // Header Background
              _buildHeader(context, viewModel),
              
              // Main Card (No Overlap)
              Expanded(
                child: _buildMainContent(viewModel),
              ),
            ],
          ),
          
          // Rules Modal - Positioned at the top with higher z-index
          if (viewModel.showRules)
            Positioned.fill(
              child: _buildRulesModal(context, viewModel),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CheckInViewModel viewModel) {
    return Container(
      height: 320,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.textSecondary,
            AppColors.brandDark,
            AppColors.brandDark,
          ],
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?q=80&w=1200&auto=format&fit=crop'),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
          child: Column(
            children: [
              // Nav Bar
              Padding(
                padding: const EdgeInsets.only(top: 54, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BaicBounceButton(
                      onPressed: () => viewModel.goBack(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.bgSurface.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.bgSurface.withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                        child: const Icon(LucideIcons.arrowLeft, color: Colors.white, size: 20),
                      ),
                    ),
                    const Text(
                      '每日签到',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    BaicBounceButton(
                      onPressed: viewModel.toggleRules,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.bgSurface.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.bgSurface.withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                        child: const Icon(LucideIcons.helpCircle, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Points Display - Simple and Clean
              Column(
                children: [
                  Text(
                    '我的积分',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    viewModel.points.toString(),
                    style: AppTypography.dataDisplay(
                      fontSize: 56,
                      color: const Color(0xFFFFD700),
                      letterSpacing: -2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BaicBounceButton(
                    onPressed: () => viewModel.MapsTo(AppRoutes.pointsHistory),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.bgSurface.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.bgSurface.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '积分明细',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(LucideIcons.arrowRight, size: 12, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(CheckInViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Column(
        children: [
          // Check-in Card
          _buildCheckInCard(viewModel),
          
          const SizedBox(height: 20),
          
          // Tasks List
          _buildTasksList(viewModel),
        ],
      ),
    );
  }

  Widget _buildCheckInCard(CheckInViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '已连续签到 ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brandDark,
                          ),
                        ),
                        Text(
                          '${viewModel.consecutiveDays}',
                          style: AppTypography.dataDisplayM.copyWith(
                            color: AppColors.brandOrange,
                          ),
                        ),
                        const Text(
                          ' 天',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brandDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '再签到 4 天可得大额积分礼包',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                LucideIcons.gift,
                size: 32,
                color: AppColors.brandOrange,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Days Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: viewModel.weekDays.map((day) {
              return _buildDayItem(day, viewModel.checkedInToday);
            }).toList(),
          ),
          
          const SizedBox(height: 32),
          
          // Check-in Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: BaicBounceButton(
              onPressed: viewModel.checkedInToday ? null : viewModel.performCheckIn,
              child: Container(
                decoration: BoxDecoration(
                  color: viewModel.checkedInToday 
                      ? AppColors.bgFill 
                      : AppColors.brandDark,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: viewModel.checkedInToday ? [] : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        viewModel.checkedInToday ? '今日已签到' : '立即签到',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: viewModel.checkedInToday 
                              ? AppColors.textTertiary 
                              : Colors.white,
                        ),
                      ),
                      if (!viewModel.checkedInToday) ...[
                        const SizedBox(width: 8),
                        const Icon(LucideIcons.coins, size: 18, color: Color(0xFFFFD700)),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayItem(DayCheckIn day, bool checkedInToday) {
    final isChecked = day.status == CheckInStatus.checked;
    final isToday = day.status == CheckInStatus.today;
    final isTodayChecked = isToday && checkedInToday;
    
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isChecked || isTodayChecked
                ? AppColors.brandOrange
                : isToday
                    ? AppColors.bgSurface
                    : AppColors.bgCanvas,
            shape: BoxShape.circle,
            border: Border.all(
              color: isChecked || isTodayChecked
                  ? AppColors.brandOrange
                  : isToday
                      ? AppColors.brandOrange
                      : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: isChecked || isTodayChecked
                ? const Icon(LucideIcons.check, size: 14, color: Colors.white)
                : Text(
                    '+${day.points}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isToday ? AppColors.brandOrange : AppColors.textTertiary,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day.day,
          style: TextStyle(
            fontSize: 10,
            color: isToday ? AppColors.brandDark : AppColors.textTertiary,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildTasksList(CheckInViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.infoLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  LucideIcons.calendarDays,
                  size: 12,
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '做任务 赚积分',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.brandDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...viewModel.tasks.map((task) => _buildTaskItem(task)),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.bgCanvas,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.brandDark,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        LucideIcons.coins,
                        size: 10,
                        color: AppColors.brandOrange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+${task.reward}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.brandOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: task.completed ? AppColors.bgCanvas : AppColors.bgSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: task.completed ? Colors.transparent : AppColors.brandDark,
                width: 1,
              ),
            ),
            child: Text(
              task.completed ? '已完成' : '去完成',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: task.completed ? AppColors.textTertiary : AppColors.brandDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRulesModal(BuildContext context, CheckInViewModel viewModel) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: viewModel.closeRules,
        child: Container(
          color: Colors.black.withOpacity(0.6),
          child: Center(
            child: GestureDetector(
              onTap: () {}, // Prevent closing when tapping modal
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 40,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '签到规则',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brandDark,
                          ),
                        ),
                        BaicBounceButton(
                          onPressed: viewModel.closeRules,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: AppColors.bgCanvas,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons.x,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: const SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1. 每日签到可获得基础积分奖励，连续签到天数越多，奖励越丰厚。',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '2. 连续签到7天为一个周期，第3天、第7天可获得额外积分宝箱。',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '3. 若签到中断，连续签到天数将重新计算。',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '4. 获得的积分可在积分商城兑换实物礼品、卡券或服务权益。',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '5. 北京汽车保留对签到规则的最终解释权。',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: BaicBounceButton(
                        onPressed: viewModel.closeRules,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.brandDark,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              '我知道了',
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
  CheckInViewModel viewModelBuilder(BuildContext context) => CheckInViewModel();

  @override
  void onViewModelReady(CheckInViewModel viewModel) => viewModel.init();
}

class _SkeletonView extends StatelessWidget {
  const _SkeletonView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SkeletonLoader(
        child: Stack(
          children: [
            // Header Background Skeleton
            Container(
              height: 320,
              color: AppColors.brandDark,
              child: const Column(
                children: [
                  // Nav Skeleton
                  Padding(
                    padding: EdgeInsets.only(top: 54, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SkeletonCircle(size: 40),
                        SkeletonBox(width: 80, height: 24),
                        SkeletonCircle(size: 40),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  // Points Skeleton
                  Column(
                    children: [
                       SkeletonBox(width: 60, height: 16),
                       SizedBox(height: 16),
                       SkeletonBox(width: 120, height: 48),
                       SizedBox(height: 16),
                       SkeletonBox(width: 100, height: 32, borderRadius: BorderRadius.all(Radius.circular(16))),
                    ],
                  ),
                ],
              ),
            ),
            
            // Content Skeleton
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 300, 20, 40),
              child: Column(
                children: [
                  // Check-in Card Skeleton
                  Container(
                    height: 250,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SkeletonBox(width: 150, height: 24),
                                SizedBox(height: 8),
                                SkeletonBox(width: 200, height: 14),
                              ],
                            ),
                            SkeletonCircle(size: 32),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(7, (index) => const SkeletonCircle(size: 36)),
                        ),
                        const Spacer(),
                        const SkeletonBox(width: double.infinity, height: 48, borderRadius: BorderRadius.all(Radius.circular(16))),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Tasks List Skeleton
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const SkeletonBox(width: 100, height: 20),
                        const SizedBox(height: 20),
                        ...List.generate(3, (index) => 
                          const Padding(
                            padding: EdgeInsets.only(bottom: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SkeletonBox(width: 120, height: 16),
                                    SizedBox(height: 8),
                                    SkeletonBox(width: 60, height: 14),
                                  ],
                                ),
                                SkeletonBox(width: 70, height: 28, borderRadius: BorderRadius.all(Radius.circular(14))),
                              ],
                            ),
                          )
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
}
