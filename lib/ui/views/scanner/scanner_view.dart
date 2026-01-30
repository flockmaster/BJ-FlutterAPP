// ============================================================================
// BAIC 架构规范 - 扫码页面
// ============================================================================
// - ViewModel: 继承 BaicBaseViewModel
// - View: 使用 ViewModelBuilder<T>.reactive() 构建
// - 颜色: 只使用 AppColors.xxx (禁止硬编码)
// - 按钮: 必须使用 BaicBounceButton 包裹
// - 导航: 使用 viewModel.goBack() 而非 context.pop()
// ============================================================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/components/baic_ui_kit.dart';
import 'scanner_viewmodel.dart';

class ScannerView extends StackedView<ScannerViewModel> {
  const ScannerView({super.key});

  @override
  Widget builder(BuildContext context, ScannerViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Stack(
        children: [
          // QR Scanner - 铺满整个屏幕
          Positioned.fill(
            child: QRView(
              key: viewModel.qrKey,
              onQRViewCreated: viewModel.onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: AppColors.white.withOpacity(0), // 隐藏默认边框
                borderRadius: 0,
                borderLength: 0,
                borderWidth: 0,
                cutOutSize: 0, // 不使用默认的cutOut
                overlayColor: AppColors.white.withOpacity(0), // 不使用默认遮罩
              ),
              onPermissionSet: (ctrl, p) => viewModel.onPermissionSet(context, ctrl, p),
            ),
          ),
          
          // 自定义遮罩层 - 中间圆角矩形外的半透明黑色遮罩
          _buildCustomOverlay(context, viewModel),
          
          // UI Overlay
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BaicBounceButton(
                        onPressed: () => viewModel.goBack(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            LucideIcons.arrowLeft,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      Text(
                        viewModel.scanMode == ScanMode.general ? '扫码' : '扫码充电',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          shadows: [
                            Shadow(
                              color: AppColors.black,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Hint Text
                Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    viewModel.scanMode == ScanMode.general 
                        ? '对准二维码，即可自动扫描' 
                        : '请对准充电桩上的二维码',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                ),
                
                // Mode Switcher
                Container(
                  margin: const EdgeInsets.only(bottom: 60),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildModeButton(
                        icon: LucideIcons.scanLine,
                        label: '扫一扫',
                        isActive: viewModel.scanMode == ScanMode.general,
                        onTap: () => viewModel.setScanMode(ScanMode.general),
                      ),
                      const SizedBox(width: 4),
                      _buildModeButton(
                        icon: LucideIcons.zap,
                        label: '充电',
                        isActive: viewModel.scanMode == ScanMode.charging,
                        onTap: () => viewModel.setScanMode(ScanMode.charging),
                        isCharging: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Side Tools (positioned absolutely)
          Positioned(
            right: 24,
            top: 150,
            child: SafeArea(
              child: Column(
                children: [
                  _buildToolButton(
                    icon: LucideIcons.flashlight,
                    label: '手电',
                    onTap: viewModel.toggleFlash,
                  ),
                  const SizedBox(height: 24),
                  _buildToolButton(
                    icon: LucideIcons.image,
                    label: '相册',
                    onTap: viewModel.pickImageFromGallery,
                  ),
                  if (viewModel.scanMode == ScanMode.charging) ...[
                    const SizedBox(height: 24),
                    _buildToolButton(
                      icon: LucideIcons.keyboard,
                      label: '输码',
                      onTap: viewModel.showManualInput,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 自定义遮罩层 - 中间圆角矩形外的半透明黑色遮罩
  Widget _buildCustomOverlay(BuildContext context, ScannerViewModel viewModel) {
    final size = MediaQuery.of(context).size;
    final scanAreaSize = 260.0; // 扫码区域大小
    final borderRadius = 32.0; // 圆角半径
    
    return CustomPaint(
      size: size,
      painter: ScannerOverlayPainter(
        scanAreaSize: scanAreaSize,
        borderRadius: borderRadius,
        borderColor: viewModel.scanMode == ScanMode.general 
            ? AppColors.white 
            : AppColors.brandOrange,
        borderWidth: 4.0,
        overlayColor: AppColors.black.withOpacity(0.5), // 半透明黑色遮罩
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return BaicBounceButton(
      onPressed: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: AppColors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
              shadows: [
                Shadow(
                  color: AppColors.black,
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    bool isCharging = false,
  }) {
    return BaicBounceButton(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isActive 
              ? (isCharging ? AppColors.brandOrange : AppColors.white)
              : AppColors.white.withOpacity(0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive 
                  ? (isCharging ? AppColors.white : AppColors.black)
                  : AppColors.white.withOpacity(0.6),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isActive 
                    ? (isCharging ? AppColors.white : AppColors.black)
                    : AppColors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  ScannerViewModel viewModelBuilder(BuildContext context) => ScannerViewModel();

  @override
  void onViewModelReady(ScannerViewModel viewModel) => viewModel.init();

  @override
  void onDispose(ScannerViewModel viewModel) => viewModel.dispose();
}

// 自定义扫码遮罩绘制器
class ScannerOverlayPainter extends CustomPainter {
  final double scanAreaSize;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;

  ScannerOverlayPainter({
    required this.scanAreaSize,
    required this.borderRadius,
    required this.borderColor,
    required this.borderWidth,
    required this.overlayColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 计算扫码区域的位置（居中）
    final left = (size.width - scanAreaSize) / 2;
    final top = (size.height - scanAreaSize) / 2;
    final scanRect = Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize);
    
    // 绘制半透明黑色遮罩（扫码区域外）
    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    
    final scanAreaPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        scanRect,
        Radius.circular(borderRadius),
      ));
    
    // 使用差集，挖空中间的扫码区域
    final maskPath = Path.combine(
      PathOperation.difference,
      overlayPath,
      scanAreaPath,
    );
    
    final overlayPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(maskPath, overlayPaint);
    
    // 绘制扫码区域的圆角边框
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        scanRect,
        Radius.circular(borderRadius),
      ),
      borderPaint,
    );
    
    // 绘制四个角的装饰线（可选，增强视觉效果）
    final cornerLength = 40.0;
    final cornerPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth + 2
      ..strokeCap = StrokeCap.round;
    
    // 左上角
    canvas.drawLine(
      Offset(left, top + borderRadius + cornerLength),
      Offset(left, top + borderRadius),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + borderRadius, top),
      Offset(left + borderRadius + cornerLength, top),
      cornerPaint,
    );
    
    // 右上角
    canvas.drawLine(
      Offset(left + scanAreaSize, top + borderRadius + cornerLength),
      Offset(left + scanAreaSize, top + borderRadius),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaSize - borderRadius - cornerLength, top),
      Offset(left + scanAreaSize - borderRadius, top),
      cornerPaint,
    );
    
    // 左下角
    canvas.drawLine(
      Offset(left, top + scanAreaSize - borderRadius - cornerLength),
      Offset(left, top + scanAreaSize - borderRadius),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + borderRadius, top + scanAreaSize),
      Offset(left + borderRadius + cornerLength, top + scanAreaSize),
      cornerPaint,
    );
    
    // 右下角
    canvas.drawLine(
      Offset(left + scanAreaSize, top + scanAreaSize - borderRadius - cornerLength),
      Offset(left + scanAreaSize, top + scanAreaSize - borderRadius),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaSize - borderRadius - cornerLength, top + scanAreaSize),
      Offset(left + scanAreaSize - borderRadius, top + scanAreaSize),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(ScannerOverlayPainter oldDelegate) {
    return oldDelegate.scanAreaSize != scanAreaSize ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.overlayColor != overlayColor;
  }
}
