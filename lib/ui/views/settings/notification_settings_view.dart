import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:car_owner_app/core/shared/widgets/custom_switch.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/components/baic_ui_kit.dart';
import 'notification_settings_viewmodel.dart';

/// 消息推送设置页面
/// 对齐 V4.0 二级页面规范：移除图标背景，统一阴影与排印
class NotificationSettingsView extends StackedView<NotificationSettingsViewModel> {
  const NotificationSettingsView({super.key});

  @override
  Widget builder(BuildContext context, NotificationSettingsViewModel viewModel, Widget? child) {
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
                  _buildSection(
                    title: '推送类别',
                    items: [
                      _buildSwitchItem(
                        icon: LucideIcons.bell,
                        label: '系统通知',
                        subLabel: '账户安全、版本更新等重要信息',
                        value: viewModel.systemNotification,
                        onChanged: (val) => viewModel.toggleSystemNotification(val),
                      ),
                      _buildDivider(),
                      _buildSwitchItem(
                        icon: LucideIcons.megaphone,
                        label: '活动优惠',
                        subLabel: '商城促销、车主福利活动',
                        value: viewModel.activityNotification,
                        onChanged: (val) => viewModel.toggleActivityNotification(val),
                      ),
                      _buildDivider(),
                      _buildSwitchItem(
                        icon: LucideIcons.truck,
                        label: '交易物流',
                        subLabel: '订单状态、物流进度更新',
                        value: viewModel.logisticsNotification,
                        onChanged: (val) => viewModel.toggleLogisticsNotification(val),
                      ),
                      _buildDivider(),
                      _buildSwitchItem(
                        icon: LucideIcons.messageSquare,
                        label: '互动消息',
                        subLabel: '评论、点赞、@我的',
                        value: viewModel.interactionNotification,
                        onChanged: (val) => viewModel.toggleInteractionNotification(val),
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _buildSection(
                    title: '提醒方式',
                    items: [
                      _buildSwitchItem(
                        icon: LucideIcons.volume2,
                        label: '声音',
                        value: viewModel.soundEnabled,
                        onChanged: (val) => viewModel.toggleSound(val),
                      ),
                      _buildDivider(),
                      _buildSwitchItem(
                        icon: LucideIcons.vibrate,
                        label: '振动',
                        value: viewModel.vibrationEnabled,
                        onChanged: (val) => viewModel.toggleVibration(val),
                        isLast: true,
                      ),
                    ],
                  ),
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

  Widget _buildHeader(NotificationSettingsViewModel viewModel) {
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
                child: const SizedBox(width: 40, height: 40, child: Icon(LucideIcons.arrowLeft, size: 24, color: AppColors.brandBlack)),
              ),
              const SizedBox(width: 8),
              Text('消息推送', style: AppTypography.headingS.copyWith(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: AppTypography.captionSecondary.copyWith(fontWeight: FontWeight.bold, color: AppColors.textTertiary),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: AppColors.shadowLight, blurRadius: 15, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: items),
        ),
      ],
    );
  }

  Widget _buildSwitchItem({
    IconData? icon,
    required String label,
    String? subLabel,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: AppColors.textPrimary),
            const SizedBox(width: 14),
          ],
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
          const SizedBox(width: 16),
          CustomSwitch(value: value, onChanged: onChanged),
        ],
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
              '若关闭系统通知，您可能会错过重要的账户安全提醒和维保预约确认，请谨慎操作。',
              style: AppTypography.captionSecondary.copyWith(color: AppColors.textTertiary, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  @override
  NotificationSettingsViewModel viewModelBuilder(BuildContext context) => NotificationSettingsViewModel();

  @override
  void onViewModelReady(NotificationSettingsViewModel viewModel) => viewModel.init();
}
