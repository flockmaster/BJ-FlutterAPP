import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'vr_experience_enhanced_viewmodel.dart';

/// 增强版VR看车视图 - 使用WebView实现完整功能
/// 支持本地GLB文件加载和颜色动态修改
class VRExperienceEnhancedView extends StackedView<VRExperienceEnhancedViewModel> {
  final String carName;
  final String? modelAssetPath;

  const VRExperienceEnhancedView({
    super.key,
    required this.carName,
    this.modelAssetPath,
  });

  @override
  VRExperienceEnhancedViewModel viewModelBuilder(BuildContext context) => 
      VRExperienceEnhancedViewModel(carName: carName, modelAssetPath: modelAssetPath);

  @override
  void onViewModelReady(VRExperienceEnhancedViewModel viewModel) {
    viewModel.init();
  }

  @override
  Widget builder(
    BuildContext context,
    VRExperienceEnhancedViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          // WebView with 3D Model
          if (viewModel.isWebViewReady)
            WebViewWidget(controller: viewModel.webViewController)
          else
            _buildLoadingState(),
          
          // UI Overlay
          _buildUIOverlay(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE5E7EB), Color(0xFFF5F7FA)],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B00)),
            ),
            SizedBox(height: 16),
            Text(
              '正在加载3D模型...',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUIOverlay(BuildContext context, VRExperienceEnhancedViewModel viewModel) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.compass,
                        size: 14,
                        color: viewModel.isAutoRotate 
                            ? const Color(0xFFFF6B00) 
                            : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        viewModel.isWebViewReady 
                            ? 'REAL-TIME 3D RENDER' 
                            : 'LOADING',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Action Buttons
                Column(
                  children: [
                    // Close Button
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: Color(0xFF111111),
                        ),
                      ),
                    ),
                    
                    if (viewModel.isWebViewReady) ...[
                      const SizedBox(height: 12),
                      // Auto Rotate Toggle
                      GestureDetector(
                        onTap: viewModel.toggleAutoRotate,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: viewModel.isAutoRotate 
                                ? const Color(0xFF111111) 
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: viewModel.isAutoRotate 
                                  ? const Color(0xFF111111) 
                                  : Colors.white,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            LucideIcons.rotateCw,
                            size: 18,
                            color: viewModel.isAutoRotate 
                                ? Colors.white 
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            
            // Car Name
            if (viewModel.isWebViewReady) ...[
              const SizedBox(height: 8),
              Text(
                carName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ],
            
            const Spacer(),
            
            // Bottom Control Panel
            if (viewModel.isWebViewReady)
              _buildControlPanel(viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel(VRExperienceEnhancedViewModel viewModel) {
    return Column(
      children: [
        // Color Selection Panel
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 60,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: viewModel.carColors.asMap().entries.map((entry) {
              final index = entry.key;
              final color = entry.value;
              final isSelected = viewModel.selectedColorIndex == index;
              
              return GestureDetector(
                onTap: () => viewModel.selectColor(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color['hex'] as Color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected 
                              ? const Color(0xFF111111) 
                              : const Color(0xFFE5E7EB),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ] : null,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              size: 18,
                              color: color['hex'] == Colors.white 
                                  ? Colors.black 
                                  : Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      color['name'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isSelected 
                            ? const Color(0xFF111111) 
                            : const Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Footer Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: const Text(
            'INTERACTIVE 3D ENGINE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF999999),
              letterSpacing: 3,
            ),
          ),
        ),
      ],
    );
  }
}
