import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' hide SkeletonLoader;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'order_list_viewmodel.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/skeleton_loader.dart';
import '../../../../core/theme/app_dimensions.dart';

/// 我的订单列表页面 - 像素级还原原型
class OrderListView extends StackedView<OrderListViewModel> {
  const OrderListView({Key? key}) : super(key: key);

  @override
  OrderListViewModel viewModelBuilder(BuildContext context) => OrderListViewModel();

  @override
  void onViewModelReady(OrderListViewModel viewModel) => viewModel.init();

  @override
  Widget builder(BuildContext context, OrderListViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: viewModel.isBusy
          ? const _SkeletonView()
          : Column(
        children: [
          // 顶部栏
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              left: 20,
              right: 20,
              bottom: 8,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                // 标题栏
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => viewModel.goBack(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                        child: const Icon(
                          LucideIcons.arrowLeft,
                          size: 24,
                          color: Color(0xFF111111),
                        ),
                      ),
                    ),
                    const Text(
                      '我的订单',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111111),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => viewModel.handleSearch(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                        child: const Icon(
                          LucideIcons.search,
                          size: 22,
                          color: Color(0xFF111111),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Tab栏
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFF9FAFB),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: viewModel.tabs.asMap().entries.map((entry) {
                      final index = entry.key;
                      final tab = entry.value;
                      final isActive = viewModel.activeTabIndex == index;
                      
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => viewModel.switchTab(index),
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              children: [
                                Text(
                                  tab,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isActive 
                                        ? const Color(0xFF111111) 
                                        : const Color(0xFF9CA3AF),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (isActive)
                                  Container(
                                    width: 20,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF111111),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // 订单列表
          Expanded(
            child: viewModel.filteredOrders.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: viewModel.filteredOrders.length + 1,
                    itemBuilder: (context, index) {
                      if (index == viewModel.filteredOrders.length) {
                        return _buildEndIndicator();
                      }
                      
                      final order = viewModel.filteredOrders[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildOrderCard(context, viewModel, order),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// 订单卡片
  Widget _buildOrderCard(BuildContext context, OrderListViewModel viewModel, Map<String, dynamic> order) {
    return GestureDetector(
      onTap: () => viewModel.navigateToOrderDetail(order),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // 订单头部
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFF9FAFB),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getOrderIcon(order['type']),
                          size: 16,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${order['type']}订单',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        LucideIcons.chevronRight,
                        size: 14,
                        color: Color(0xFFD1D5DB),
                      ),
                    ],
                  ),
                  Text(
                    order['status'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: order['status'] == '已完成'
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFFFF6B00),
                    ),
                  ),
                ],
              ),
            ),

            // 商品信息
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 商品图片
                      Container(
                        width: 85,
                        height: 85,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFF0F0F0),
                            width: 0.5,
                          ),
                        ),
                        child: order['image'] != null && order['image'].isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: order['image'],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    _getOrderIcon(order['type']),
                                    size: 32,
                                    color: const Color(0xFFD1D5DB),
                                  ),
                                ),
                              )
                            : Icon(
                                _getOrderIcon(order['type']),
                                size: 32,
                                color: const Color(0xFFD1D5DB),
                              ),
                      ),
                      const SizedBox(width: 16),
                      
                      // 商品信息
                      Expanded(
                        child: SizedBox(
                          height: 85,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order['title'],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF111111),
                                      height: 1.3,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF9FAFB),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      order['spec'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                order['date'],
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF9CA3AF),
                                  fontFamily: 'Oswald',
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // 底部操作栏
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              fontFamily: 'Oswald',
                              color: Color(0xFF111111),
                            ),
                          ),
                          Text(
                            order['price'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Oswald',
                              color: Color(0xFF111111),
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      
                      // 操作按钮
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => viewModel.handleViewInvoice(order),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
                                borderRadius: AppDimensions.borderRadiusFull,
                              ),
                              child: const Text(
                                '查看发票',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => viewModel.handlePrimaryAction(order),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF111111),
                                borderRadius: AppDimensions.borderRadiusFull,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                order['status'] == '已完成' ? '再次购买' : '详情',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
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

  /// 空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.shoppingBag,
            size: 64,
            color: const Color(0xFFE5E7EB),
          ),
          const SizedBox(height: 16),
          const Text(
            '暂无订单',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 列表结束标识
  Widget _buildEndIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          'END OF LIST',
          style: TextStyle(
            fontSize: 11,
            color: const Color(0xFFD1D5DB),
            fontFamily: 'Oswald',
            letterSpacing: 3.2,
          ),
        ),
      ),
    );
  }

  /// 获取订单类型图标
  IconData _getOrderIcon(String type) {
    switch (type) {
      case '整车':
        return LucideIcons.car;
      case '商城':
        return LucideIcons.shoppingBag;
      case '充电':
        return LucideIcons.zap;
      case '服务':
        return LucideIcons.wrench;
      default:
        return LucideIcons.shoppingBag;
    }
  }
}

class _SkeletonView extends StatelessWidget {
  const _SkeletonView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F7FA), // Keep background color
      child: SkeletonLoader(
        child: Column(
          children: [
            // 顶部栏骨架
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 20,
                right: 20,
                bottom: 8,
              ),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      SkeletonCircle(size: 40),
                      SkeletonBox(width: 100, height: 24),
                      SkeletonCircle(size: 40),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Tabs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) => 
                      const SkeletonBox(width: 60, height: 20)
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            
            // 列表骨架
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: 4,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        // Card Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                SkeletonCircle(size: 28),
                                SizedBox(width: 8),
                                SkeletonBox(width: 60, height: 16),
                              ],
                            ),
                            const SkeletonBox(width: 40, height: 16),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Card Body
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SkeletonBox(width: 85, height: 85, borderRadius: BorderRadius.all(Radius.circular(12))),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  SkeletonBox(width: 150, height: 20),
                                  SizedBox(height: 12),
                                  SkeletonBox(width: 100, height: 16),
                                  SizedBox(height: 12),
                                  SkeletonBox(width: 80, height: 14),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SkeletonBox(width: 60, height: 24),
                            Row(
                              children: const [
                                SkeletonBox(width: 80, height: 32, borderRadius: BorderRadius.all(Radius.circular(12))),
                                SizedBox(width: 12),
                                SkeletonBox(width: 80, height: 32, borderRadius: BorderRadius.all(Radius.circular(12))),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
