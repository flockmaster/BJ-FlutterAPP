import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:stacked/stacked.dart';
import '../../../app/routes.dart';
import '../../../core/extensions/context_extensions.dart';
import 'package:car_owner_app/core/shared/widgets/optimized_image.dart';
import 'package:car_owner_app/core/shared/widgets/car_buying/single_car_scroll_view.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/car_buying_skeleton.dart';
import 'car_buying_viewmodel.dart';
import '../../common/ui_converters.dart'; // Import UI Converters
import '../../../core/theme/app_typography.dart';
import '../../../core/components/consultant_modal.dart';

/// [CarBuyingView] - 购车频道主页面
/// 
/// 核心功能：
/// 1. 沉浸式多车型切换展示（采用 [TabBarView] + [SingleCarScrollView]）。
/// 2. 动态底部悬浮栏：根据滚动方向自动显隐，提供“立即定购”核心入口。
/// 3. 集成一键拨号（产品顾问）、门店查找及参数对比。
class CarBuyingView extends StackedView<CarBuyingViewModel> {
  const CarBuyingView({super.key});

  @override
  CarBuyingViewModel viewModelBuilder(BuildContext context) => CarBuyingViewModel();

  @override
  void onViewModelReady(CarBuyingViewModel viewModel) {
    viewModel.init();
  }

  @override
  Widget builder(
    BuildContext context,
    CarBuyingViewModel viewModel,
    Widget? child,
  ) {
    // We delegate to a StatefulWidget to handle TabController logic,
    // which is view-specific and hard to move fully to ViewModel without services.
    return _CarBuyingContent(viewModel: viewModel);
  }
}

/// 处理页面内部状态（如 Tab 控制、滚动监听动态显隐 UI 元素）的具体实现类
class _CarBuyingContent extends StatefulWidget {
  final CarBuyingViewModel viewModel;
  const _CarBuyingContent({required this.viewModel});

  @override
  State<_CarBuyingContent> createState() => _CarBuyingContentState();
}

class _CarBuyingContentState extends State<_CarBuyingContent> with TickerProviderStateMixin {
  TabController? _tabController;
  bool _showFloatingBar = false;
  int _currentCarIndex = 0;

  CarBuyingViewModel get viewModel => widget.viewModel;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (viewModel.isBusy && viewModel.isEmpty) {
      return Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: CarBuyingSkeleton(),
      );
    }

    if (viewModel.hasError) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "数据加载失败:\n${viewModel.modelError}",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    }

    if (viewModel.carModels.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Center(child: Text("暂无车型数据")),
      );
    }

    // Initialize or Update TabController if data changes
    if (_tabController == null || _tabController!.length != viewModel.carModels.length) {
      _tabController?.dispose();
      _tabController = TabController(length: viewModel.carModels.length, vsync: this);
      _tabController!.addListener(() {
        if (_tabController!.index != _currentCarIndex) {
          setState(() {
            _currentCarIndex = _tabController!.index;
          });
        }
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          /// 核心滚动监听器：
          /// 实现逻辑：当用户向上滚动（Delta < 0）时隐藏底部工具栏，
          /// 当滚动接近底部（距离小于阈值）或向下滚动超过安全区时显示工具栏。
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              // 仅处理垂直方向的主要内容滚动，忽略 NestedScrollView 的头部微调
              if (notification.metrics.axis != Axis.vertical) return false;
              if (notification.metrics.maxScrollExtent < 500) return false;

              if (notification is ScrollUpdateNotification) {
                final double distanceToBottom = notification.metrics.extentAfter;
                // Range 900-1000 logic: If within bottom 100px, FORCE SHOW.
                // This prevents hiding when bouncing at bottom or small adjustments.
                if (distanceToBottom < 100) {
                  if (!_showFloatingBar) {
                    setState(() => _showFloatingBar = true);
                  }
                  return false;
                }

                // Delta < 0 means scrolling UP (towards top)
                final isScrollingUp = notification.scrollDelta != null && notification.scrollDelta! < 0;
                const double activationThreshold = 300.0;

                if (isScrollingUp) {
                  // User rule: "Reverse then hide" (only if outside safe zone)
                  if (_showFloatingBar) {
                    setState(() => _showFloatingBar = false);
                  }
                } else {
                  // Scrolling DOWN
                  if (distanceToBottom < activationThreshold) {
                    if (!_showFloatingBar) {
                      setState(() => _showFloatingBar = true);
                    }
                  } else {
                    if (_showFloatingBar) {
                      setState(() => _showFloatingBar = false);
                    }
                  }
                }
              }
              return false;
            },
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
                textStyle: TextStyle(color: Color(0xFF666666), fontSize: 13),
              ),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 120,
                      backgroundColor: const Color(0xFFF5F5F5),
                      floating: true,
                      pinned: true,
                      elevation: 0,
                      flexibleSpace: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: FlexibleSpaceBar(
                            titlePadding: const EdgeInsets.only(left: 20, bottom: 64),
                            title: const Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                '选择车型',
                                style: TextStyle(
                                  color: Color(0xFF1A1A1A),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            background: Container(
                              color: const Color(0xFFF5F5F5),
                            ),
                          ),
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(54),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(bottom: 6),
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            labelColor: Colors.white,
                            unselectedLabelColor: const Color(0xFF666666),
                            indicatorSize: TabBarIndicatorSize.label,
                            dividerColor: Colors.transparent,
                            indicator: const BoxDecoration(),
                            labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                            tabAlignment: TabAlignment.start,
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                            tabs: viewModel.carModels.asMap().entries.map((entry) {
                              final index = entry.key;
                              final car = entry.value;
                              final isSelected = _currentCarIndex == index;
                              return Tab(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: isSelected ? const Color(0xFF1A1A1A) : const Color(0xFFEEF0F4),
                                    boxShadow: isSelected ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ] : null,
                                  ),
                                  child: Text(
                                    car.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isSelected ? Colors.white : const Color(0xFF666666),
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: viewModel.carModels.map((car) {
                    return SingleCarScrollView(
                      car: car,
                      onOrder: () => viewModel.navigateToCarOrder(car), 
                      onTestDrive: () => viewModel.navigateToTestDrive(car), // 使用 ViewModel 处理导航逻辑
                      onDetail: () => viewModel.navigateToCarDetail(car),
                      onAllStores: () => viewModel.navigateToNearbyStores(),
                      onCompare: () => viewModel.navigateToCarCompare(car), // 新增：车型对比导航
                      onConsultant: () => ConsultantModal.show(context, carName: car.name),
                      key: PageStorageKey<String>(car.id), // Preserve scroll position
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          
          // [底部悬浮操作栏]
          // 采用 AnimatedPositioned 实现平滑的上下滑入滑出动画效果
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _showFloatingBar ? 0 : -100,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Promo info
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '现在定购，最高可享优惠',
                                style: AppTypography.captionSecondary,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                viewModel.carModels.isNotEmpty && _currentCarIndex < viewModel.carModels.length 
                                    ? viewModel.carModels[_currentCarIndex].promoPrice ?? '限时优惠'
                                    : '',
                                style: AppTypography.dataDisplayM.copyWith(
                                  color: const Color(0xFFC18E58),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Buttons
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: OutlinedButton(
                                  onPressed: () => viewModel.navigateToCarSpecs(viewModel.carModels[_currentCarIndex]),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF1A1A1A),
                                    side: const BorderSide(color: Color(0xFF1A1A1A)),
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    minimumSize: const Size(0, 40),
                                  ),
                                  child: const Text('参数配置', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (viewModel.carModels.isNotEmpty && _currentCarIndex < viewModel.carModels.length) {
                                      viewModel.navigateToCarOrder(viewModel.carModels[_currentCarIndex]);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1A1A1A),
                                    foregroundColor: Colors.white,
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    minimumSize: const Size(0, 40),
                                  ),
                                  child: const Text('立即定购', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
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
            ),
        ],
      ),
    );
  }
}

