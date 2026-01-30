import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:stacked/stacked.dart';
import 'fault_reporting_viewmodel.dart';
import 'fault_reporting_skeleton.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/components/baic_ui_kit.dart';
import '../../profile/widgets/tire_track_background.dart';
import '../../../../core/services/fault_detection_service.dart';

class FaultReportingView extends StatelessWidget {
  const FaultReportingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FaultReportingViewModel>.reactive(
      viewModelBuilder: () => FaultReportingViewModel(),
      onViewModelReady: (viewModel) => viewModel.initialize(),
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: viewModel.currentStep == FaultReportingStep.camera || 
                         viewModel.currentStep == FaultReportingStep.analyzing 
                         ? Colors.black 
                         : const Color(0xFFF5F7FA),
        body: Stack(
          children: [
            // 主内容切换
            _buildContent(viewModel),

            // 动态顶部导航栏 (只在开始阶段显示，结果页使用自带的动态导航)
            if (viewModel.currentStep == FaultReportingStep.start)
              _buildDynamicHeader(context, viewModel),

            // 骨架屏
            if (viewModel.isBusy) const FaultReportingSkeleton(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(FaultReportingViewModel viewModel) {
    switch (viewModel.currentStep) {
      case FaultReportingStep.start:
        return _StartScreen(viewModel: viewModel);
      case FaultReportingStep.camera:
        return _CameraScreen(viewModel: viewModel);
      case FaultReportingStep.analyzing:
        return _AnalyzingScreen(viewModel: viewModel);
      case FaultReportingStep.result:
        return _ResultScreen(viewModel: viewModel);
    }
  }

  Widget _buildDynamicHeader(BuildContext context, FaultReportingViewModel viewModel) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.only(top: 54, left: 20, right: 20, bottom: 12),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BaicBounceButton(
              onPressed: () => viewModel.navigateBack(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(LucideIcons.arrowLeft, color: Color(0xFF111111), size: 24),
              ),
            ),
            const SizedBox(width: 40),
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }
}

// --- 1. Start Screen ---
class _StartScreen extends StatelessWidget {
  final FaultReportingViewModel viewModel;
  const _StartScreen({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9FAFB),
      child: Stack(
        children: [
          const TireTrackBackground(),
          Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Illustration Area
                    _buildIllustration(),
                    
                    const SizedBox(height: 32),
                    
                    Text(
                      '智能故障诊断系统',
                      style: AppTypography.headingM.copyWith(
                        color: const Color(0xFF111111),
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF111111),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'PRO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AI DIAGNOSTICS V3.0',
                          style: AppTypography.captionPrimary.copyWith(
                            color: Colors.grey[400],
                            letterSpacing: 2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          _buildFeatureCard(
                            icon: LucideIcons.database,
                            title: '千万级案例库',
                            subtitle: '覆盖全系车型数据',
                          ),
                          const SizedBox(width: 12),
                          _buildFeatureCard(
                            icon: LucideIcons.cpu,
                            title: 'AI 视觉识别',
                            subtitle: '精准定位故障源',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Bottom Action
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFF3F4F6), width: 1)),
                ),
                child: BaicBounceButton(
                  onPressed: () => viewModel.setStep(FaultReportingStep.camera),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.scanLine, color: Colors.white, size: 18),
                        SizedBox(width: 12),
                        Text(
                          '启动诊断扫描',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 340,
      height: 240, // Ensure fixed height to prevent collapse if image fails
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.grey[100], // Placeholder color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://p.sda1.dev/29/c5d0f19a3ce15bb494b6e2fbd583226d/2c96cb8ae1274cd8d951cd612bbb9cbf.jpg',
              fit: BoxFit.cover,
              width: 340,
              height: 240,
              colorBlendMode: BlendMode.darken,
              color: Colors.white.withOpacity(0.9),
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.imageOff, color: Colors.grey[400], size: 48),
                      const SizedBox(height: 8),
                      Text(
                        '图片加载失败',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const _ScanningLineAnimation(),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({required IconData icon, required String title, required String subtitle}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF111111), size: 24),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTypography.bodyPrimary.copyWith(
                color: const Color(0xFF111111),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTypography.captionPrimary.copyWith(
                color: Colors.grey[400],
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanningLineAnimation extends StatefulWidget {
  const _ScanningLineAnimation();
  @override
  State<_ScanningLineAnimation> createState() => _ScanningLineAnimationState();
}
class _ScanningLineAnimationState extends State<_ScanningLineAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.38, end: 0.58).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: 240 * _animation.value,
          left: 100,
          right: 100,
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.8),
              boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.8), blurRadius: 8)],
            ),
          ),
        );
      },
    );
  }
}

// --- 2. Camera Screen ---
class _CameraScreen extends StatelessWidget {
  final FaultReportingViewModel viewModel;
  const _CameraScreen({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Camera Preview with Tap Focus
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) {
                  final offset = details.localPosition;
                  final relativePoint = Offset(
                    offset.dx / constraints.maxWidth,
                    offset.dy / constraints.maxHeight,
                  );
                  viewModel.onFocusTap(relativePoint);
                },
                child: viewModel.isCameraInitialized && viewModel.cameraController != null
                    ? CameraPreview(viewModel.cameraController!)
                    : Container(color: Colors.black),
              ),
            ),

            // Focus Indicator Animation (Simple Box)
            if (viewModel.focusPoint != null)
              Positioned(
                left: viewModel.focusPoint!.dx * constraints.maxWidth - 35,
                top: viewModel.focusPoint!.dy * constraints.maxHeight - 35,
                child: IgnorePointer(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.8), width: 1.5),
                    ),
                  ),
                ),
              ),

            // Zoom Toggle
            if (viewModel.isCameraInitialized)
              Positioned(
                bottom: 220,
                right: 32,
                child: BaicBounceButton(
                  onPressed: () {
                    double target = (viewModel.currentZoomLevel - 1.0).abs() < 0.1 ? 2.0 : 1.0;
                    viewModel.setZoomLevel(target);
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        "${viewModel.currentZoomLevel == 1.0 ? '1' : viewModel.currentZoomLevel.toInt()}x",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ),

            // HUD Overlay
            _buildHUD(),

            // Bottom Controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black, Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BaicBounceButton(
                      onPressed: () => viewModel.pickImage(),
                      child: _buildCircleButton(LucideIcons.image),
                    ),
                    BaicBounceButton(
                      onPressed: () => viewModel.capture(),
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
                        padding: const EdgeInsets.all(4),
                        child: Container(decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                      ),
                    ),
                    BaicBounceButton(
                      onPressed: () => viewModel.navigateBack(),
                      child: _buildCircleButton(LucideIcons.x),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCircleButton(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }

  Widget _buildHUD() {
    return Stack(
      children: [
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PulseDot(),
                  SizedBox(width: 8),
                  Text('SYSTEM READY', style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'monospace', letterSpacing: 1)),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 280,
            height: 280,
            child: Stack(
              children: [
                _buildCorner(0), _buildCorner(1), _buildCorner(2), _buildCorner(3),
                const Center(child: Icon(LucideIcons.plus, color: Colors.white24, size: 32)),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 180,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              '请将故障区域或仪表盘置于框内',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCorner(int index) {
    const double size = 24.0;
    const double thickness = 2.0;
    Border? border;
    Alignment? alignment;
    switch (index) {
      case 0: border = const Border(top: BorderSide(color: Colors.white, width: thickness), left: BorderSide(color: Colors.white, width: thickness)); alignment = Alignment.topLeft; break;
      case 1: border = const Border(top: BorderSide(color: Colors.white, width: thickness), right: BorderSide(color: Colors.white, width: thickness)); alignment = Alignment.topRight; break;
      case 2: border = const Border(bottom: BorderSide(color: Colors.white, width: thickness), left: BorderSide(color: Colors.white, width: thickness)); alignment = Alignment.bottomLeft; break;
      case 3: border = const Border(bottom: BorderSide(color: Colors.white, width: thickness), right: BorderSide(color: Colors.white, width: thickness)); alignment = Alignment.bottomRight; break;
    }
    return Align(alignment: alignment!, child: Container(width: size, height: size, decoration: BoxDecoration(border: border)));
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();
  @override
  State<_PulseDot> createState() => _PulseDotState();
}
class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _controller, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)));
  }
}

// --- 3. Analyzing Screen ---
class _AnalyzingScreen extends StatelessWidget {
  final FaultReportingViewModel viewModel;
  const _AnalyzingScreen({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.brandBlack,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 背景微弱装饰
          const TireTrackBackground(),
          
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _AnalyzingAnimation(),
                const SizedBox(height: 48),
                Text(
                  '智能诊断中',
                  style: AppTypography.headingM.copyWith(
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'AI 正在云端进行视觉图像分析...',
                  style: AppTypography.captionPrimary.copyWith(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 40),
                
                // 进度条
                SizedBox(
                  width: 200,
                  height: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Stack(
                      children: [
                        Container(color: Colors.white.withOpacity(0.1)),
                        const _ShimmerBar(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyzingAnimation extends StatefulWidget {
  const _AnalyzingAnimation();
  @override
  State<_AnalyzingAnimation> createState() => _AnalyzingAnimationState();
}

class _AnalyzingAnimationState extends State<_AnalyzingAnimation> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背景脉冲圆环 1
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 80 * (1 + _pulseController.value * 0.5),
                height: 80 * (1 + _pulseController.value * 0.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3 * (1 - _pulseController.value)),
                    width: 1,
                  ),
                ),
              );
            },
          ),
          
          // 背景脉冲圆环 2
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final val = (_pulseController.value + 0.5) % 1.0;
              return Container(
                width: 80 * (1 + val * 0.5),
                height: 80 * (1 + val * 0.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2 * (1 - val)),
                    width: 1,
                  ),
                ),
              );
            },
          ),

          // 核心旋转扫描环
          RotationTransition(
            turns: _rotationController,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 40 - 2,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.white, blurRadius: 10, spreadRadius: 2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 中心图标
          const Icon(LucideIcons.scan, color: Colors.white, size: 32),
        ],
      ),
    );
  }
}

class _ShimmerBar extends StatefulWidget {
  const _ShimmerBar();
  @override
  State<_ShimmerBar> createState() => _ShimmerBarState();
}

class _ShimmerBarState extends State<_ShimmerBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(_controller.value * 2 - 1, 0),
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0),
                  Colors.white,
                  Colors.white.withOpacity(0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- 4. Result Screen (Stateful for Scroll Interaction) ---
class _ResultScreen extends StatefulWidget {
  final FaultReportingViewModel viewModel;
  const _ResultScreen({required this.viewModel});

  @override
  State<_ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<_ResultScreen> {
  final ScrollController _scrollController = ScrollController();
  double _navOpacity = 0.0;
  static const double _scrollThreshold = 180.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;
    final double opacity = (_scrollController.offset / _scrollThreshold).clamp(0.0, 1.0);
    if (opacity != _navOpacity) {
      setState(() {
        _navOpacity = opacity;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    if (viewModel.report == null) return const SizedBox.shrink();
    
    final bool isSafe = viewModel.report!.items.isEmpty;
    final FaultItem? mainFault = isSafe ? null : viewModel.report!.items.first;
    final FaultSeverity severity = mainFault?.severity ?? FaultSeverity.info;
    final bool isCritical = severity == FaultSeverity.critical;
    
    final Color statusColor = isCritical ? const Color(0xFFD93025) : 
                             (severity == FaultSeverity.warning ? const Color(0xFFF59E0B) : const Color(0xFF10B981));
    const Color bgColor = Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // 1. 固定背景图
          Positioned(
            top: 0, left: 0, right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: _buildHeaderImage(viewModel.capturedImagePath),
          ),

          // 2. 也是滚动内容
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.38),
                  
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, -10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isSafe)
                          _buildSafeStateContent()
                        else
                          _buildFaultStateContent(mainFault!, statusColor, context),

                        const SizedBox(height: 32),
                        
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 12),
                          child: Text(
                            '专属服务', 
                            style: AppTypography.captionSecondary.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textTertiary,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        _buildServiceItem(LucideIcons.phone, '联系专家', '咨询 24小时在线技术专家', () {}),
                        const SizedBox(height: 12),
                        _buildServiceItem(LucideIcons.fileText, '查看电子手册', 'BJ40 仪表盘指示灯说明书', () {}),
                        
                        const SizedBox(height: 48),
                        
                        // 免责声明
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              '声明：诊断结果仅供参考，AI 识别受光照及角度影响。若指示灯亮起，请务必咨询专业技术专家或前往门店检修以确保行车安全。',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[400],
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. 动态导航栏
          _buildDynamicNavBar(context),
        ],
      ),
    );
  }

  Widget _buildDynamicNavBar(BuildContext context) {
    final double safeAreaTop = MediaQuery.of(context).padding.top;
    
    return Positioned(
      top: 0, left: 0, right: 0,
      child: Stack(
        children: [
          Opacity(
            opacity: _navOpacity,
            child: Container(
              height: safeAreaTop + 56,
              color: Colors.white,
              padding: EdgeInsets.only(top: safeAreaTop),
              alignment: Alignment.center,
              child: Text(
                '诊断报告',
                style: AppTypography.headingS.copyWith(color: AppColors.brandBlack),
              ),
            ),
          ),
          
          SafeArea(
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  BaicBounceButton(
                    onPressed: widget.viewModel.navigateBack,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _navOpacity > 0.5 
                            ? Colors.transparent 
                            : Colors.black.withOpacity(0.3 * (1 - _navOpacity)),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.arrowLeft, 
                        color: _navOpacity > 0.5 ? AppColors.brandBlack : Colors.white, 
                        size: 24
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (_navOpacity > 0.9)
            Positioned(
              left: 0, right: 0, bottom: 0,
              child: Container(height: 0.5, color: Colors.grey[200]),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage(String? path) {
    if (path == null) return Container(color: Colors.black);
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(
          File(path),
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.4),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSafeStateContent() {
    final report = widget.viewModel.report;
    // 简单判断 summary 是否包含错误关键词
    final bool isError = report != null && (
      report.summary.contains('失败') || 
      report.summary.contains('出错') || 
      report.summary.contains('Error') ||
      report.summary.contains('无效')
    );

    if (isError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.xCircle, color: Color(0xFFD93025), size: 32),
              const SizedBox(width: 12),
              Text('诊断中断', style: AppTypography.headingL.copyWith(color: const Color(0xFFD93025))),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            report.summary, // 显示具体的错误信息
            style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.5),
          ),
          const SizedBox(height: 32),
          BaicBounceButton(
            onPressed: widget.viewModel.navigateBack,
            child: Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text('重试', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      );
    }

    // 真正的“状态良好”
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.checkCircle2, color: Color(0xFF10B981), size: 32),
            const SizedBox(width: 12),
            Text('状态良好', style: AppTypography.headingL.copyWith(color: const Color(0xFF10B981))),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          report?.summary.isNotEmpty == true ? report!.summary : '未发现异常故障灯点亮。您的爱车处于健康状态，请放心驾驶。',
          style: TextStyle(fontSize: 16, color: Colors.grey[800], height: 1.5),
        ),
        const SizedBox(height: 32),
        BaicBounceButton(
          onPressed: widget.viewModel.navigateBack,
          child: Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text('完成检测', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFaultStateContent(FaultItem item, Color statusColor, BuildContext context) {
    final bool isCritical = item.severity == FaultSeverity.critical;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isCritical ? LucideIcons.alertTriangle : LucideIcons.alertCircle, 
              color: statusColor, 
              size: 32
            ),
            const SizedBox(width: 12),
            Text(
              isCritical ? '立即停车' : '建议检修', 
              style: AppTypography.headingL.copyWith(
                color: statusColor, 
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04), // 使用更轻盈的阴影，符合品牌风格
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
            // 移除 Border.all
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '行动建议', 
                    style: TextStyle(
                      color: statusColor, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 13, 
                      letterSpacing: 1.5,
                    ),
                  ),
                  // 置信度标签
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.gauge, size: 10, color: Colors.blueGrey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '置信度 ${(item.confidence * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: Colors.blueGrey[700],
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.advice, 
                style: AppTypography.headingM.copyWith(
                  fontWeight: FontWeight.bold, 
                  color: AppColors.brandDark, 
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              
              BaicBounceButton(
                onPressed: isCritical ? widget.viewModel.navigateToRescue : widget.viewModel.navigateToDealers,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: isCritical ? const Color(0xFFD93025) : const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: (isCritical ? const Color(0xFFD93025) : const Color(0xFF111111)).withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isCritical ? LucideIcons.phoneCall : LucideIcons.mapPin, 
                        color: Colors.white, 
                        size: 20
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isCritical ? '一键呼叫道路救援' : '查找附近门店',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            '故障详情', 
            style: AppTypography.captionSecondary.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textTertiary,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
            // 移除 Border.all
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                        color: Color(0xFF111111)
                      ),
                      maxLines: 10,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  const SizedBox(width: 12),
                   Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.severity == FaultSeverity.critical ? '红色警报' : '黄色警告',
                      style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 0.5),
              const SizedBox(height: 12),
              Text(
                item.description,
                style: TextStyle(
                  fontSize: 14, 
                  color: Colors.grey[600], 
                  height: 1.6
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return BaicBounceButton(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFB),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF111111), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF111111))),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, color: Colors.grey[300], size: 20),
          ],
        ),
      ),
    );
  }
}
