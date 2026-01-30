import 'package:car_owner_app/core/base/baic_base_view_model.dart';

class OrderDetailViewModel extends BaicBaseViewModel {

  final String orderId;
  final String orderType;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String paymentMethod;
  final String? appointmentDate;
  
  // 价格明细
  final double productTotal;
  final double shippingFee;
  final double couponDiscount;
  final double pointsDiscount;
  final int rewardPoints;
  
  // 优惠信息
  final Map<String, dynamic>? selectedCoupon;
  final int pointsUsed;
  
  // 发票信息
  final String invoiceMode;
  final String? invoiceTitle;
  final String? taxNumber;
  
  // 其他信息
  final String? remark;
  final DateTime? orderTime;
  final DateTime? paymentTime;

  OrderDetailViewModel({
    required this.orderId,
    required this.orderType,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    this.appointmentDate,
    this.productTotal = 0.0,
    this.shippingFee = 0.0,
    this.couponDiscount = 0.0,
    this.pointsDiscount = 0.0,
    this.rewardPoints = 0,
    this.selectedCoupon,
    this.pointsUsed = 0,
    this.invoiceMode = 'none',
    this.invoiceTitle,
    this.taxNumber,
    this.remark,
    this.orderTime,
    this.paymentTime,
  });

  void handleGoBack() {
    goBack();
  }

  void buyAgain() {
    // 重新购买逻辑 - 返回商城，暂定回退上一页
    goBack();
  }
}
