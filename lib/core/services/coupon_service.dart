import '../models/coupon.dart';

/// [ICouponService] - 优惠券业务服务接口
/// 
/// 负责管理用户名下的各种优惠券（折扣券、工时费抵扣券、充电额度等）。
abstract class ICouponService {
  /// 获取当前用户的所有优惠券列表（包含可用、已使用及已过期）
  Future<List<Coupon>> getCoupons();

  /// 仅获取当前可用的优惠券
  Future<List<Coupon>> getValidCoupons();

  /// 仅获取已过期或已失效的优惠券
  Future<List<Coupon>> getExpiredCoupons();

  /// 使用指定的优惠券
  /// [couponId]：优惠券唯一标识
  Future<bool> useCoupon(String couponId);

  /// 快捷获取当前可用优惠券的数量（常用于在个人中心显示红点或数字）
  int getValidCouponCount();
}

/// [CouponService] - 优惠券服务具体实现
/// 
/// 包含模拟数据与基本的过滤逻辑。
class CouponService implements ICouponService {
  // 模拟优惠券数据源
  final List<Coupon> _mockCoupons = [
    const Coupon(
      id: '1',
      type: CouponType.discount,
      amount: '50',
      unit: '元',
      title: '商城通用立减券',
      subtitle: '满 200 元可用',
      expiry: '2024.02.28',
      status: CouponStatus.valid,
      minAmount: 20000, 
    ),
    const Coupon(
      id: '2',
      type: CouponType.service,
      amount: '8.8',
      unit: '折',
      title: '保养工时费折扣券',
      subtitle: '全国4S店通用',
      expiry: '2024.06.30',
      status: CouponStatus.valid,
    ),
    const Coupon(
      id: '3',
      type: CouponType.charging,
      amount: '20',
      unit: '度',
      title: '免费充电额度',
      subtitle: '仅限自营充电站',
      expiry: '2024.01.31',
      status: CouponStatus.valid,
    ),
    const Coupon(
      id: '4',
      type: CouponType.discount,
      amount: '100',
      unit: '元',
      title: '新人专享券',
      subtitle: '无门槛',
      expiry: '2023.12.31',
      status: CouponStatus.expired,
    ),
  ];

  @override
  Future<List<Coupon>> getCoupons() async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockCoupons;
  }

  @override
  Future<List<Coupon>> getValidCoupons() async {
    final coupons = await getCoupons();
    return coupons.where((c) => c.isValid).toList();
  }

  @override
  Future<List<Coupon>> getExpiredCoupons() async {
    final coupons = await getCoupons();
    return coupons.where((c) => c.isExpired || c.isUsed).toList();
  }

  @override
  Future<bool> useCoupon(String couponId) async {
    // 模拟核销过程
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  int getValidCouponCount() {
    // 静态返回模拟内存中可用的券数
    return _mockCoupons.where((c) => c.isValid).length;
  }
}
