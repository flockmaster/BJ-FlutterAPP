import 'package:flutter/material.dart'; // Keeping for TickerProviderStateMixin if needed, or Color, but Context is banned
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart' as stacked_routes;
import '../../../../app/routes.dart'; // Legacy routes if needed
import '../../../../core/models/user_address.dart';
import '../../../../core/services/address_service.dart';
import 'package:car_owner_app/core/base/baic_base_view_model.dart'; // Core Base
import '../../../../app/app.bottomsheets.dart'; // Import BottomSheetType for UI restoration

enum CheckoutStep { confirm, paying, success }

class StoreCheckoutViewModel extends BaicBaseViewModel {
  final _addressService = locator<IAddressService>();
  final _bottomSheetService = locator<BottomSheetService>(); // For payment sheet

  final List<Map<String, dynamic>> items;
  
  StoreCheckoutViewModel({required this.items});

  CheckoutStep _step = CheckoutStep.confirm;
  CheckoutStep get step => _step;

  UserAddress? _selectedAddress;
  UserAddress? get selectedAddress => _selectedAddress;

  String? _appointmentDate;
  String? get appointmentDate => _appointmentDate;

  String _paymentMethod = 'wechat';
  String get paymentMethod => _paymentMethod;
  
  DateTime? _paymentExpiryTime;
  DateTime? get paymentExpiryTime => _paymentExpiryTime;

  // 优惠券相关
  Map<String, dynamic>? _selectedCoupon;
  Map<String, dynamic>? get selectedCoupon => _selectedCoupon;

  // 积分相关
  int _pointsToUse = 0;
  int get pointsToUse => _pointsToUse;

  // 发票相关
  String _invoiceMode = 'none'; // 'none', 'personal', 'company'
  String get invoiceMode => _invoiceMode;
  
  bool get needInvoice => _invoiceMode != 'none';
  String get invoiceType => _invoiceMode;

  // 协议勾选
  bool _agreedToTerms = true;
  bool get agreedToTerms => _agreedToTerms;

  final TextEditingController remarkController = TextEditingController();
  final TextEditingController invoiceTitleController = TextEditingController();
  final TextEditingController taxNumberController = TextEditingController();
  final TextEditingController pointsInputController = TextEditingController();

  // 常量
  static const int USER_POINTS = 2450;
  static const double POINTS_RATE = 100.0; // 100积分 = 1元
  static const double MAX_POINTS_DISCOUNT = 20.0; // 最多抵扣20元
  
  // 模拟可用优惠券列表
  static final List<Map<String, dynamic>> AVAILABLE_COUPONS = [
    {
      'id': 1,
      'type': 'discount',
      'amount': 50.0,
      'title': '商城通用立减券',
      'condition': '满 200 元可用',
      'expiry': '2024.02.28',
    },
    {
      'id': 2,
      'type': 'discount',
      'amount': 100.0,
      'title': '新人专享券',
      'condition': '满 500 元可用',
      'expiry': '2024.03.15',
    },
    {
      'id': 3,
      'type': 'discount',
      'amount': 30.0,
      'title': '周末特惠券',
      'condition': '满 150 元可用',
      'expiry': '2024.02.20',
    },
  ];

  String? _orderId;
  String? get orderId => _orderId;

  Future<void> init() async {
    setBusy(true);
    
    // 加载默认地址（物理商品需要）
    if (orderType == 'physical') {
      final addresses = await _addressService.getUserAddresses();
      if (addresses.isNotEmpty) {
        _selectedAddress = addresses.firstWhere(
          (addr) => addr.isDefault,
          orElse: () => addresses.first,
        );
      }
    }
    
    setBusy(false);
  }

  /// 获取订单类型
  String get orderType {
    if (items.isEmpty) return 'physical';
    final firstProduct = items.first['product'];
    // Assuming product model has type, or defaulting
    return (firstProduct.toJson()['type'] as String?) ?? 'physical';
  }

  /// 计算商品总价
  double get productTotal {
    return items.fold(0.0, (sum, item) {
      final price = (item['product'].price as num).toDouble();
      final quantity = item['quantity'] as int;
      return sum + (price * quantity);
    });
  }

  /// 优惠券抵扣金额
  double get couponDiscount {
    if (_selectedCoupon == null) return 0.0;
    final amount = (_selectedCoupon!['amount'] as num).toDouble();
    final condition = _selectedCoupon!['condition'] as String;
    
    // 检查是否满足使用条件
    if (condition.contains('满')) {
      final match = RegExp(r'满\s*(\d+)').firstMatch(condition);
      if (match != null) {
        final minAmount = double.parse(match.group(1)!);
        if (productTotal < minAmount) {
          return 0.0; // 不满足条件
        }
      }
    }
    
    return amount;
  }

  /// 积分抵扣金额
  double get pointsDiscount {
    return (_pointsToUse / POINTS_RATE).clamp(0.0, productTotal);
  }

  /// 计算最终金额
  double get finalTotal {
    double total = productTotal;
    total -= couponDiscount;
    total -= pointsDiscount;
    return total < 0 ? 0.0 : total;
  }

  /// 选择优惠券 - 返回可用优惠券列表
  List<Map<String, dynamic>> getAvailableCoupons() {
    return AVAILABLE_COUPONS.where((coupon) {
      final condition = coupon['condition'] as String;
      if (condition.contains('满')) {
        final match = RegExp(r'满\s*(\d+)').firstMatch(condition);
        if (match != null) {
          final minAmount = double.parse(match.group(1)!);
          return productTotal >= minAmount;
        }
      }
      return true;
    }).toList();
  }

  /// 设置选中的优惠券
  void setSelectedCoupon(Map<String, dynamic>? coupon) {
    _selectedCoupon = coupon;
    notifyListeners();
  }

  /// 取消优惠券
  void removeCoupon() {
    _selectedCoupon = null;
    notifyListeners();
  }

  /// 设置使用积分
  void setPointsToUse(int points) {
    // 限制最大可用积分
    final maxPoints = (productTotal * POINTS_RATE).toInt().clamp(0, USER_POINTS);
    _pointsToUse = points.clamp(0, maxPoints);
    pointsInputController.text = _pointsToUse.toString();
    notifyListeners();
  }

  /// 使用全部积分
  void useAllPoints() {
    final maxPoints = (productTotal * POINTS_RATE).toInt().clamp(0, USER_POINTS);
    setPointsToUse(maxPoints);
  }

  /// 清除积分
  void clearPoints() {
    _pointsToUse = 0;
    pointsInputController.clear();
    notifyListeners();
  }

  /// 切换发票（已废弃，使用 setInvoiceMode）
  void toggleInvoice() {
    if (_invoiceMode == 'none') {
      _invoiceMode = 'personal';
    } else {
      _invoiceMode = 'none';
    }
    notifyListeners();
  }

  /// 设置发票模式
  void setInvoiceMode(String mode) {
    _invoiceMode = mode;
    notifyListeners();
  }

  /// 设置发票类型（兼容旧代码）
  void setInvoiceType(String type) {
    _invoiceMode = type;
    notifyListeners();
  }

  /// 切换协议同意状态
  void toggleAgreement() {
    _agreedToTerms = !_agreedToTerms;
    notifyListeners();
  }

  /// 选择地址
  Future<void> selectAddress() async {
    final result = await MapsTo(
      stacked_routes.Routes.addressSelectionView,
      arguments: stacked_routes.AddressSelectionViewArguments(
        selectedId: _selectedAddress?.id,
      ),
    );
    
    if (result != null && result is UserAddress) {
      _selectedAddress = result;
      notifyListeners();
    }
  }

  /// 选择门店
  Future<void> selectStore() async {
    await dialogService.showDialog(
      title: '选择门店',
      description: '门店选择功能开发中',
    );
  }

  /// 选择预约日期
  Future<void> selectAppointmentDate() async {
    final now = DateTime.now();
    final dates = [
      now.add(const Duration(days: 1)),
      now.add(const Duration(days: 2)),
      now.add(const Duration(days: 3)),
    ];

    // 简单实现：直接选择第一个日期
    _appointmentDate = '${dates[0].year}-${dates[0].month.toString().padLeft(2, '0')}-${dates[0].day.toString().padLeft(2, '0')}';
    notifyListeners();
  }

  /// 设置支付方式
  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  /// 提交订单
  Future<void> submitOrder() async {
    // 验证到店服务必须选择预约日期
    if (orderType == 'service' && _appointmentDate == null) {
      await dialogService.showDialog(
        title: '提示',
        description: '请先选择预约到店日期',
      );
      return;
    }

    // 生成订单ID和支付过期时间
    _orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    _paymentExpiryTime = DateTime.now().add(const Duration(minutes: 15));
    
    notifyListeners();
  }

  /// 显示支付方式选择弹窗并处理支付
  Future<void> showPaymentMethodSheet() async {
    if (_orderId == null || _paymentExpiryTime == null) {
      return;
    }
    
    // 使用 Custom Stacked Sheet
    final response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.paymentMethod,
      customData: {
        'amount': finalTotal,
        'expiryTime': _paymentExpiryTime,
        'selectedMethod': _paymentMethod,
      },
    );

    if (response != null && response.confirmed) {
      if (response.data is String) {
         _paymentMethod = response.data as String;
      }
      
      notifyListeners();
      await _processPayment();
    }
  }

  /// 处理支付
  Future<void> _processPayment() async {
    // 切换到支付中状态
    _step = CheckoutStep.paying;
    notifyListeners();

    // 模拟支付处理
    await Future.delayed(const Duration(milliseconds: 1500));

    // 切换到成功状态
    _step = CheckoutStep.success;
    notifyListeners();
  }

  /// 查看订单详情
  void viewOrderDetail() {
    final now = DateTime.now();
    
    MapsTo(
      stacked_routes.Routes.orderDetailView,
      arguments: stacked_routes.OrderDetailViewArguments(
        orderId: _orderId!,
        orderType: orderType,
        items: items,
        totalAmount: finalTotal,
        paymentMethod: _paymentMethod,
        appointmentDate: _appointmentDate,
        // 价格明细
        productTotal: productTotal,
        shippingFee: 0.0,
        couponDiscount: couponDiscount,
        pointsDiscount: pointsDiscount,
        rewardPoints: (finalTotal / 10).floor(),
        // 优惠信息
        selectedCoupon: _selectedCoupon,
        pointsUsed: _pointsToUse,
        // 发票信息
        invoiceMode: _invoiceMode,
        invoiceTitle: invoiceTitleController.text.isNotEmpty 
            ? invoiceTitleController.text 
            : null,
        taxNumber: taxNumberController.text.isNotEmpty 
            ? taxNumberController.text 
            : null,
        // 其他信息
        remark: remarkController.text.isNotEmpty 
            ? remarkController.text 
            : null,
        orderTime: now.subtract(const Duration(minutes: 2)),
        paymentTime: now,
      ),
    );
  }

  /// 返回商城
  void backToStore() {
    // 使用 Router 跳转回商城首页，或者 Pop until
    // 简单实现：回退到 StoreView
    // navigationService.popUntil((route) => route.settings.name == Routes.storeView);
    // 这里暂时使用 backMultiple 或 navigateTo
    navigationService.clearStackAndShow(stacked_routes.Routes.storeView);
  }

  @override // Removing GoBack redundant definition if base has it. But base has optional result.
  void goBack({dynamic result}) {
    super.goBack(result: result);
  }

  @override
  void dispose() {
    remarkController.dispose();
    invoiceTitleController.dispose();
    taxNumberController.dispose();
    pointsInputController.dispose();
    super.dispose();
  }
}
