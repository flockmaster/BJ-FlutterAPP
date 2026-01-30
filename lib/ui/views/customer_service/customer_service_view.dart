import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'customer_service_viewmodel.dart';
import '../../../core/services/customer_service_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/components/baic_ui_kit.dart';

/// 客服聊天页面 - 严格遵循 BAIC 架构规范
/// 架构规范: .rules (Stacked MVVM + AppColors + BaicBounceButton)
class CustomerServiceView extends StackedView<CustomerServiceViewModel> {
  const CustomerServiceView({super.key});

  @override
  Widget builder(BuildContext context, CustomerServiceViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Column(
        children: [
          _buildHeader(context, viewModel),
          Expanded(
            child: viewModel.isBusy
                ? const Center(child: CircularProgressIndicator())
                : _buildChatArea(viewModel),
          ),
          _buildInputArea(viewModel),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CustomerServiceViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.only(top: 54, left: 12, right: 12, bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.bgFill,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BaicBounceButton(
            onPressed: () => viewModel.goBack(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                LucideIcons.arrowLeft,
                size: 24,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '专属客服',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '官方产品专家在线',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          BaicBounceButton(
            onPressed: viewModel.handlePhoneCall,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                LucideIcons.phone,
                size: 20,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea(CustomerServiceViewModel viewModel) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: viewModel.messages.length,
      itemBuilder: (context, index) {
        final message = viewModel.messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.type == MessageType.user;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.brandDark,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                LucideIcons.headphones,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? AppColors.brandDark : AppColors.bgSurface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: isUser ? null : Border.all(
                  color: AppColors.bgFill,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 14,
                  color: isUser ? AppColors.bgSurface : AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(CustomerServiceViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(
          top: BorderSide(
            color: AppColors.bgFill,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quick replies
            if (viewModel.quickReplies.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: viewModel.quickReplies.map((reply) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: BaicBounceButton(
                          onPressed: () => viewModel.sendQuickReply(reply),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.bgCanvas,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.borderPrimary,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              reply,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            // Input field
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgCanvas,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: viewModel.updateInputText,
                            onSubmitted: (_) => viewModel.sendMessage(),
                            decoration: InputDecoration(
                              hintText: '请输入您的问题...',
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: AppColors.textTertiary,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Icon(
                            LucideIcons.messageCircle,
                            size: 18,
                            color: AppColors.textDisabled,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                BaicBounceButton(
                  onPressed: viewModel.canSend ? viewModel.sendMessage : null,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: viewModel.canSend
                          ? AppColors.brandDark
                          : AppColors.borderPrimary,
                      shape: BoxShape.circle,
                      boxShadow: viewModel.canSend
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      LucideIcons.send,
                      size: 20,
                      color: viewModel.canSend
                          ? AppColors.bgSurface
                          : AppColors.textDisabled,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  CustomerServiceViewModel viewModelBuilder(BuildContext context) =>
      CustomerServiceViewModel();

  @override
  void onViewModelReady(CustomerServiceViewModel viewModel) => viewModel.init();
}
