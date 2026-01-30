import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../core/themes/app_theme.dart';
import 'package:car_owner_app/core/shared/widgets/optimized_image.dart';
import 'consultant_chat_viewmodel.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/components/baic_ui_kit.dart';

/// AI产品顾问聊天页面 - 严格遵循 BAIC 架构规范
/// 架构规范: .rules (Stacked MVVM + AppColors + BaicBounceButton)
/// [ConsultantChatPage] - AI 产品顾问在线咨询对话视图
/// 
/// 核心规范：
/// 1. 严格遵循 Stacked (MVVM) 架构。
/// 2. 交互逻辑（如回弹、抖动）必须通过 [BaicBounceButton] 进行。
/// 3. 所有字号颜色引用自 [AppTypography] 与 [AppColors]。
class ConsultantChatPage extends StatelessWidget {
  final Map<String, dynamic> carInfo; // 关联的车型详情上下文数据

  const ConsultantChatPage({
    super.key,
    required this.carInfo,
  });

  @override
  Widget build(BuildContext context) {
    // 采用沉浸式对话流设计，背景设为透明以便在 BottomSheet 等容器中优雅展示
    return ViewModelBuilder<ConsultantChatViewModel>.reactive(
      viewModelBuilder: () => ConsultantChatViewModel(),
      onViewModelReady: (viewModel) => viewModel.initialize(carInfo),
      builder: (context, viewModel, child) => _buildView(context, viewModel),
    );
  }

  Widget _buildView(BuildContext context, ConsultantChatViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20)],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Custom Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  border: Border(bottom: BorderSide(color: AppColors.borderPrimary)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [AppColors.brandDark, AppColors.textSecondary],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                          ),
                          child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('AI 产品顾问', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 4),
                                Text('在线', style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    BaicBounceButton(
                      onPressed: () => viewModel.goBack(),
                      child: Icon(Icons.close, color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ),

              /// 构建聊天内容滚动列表，区分普通文本与车型卡片。
              Expanded(
                child: Container(
                  color: AppColors.bgCanvas,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.messages.length,
                    itemBuilder: (context, index) {
                      final msg = viewModel.messages[index];
                      final isMe = msg.isMe;
                      final type = msg.type;
                      
                      // 如果是车型预览卡片类型，则调用专用构建器
                      if (type == 'car_card') {
                        final data = msg.data!;
                        return _buildCarCard(data);
                      }
                      
                      // 默认普通对话消息气泡
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
                            color: isMe ? AppColors.brandDark : AppColors.bgSurface,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: Radius.circular(isMe ? 12 : 0),
                              bottomRight: Radius.circular(isMe ? 0 : 12),
                            ),
                            boxShadow: isMe ? null : [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                            ],
                          ),
                          child: Text(
                            msg.text,
                            style: TextStyle(
                              color: isMe ? AppColors.bgSurface : AppColors.textPrimary,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Input Area
              Container(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + MediaQuery.of(context).padding.bottom),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  border: Border(top: BorderSide(color: AppColors.borderPrimary)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.bgCanvas,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: viewModel.messageController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '询问关于车型的问题...',
                            hintStyle: TextStyle(fontSize: 14, color: AppColors.textTertiary),
                            contentPadding: const EdgeInsets.only(bottom: 10), // Fine tune alignment
                          ),
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => viewModel.sendMessage(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    BaicBounceButton(
                       onPressed: viewModel.sendMessage,
                       child: Container(
                         width: 40,
                         height: 40,
                         decoration: BoxDecoration(
                           color: AppColors.brandDark,
                           shape: BoxShape.circle,
                         ),
                         child: const Icon(Icons.send, color: Colors.white, size: 20),
                       ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 专用构建器：构建车型详情卡片气泡。
  Widget _buildCarCard(Map data) {
      return Align(
        alignment: Alignment.centerRight,
         child: Container(
            width: 240,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
               color: AppColors.bgSurface,
               borderRadius: BorderRadius.circular(12),
               border: Border.all(color: AppColors.borderPrimary),
            ),
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  Text('我想咨询这款车', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Row(
                     children: [
                        ClipRRect(
                           borderRadius: BorderRadius.circular(4),
                           child: OptimizedThumbnail(
                              imageUrl: data['image'] ?? '',
                              width: 60,
                              height: 40,
                              fit: BoxFit.cover,
                           ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                           child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text(data['name'] ?? '', style: AppTypography.headingS),
                                 if (data['price'] != null)
                                    Text('¥${data['price']}', style: AppTypography.priceSmall.copyWith(fontSize: 12)),
                              ],
                           ),
                        )
                     ],
                  )
               ],
            ),
         ),
      );
  }
}