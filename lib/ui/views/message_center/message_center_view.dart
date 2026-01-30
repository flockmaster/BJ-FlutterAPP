import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'message_center_viewmodel.dart';
import '../../../core/services/message_service.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/components/baic_ui_kit.dart';

/// 消息中心页面 - 严格遵循 BAIC 架构规范
/// 架构规范: .rules (Stacked MVVM + AppColors + BaicBounceButton)
class MessageCenterView extends StackedView<MessageCenterViewModel> {
  const MessageCenterView({super.key});

  @override
  Widget builder(BuildContext context, MessageCenterViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Column(
        children: [
          _buildHeader(viewModel),
          _buildTabs(viewModel),
          Expanded(
            child: _buildMessageList(viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(MessageCenterViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.only(top: 54, left: 12, right: 20, bottom: 12),
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Text(
            '消息中心',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          BaicBounceButton(
            onPressed: viewModel.markAllAsRead,
            child: const Text(
              '全部已读',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(MessageCenterViewModel viewModel) {
    return Container(
      color: AppColors.bgSurface,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: viewModel.tabs.map((tab) {
          final isActive = viewModel.activeTab == tab.id;
          
          return BaicBounceButton(
            onPressed: () => viewModel.setActiveTab(tab.id),
            child: Container(
              margin: const EdgeInsets.only(right: 24),
              padding: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? AppColors.brandDark : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                tab.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? AppColors.textPrimary : AppColors.textTertiary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMessageList(MessageCenterViewModel viewModel) {
    if (viewModel.isBusy) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.brandDark,
        ),
      );
    }

    if (viewModel.messages.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: viewModel.messages.length,
      itemBuilder: (context, index) {
        final message = viewModel.messages[index];
        return _buildMessageItem(message, viewModel);
      },
    );
  }

  Widget _buildMessageItem(Message message, MessageCenterViewModel viewModel) {
    return BaicBounceButton(
      onPressed: () => viewModel.markAsRead(message.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.borderPrimary,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowBase.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getIconBackgroundColor(message.type),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(message.type),
                size: 18,
                color: _getIconColor(message.type),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          message.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        message.time,
                        style: AppTypography.dataDisplayXS.copyWith(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Unread indicator
            if (!message.isRead) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.bgFill,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.bell,
              size: 24,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '暂无消息',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(MessageType type) {
    switch (type) {
      case MessageType.system:
        return LucideIcons.bell;
      case MessageType.service:
        return LucideIcons.wrench;
      case MessageType.social:
        return LucideIcons.messageSquare;
    }
  }

  Color _getIconBackgroundColor(MessageType type) {
    switch (type) {
      case MessageType.system:
        return AppColors.infoLight;
      case MessageType.service:
        return AppColors.warningLight;
      case MessageType.social:
        return const Color(0xFFFCE7F3);
    }
  }

  Color _getIconColor(MessageType type) {
    switch (type) {
      case MessageType.system:
        return AppColors.info;
      case MessageType.service:
        return AppColors.brandOrange;
      case MessageType.social:
        return const Color(0xFFEC4899);
    }
  }

  @override
  MessageCenterViewModel viewModelBuilder(BuildContext context) => MessageCenterViewModel();

  @override
  void onViewModelReady(MessageCenterViewModel viewModel) => viewModel.init();
}
