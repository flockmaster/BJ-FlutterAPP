import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'privacy_settings_viewmodel.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/components/baic_ui_kit.dart';

/// 隐私设置页面
/// 对齐 V4.0 二级页面规范：移除图标背景，统一间距与阴影
class PrivacySettingsView extends StackedView<PrivacySettingsViewModel> {
  const PrivacySettingsView({super.key});

  @override
  Widget builder(BuildContext context, PrivacySettingsViewModel viewModel, Widget? child) {
    if (viewModel.showBlockList) {
      return _buildBlockListView(viewModel);
    }

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Column(
        children: [
          _buildHeader(viewModel),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('用户互动'),
                  _buildSectionContainer([
                    _buildNavigationItem(
                      icon: LucideIcons.users,
                      label: '黑名单管理',
                      value: '${viewModel.blockedUsers.length}人',
                      onTap: () => viewModel.showBlockListPage(),
                    ),
                    _buildDivider(),
                    _buildNavigationItem(
                      icon: LucideIcons.eye,
                      label: '谁可以看我的动态',
                      value: '所有人',
                      onTap: () => viewModel.navigateToVisibilitySettings(),
                      isLast: true,
                    ),
                  ]),
                  const SizedBox(height: 28),
                  _buildSectionTitle('权限与数据'),
                  _buildSectionContainer([
                    _buildNavigationItem(
                      icon: LucideIcons.lock,
                      label: '系统权限管理',
                      subLabel: '相机、定位、麦克风等权限状态',
                      onTap: () => viewModel.navigateToSystemPermissions(),
                    ),
                    _buildDivider(),
                    _buildNavigationItem(
                      icon: LucideIcons.share2,
                      label: '第三方共享信息清单',
                      subLabel: 'SDK技术使用详情说明',
                      onTap: () => viewModel.navigateToThirdPartyInfo(),
                    ),
                    _buildDivider(),
                    _buildNavigationItem(
                      icon: LucideIcons.list,
                      label: '个人信息收集清单',
                      onTap: () => viewModel.navigateToDataCollection(),
                    ),
                    _buildDivider(),
                    _buildNavigationItem(
                      icon: LucideIcons.fileText,
                      label: '隐私政策条款',
                      onTap: () => viewModel.viewPrivacyPolicy(),
                      isLast: true,
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildFooterHint(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(PrivacySettingsViewModel viewModel) {
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
                  child: const Icon(LucideIcons.arrowLeft, size: 24, color: AppColors.brandBlack),
                ),
              ),
              const SizedBox(width: 8),
              Text('隐私设置', style: AppTypography.headingS.copyWith(fontSize: 18)),
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
        style: AppTypography.captionSecondary.copyWith(fontWeight: FontWeight.bold, color: AppColors.textTertiary),
      ),
    );
  }

  Widget _buildSectionContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.shadowLight, blurRadius: 15, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    );
  }

  Widget _buildNavigationItem({
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
            Icon(icon, size: 20, color: AppColors.textPrimary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.bodyPrimary.copyWith(fontWeight: FontWeight.bold)),
                  if (subLabel != null) ...[
                    const SizedBox(height: 4),
                    Text(subLabel, style: AppTypography.captionSecondary.copyWith(color: AppColors.textTertiary)),
                  ],
                ],
              ),
            ),
            if (value != null) ...[
              const SizedBox(width: 8),
              Text(value, style: AppTypography.bodySecondary.copyWith(color: AppColors.textTertiary)),
            ],
            const SizedBox(width: 8),
            const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.textDisabled),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 54, endIndent: 20, color: AppColors.divider);
  }

  Widget _buildFooterHint() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•', style: AppTypography.captionSecondary.copyWith(color: AppColors.textTertiary)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '北京汽车严格遵守法律法规，保护您的个人隐私安全。如需撤回隐私授权，可能影响部分功能的使用。',
              style: AppTypography.captionSecondary.copyWith(color: AppColors.textTertiary, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockListView(PrivacySettingsViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Column(
        children: [
          _buildHeaderWithTitle('黑名单管理', () => viewModel.hideBlockListPage()),
          Expanded(
            child: viewModel.blockedUsers.isEmpty
                ? Center(child: Text('暂无拉黑用户', style: AppTypography.bodySecondary))
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: viewModel.blockedUsers.length,
                    itemBuilder: (context, index) {
                      final user = viewModel.blockedUsers[index];
                      return _buildBlockUserItem(user, () => viewModel.unblockUser(user['id']));
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderWithTitle(String title, VoidCallback onBack) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              BaicBounceButton(
                onPressed: onBack,
                child: const SizedBox(width: 40, height: 40, child: Icon(LucideIcons.arrowLeft, size: 24, color: AppColors.brandBlack)),
              ),
              const SizedBox(width: 8),
              Text(title, style: AppTypography.headingS.copyWith(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlockUserItem(Map<String, dynamic> user, VoidCallback onUnblock) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['name'] ?? '', style: AppTypography.bodyPrimary.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('拉黑时间: ${user['time'] ?? ''}', style: AppTypography.captionSecondary),
              ],
            ),
          ),
          BaicBounceButton(
            onPressed: onUnblock,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(color: AppColors.bgFill, borderRadius: BorderRadius.circular(8)),
              child: Text('移除', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  PrivacySettingsViewModel viewModelBuilder(BuildContext context) => PrivacySettingsViewModel();

  @override
  void onViewModelReady(PrivacySettingsViewModel viewModel) => viewModel.init();
}
