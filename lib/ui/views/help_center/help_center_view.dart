import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../app/routes.dart';
import 'help_center_viewmodel.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/components/baic_ui_kit.dart';

/// 帮助中心页面
/// 
/// 遵循 BAIC V4.0 开发规范：
/// - 架构：Stacked MVVM
/// - 样式：全面对齐 AppColors & AppTypography
/// - UI 规范：Radius-M (16px) & Radius-L (24px)
/// - 交互：BaicBounceButton 全覆盖
class HelpCenterView extends StackedView<HelpCenterViewModel> {
  const HelpCenterView({super.key});

  @override
  Widget builder(BuildContext context, HelpCenterViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Column(
        children: [
          _buildHeader(context, viewModel),
          Expanded(
            child: viewModel.isBusy
                ? const Center(child: CircularProgressIndicator(color: AppColors.brandOrange))
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _buildModelSelector(viewModel),
                        _buildSearchBar(viewModel),
                        _buildLifecycleStages(viewModel),
                        _buildFAQList(viewModel),
                        const SizedBox(height: 160),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: _buildContactBar(context, viewModel),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader(BuildContext context, HelpCenterViewModel viewModel) {
    return Container(
      color: AppColors.bgCanvas,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BaicBounceButton(
                onPressed: () => viewModel.goBack(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.arrowLeft,
                    size: 24,
                    color: AppColors.brandBlack,
                  ),
                ),
              ),
              Text(
                '帮助中心',
                style: AppTypography.headingS.copyWith(
                  color: AppColors.brandBlack,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModelSelector(HelpCenterViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          children: viewModel.carModels.asMap().entries.map((entry) {
            final index = entry.key;
            final car = entry.value;
            final isSelected = viewModel.selectedModel == car.id;
            
            return Padding(
              padding: EdgeInsets.only(
                right: index < viewModel.carModels.length - 1 ? 32 : 0,
              ),
              child: BaicBounceButton(
                onPressed: () => viewModel.selectModel(car.id),
                child: Column(
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: isSelected ? 1.0 : 0.3,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 400),
                        scale: isSelected ? 1.1 : 0.9,
                        child: Image.network(
                          car.backgroundImage,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: AppTypography.captionSecondary.copyWith(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? AppColors.brandBlack : AppColors.textTertiary,
                            fontSize: 12,
                          ),
                          child: Text(car.name),
                        ),
                        const SizedBox(height: 6),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 2,
                          width: isSelected ? 12 : 0,
                          decoration: BoxDecoration(
                            color: AppColors.brandOrange,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSearchBar(HelpCenterViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 12),
              child: Icon(
                LucideIcons.search,
                size: 18,
                color: AppColors.textTertiary,
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: viewModel.searchPlaceholder,
                  hintStyle: AppTypography.bodySecondary.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: AppTypography.bodySecondary.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLifecycleStages(HelpCenterViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: viewModel.lifecycleStages.map((stage) {
          final isActive = viewModel.activeStage == stage.id;
          IconData icon;
          
          switch (stage.id) {
            case 'buy': icon = LucideIcons.search; break;
            case 'delivery': icon = LucideIcons.truck; break;
            case 'use': icon = LucideIcons.bookOpen; break;
            case 'service': icon = LucideIcons.wrench; break;
            default: icon = LucideIcons.helpCircle;
          }
          
          return BaicBounceButton(
            onPressed: () => viewModel.selectStage(stage.id),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.brandBlack : AppColors.bgSurface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: isActive 
                            ? AppColors.brandBlack.withOpacity(0.15) 
                            : AppColors.shadowLight,
                        blurRadius: isActive ? 16 : 8,
                        offset: Offset(0, isActive ? 8 : 2),
                      ),
                    ],
                  ),
                  transform: Matrix4.translationValues(0, isActive ? -4 : 0, 0),
                  child: Icon(
                    icon,
                    size: 24,
                    color: isActive ? AppColors.textInverse : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  stage.label,
                  style: AppTypography.captionSecondary.copyWith(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? AppColors.brandBlack : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFAQList(HelpCenterViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.brandOrange,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${viewModel.currentStageLabel}常见问题',
                  style: AppTypography.headingS.copyWith(color: AppColors.brandBlack),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: viewModel.currentFAQs.asMap().entries.map((entry) {
                final index = entry.key;
                final question = entry.value;
                final isLast = index == viewModel.currentFAQs.length - 1;
                
                return Column(
                  children: [
                    BaicBounceButton(
                      onPressed: () => viewModel.handleFAQTap(question),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                question,
                                style: AppTypography.bodySecondary.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              LucideIcons.chevronRight,
                              size: 16,
                              color: AppColors.textDisabled,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!isLast)
                      const Divider(
                        height: 1,
                        color: AppColors.divider,
                        indent: 20,
                        endIndent: 20,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactBar(BuildContext context, HelpCenterViewModel viewModel) {
    return BaicBounceButton(
      onPressed: () => viewModel.MapsTo(AppRoutes.customerService),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.brandBlack,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandBlack.withOpacity(0.2),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Subtle Gradient for depth
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.bgSurface.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.headphones,
                      size: 22,
                      color: AppColors.textInverse,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '寻求人工帮助',
                          style: AppTypography.bodyPrimary.copyWith(
                            color: AppColors.textInverse,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'PROFESSIONAL EXPERT',
                          style: AppTypography.captionSecondary.copyWith(
                            color: AppColors.textInverse.withOpacity(0.4),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.brandOrange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '立即咨询',
                          style: AppTypography.label.copyWith(
                            color: AppColors.textInverse,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          LucideIcons.chevronRight,
                          size: 14,
                          color: AppColors.textInverse,
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

  @override
  HelpCenterViewModel viewModelBuilder(BuildContext context) => HelpCenterViewModel();

  @override
  void onViewModelReady(HelpCenterViewModel viewModel) => viewModel.init();
}
