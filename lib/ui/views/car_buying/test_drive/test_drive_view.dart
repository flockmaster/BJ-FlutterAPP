import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_owner_app/core/theme/app_colors.dart';
import 'package:car_owner_app/core/theme/app_dimensions.dart';
import 'package:car_owner_app/core/theme/app_typography.dart';
import 'package:car_owner_app/core/components/baic_ui_kit.dart';
import 'package:car_owner_app/core/models/car_model.dart';
import 'test_drive_viewmodel.dart';

class TestDriveView extends StackedView<TestDriveViewModel> {
  final CarModel car;

  const TestDriveView({
    super.key,
    required this.car,
  });

  @override
  Widget builder(
    BuildContext context,
    TestDriveViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.isBusy) {
      return const _SkeletonView();
    }

    if (viewModel.isSubmitted) {
      return _buildSuccessView(context, viewModel);
    }

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      appBar: AppBar(
        title: Text('预约试驾', style: AppTypography.headingM),
        leading: BaicBounceButton(
          onPressed: viewModel.goBack,
          child: const Icon(LucideIcons.arrowLeft, color: AppColors.textTitle),
        ),
        backgroundColor: AppColors.bgSurface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 车辆信息卡片
            _buildCarCard(viewModel),
            const SizedBox(height: 24),
            
            Text('填写预约信息', style: AppTypography.headingS),
            const SizedBox(height: 16),
            
            // 预约表单
            _buildForm(viewModel),
            const SizedBox(height: 24),
            
            // 隐私协议
            _buildPrivacyTerms(viewModel),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, viewModel),
    );
  }

  Widget _buildCarCard(TestDriveViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: AppDimensions.borderRadiusM,
        border: Border.all(color: AppColors.white),
        boxShadow: AppDimensions.shadowL1,
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.bgFill,
              borderRadius: AppDimensions.borderRadiusM,
            ),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              imageUrl: car.backgroundImage ?? '',
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const Icon(LucideIcons.image),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  car.name ?? '',
                  style: AppTypography.headingS,
                ),
                const SizedBox(height: 4),
                Text(
                  car.subtitle ?? '',
                  style: AppTypography.captionPrimary,
                ),
                const SizedBox(height: 8),
                Text(
                  '预约有好礼',
                  style: AppTypography.label.copyWith(
                    color: AppColors.brandOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(TestDriveViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: AppDimensions.borderRadiusL,
        border: Border.all(color: AppColors.white),
        boxShadow: AppDimensions.shadowL1,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildFormItem(
            icon: LucideIcons.user,
            label: '姓名',
            child: TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppTypography.bodyPrimary.copyWith(fontWeight: FontWeight.w500),
              controller: TextEditingController(text: viewModel.name),
              onChanged: viewModel.updateName,
            ),
          ),
          _buildFormItem(
            icon: LucideIcons.phone,
            label: '手机号',
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppTypography.bodyPrimary.copyWith(fontWeight: FontWeight.w500),
                    controller: TextEditingController(text: viewModel.phone),
                    onChanged: viewModel.updatePhone,
                  ),
                ),
                BaicBounceButton(
                  onPressed: viewModel.sendVerificationCode,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderPrimary),
                      borderRadius: AppDimensions.borderRadiusS,
                    ),
                    child: const Text(
                      '发送验证码',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textTitle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildFormItem(
            icon: LucideIcons.mapPin,
            label: '城市',
            isClickable: true,
            onTap: () {},
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    viewModel.city,
                    style: AppTypography.bodyPrimary.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.textDisabled),
              ],
            ),
          ),
          _buildFormItem(
            icon: LucideIcons.calendar,
            label: '时间',
            isClickable: true,
            onTap: () {},
            showDivider: false,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${viewModel.date} (周三)',
                    style: AppTypography.bodyPrimary.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.textDisabled),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormItem({
    required IconData icon,
    required String label,
    required Widget child,
    bool isClickable = false,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    Widget content = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: showDivider ? const Border(bottom: BorderSide(color: AppColors.bgCanvas)) : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.textTertiary),
                const SizedBox(width: 12),
                Text(label, style: AppTypography.bodySecondary.copyWith(fontSize: 14)),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );

    if (isClickable) {
      return BaicBounceButton(onPressed: onTap, child: content);
    }
    return content;
  }

  Widget _buildPrivacyTerms(TestDriveViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaicBounceButton(
            onPressed: () => viewModel.setAgreed(!viewModel.isAgreed),
            child: Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.textTitle, width: 1),
              ),
              padding: const EdgeInsets.all(2),
              child: viewModel.isAgreed 
                ? Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.textTitle))
                : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTypography.captionSecondary.copyWith(color: AppColors.textTertiary, height: 1.5),
                children: const [
                  TextSpan(text: '我已阅读并同意 '),
                  TextSpan(
                    text: '《隐私政策》',
                    style: TextStyle(color: AppColors.textTitle, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' 和 '),
                  TextSpan(
                    text: '《试驾服务条款》',
                    style: TextStyle(color: AppColors.textTitle, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '。'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, TestDriveViewModel viewModel) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(top: BorderSide(color: AppColors.bgCanvas)),
      ),
      child: BaicBounceButton(
        onPressed: viewModel.submit,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.brandDark,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Text(
            '立即预约',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, TestDriveViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.bgSurface,
      body: Container(
        padding: const EdgeInsets.all(32),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.checkCircle2, size: 40, color: AppColors.success),
            ),
            const SizedBox(height: 24),
            Text('预约成功', style: AppTypography.headingL),
            const SizedBox(height: 8),
            Text(
              '您的试驾预约已提交。\n销售顾问将在 24 小时内与您联系。',
              textAlign: TextAlign.center,
              style: AppTypography.bodySecondary.copyWith(height: 1.6),
            ),
            const SizedBox(height: 48),
            BaicBounceButton(
              onPressed: viewModel.goBack,
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.brandDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '返回',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            BaicBounceButton(
              onPressed: viewModel.viewMyOrders,
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.bgFill,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '查看我的预约',
                  style: TextStyle(color: AppColors.textTitle, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  TestDriveViewModel viewModelBuilder(BuildContext context) => TestDriveViewModel(car: car);
}

class _SkeletonView extends StatelessWidget {
  const _SkeletonView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      appBar: AppBar(
        title: const BaicSkeleton(width: 80, height: 20),
        leading: const Icon(LucideIcons.arrowLeft, color: AppColors.textDisabled),
        backgroundColor: AppColors.bgSurface,
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaicSkeleton(width: double.infinity, height: 112, radius: 12),
            SizedBox(height: 24),
            BaicSkeleton(width: 100, height: 20),
            SizedBox(height: 16),
            BaicSkeleton(width: double.infinity, height: 260, radius: 16),
            SizedBox(height: 24),
            BaicSkeleton(width: double.infinity, height: 40),
          ],
        ),
      ),
    );
  }
}
