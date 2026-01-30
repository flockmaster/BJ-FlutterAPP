import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'my_qrcode_viewmodel.dart';

/// [MyQRCodeView] - 个人主页/数字名片页
/// 
/// 视觉特性：卡片式设计，突出用户隐私保护的同时，提供高清二维码渲染及保存/分享动作。
class MyQRCodeView extends StackedView<MyQRCodeViewModel> {
  const MyQRCodeView({super.key});

  @override
  Widget builder(BuildContext context, MyQRCodeViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        LucideIcons.arrowLeft,
                        color: Color(0xFF1A1A1A),
                        size: 24,
                      ),
                    ),
                  ),
                  const Text(
                    '我的二维码',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  GestureDetector(
                    onTap: viewModel.showMoreOptions,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        LucideIcons.moreHorizontal,
                        color: Color(0xFF1A1A1A),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // QR Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 45,
                              offset: const Offset(0, 15),
                            ),
                          ],
                          border: Border.all(
                            color: const Color(0xFFF5F5F5),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            // Profile Info
                            Row(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFFF5F5F5),
                                          width: 2,
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(viewModel.avatarUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -1,
                                      right: -1,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF111111),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          LucideIcons.shieldCheck,
                                          color: Color(0xFFE5C07B),
                                          size: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        viewModel.userName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF111111),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        viewModel.userInfo,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF999999),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 40),
                            
                            // QR Code
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Background decoration
                                  Positioned.fill(
                                    child: Opacity(
                                      opacity: 0.03,
                                      child: Transform.rotate(
                                        angle: 0.2,
                                        child: Transform.translate(
                                          offset: const Offset(-40, 0),
                                          child: const Icon(
                                            LucideIcons.qrCode,
                                            size: 400,
                                            color: Color(0xFF111111),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  // Actual QR Code
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 20,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: const Color(0xFFF5F5F5),
                                        width: 1,
                                      ),
                                    ),
                                    child: QrImageView(
                                      data: viewModel.qrData,
                                      version: QrVersions.auto,
                                      size: 180,
                                      backgroundColor: Colors.white,
                                      eyeStyle: const QrEyeStyle(
                                        eyeShape: QrEyeShape.square,
                                        color: Color(0xFF111111),
                                      ),
                                      dataModuleStyle: const QrDataModuleStyle(
                                        dataModuleShape: QrDataModuleShape.square,
                                        color: Color(0xFF111111),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 40),
                            
                            // Hint Text
                            Text(
                              '扫一扫上面的二维码图案，\n加我为车友',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[400],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildActionButton(
                            icon: LucideIcons.download,
                            label: '保存到相册',
                            onTap: viewModel.saveToGallery,
                            backgroundColor: Colors.white,
                            iconColor: const Color(0xFF111111),
                            textColor: const Color(0xFF666666),
                          ),
                          const SizedBox(width: 40),
                          _buildActionButton(
                            icon: LucideIcons.share2,
                            label: '分享给好友',
                            onTap: viewModel.shareQRCode,
                            backgroundColor: const Color(0xFF111111),
                            iconColor: Colors.white,
                            textColor: const Color(0xFF111111),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Footer Branding
                      Column(
                        children: [
                          Opacity(
                            opacity: 0.2,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?q=80&w=100&auto=format&fit=crop',
                              height: 24,
                              errorBuilder: (context, error, stackTrace) => const SizedBox(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'BAIC OFFICIAL SOCIAL ID',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color iconColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor == Colors.white
                      ? Colors.black.withOpacity(0.05)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
              border: backgroundColor == Colors.white
                  ? Border.all(
                      color: const Color(0xFFF0F0F0),
                      width: 1,
                    )
                  : null,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  MyQRCodeViewModel viewModelBuilder(BuildContext context) => MyQRCodeViewModel();

  @override
  void onViewModelReady(MyQRCodeViewModel viewModel) => viewModel.init();
}
