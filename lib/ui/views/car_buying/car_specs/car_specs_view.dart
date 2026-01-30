import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../../core/models/car_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/components/baic_ui_kit.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/skeleton_loader.dart';
import 'car_specs_viewmodel.dart';

/// 参数配置页面
class CarSpecsView extends StackedView<CarSpecsViewModel> {
  final CarModel car;

  const CarSpecsView({
    super.key,
    required this.car,
  });

  @override
  CarSpecsViewModel viewModelBuilder(BuildContext context) =>
      CarSpecsViewModel(car);

  @override
  void onViewModelReady(CarSpecsViewModel viewModel) {
    viewModel.init();
  }

  @override
  Widget builder(
    BuildContext context,
    CarSpecsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: viewModel.isBusy
          ? const _SkeletonView()
          : Column(
              children: [
                // 顶部导航栏
                _buildHeader(context, viewModel),
                // 主体内容
                Expanded(
                  child: Row(
                    children: [
                      // 左侧分组导航
                      _buildGroupNav(viewModel),
                      // 右侧参数列表
                      Expanded(
                        child: _buildSpecsList(viewModel),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  /// 构建顶部导航栏
  Widget _buildHeader(BuildContext context, CarSpecsViewModel viewModel) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: AppDimensions.spaceM,
        right: AppDimensions.spaceM,
        bottom: AppDimensions.spaceS,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          BaicBounceButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '参数配置',
              style: AppTypography.headingM,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  /// 构建左侧分组导航
  Widget _buildGroupNav(CarSpecsViewModel viewModel) {
    return Container(
      width: 90,
      color: const Color(0xFFF5F7FA),
      child: ListView.builder(
        itemCount: viewModel.groups.length,
        itemBuilder: (context, index) {
          final group = viewModel.groups[index];
          final isActive = group == viewModel.activeGroup;

          return BaicBounceButton(
            onPressed: () => viewModel.setActiveGroup(group),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: isActive ? AppColors.bgSurface : Colors.transparent,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      group,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                        color: isActive
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  if (isActive)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.textPrimary,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(2),
                              bottomRight: Radius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建右侧参数列表
  Widget _buildSpecsList(CarSpecsViewModel viewModel) {
    return Container(
      color: AppColors.bgSurface,
      child: ListView(
        padding: EdgeInsets.all(AppDimensions.spaceM),
        children: [
          // 标题区域
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${viewModel.activeGroup}核心参数',
                style: AppTypography.headingM,
              ),
              Text(
                'SPECIFICATIONS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.divider,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spaceL),
          // 参数列表容器
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: const Color(0xFFF0F0F0),
                width: 1,
              ),
            ),
            child: Column(
              children: List.generate(
                viewModel.currentSpecs.length,
                (index) {
                  final spec = viewModel.currentSpecs[index];
                  final isLast = index == viewModel.currentSpecs.length - 1;

                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceM,
                      vertical: AppDimensions.spaceM,
                    ),
                    decoration: BoxDecoration(
                      border: isLast
                          ? null
                          : Border(
                              bottom: BorderSide(
                                color: AppColors.divider.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          spec.label,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          spec.value,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 骨架屏
class _SkeletonView extends StatelessWidget {
  const _SkeletonView();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 左侧导航骨架
        Container(
          width: 90,
          color: const Color(0xFFF5F7FA),
          child: Column(
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SkeletonBox(
                  width: 40,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        // 右侧内容骨架
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(
                  width: 150,
                  height: 24,
                  borderRadius: BorderRadius.circular(4),
                ),
                SizedBox(height: AppDimensions.spaceL),
                ...List.generate(
                  5,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: AppDimensions.spaceM),
                    child: SkeletonBox(
                      height: 50,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
