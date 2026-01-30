import '../../../app/app.locator.dart';
import '../../../core/base/baic_base_view_model.dart';
import '../../../core/models/coupon.dart';
import '../../../core/services/coupon_service.dart';

enum CouponTab { valid, expired }

/// [MyCouponsViewModel] - 我的优惠券中心业务逻辑类
///
/// 核心职责：
/// 1. 分类展示用户持有的优惠券：包含可用券（Valid）与已失效/已使用券（Expired/Used）。
/// 2. 提供快捷使用入口（跳转至商场或服务预约模块）。
class MyCouponsViewModel extends BaicBaseViewModel {
  final _couponService = locator<ICouponService>();

  /// 当前选中的卡券状态 Tab
  CouponTab _activeTab = CouponTab.valid;
  CouponTab get activeTab => _activeTab;

  /// 卡券实体全量列表
  List<Coupon> _coupons = [];
  
  /// 计算属性：基于当前 Tab 过滤出的卡券子集
  List<Coupon> get filteredCoupons {
    if (_activeTab == CouponTab.valid) {
      return _coupons.where((c) => c.isValid).toList();
    } else {
      return _coupons.where((c) => c.isExpired || c.isUsed).toList();
    }
  }

  /// 生命周期：首次进入时全量拉取卡券数据
  Future<void> initialize() async {
    await runBusyFuture(_loadCoupons());
  }

  /// 业务加载：从服务层同步最新卡券
  Future<void> _loadCoupons() async {
    _coupons = await _couponService.getCoupons();
    notifyListeners();
  }

  /// 交互：切换 Tab 筛选显示不同的卡券
  void switchTab(CouponTab tab) {
    _activeTab = tab;
    notifyListeners();
  }

  /// 交互：点击“立即使用”发起核销逻辑或路由跳转
  Future<void> useCoupon(String couponId) async {
    final success = await _couponService.useCoupon(couponId);
    if (success) {
      // 若使用成功，重载列表以更新卡券状态
      await _loadCoupons();
    }
  }
}
