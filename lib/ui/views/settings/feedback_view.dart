import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'feedback_viewmodel.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/components/baic_ui_kit.dart';

/// 投诉建议页面
class FeedbackView extends StackedView<FeedbackViewModel> {
  const FeedbackView({super.key});

  @override
  Widget builder(BuildContext context, FeedbackViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Column(
        children: [
          _buildHeader(context, viewModel),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTypeCard(viewModel),
                  const SizedBox(height: 24),
                  _buildContentCard(context, viewModel),
                  const SizedBox(height: 24),
                  _buildContactCard(viewModel),
                  const SizedBox(height: 24),
                  _buildPrivacyNotice(),
                ],
              ),
            ),
          ),
          _buildFooter(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, FeedbackViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              BaicBounceButton(
                onPressed: () => viewModel.goBack(),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.centerLeft,
                  child: const Icon(
                    LucideIcons.arrowLeft,
                    size: 24,
                    color: AppColors.brandBlack,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '投诉建议',
                style: AppTypography.headingS.copyWith(
                  color: AppColors.brandBlack,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeCard(FeedbackViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '反馈类型',
            style: AppTypography.bodyPrimary.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textTitle,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTypeButton(
                  icon: LucideIcons.messageSquare,
                  label: '功能异常',
                  isSelected: viewModel.selectedType == '功能异常',
                  onTap: () => viewModel.selectType('功能异常'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTypeButton(
                  icon: LucideIcons.lightbulb,
                  label: '产品建议',
                  isSelected: viewModel.selectedType == '产品建议',
                  onTap: () => viewModel.selectType('产品建议'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTypeButton(
                  icon: LucideIcons.thumbsUp,
                  label: '服务表扬',
                  isSelected: viewModel.selectedType == '服务表扬',
                  onTap: () => viewModel.selectType('服务表扬'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return BaicBounceButton(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandBlack : AppColors.bgFill,
          borderRadius: BorderRadius.circular(12),
          border: isSelected 
              ? Border.all(color: AppColors.brandBlack, width: 1)
              : Border.all(color: Colors.transparent, width: 1),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.textInverse : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTypography.captionPrimary.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.textInverse : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(BuildContext context, FeedbackViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '详细描述',
            style: AppTypography.bodyPrimary.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textTitle,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgFill.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider, width: 0.5),
            ),
            child: TextField(
              controller: viewModel.contentController,
              maxLines: 5,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: '请详细描述您遇到的问题或建议，以便我们快速定位并为您处理...',
                hintStyle: AppTypography.bodySecondary.copyWith(
                  color: AppColors.textTertiary,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                counterText: '',
              ),
              style: AppTypography.bodyPrimary.copyWith(
                color: AppColors.textTitle,
                height: 1.6,
              ),
              onChanged: (_) => viewModel.notifyListeners(),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...viewModel.selectedImages.asMap().entries.map((entry) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.bgFill,
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(entry.value),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -6,
                      right: -6,
                      child: BaicBounceButton(
                        onPressed: () => viewModel.removeImage(entry.key),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                            ],
                          ),
                          child: const Icon(
                            LucideIcons.x,
                            size: 14,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              if (viewModel.selectedImages.length < 3)
                BaicBounceButton(
                  onPressed: () => viewModel.pickImages(),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.bgFill.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.divider,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          LucideIcons.camera,
                          size: 24,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '添加图片',
                          style: AppTypography.captionSecondary.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(FeedbackViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '联系方式',
            style: AppTypography.bodyPrimary.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textTitle,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.bgFill.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider, width: 0.5),
            ),
            child: TextField(
              controller: viewModel.contactController,
              decoration: InputDecoration(
                hintText: '手机号 / 邮箱 (选填)',
                hintStyle: AppTypography.bodySecondary.copyWith(
                  color: AppColors.textTertiary,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              style: AppTypography.bodyPrimary.copyWith(
                color: AppColors.textTitle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyNotice() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            LucideIcons.info,
            size: 14,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '您的反馈将直接发送至北京汽车客户体验中心，我们承诺严格保护您的个人隐私信息。',
              style: AppTypography.captionSecondary.copyWith(
                color: AppColors.textTertiary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, FeedbackViewModel viewModel) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).padding.bottom + 20),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BaicBounceButton(
        onPressed: viewModel.canSubmit && !viewModel.isBusy
            ? () => viewModel.submitFeedback(context)
            : null,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: viewModel.canSubmit && !viewModel.isBusy
                ? AppColors.brandBlack
                : AppColors.bgFill,
            borderRadius: BorderRadius.circular(16),
            boxShadow: viewModel.canSubmit && !viewModel.isBusy
                ? [
                    BoxShadow(
                      color: AppColors.brandBlack.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: viewModel.isBusy
              ? const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.bgSurface,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '提交反馈',
                      style: AppTypography.button.copyWith(
                        color: viewModel.canSubmit && !viewModel.isBusy
                            ? AppColors.textInverse
                            : AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      LucideIcons.send,
                      size: 18,
                      color: viewModel.canSubmit && !viewModel.isBusy
                          ? AppColors.textInverse
                          : AppColors.textTertiary,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  FeedbackViewModel viewModelBuilder(BuildContext context) => FeedbackViewModel();
}
