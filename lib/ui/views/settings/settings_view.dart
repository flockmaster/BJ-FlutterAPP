import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/components/baic_ui_kit.dart';
import 'settings_viewmodel.dart';

/// 设置页面
/// 
/// 遵循 BAIC V4.0 设计规范：
/// 1. 移除了图标背景色，改为纯净图标模式
/// 2. 统一了二级页面的装饰风格（无边框、标准阴影）
/// 3. 使用 AppTypography 对齐排印系统
class SettingsView extends StackedView<SettingsViewModel> {
  const SettingsView({super.key});

  @override
  Widget builder(BuildContext context, SettingsViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(viewModel),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildBasicServicesSection(viewModel),
                      const SizedBox(height: 28),
                      _buildPrivacySection(viewModel),
                      const SizedBox(height: 28),
                      _buildGeneralSection(viewModel),
                      const SizedBox(height: 32),
                      _buildLogoutButton(viewModel),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          if (viewModel.showLogoutModal)
            _buildLogoutModal(viewModel),
        ],
      ),
    );
  }

  Widget _buildHeader(SettingsViewModel viewModel) {
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
              const SizedBox(width: 8),
              Text(
                '设置',
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title,
        style: AppTypography.captionSecondary.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textTertiary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildBasicServicesSection(SettingsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('基础服务'),
        _buildSectionContainer([
          _buildSettingItem(
            icon: LucideIcons.smartphone,
            label: '账号绑定',
            value: '138****8888',
            onTap: () => viewModel.navigateToAccountBinding(),
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: LucideIcons.mapPin,
            label: '地址管理',
            onTap: () => viewModel.navigateToAddressList(),
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: LucideIcons.receipt,
            label: '发票抬头',
            onTap: () => viewModel.navigateToInvoiceList(),
            isLast: true,
          ),
        ]),
      ],
    );
  }

  Widget _buildPrivacySection(SettingsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('隐私与安全'),
        _buildSectionContainer([
          _buildSettingItem(
            icon: LucideIcons.lock,
            label: '修改登录密码',
            onTap: () => viewModel.handleChangePassword(),
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: LucideIcons.shield,
            label: '隐私设置',
            subLabel: '黑名单、系统权限、隐私政策说明',
            onTap: () => viewModel.navigateToPrivacySettings(),
            isLast: true,
          ),
        ]),
      ],
    );
  }

  Widget _buildGeneralSection(SettingsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('通用与反馈'),
        _buildSectionContainer([
          _buildSettingItem(
            icon: LucideIcons.bell,
            label: '消息推送',
            onTap: () => viewModel.navigateToNotificationSettings(),
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: LucideIcons.trash2,
            label: '清理缓存',
            value: viewModel.cacheSize,
            onTap: () => viewModel.handleClearCache(),
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: LucideIcons.messageSquare,
            label: '投诉建议',
            onTap: () => viewModel.navigateToFeedback(),
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: LucideIcons.info,
            label: '关于我们',
            value: viewModel.appVersion,
            onTap: () => viewModel.handleAboutUs(),
            isLast: true,
          ),
        ]),
      ],
    );
  }

  Widget _buildSectionContainer(List<Widget> children) {
    return Container(
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
        children: children,
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String label,
    String? subLabel,
    String? value,
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
              color: AppColors.textPrimary, // 去掉背景，直接使用系统文字主色
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.bodyPrimary.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textTitle,
                    ),
                  ),
                  if (subLabel != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subLabel,
                      style: AppTypography.captionSecondary.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (value != null) ...[
              const SizedBox(width: 8),
              Text(
                value,
                style: AppTypography.bodySecondary.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
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

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 54,
      endIndent: 20,
      color: AppColors.divider,
    );
  }

  Widget _buildLogoutButton(SettingsViewModel viewModel) {
    return BaicBounceButton(
      onPressed: () => viewModel.showLogoutConfirmation(),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '退出当前登录',
          style: AppTypography.bodyPrimary.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.error,
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutModal(SettingsViewModel viewModel) {
    return Positioned.fill(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => viewModel.hideLogoutModal(),
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          Center(
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('确认退出登录？', style: AppTypography.headingS),
                  const SizedBox(height: 12),
                  Text(
                    '退出后将无法接收及时的服务提醒，建议保持登录状态。',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySecondary,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: BaicBounceButton(
                          onPressed: () => viewModel.hideLogoutModal(),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.bgFill,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text('取消', style: AppTypography.button.copyWith(color: AppColors.textSecondary)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BaicBounceButton(
                          onPressed: () => viewModel.handleLogout(),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.brandBlack,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text('确认', style: AppTypography.button.copyWith(color: AppColors.textInverse)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  SettingsViewModel viewModelBuilder(BuildContext context) => SettingsViewModel();

  @override
  void onViewModelReady(SettingsViewModel viewModel) => viewModel.init();
}
