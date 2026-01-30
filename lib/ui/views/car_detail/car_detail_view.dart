import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' hide SkeletonLoader;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/skeleton_loader.dart';
import 'package:car_owner_app/core/models/car_model.dart';
import 'package:car_owner_app/core/theme/app_dimensions.dart';
import 'package:car_owner_app/core/theme/app_typography.dart';
import 'package:car_owner_app/core/components/baic_ui_kit.dart';
import 'package:car_owner_app/core/shared/widgets/optimized_image.dart';
import 'car_detail_viewmodel.dart';

/// [CarDetailView] - 车型沉浸式详情展示视图
/// 采用了动态滚动视差效果、沉浸式 Header 以及丰富的富媒体展示块。
class CarDetailView extends StackedView<CarDetailViewModel> {
  final CarModel car; // 页面所需的车型基础数据

  const CarDetailView({
    super.key,
    required this.car,
  });

  @override
  CarDetailViewModel viewModelBuilder(BuildContext context) => CarDetailViewModel();

  @override
  void onViewModelReady(CarDetailViewModel viewModel) {
    viewModel.init(car);
  }

  @override
  Widget builder(
    BuildContext context,
    CarDetailViewModel viewModel,
    Widget? child,
  ) {
    // 遵循铁律 13：数据加载中展示高度还原的骨架屏
    if (viewModel.isBusy) {
      return const _SkeletonView();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main Content
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                final offset = notification.metrics.pixels;
                final progress = (offset / 300).clamp(0.0, 1.0);
                viewModel.updateScrollProgress(progress, offset);
              }
              return false;
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroSection(context, viewModel),
                  _DiscoveryScrollReveal(
                    child: _buildQuickSpecs(viewModel),
                  ),
                  _DiscoveryScrollReveal(
                    child: _buildSpaceBlueprint(viewModel),
                  ),
                  _DiscoveryScrollReveal(
                    child: _buildDesignAesthetic(viewModel),
                  ),
                  _DiscoveryScrollReveal(
                    child: _buildCustomizationKits(viewModel),
                  ),
                  _DiscoveryScrollReveal(
                    child: _buildFramelessDoors(viewModel),
                  ),
                  _DiscoveryScrollReveal(
                    child: _buildCabinCarousel(viewModel),
                  ),
                  _DiscoveryScrollReveal(
                    child: _buildImmersiveVideo(viewModel),
                  ),
                ],
              ),
            ),
          ),

          // Header
          _buildImmersiveHeader(viewModel),

          // Bottom Bar
          _buildBottomFloatingBar(viewModel),
        ],
      ),
    );
  }

  /// 构建沉浸式头部导航栏，随页面滚动由透明渐变为白色。
  Widget _buildImmersiveHeader(CarDetailViewModel viewModel) {
    final progress = viewModel.scrollProgress;
    final isDark = progress < 0.5;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        padding: const EdgeInsets.fromLTRB(20, 54, 20, 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(progress),
          border: Border(
            bottom: BorderSide(
              color: Colors.black.withOpacity(progress > 0.9 ? 0.05 : 0),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BaicBounceButton(
              onPressed: viewModel.navigateBack,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? Colors.black.withOpacity(0.2) : Colors.grey[100],
                ),
                child: Icon(
                  LucideIcons.arrowLeft,
                  color: isDark ? Colors.white : const Color(0xFF111111),
                  size: 20,
                ),
              ),
            ),
            Opacity(
              opacity: progress,
              child: Text(
                '${viewModel.car?.name ?? ""} 详情',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ),
            BaicBounceButton(
              onPressed: viewModel.share,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? Colors.black.withOpacity(0.2) : Colors.grey[100],
                ),
                child: Icon(
                  LucideIcons.share2,
                  color: isDark ? Colors.white : const Color(0xFF111111),
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建首屏 Hero 视觉区域，包含大图、名称、副标题及价格信息。
  Widget _buildHeroSection(BuildContext context, CarDetailViewModel viewModel) {
    if (viewModel.car == null) return const SizedBox.shrink();
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final bottomPadding = mediaQuery.padding.bottom;
    // 底部工具栏高度由 padding(16+44=60) + 内容确定。通常约 108-110px (含安全区)。
    // 这里精确计算：屏幕高度 - 工具栏容器 padding - 底部安全区
    final heroHeight = screenHeight - 60 - bottomPadding;
    
    return SizedBox(
      height: heroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const OptimizedImage(
            imageUrl: "https://p.sda1.dev/29/dbaf76958fd40c38093331ef8952ef36/7a5f657b4c35395b6f910b6c1933da20.jpg",
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: const Text(
                      'MASTERPIECE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.car!.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    viewModel.car!.subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 6),
                        child: Text(
                          '¥',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${viewModel.car!.price}',
                        style: AppTypography.dataDisplayXL.copyWith(
                          color: Colors.white, 
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          viewModel.car!.priceUnit ?? '万',
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: _AnimatedScrollIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建核心性能指标模块（如扭矩、变速箱、离地间隙）。
  Widget _buildQuickSpecs(CarDetailViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSpecItem("380", "N·m", "最大扭矩"),
              Container(width: 1, height: 32, color: Colors.grey[100]),
              _buildSpecItem("8AT", "", "变速箱"),
              Container(width: 1, height: 32, color: Colors.grey[100]),
              _buildSpecItem("220", "mm", "离地间隙"),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey[100]),
        ],
      ),
    );
  }

  Widget _buildSpecItem(String value, String unit, String label) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// 构建车身尺寸与平滑空间蓝图展示。
  Widget _buildSpaceBlueprint(CarDetailViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '黄金比例，\n越野空间学。',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
              ),
              SizedBox(height: 8),
              Text(
                '2745mm 超长轴距，为您提供宽适驾乘体验。',
                style: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          color: const Color(0xFFF5F7FA),
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _GridPainter(),
                ),
              ),
              Column(
                children: [
                  Container(
                    height: 220,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const OptimizedImage(
                          imageUrl: "https://p.sda1.dev/29/0c0cc4449ea2a1074412f6052330e4c4/63999cc7e598e7dc1e84445be0ba70eb-Photoroom.png",
                          fit: BoxFit.contain,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(width: 1.5, height: 12, color: Colors.black.withOpacity(0.4)),
                                  Expanded(child: Container(height: 1, color: Colors.black.withOpacity(0.4))),
                                  Container(width: 1.5, height: 12, color: Colors.black.withOpacity(0.4)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '4790 mm',
                                style: TextStyle(
                                  fontFamily: 'Oswald',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(LucideIcons.moveHorizontal, size: 14, color: Color(0xFFFF6B00)),
                                    SizedBox(width: 4),
                                    Text('车宽', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text('1940', style: AppTypography.dataDisplayXL.copyWith(fontSize: 30, color: const Color(0xFF111111))),
                                    const SizedBox(width: 4),
                                    const Text('mm', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(width: 1, color: Colors.grey[200]),
                          Expanded(
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(LucideIcons.maximize2, size: 14, color: Color(0xFFFF6B00)),
                                    SizedBox(width: 4),
                                    Text('容积', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text('1120', style: AppTypography.dataDisplayXL.copyWith(fontSize: 30, color: const Color(0xFF111111))),
                                    const SizedBox(width: 4),
                                    const Text('L', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 64),
      ],
    );
  }

  /// 构建外观设计/美学细节块。
  Widget _buildDesignAesthetic(CarDetailViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '经典外观，\n致敬传奇。',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          height: 500,
          width: double.infinity,
          decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const OptimizedImage(
                imageUrl: "https://youke3.picui.cn/s1/2026/01/07/695dd9e808861.jpeg",
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 32,
                left: 32,
                right: 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 40, height: 4, color: const Color(0xFFFF6B00)),
                    const SizedBox(height: 16),
                    const Text(
                      '一体式高强度防滚架',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '赛车级安全防护标准，为越野保驾护航。高强度钢材构建坚固堡垒。',
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 64),
      ],
    );
  }

  /// 构建官方改装套件/个性化配置模块。
  Widget _buildCustomizationKits(CarDetailViewModel viewModel) {
    final modKits = [
      { 'name': '雨林穿越版', 'image': 'https://youke3.picui.cn/s1/2026/01/07/695df03c5243a.jpg', 'tags': ['涉水喉', 'MT胎'] },
      { 'name': '黑武士版', 'image': 'https://youke3.picui.cn/s1/2026/01/07/695df06febd20.jpg', 'tags': ['全黑涂装', '升高'] },
      { 'name': '荒野露营版', 'image': 'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=600&auto=format&fit=crop', 'tags': ['车顶帐篷', '侧帐'] },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '百变改装，\n千人千面。',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: modKits.length,
            itemBuilder: (context, index) {
              final kit = modKits[index];
              return Container(
                width: MediaQuery.of(context).size.width * 0.85,
                margin: const EdgeInsets.only(right: 4),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    OptimizedImage(
                      imageUrl: kit['image'] as String,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 24,
                      left: 24,
                      right: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFF6B00)),
                                child: const Icon(LucideIcons.wrench, color: Colors.white, size: 12),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'OFFICIAL KIT',
                                style: TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            kit['name'] as String,
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: (kit['tags'] as List<String>).map((tag) => Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Text(tag, style: const TextStyle(color: Colors.white70, fontSize: 10)),
                            )).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 64),
      ],
    );
  }

  /// 构建无框车门等亮点配置说明。
  Widget _buildFramelessDoors(CarDetailViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '无框车门，\n先锋美学。',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
          ),
        ),
        const SizedBox(height: 24),
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const OptimizedImage(
                imageUrl: "https://img.pcauto.com.cn/images/ttauto/2023/11/30/7306806780938715688/9619c2693aaa41bd95316e48118eb0a7.png",
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 32,
                left: 32,
                right: 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 40, height: 4, color: const Color(0xFFFF6B00)),
                    const SizedBox(height: 16),
                    const Text(
                      '同级罕见无框设计',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '打破传统越野定义，融合跑车设计元素。双层夹胶玻璃，在展现极致个性的同时，静谧性依然出色。',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 64),
      ],
    );
  }

  /// 构建智能座舱/内饰交互轮播图。
  Widget _buildCabinCarousel(CarDetailViewModel viewModel) {
    final features = [
      { "title": "五屏联动智能座舱", "desc": "由双10.25英寸联屏与中控屏组成，支持多指飞屏操作，将越野路况、导航信息实时流转。", "image": "https://images.unsplash.com/photo-1550009158-9ebf69173e03?q=80&w=800&auto=format&fit=crop" },
      { "title": "女王副驾，尊享体验", "desc": "配备电动腿托与零重力模式，支持12向电动调节、通风、加热及按摩功能。", "image": "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=800&auto=format&fit=crop" },
      { "title": "丹拿高保真音响", "desc": "12扬声器环绕音响系统，配合ANC主动降噪技术，隔绝车外喧嚣。", "image": "https://images.unsplash.com/photo-1583267746897-2cf415887172?q=80&w=800&auto=format&fit=crop" }
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '智能座舱，\n越野亦从容。',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
          ),
        ),
        const SizedBox(height: 24),
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Stack(
            children: [
              PageView.builder(
                onPageChanged: viewModel.setActiveFeatureIndex,
                itemCount: features.length,
                itemBuilder: (context, index) {
                  final feat = features[index];
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      OptimizedImage(imageUrl: feat['image']!, fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 32,
                        left: 32,
                        right: 32,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feat['title']!,
                              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              feat['desc']!,
                              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14, fontWeight: FontWeight.w500, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              Positioned(
                top: 24,
                right: 24,
                child: Row(
                  children: List.generate(features.length, (index) {
                    final isActive = viewModel.activeFeatureIndex == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isActive ? 24 : 8,
                      height: 4,
                      margin: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.white : Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 64),
      ],
    );
  }

  Widget _buildImmersiveVideo(CarDetailViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '全地形征服者。',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 24),
        BaicBounceButton(
          onPressed: viewModel.toggleVideoPlay,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const OptimizedImage(
                  imageUrl: "https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=800&auto=format&fit=crop",
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.black.withOpacity(0.2),
                ),
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: const Icon(LucideIcons.play, color: Colors.white, size: 28),
                  ),
                ),
                const Positioned(
                  bottom: 24,
                  right: 24,
                  child: Text(
                    '00:45',
                    style: TextStyle(fontFamily: 'Oswald', color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildBottomFloatingBar(CarDetailViewModel viewModel) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 44),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[100]!, width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 30,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PRICE STARTS',
                      style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Text('¥', style: TextStyle(color: Color(0xFFFF6B00), fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 2),
                        Text(
                          '${viewModel.car?.price ?? "---"}',
                          style: AppTypography.dataDisplayL.copyWith(fontSize: 28, color: const Color(0xFF111111)),
                        ),
                        const SizedBox(width: 4),
                        const Text('万', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: BaicBounceButton(
                          onPressed: viewModel.navigateToTestDrive,
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: AppDimensions.borderRadiusFull,
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '预约试驾',
                              style: TextStyle(color: Color(0xFF111111), fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BaicBounceButton(
                          onPressed: viewModel.navigateToOrder,
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF111111),
                              borderRadius: AppDimensions.borderRadiusFull,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '立即定购',
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
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
    );
  }

}

class _DiscoveryScrollReveal extends StatefulWidget {
  final Widget child;

  const _DiscoveryScrollReveal({required this.child});

  @override
  State<_DiscoveryScrollReveal> createState() => _DiscoveryScrollRevealState();
}

class _DiscoveryScrollRevealState extends State<_DiscoveryScrollReveal> with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 64), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkVisibility() {
    if (_isVisible) return;
    
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) return;

    final position = renderObject.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    // Trigger when top of element is 50px above the bottom of the screen
    if (position.dy < screenHeight - 50) {
      setState(() {
        _isVisible = true;
      });
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    // We check visibility on every build until it's visible.
    // In a real app, a NotificationListener or VisibilityDetector is better,
    // but this fits within our self-contained class structure.
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _AnimatedScrollIndicator extends StatefulWidget {
  const _AnimatedScrollIndicator();

  @override
  State<_AnimatedScrollIndicator> createState() => _AnimatedScrollIndicatorState();
}

class _AnimatedScrollIndicatorState extends State<_AnimatedScrollIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: const Icon(
            LucideIcons.chevronDown,
            color: Colors.white54,
            size: 28,
          ),
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.03)
      ..strokeWidth = 1;

    const step = 30.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SkeletonView extends StatelessWidget {
  const _SkeletonView();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SkeletonLoader(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(height: 600, width: screenWidth, borderRadius: BorderRadius.zero),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(child: SkeletonBox(height: 60, width: (screenWidth - 72) / 3)),
                    const SizedBox(width: 12),
                    Expanded(child: SkeletonBox(height: 60, width: (screenWidth - 72) / 3)),
                    const SizedBox(width: 12),
                    Expanded(child: SkeletonBox(height: 60, width: (screenWidth - 72) / 3)),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: SkeletonBox(height: 40, width: 200),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: SkeletonBox(height: 20, width: 300),
              ),
              const SizedBox(height: 32),
              SkeletonBox(height: 300, width: screenWidth, borderRadius: BorderRadius.zero),
            ],
          ),
        ),
      ),
    );
  }
}