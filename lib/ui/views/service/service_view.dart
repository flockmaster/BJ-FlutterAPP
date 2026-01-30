import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:stacked/stacked.dart';
import 'dart:ui';
import 'service_viewmodel.dart';
import 'maintenance_booking_view.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_dimensions.dart';
import 'package:car_owner_app/core/shared/widgets/service/core_services_grid.dart';
import 'package:car_owner_app/core/shared/widgets/service/vehicle_card.dart';
import 'package:car_owner_app/core/shared/widgets/service/charging_service.dart';
import 'package:car_owner_app/core/shared/widgets/service/nearby_stores.dart';
import 'package:car_owner_app/core/shared/widgets/service/travel_services.dart';
import 'package:car_owner_app/core/shared/widgets/service/used_car_service.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/service_skeleton.dart';

/// [ServiceView] - 服务中心（用车/维保/充电看板）主页面入口
/// 
/// 核心特性：
/// 1. 业务聚合：将道路救援、故障报修、保养预约整合为顶部高权重入口。
/// 2. 实时控车：针对已登录并绑车的用户展示车辆电量/续航动态卡片。
/// 3. 门店直达：根据用户位置动态渲染附近的充电站与服务门店。
class ServiceView extends StatelessWidget {
  const ServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ServiceViewModel>.reactive(
      viewModelBuilder: () => ServiceViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) => _ServiceViewContent(viewModel: viewModel),
    );
  }
}

class _ServiceViewContent extends StatefulWidget {
  final ServiceViewModel viewModel;
  
  const _ServiceViewContent({required this.viewModel});

  @override
  State<_ServiceViewContent> createState() => _ServiceViewContentState();
}

class _ServiceViewContentState extends State<_ServiceViewContent> {
  final ScrollController _scrollController = ScrollController();
  double _headerOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// 滚动性能优化监听：
  /// 基于滚动偏移量计算顶部“沉浸式毛玻璃导航栏”的模糊度与背景色深浅，
  /// 确保页面内容在背景转换时保持极佳的阅读舒适度。
  void _onScroll() {
    final scrollTop = _scrollController.offset;
    final opacity = (scrollTop / 50).clamp(0.0, 1.0);
    if (opacity != _headerOpacity) {
      setState(() {
        _headerOpacity = opacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Stack(
        children: [
          // 内容区域
          widget.viewModel.isBusy
              ? ServiceSkeleton()
              : EasyRefresh(
                  onRefresh: widget.viewModel.refresh,
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
                      controller: _scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 100, bottom: 100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 楼层 1: 核心业务金刚位 (救援/报修/保养)
                                CoreServicesGrid(
                                  onRescueTap: () => widget.viewModel.handleRescueTap(),
                                  onRepairTap: () => widget.viewModel.handleRepairTap(),
                                  onMaintenanceTap: () => widget.viewModel.handleMaintenanceTap(),
                                ),
                                AppDimensions.spaceML.verticalSpace,
                                
                                // 楼层 2: 车辆状态仪表盘 (仅针对认证车主展示)
                                if (widget.viewModel.isLoggedIn && widget.viewModel.hasVehicle) ...[
                                  VehicleCard(
                                    vehicleInfo: widget.viewModel.vehicleInfo,
                                    isExpanded: widget.viewModel.isVehicleExpanded,
                                    isLoggedIn: widget.viewModel.isLoggedIn,
                                    onToggle: () => widget.viewModel.toggleVehicleExpansion(),
                                    onLoginTap: () => widget.viewModel.navigateToLogin(),
                                  ),
                                  AppDimensions.spaceML.verticalSpace,
                                ],

                                // 楼层 3: 充电无忧专区
                                ChargingService(
                                  onMapTap: () => widget.viewModel.handleChargingMapTap(),
                                  onScanTap: () => widget.viewModel.handleScanChargeTap(),
                                ),
                                AppDimensions.spaceML.verticalSpace,

                                // 楼层 4: 附近门店精选
                                NearbyStores(
                                  stores: widget.viewModel.nearbyStores,
                                  onViewAllTap: () => widget.viewModel.handleViewAllStoresTap(),
                                ),
                                AppDimensions.spaceML.verticalSpace,

                                // 楼层 5: 增值出行服务
                                const TravelServices(),
                                AppDimensions.spaceML.verticalSpace,

                                // 楼层 6: 二手车换购入口
                                UsedCarService(
                                  onTap: () => widget.viewModel.handleUsedCarTap(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ),

          // 顶部导航栏
          _buildHeader(),

          // 悬浮客服按钮
          _buildFloatingButton(),
        ],
      ),
    );
  }

  /// 构建顶部导航栏 (采用 BackdropFilter 实现 iOS 风格的毛玻璃模糊，适配深浅色背景)
  Widget _buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: _headerOpacity * 10,
            sigmaY: _headerOpacity * 10,
          ),
          child: Container(
            height: 100,
            padding: EdgeInsets.fromLTRB(
              AppDimensions.spaceML,
              54,
              AppDimensions.spaceML,
              10,
            ),
            decoration: BoxDecoration(
              color: AppColors.bgSurface.withOpacity(0.95 * _headerOpacity),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.borderPrimary.withOpacity(0.1 * _headerOpacity),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '服务',
                  style: AppTypography.headingL.copyWith(
                    color: AppColors.brandDark,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                IconButton(
                  onPressed: () => widget.viewModel.handleSupportTap(),
                  icon: const Icon(LucideIcons.headphones, color: AppColors.brandDark, size: 24),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingButton() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: GestureDetector(
        onTap: () => widget.viewModel.handleSupportTap(),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.brandDark,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(LucideIcons.headphones, color: AppColors.textInverse, size: 22),
        ),
      ),
    );
  }
}
