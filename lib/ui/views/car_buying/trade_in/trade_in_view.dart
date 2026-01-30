import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/skeleton_loader.dart';
import '../../../../core/components/baic_ui_kit.dart';
import 'trade_in_viewmodel.dart';

/// 置换估值页面
class TradeInView extends StackedView<TradeInViewModel> {
  const TradeInView({super.key});

  @override
  TradeInViewModel viewModelBuilder(BuildContext context) => TradeInViewModel();

  @override
  void onViewModelReady(TradeInViewModel viewModel) {
    viewModel.init();
  }

  @override
  Widget builder(
    BuildContext context,
    TradeInViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: viewModel.isBusy
          ? const _SkeletonView()
          : Column(
              children: [
                // 顶部导航栏
                _buildHeader(context),
                // 主体内容
                Expanded(
                  child: viewModel.step == 'form'
                      ? _buildFormView(context, viewModel)
                      : _buildResultView(context, viewModel),
                ),
              ],
            ),
    );
  }

  /// 构建顶部导航栏
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: AppDimensions.spaceM,
        right: AppDimensions.spaceM,
        bottom: AppDimensions.spaceS,
      ),
      decoration: const BoxDecoration(
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
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '置换估值',
              style: AppTypography.headingM,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  /// 构建表单视图
  Widget _buildFormView(BuildContext context, TradeInViewModel viewModel) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spaceM),
      children: [
        // 主卡片
        Container(
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(color: AppColors.bgSurface),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '您的爱车目前价值多少？',
                style: AppTypography.headingL,
              ),
              const SizedBox(height: AppDimensions.spaceL),
              // 品牌选择
              _buildBrandSection(context, viewModel),
              const SizedBox(height: AppDimensions.spaceL),
              // 年份选择
              _buildYearSection(viewModel),
              const SizedBox(height: AppDimensions.spaceL),
              // 里程输入
              _buildMileageSection(viewModel),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spaceL),
        // 估值按钮
        BaicBounceButton(
          onPressed: viewModel.isFormComplete && !viewModel.isEstimating
              ? viewModel.startEstimation
              : null,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: viewModel.isFormComplete && !viewModel.isEstimating
                  ? AppColors.textPrimary
                  : AppColors.textTertiary,
              borderRadius: BorderRadius.circular(28),
              boxShadow: viewModel.isFormComplete && !viewModel.isEstimating
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (viewModel.isEstimating)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.bgSurface,
                      ),
                    ),
                  )
                else
                  const Text(
                    '开始极速估值',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bgSurface,
                    ),
                  ),
                if (!viewModel.isEstimating) ...[
                  const SizedBox(width: AppDimensions.spaceS),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.bgSurface,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 构建品牌选择区域
  Widget _buildBrandSection(BuildContext context, TradeInViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '品牌型号',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceS),
        Wrap(
          spacing: AppDimensions.spaceS,
          runSpacing: AppDimensions.spaceS,
          children: viewModel.brands.map((brand) {
            final isSelected = brand == viewModel.brand;
            return BaicBounceButton(
              onPressed: () => viewModel.setBrand(brand),
              child: Container(
                width: (MediaQuery.of(context).size.width -
                        AppDimensions.spaceM * 2 -
                        AppDimensions.spaceL * 2 -
                        AppDimensions.spaceS * 3) /
                    4,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spaceS,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.textPrimary
                      : const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.textPrimary
                        : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  brand,
                  style: TextStyle(
                    fontSize: 13,
                    color: isSelected
                        ? AppColors.bgSurface
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 构建年份选择区域
  Widget _buildYearSection(TradeInViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '上牌年份',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceS),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: viewModel.years.map((year) {
              final isSelected = year == viewModel.year;
              return Padding(
                padding: const EdgeInsets.only(right: AppDimensions.spaceS),
                child: BaicBounceButton(
                  onPressed: () => viewModel.setYear(year),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceM,
                      vertical: AppDimensions.spaceS,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.bgSurface,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusS),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.divider,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      year,
                      style: AppTypography.dataDisplayS.copyWith(
                        color: isSelected
                            ? AppColors.bgSurface
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// 构建里程输入区域
  Widget _buildMileageSection(TradeInViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '行驶里程 (万公里)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceS),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: viewModel.setMileage,
          decoration: InputDecoration(
            hintText: '0.0',
            filled: true,
            fillColor: const Color(0xFFF5F7FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: const BorderSide(
                color: AppColors.textPrimary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceM,
              vertical: AppDimensions.spaceS + 4,
            ),
          ),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  /// 构建结果视图
  Widget _buildResultView(BuildContext context, TradeInViewModel viewModel) {
    final estimation = viewModel.estimation;
    if (estimation == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spaceM),
      children: [
        // 估值结果卡片
        Container(
          padding: const EdgeInsets.all(AppDimensions.spaceXL),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(color: AppColors.bgSurface),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // 顶部橙色条
              Container(
                height: 8,
                margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
                decoration: BoxDecoration(
                  color: AppColors.brandOrange,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Text(
                '预计置换抵扣金额',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceS),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    '¥',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.brandOrange,
                    ),
                  ),
                  Text(
                    estimation.formattedRange,
                    style: AppTypography.priceMain.copyWith(
                      fontSize: 48,
                      color: AppColors.brandOrange,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceS),
                  const Text(
                    '万',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.brandOrange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceL),
              // 车辆信息
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceM),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(
                    color: const Color(0xFFF0F0F0),
                    width: 1,
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
                            '${estimation.brand} 热门车型',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                          ),
                          const SizedBox(height: AppDimensions.spaceS),
                          Text(
                            '${estimation.year}年 · ${estimation.mileage}万公里',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    BaicBounceButton(
                      onPressed: viewModel.resetEstimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spaceS,
                          vertical: AppDimensions.spaceS + 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusXS),
                        ),
                        child: const Text(
                          '重测',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brandOrange,
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
        const SizedBox(height: AppDimensions.spaceL),
        // 权益卡片
        Container(
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      size: 20,
                      color: AppColors.brandOrange,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceS),
                  const Text(
                    '本月置换权益',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bgSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceM),
              _buildBenefitItem(
                '最高享 12,000 元现金直补',
              ),
              const SizedBox(height: AppDimensions.spaceM),
              _buildBenefitItem(
                '免费官方上门检测，10分钟出价',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXL),
        // 预约按钮
        BaicBounceButton(
          onPressed: viewModel.scheduleAppointment,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.brandOrange,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandOrange.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              '立即预约高价卖车',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.bgSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建权益项
  Widget _buildBenefitItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle,
          size: 18,
          color: AppColors.brandOrange,
        ),
        const SizedBox(width: AppDimensions.spaceS),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.bgSurface,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

/// 骨架屏
class _SkeletonView extends StatelessWidget {
  const _SkeletonView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceM),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 60),
          SkeletonBox(
            height: 400,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          const SizedBox(height: AppDimensions.spaceL),
          SkeletonBox(
            height: 56,
            borderRadius: BorderRadius.circular(28),
          ),
        ],
      ),
    );
  }
}
