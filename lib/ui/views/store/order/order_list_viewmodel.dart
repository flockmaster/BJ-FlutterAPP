import 'package:flutter/material.dart'; // Keeping for Color/TextStyle in Dialog, though VM shouldn't have widget code, we'll fix later
import 'package:stacked/stacked.dart'; // Keeping for BaseViewModel compat if needed, but we use BaicBaseViewModel
import 'package:car_owner_app/core/base/baic_base_view_model.dart';
import '../../../../app/app.router.dart' as stacked_routes;
import 'order_detail_view.dart'; // Removed dependency on View import logic if possible

/// 订单列表 ViewModel
class OrderListViewModel extends BaicBaseViewModel {
  // navigationService available from base

  // Tab列表
  final List<String> tabs = ['全部', '整车', '商城', '充电', '服务'];
  
  // 当前激活的Tab索引
  int _activeTabIndex = 0;
  int get activeTabIndex => _activeTabIndex;

  // 所有订单数据
  List<Map<String, dynamic>> _allOrders = [];
  
  // 过滤后的订单
  List<Map<String, dynamic>> get filteredOrders {
    if (_activeTabIndex == 0) {
      return _allOrders;
    }
    final selectedTab = tabs[_activeTabIndex];
    return _allOrders.where((order) => order['type'] == selectedTab).toList();
  }

  /// 初始化
  Future<void> init() async {
    setBusy(true);
    await _loadOrders();
    setBusy(false);
  }

  /// 加载订单数据
  Future<void> _loadOrders() async {
    // 模拟网络请求延迟
    await Future.delayed(const Duration(milliseconds: 500));
    
    // 模拟订单数据
    _allOrders = [
      {
        'id': 'ord_car_1',
        'type': '整车',
        'status': '排产中',
        'title': '北京BJ40 城市猎人版',
        'spec': '极夜黑 · 酷黑内饰',
        'price': '159,800',
        'image': 'https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=200&auto=format&fit=crop',
        'date': '2024-01-10',
      },
      {
        'id': 'ord_mall_1',
        'type': '商城',
        'status': '已发货',
        'title': '户外露营天幕帐篷',
        'spec': '象牙白 · 大号',
        'price': '899',
        'image': 'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=200&auto=format&fit=crop',
        'date': '2024-01-12',
      },
      {
        'id': 'ord_chg_1',
        'type': '充电',
        'status': '已完成',
        'title': '特来电充电站(SOHO)',
        'spec': '42.5 kWh · 快充',
        'price': '54.20',
        'image': '',
        'date': '2024-01-08',
      },
      {
        'id': 'ord_srv_1',
        'type': '服务',
        'status': '待使用',
        'title': '专业保养套餐',
        'spec': '含机油机滤 · 全车检测',
        'price': '599',
        'image': 'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?q=80&w=200&auto=format&fit=crop',
        'date': '2024-01-15',
      },
      {
        'id': 'ord_mall_2',
        'type': '商城',
        'status': '已完成',
        'title': '车载冰箱 · 双温区',
        'spec': '黑色 · 30L',
        'price': '1,299',
        'image': 'https://images.unsplash.com/photo-1585909695284-32d2985ac9c0?q=80&w=200&auto=format&fit=crop',
        'date': '2024-01-05',
      },
    ];
    
    notifyListeners();
  }

  /// 切换Tab
  void switchTab(int index) {
    _activeTabIndex = index;
    notifyListeners();
  }

  /// 处理搜索
  void handleSearch() {
    debugPrint('搜索订单');
  }

  /// 导航到订单详情
  void navigateToOrderDetail(Map<String, dynamic> order) {
    // 只有商城订单才跳转到详情页
    if (order['type'] == '商城') {
      final orderPrice = double.tryParse(order['price'].replaceAll(',', '')) ?? 0.0;
      
      MapsTo(
        stacked_routes.Routes.orderDetailView,
        arguments: stacked_routes.OrderDetailViewArguments(
          orderId: order['id'],
          orderType: 'physical',
          items: [
            {
              // Using a simple Map for product representation to pass serializable args
              // Ideally should exist a Product model logic here
              'product': {
                 'title': order['title'],
                 'image': order['image'],
                 'price': orderPrice,
              },
              'spec': order['spec'],
              'quantity': 1,
            }
          ],
          totalAmount: orderPrice,
          paymentMethod: 'wechat',
          productTotal: orderPrice,
          shippingFee: 0.0,
          couponDiscount: 0.0,
          pointsDiscount: 0.0,
          rewardPoints: 0,
          pointsUsed: 0,
          invoiceMode: 'none',
        ),
      );
    } else {
      // 其他类型订单暂时只显示提示
      debugPrint('查看${order['type']}订单详情: ${order['id']}');
    }
  }

  /// 查看发票
  void handleViewInvoice(Map<String, dynamic> order) {
    debugPrint('查看发票: ${order['id']}');
  }

  /// 处理主要操作（详情/再次购买）
  void handlePrimaryAction(Map<String, dynamic> order) {
    if (order['status'] == '已完成') {
      // 再次购买
      debugPrint('再次购买: ${order['id']}');
    } else {
      // 查看详情
      navigateToOrderDetail(order);
    }
  }
}
