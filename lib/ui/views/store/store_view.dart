// ============================================================================
// BAIC 架构规范 - 商城页面
// ============================================================================
// - ViewModel: 继承 BaicBaseViewModel
// - View: 使用 ViewModelBuilder<T>.reactive() 构建
// - 颜色: 只使用 AppColors.xxx (禁止硬编码)
// - 按钮: 必须使用 BaicBounceButton 包裹
// - 导航: 使用 viewModel.goBack() 而非 context.pop()
// ============================================================================

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:stacked/stacked.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/components/baic_ui_kit.dart';
import 'store_viewmodel.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/models/store_models.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/store_skeleton.dart';
import '../../../app/app.router.dart' as stacked_routes;

/// [StoreView] - 精品商城/改装中心主页面
/// 
/// 视觉设计标准：
/// 1. 沉浸式 (Immersive) 体验：顶部导航栏与大大幅 Hero 图片无缝融合，随滚动动态转换。
/// 2. 分类导向：采用 Tab + ScrollView 结构，支持高响应的分类切换。
/// 3. 楼层化布局：Hero 轮播 -> 定制特色位 -> 热卖榜 -> 主题商品墙。
class StoreView extends StackedView<StoreViewModel> {
  const StoreView({super.key});

  @override
  StoreViewModel viewModelBuilder(BuildContext context) => StoreViewModel();

  @override
  void onViewModelReady(StoreViewModel viewModel) {
    viewModel.init();
  }

  @override
  Widget builder(BuildContext context, StoreViewModel viewModel, Widget? child) {
    if (viewModel.isBusy) {
      return const Scaffold(
        backgroundColor: AppColors.bgCanvas,
        body: StoreSkeleton(),
      );
    }

    if (viewModel.categories.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColors.bgCanvas,
        body: Center(child: Text('暂无数据')),
      );
    }

    return _StoreViewContent(viewModel: viewModel);
  }
}


/// 商城主内容 - 使用 TabController 管理分类切换
/// 商城主内容容器：协调 TabController 切换与不同分类间的滚动偏移量管理
class _StoreViewContent extends StatefulWidget {
  final StoreViewModel viewModel;
  const _StoreViewContent({required this.viewModel});

  @override
  State<_StoreViewContent> createState() => _StoreViewContentState();
}

class _StoreViewContentState extends State<_StoreViewContent>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, ScrollController> _scrollControllers = {};
  double _scrollOffset = 0.0;

  StoreViewModel get vm => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: vm.categories.length,
      vsync: this,
    );
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    for (var c in _scrollControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTabChanged() {
    _syncScrollOffset();
  }

  void _syncScrollOffset() {
    if (_tabController.index < vm.categories.length) {
      final categoryId = vm.categories[_tabController.index].id;
      final offset = _scrollControllers[categoryId]?.hasClients == true
          ? _scrollControllers[categoryId]!.offset
          : 0.0;
      setState(() => _scrollOffset = offset);
    }
  }

  ScrollController _getScrollController(String id) {
    if (!_scrollControllers.containsKey(id)) {
      _scrollControllers[id] = ScrollController()
        ..addListener(() {
          if (_tabController.index < vm.categories.length) {
            final activeId = vm.categories[_tabController.index].id;
            if (id == activeId) {
              setState(() => _scrollOffset = _scrollControllers[id]!.offset);
            }
          }
        });
    }
    return _scrollControllers[id]!;
  }

  @override
  Widget build(BuildContext context) {
    // 根据滚动距离计算透明度和颜色
    final isScrolled = _scrollOffset > 50;
    final alpha = (_scrollOffset / 100.0).clamp(0.0, 1.0);
    
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 主内容区域
          TabBarView(
            controller: _tabController,
            physics: const BouncingScrollPhysics(),
            children: vm.categories.map((cat) {
              return _StoreCategoryContent(
                category: cat,
                scrollController: _getScrollController(cat.id),
                viewModel: vm,
              );
            }).toList(),
          ),

          // 顶部导航栏 - 渐变背景
          _buildHeader(context, alpha, isScrolled),

          // 搜索遮罩层
          if (vm.searchVisible) const _StoreSearchView(),
        ],
      ),
    );
  }


  /// 构建顶部导航栏 - 完全按照原型设计
  /// 构建极简搜索栏与购物车入口
  /// 完全根据页面滚动偏移量动态混合背景与文字颜色：
  /// - 顶部态：文字/图标纯白，搜索背景半透明深灰。
  /// - 滚动态：文字/图标变为深色文字，背景渐变为高斯模糊实色，搜索框呈激活边框态。
  Widget _buildHeader(BuildContext context, double alpha, bool isScrolled) {
    final headerBg = Color.lerp(
      AppColors.white.withOpacity(0),
      AppColors.bgCanvas.withOpacity(0.95),
      alpha,
    )!;
    
    final contentColor = Color.lerp(
      AppColors.white,
      AppColors.textTitle,
      alpha,
    )!;
    
    final unselectedColor = Color.lerp(
      AppColors.white.withOpacity(0.7),
      AppColors.textSecondary,
      alpha,
    )!;
    
    final searchBg = Color.lerp(
      AppColors.black.withOpacity(0.2),
      AppColors.white,
      alpha,
    )!;
    
    final searchIcon = Color.lerp(
      AppColors.white,
      AppColors.textTertiary,
      alpha,
    )!;
    
    final searchHint = Color.lerp(
      AppColors.white.withOpacity(0.6), // 从之前的 0.9 降低到 0.6，使其更偏灰调
      AppColors.textTertiary,
      alpha,
    )!;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: alpha * 10,
            sigmaY: alpha * 10,
          ),
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 6,
              bottom: 4,
            ),
            decoration: BoxDecoration(
              color: headerBg,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.borderPrimary.withOpacity(alpha * 0.1),
                  width: 0.5,
                ),
              ),
            ),
            child: Column(
              children: [
                // 搜索栏和购物车
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: BaicBounceButton(
                          onPressed: () => vm.openSearch(),
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: searchBg,
                                borderRadius: AppDimensions.borderRadiusFull,
                              border: isScrolled
                                  ? Border.all(
                                      color: AppColors.borderPrimary,
                                      width: 1,
                                    )
                                  : Border.all(
                                      color: AppColors.white.withOpacity(0.1),
                                      width: 1,
                                    ),
                              boxShadow: isScrolled
                                  ? [
                                      BoxShadow(
                                        color: AppColors.shadowLight,
                                        blurRadius: 14,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.search,
                                  size: 18,
                                  color: searchIcon,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '搜索商品、改装件...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: searchHint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 购物车图标
                      BaicBounceButton(
                        onPressed: () => vm.MapsTo(stacked_routes.Routes.storeCartView),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isScrolled
                                ? AppColors.white
                                : AppColors.black.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: isScrolled
                                ? Border.all(
                                    color: AppColors.borderPrimary,
                                    width: 1,
                                  )
                                : Border.all(
                                    color: AppColors.white.withOpacity(0.1),
                                    width: 1,
                                  ),
                            boxShadow: isScrolled
                                ? [
                                    BoxShadow(
                                      color: AppColors.shadowLight,
                                      blurRadius: 14,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                LucideIcons.shoppingCart,
                                size: 20,
                                color: contentColor,
                              ),
                              // 购物车角标
                              if (vm.cartItems.isNotEmpty)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: AppColors.brandOrange,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 分类标签
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 8),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    indicatorColor: contentColor,
                    labelColor: contentColor,
                    unselectedLabelColor: unselectedColor,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 3,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                    labelStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                    ),
                    dividerColor: AppColors.white.withOpacity(0),
                    tabs: vm.categories.map((c) {
                      return Tab(
                        height: 40,
                        child: Text(c.name),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/// 商城分类内容 - 完全按照原型布局
/// 分类下的瀑布流/混合楼层内容
/// 处理特定分类中的 Hero 位、金刚区图标、及商品列表渲染
class _StoreCategoryContent extends StatelessWidget {
  final StoreCategory category;
  final ScrollController scrollController;
  final StoreViewModel viewModel;

  const _StoreCategoryContent({
    required this.category,
    required this.scrollController,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: EasyRefresh(
        onRefresh: viewModel.refresh,
        header: const ClassicHeader(
          dragText: '下拉刷新',
          armedText: '释放刷新',
          readyText: '正在刷新...',
          processingText: '正在刷新...',
          processedText: '刷新完成',
          noMoreText: '没有更多',
          failedText: '刷新失败',
          messageText: '上次更新于 %T',
          textStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        child: CustomScrollView(
          controller: scrollController,
          key: PageStorageKey(category.id),
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Hero 轮播图
            SliverToBoxAdapter(
              child: _HeroCarousel(
                slides: category.slides,
                viewModel: viewModel,
              ),
            ),
            
            // 主内容区域
            SliverToBoxAdapter(
              child: Container(
                color: AppColors.bgCanvas,
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  children: [
                    // 特色功能网格
                    if (category.features != null && category.features!.isNotEmpty)
                      _FeatureGrid(
                        features: category.features!,
                        viewModel: viewModel,
                      ),
                    
                    // 热卖榜单
                    if (category.hotProducts != null && category.hotProducts!.isNotEmpty)
                      _HotSellers(
                        products: category.hotProducts!,
                        viewModel: viewModel,
                      ),
                    
                    // 主题区域
                    if (category.sections != null)
                      ...category.sections!.map((s) => _ThemeSection(
                            section: s,
                            viewModel: viewModel,
                          )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/// 沉浸式 Hero 轮播（50vh 高度适配）
/// 特性：
/// 1. 支持自动播放与手动滑动手势交互。
/// 2. 集成底部文字阴影与毛玻璃磨砂效果的操作按钮。
/// 3. 提供与品牌色调一致的长条形指示器。
class _HeroCarousel extends StatefulWidget {
  final List<HeroSlide> slides;
  final StoreViewModel viewModel;
  const _HeroCarousel({required this.slides, required this.viewModel});

  @override
  State<_HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<_HeroCarousel>
    with AutomaticKeepAliveClientMixin {
  int _currentSlide = 0;
  final PageController _pageController = PageController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // 自动轮播
    Future.delayed(const Duration(seconds: 5), _autoPlay);
  }

  void _autoPlay() {
    if (!mounted) return;
    
    // 检查是否在最后一张
    if (_currentSlide >= widget.slides.length - 1) {
      // 跳回第一张
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    } else {
      // 继续下一张
      _pageController.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
    
    Future.delayed(const Duration(seconds: 5), _autoPlay);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenHeight = MediaQuery.of(context).size.height;
    
    return SizedBox(
      height: screenHeight * 0.5, // 50vh
      child: Stack(
        children: [
          // 轮播图片
          PageView.builder(
            controller: _pageController,
            itemCount: widget.slides.length,
            onPageChanged: (index) {
              setState(() => _currentSlide = index);
            },
            itemBuilder: (context, index) {
              final slide = widget.slides[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  // 背景图片
                  CachedNetworkImage(
                    imageUrl: slide.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.brandBlack,
                    ),
                  ),
                  
                  // 渐变遮罩 - 从底部到顶部
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.bgCanvas, // 底部完全不透明
                          AppColors.white.withOpacity(0),
                          AppColors.black.withOpacity(0.3),
                        ],
                        stops: const [0.0, 0.4, 0.8],
                      ),
                    ),
                  ),
                  
                  // 底部内容区域
                  Positioned(
                    bottom: 64,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // 文字内容
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                slide.title,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      color: AppColors.black,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                slide.subtitle,
                                style: TextStyle(
                                  color: AppColors.white.withOpacity(0.9),
                                  fontSize: 13,
                                  shadows: const [
                                    Shadow(
                                      color: AppColors.black,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // 立即购买按钮
                        BaicBounceButton(
                          onPressed: () {
                            // TODO: 轮播图点击跳转
                          },
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.1),
                              borderRadius: AppDimensions.borderRadiusFull,
                              border: Border.all(
                                color: AppColors.white.withOpacity(0.5),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadowLight,
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: AppDimensions.borderRadiusFull,
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '立即购买',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      LucideIcons.arrowRight,
                                      color: AppColors.white,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          
          // 指示器
          if (widget.slides.length > 1)
            Positioned(
              bottom: 24,
              left: 20,
              child: Row(
                children: widget.slides.asMap().entries.map((entry) {
                  final isActive = _currentSlide == entry.key;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isActive ? 32 : 16,
                    height: 4,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.white
                          : AppColors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}


/// 特色功能网格 - 完全按照原型设计
/// 左侧大卡片 (row-span-2), 右侧两个小卡片
class _FeatureGrid extends StatelessWidget {
  final List<StoreFeature> features;
  final StoreViewModel viewModel;
  const _FeatureGrid({required this.features, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (features.isEmpty) return const SizedBox.shrink();
    
    final largeFeature = features.firstWhere(
      (f) => f.type == 'large',
      orElse: () => features[0],
    );
    final smallFeatures = features.where((f) => f != largeFeature).take(2).toList();

    return Container(
      height: 220,
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Row(
        children: [
          // 左侧大卡片
          Expanded(
            child: _buildFeatureCard(context, largeFeature, isLarge: true),
          ),
          
          const SizedBox(width: 12),
          
          // 右侧小卡片
          Expanded(
            child: Column(
              children: [
                if (smallFeatures.isNotEmpty)
                  Expanded(
                    child: _buildFeatureCard(context, smallFeatures[0], isLarge: false),
                  ),
                if (smallFeatures.length > 1) ...[
                  const SizedBox(height: 12),
                  Expanded(
                    child: _buildFeatureCard(context, smallFeatures[1], isLarge: false),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, StoreFeature feature, {required bool isLarge}) {
    return BaicBounceButton(
      onPressed: () {
        // TODO: 处理特色功能点击事件
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 背景图片
              CachedNetworkImage(
                imageUrl: feature.image,
                fit: BoxFit.cover,
              ),
              
              // 渐变遮罩
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: isLarge ? Alignment.topCenter : Alignment.centerLeft,
                    end: isLarge ? Alignment.bottomCenter : Alignment.centerRight,
                    colors: [
                      AppColors.white.withOpacity(0),
                      AppColors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              
              // 文字内容
              Positioned(
                bottom: isLarge ? 20 : 12,
                left: isLarge ? 20 : 12,
                right: isLarge ? 20 : 12,
                child: Column(
                  crossAxisAlignment: isLarge
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Text(
                      feature.title,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: isLarge ? 18 : 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Text(
                            feature.subtitle,
                            style: TextStyle(
                              color: AppColors.white.withOpacity(0.8),
                              fontSize: isLarge ? 12 : 10,
                            ),
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
    );
  }
}


/// 热卖榜单 - 完全按照原型设计
/// 横向滚动列表，带排名角标和收藏按钮
class _HotSellers extends StatelessWidget {
  final List<StoreProduct> products;
  final StoreViewModel viewModel;
  const _HotSellers({required this.products, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题栏
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '热卖榜单',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textTitle,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'TOP SELLING',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textTertiary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      LucideIcons.arrowRight,
                      size: 12,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 横向滚动商品列表
          SizedBox(
            height: 200,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildHotSellerCard(context, product, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotSellerCard(BuildContext context, StoreProduct product, int index) {
    return BaicBounceButton(
      onPressed: () => viewModel.navigateToProductDetail(product.id),
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品图片
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12), // 外层圆角 12
                border: Border.all(
                  color: AppColors.bgFill,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 14,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12), // 内部 Clip 圆角也必须是 12
                child: Stack(
                  children: [
                    // 商品图片
                    CachedNetworkImage(
                      imageUrl: product.image,
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                    
                    // 排名角标 (前4名)
                    if (index < 4)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: index < 3
                                ? AppColors.brandBlack
                                : AppColors.textTertiary,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Oswald',
                              ),
                            ),
                          ),
                        ),
                      ),
                    
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // 商品标题
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textTitle,
                ),
              ),
            ),
            
            const SizedBox(height: 4),
            
            // 价格
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  const Text(
                    '¥',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrice,
                      fontFamily: 'Oswald',
                    ),
                  ),
                  Text(
                    product.price.toStringAsFixed(0),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrice,
                      fontFamily: 'Oswald',
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


/// 主题区域 - 完全按照原型设计
/// Banner + 2列商品网格
class _ThemeSection extends StatelessWidget {
  final StoreSection section;
  final StoreViewModel viewModel;
  const _ThemeSection({required this.section, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Banner
          BaicBounceButton(
            onPressed: () {
              // TODO: Banner点击
            },
            child: Container(
              width: double.infinity,
              height: 160,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: section.bannerImage,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColors.brandBlack.withOpacity(0.8),
                            AppColors.white.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 24,
                      top: 0,
                      bottom: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.brandBlack,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: const Text(
                              'FEATURED COLLECTION',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            section.title.split('|')[0].trim(),
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (section.title.contains('|'))
                            Text(
                              section.title.split('|')[1].trim(),
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // 商品网格
          GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: section.products.length,
            itemBuilder: (context, index) {
              final product = section.products[index];
              return _buildProductCard(context, product);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, StoreProduct product) {
    return BaicBounceButton(
      onPressed: () => viewModel.navigateToProductDetail(product.id),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16), // 修正：从 12 改为 16，与内部图片一致
          border: Border.all(
            color: AppColors.bgFill,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 14,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品图片
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.bgFill,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: product.image,
                        fit: BoxFit.cover,
                      ),
                      
                  ],
                ),
              ),
            ),
            ),
            
            // 商品信息
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  SizedBox(
                    height: 40,
                    child: Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textTitle,
                        height: 1.4,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 价格和购物车按钮
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // 价格
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          const Text(
                            '¥',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrice,
                              fontFamily: 'Oswald',
                            ),
                          ),
                          Text(
                            product.price.toStringAsFixed(0),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrice,
                              fontFamily: 'Oswald',
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                      
                      // 购物车按钮
                      BaicBounceButton(
                        onPressed: () {
                          // TODO: 加入购物车
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.brandBlack,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowMedium,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            LucideIcons.shoppingCart,
                            size: 14,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
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


/// 搜索视图 - 完全按照原型设计
class _StoreSearchView extends StatefulWidget {
  const _StoreSearchView();

  @override
  State<_StoreSearchView> createState() => _StoreSearchViewState();
}

class _StoreSearchViewState extends State<_StoreSearchView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _close(BuildContext context) {
    _controller.reverse().then((_) {
      if (mounted) {
        // 使用 ViewModel 关闭搜索
        context.read<StoreViewModel>().closeSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StoreViewModel>();
    
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        color: AppColors.bgCanvas,
        child: Column(
          children: [
            // 搜索栏
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top.clamp(0, double.infinity),
              ),
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.borderPrimary,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: const BoxDecoration(
                        color: AppColors.bgFill,
                        borderRadius: AppDimensions.borderRadiusFull,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.search,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              autofocus: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '搜索商品',
                                hintStyle: TextStyle(fontSize: 14),
                              ),
                              style: const TextStyle(fontSize: 14),
                              onSubmitted: (val) {
                                if (val.isNotEmpty) {
                                  viewModel.addSearchHistory(val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _close(context),
                    child: const Text(
                      '取消',
                      style: TextStyle(
                        color: AppColors.textTitle,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // 搜索内容
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // 搜索历史
                  if (viewModel.searchHistory.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '搜索历史',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textTitle,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            LucideIcons.trash2,
                            size: 16,
                            color: AppColors.textTertiary,
                          ),
                          onPressed: () => viewModel.clearSearchHistory(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: viewModel.searchHistory.map((term) {
                        return BaicBounceButton(
                          onPressed: () => viewModel.addSearchHistory(term),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: AppDimensions.borderRadiusFull,
                              border: Border.all(
                                color: AppColors.borderPrimary,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              term,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                  ],
                  
                  // 热门搜索
                  const Text(
                    '热门搜索',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textTitle,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: viewModel.trendingSearches.asMap().entries.map((entry) {
                      final index = entry.key;
                      final term = entry.value;
                      final isTop3 = index < 3;
                      
                      return BaicBounceButton(
                        onPressed: () => viewModel.addSearchHistory(term),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isTop3
                                ? AppColors.brandBlack
                                : AppColors.white,
                            borderRadius: AppDimensions.borderRadiusFull,
                            border: isTop3
                                ? null
                                : Border.all(
                                    color: AppColors.borderPrimary,
                                    width: 1,
                                  ),
                          ),
                          child: Text(
                            term,
                            style: TextStyle(
                              fontSize: 13,
                              color: isTop3
                                  ? AppColors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
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
