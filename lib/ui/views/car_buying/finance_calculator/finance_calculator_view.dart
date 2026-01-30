import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../../core/models/car_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/components/baic_ui_kit.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/skeleton_loader.dart';
import 'finance_calculator_viewmodel.dart';

/// 金融计算器页面
class FinanceCalculatorView extends StackedView<FinanceCalculatorViewModel> {
  final CarModel car;

  const FinanceCalculatorView({
    super.key,
    required this.car,
  });

  @override
  FinanceCalculatorViewModel viewModelBuilder(BuildContext context) =>
      FinanceCalculatorViewModel(car);

  @override
  void onViewModelReady(FinanceCalculatorViewModel viewModel) {
    viewModel.init();
  }

  @override
  Widget builder(
    BuildContext context,
    FinanceCalculatorViewModel viewModel,
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
                  child: ListView(
                    padding: EdgeInsets.only(
                      bottom: AppDimensions.spaceXL * 2,
                    ),
                    children: [
                      // 月供结果卡片
                      _buildResultCard(viewModel),
                      SizedBox(height: AppDimensions.spaceM),
                      // 首付比例设置
                      _buildDownPaymentCard(viewModel),
                      SizedBox(height: AppDimensions.spaceM),
                      // 分期期限设置
                      _buildTermCard(context, viewModel),
                    ],
                  ),
                ),
                // 底部按钮
                _buildBottomButton(context, viewModel),
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
              width: 36,
              height: 36,
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
              '金融计算器',
              style: AppTypography.headingM,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  /// 构建月供结果卡片
  Widget _buildResultCard(FinanceCalculatorViewModel viewModel) {
    final calc = viewModel.calculation;

    return Container(
      margin: EdgeInsets.all(AppDimensions.spaceM),
      padding: EdgeInsets.all(AppDimensions.spaceL),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 月供信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '预估月供 (${calc.term}期)',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppDimensions.spaceS),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '¥',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brandOrange,
                          ),
                        ),
                        Text(
                          calc.monthlyPayment.round().toString(),
                          style: AppTypography.priceMain.copyWith(
                            fontSize: 40,
                            color: AppColors.brandOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // 饼图指示器
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF5F7FA),
                    width: 6,
                  ),
                  gradient: SweepGradient(
                    startAngle: 0,
                    endAngle: 6.28 * (1 - viewModel.downPaymentRatio),
                    colors: [
                      AppColors.brandOrange,
                      AppColors.brandOrange,
                      AppColors.textPrimary,
                      AppColors.textPrimary,
                    ],
                    stops: [
                      0,
                      1 - viewModel.downPaymentRatio,
                      1 - viewModel.downPaymentRatio,
                      1,
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.pie_chart_outline,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spaceM),
          // 详细信息
          Container(
            padding: EdgeInsets.all(AppDimensions.spaceM),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: const Color(0xFFF0F0F0),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    '首付金额',
                    '¥${calc.downPayment.toStringAsFixed(0)}',
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    '贷款总额',
                    '¥${calc.loanAmount.toStringAsFixed(0)}',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.spaceS),
          Container(
            padding: EdgeInsets.all(AppDimensions.spaceM),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: const Color(0xFFF0F0F0),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    '利息总额',
                    '¥${calc.totalInterest.round().toStringAsFixed(0)}',
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    '购车总价',
                    '¥${calc.totalPrice.toStringAsFixed(0)}',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建信息项
  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppDimensions.spaceS),
        Text(
          value,
          style: AppTypography.dataDisplayS,
        ),
      ],
    );
  }

  /// 构建首付比例卡片
  Widget _buildDownPaymentCard(FinanceCalculatorViewModel viewModel) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.spaceM),
      padding: EdgeInsets.all(AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '首付比例',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
              ),
              Text(
                '${(viewModel.downPaymentRatio * 100).round()}%',
                style: AppTypography.dataDisplayS.copyWith(
                  color: AppColors.brandOrange,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spaceM),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.textPrimary,
              inactiveTrackColor: const Color(0xFFE5E7EB),
              thumbColor: AppColors.textPrimary,
              overlayColor: AppColors.textPrimary.withOpacity(0.1),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: viewModel.downPaymentRatio,
              min: 0.1,
              max: 0.9,
              divisions: 8,
              onChanged: (value) => viewModel.setDownPaymentRatio(value),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '10%',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '50%',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '90%',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建分期期限卡片
  Widget _buildTermCard(BuildContext context, FinanceCalculatorViewModel viewModel) {
    final terms = [12, 24, 36, 48, 60];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.spaceM),
      padding: EdgeInsets.all(AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '分期期限',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
              ),
              Text(
                '${viewModel.term}期',
                style: AppTypography.dataDisplayS.copyWith(
                  color: AppColors.brandOrange,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spaceM),
          Wrap(
            spacing: AppDimensions.spaceS,
            runSpacing: AppDimensions.spaceS,
            children: terms.map((term) {
              final isSelected = term == viewModel.term;
              return BaicBounceButton(
                onPressed: () => viewModel.setTerm(term),
                child: Container(
                  width: (MediaQuery.of(context).size.width -
                          AppDimensions.spaceM * 4 -
                          AppDimensions.spaceS * 2) /
                      3,
                  padding: EdgeInsets.symmetric(
                    vertical: AppDimensions.spaceS + 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.textPrimary
                          : const Color(0xFFF0F0F0),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    '$term期',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.bgSurface
                          : AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// 构建底部按钮
  Widget _buildBottomButton(
    BuildContext context,
    FinanceCalculatorViewModel viewModel,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.spaceM,
        AppDimensions.spaceM,
        AppDimensions.spaceM,
        MediaQuery.of(context).padding.bottom + AppDimensions.spaceM,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(
          top: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: BaicBounceButton(
        onPressed: viewModel.applyFinance,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            '立即申请金融方案',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.bgSurface,
            ),
          ),
        ),
      ),
    );
  }
}

/// 骨架屏
class _SkeletonView extends StatelessWidget {
  const _SkeletonView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.spaceM),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 60),
          SkeletonBox(
            height: 200,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          SizedBox(height: AppDimensions.spaceM),
          SkeletonBox(
            height: 120,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          SizedBox(height: AppDimensions.spaceM),
          SkeletonBox(
            height: 150,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
        ],
      ),
    );
  }
}
