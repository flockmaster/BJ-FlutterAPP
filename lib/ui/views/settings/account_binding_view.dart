import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'account_binding_viewmodel.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/components/baic_ui_kit.dart';

/// 账号绑定页面
class AccountBindingView extends StackedView<AccountBindingViewModel> {
  const AccountBindingView({super.key});

  @override
  Widget builder(BuildContext context, AccountBindingViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Column(
        children: [
          _buildHeader(viewModel),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildBindingItem(
                          icon: LucideIcons.smartphone,
                          label: '手机号',
                          value: viewModel.phoneNumber,
                          isBound: viewModel.isPhoneBound,
                          onTap: () => viewModel.handlePhoneBinding(),
                        ),
                        const Divider(height: 1, indent: 56, endIndent: 20, color: AppColors.divider),
                        _buildBindingItem(
                          icon: LucideIcons.messageCircle,
                          label: '微信',
                          value: viewModel.wechatName,
                          isBound: viewModel.isWechatBound,
                          onTap: () => viewModel.handleWechatBinding(),
                        ),
                        const Divider(height: 1, indent: 56, endIndent: 20, color: AppColors.divider),
                        _buildBindingItem(
                          icon: Icons.apple,
                          label: 'Apple ID',
                          value: viewModel.email,
                          isBound: viewModel.isEmailBound,
                          onTap: () => viewModel.handleEmailBinding(),
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '* 绑定第三方账号后，可直接使用第三方账号登录，账号更安全，登录更便捷。\n* 若手机号已停用，请及时更换绑定手机。',
                      style: AppTypography.captionSecondary.copyWith(
                        color: AppColors.textTertiary,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Center(
              child: BaicBounceButton(
                onPressed: () => _showDeleteAccountDialog(context, viewModel),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '注销账号',
                    style: AppTypography.captionSecondary.copyWith(
                      color: AppColors.textTertiary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AccountBindingViewModel viewModel) {
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
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    LucideIcons.arrowLeft,
                    size: 24,
                    color: AppColors.brandBlack,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '账号绑定',
                style: AppTypography.headingS.copyWith(
                  fontSize: 18,
                  color: AppColors.brandBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBindingItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isBound,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return BaicBounceButton(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: AppTypography.bodyPrimary.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textTitle,
              ),
            ),
            const Spacer(),
            Text(
              isBound ? value : '未绑定',
              style: AppTypography.bodySecondary.copyWith(
                color: isBound ? AppColors.textTertiary : AppColors.brandOrange,
                fontWeight: isBound ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: AppColors.textDisabled,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, AccountBindingViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 310,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.alertTriangle, size: 24, color: AppColors.error),
              ),
              const SizedBox(height: 16),
              Text('注销账号', style: AppTypography.headingS),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgFill,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '注销后不可恢复：',
                      style: AppTypography.captionPrimary.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '• 车辆绑定关系、积分、权益\n• 交易记录及所有历史订单',
                      style: AppTypography.captionPrimary.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: BaicBounceButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.bgFill,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text('暂不注销', style: AppTypography.button.copyWith(color: AppColors.textSecondary)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BaicBounceButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        viewModel.handleDeleteAccount();
                        viewModel.goBack();
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.brandBlack,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text('确认注销', style: AppTypography.button.copyWith(color: AppColors.textInverse)),
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

  @override
  AccountBindingViewModel viewModelBuilder(BuildContext context) => AccountBindingViewModel();

  @override
  void onViewModelReady(AccountBindingViewModel viewModel) => viewModel.init();
}
