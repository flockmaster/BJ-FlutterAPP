import '../../../app/app.locator.dart';
import '../../../core/base/baic_base_view_model.dart';
import '../../../core/services/trade_in_service.dart';

/// [TradeInViewModel] - 置换购车（以旧换新）业务逻辑类
///
/// 核心职责：
/// 1. 构建非本品车辆入场的评估流程，支持在线估值与申请。
/// 2. 自动同步用户的当前地理位置与登录手机号，简化表单填写开销。
/// 3. 与 [ITradeInService] 集成，处理评估指令的发起与置换意向的提交。
class TradeInViewModel extends BaicBaseViewModel {
  final _tradeInService = locator<ITradeInService>();

  /// 用户当前所在城市（用于精准匹配线下评估网点）
  String _city = '';
  /// 用户联系电话（默认读取账号绑定手机）
  String _phone = '';
  /// 表单提交状态锁定
  bool _isSubmitting = false;

  String get city => _city;
  String get phone => _phone;
  bool get isSubmitting => _isSubmitting;

  /// 生命周期：加载预填充的身份与位置数据
  Future<void> init() async {
    setBusy(true);
    
    try {
      // 性能：并行获取坐标城市与用户信息，加速首屏渲染
      final results = await Future.wait([
        _tradeInService.getCurrentCity(),
        _tradeInService.getUserPhone(),
      ]);
      
      final cityResult = results[0];
      final phoneResult = results[1];
      
      if (cityResult.isSuccess) {
        _city = cityResult.data!;
      }
      
      if (phoneResult.isSuccess) {
        _phone = phoneResult.data!;
      }
      
      notifyListeners();
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  /// 交互：社交分享（置换政策宣传）
  void handleSharePressed() {
    // TODO: 实现品牌置换政策的分享转发
  }

  /// 业务操作：启动一键评估插件/H5 流程
  Future<void> handleFreeEvaluationPressed() async {
    setBusy(true);
    
    try {
      final result = await _tradeInService.startVehicleEvaluation();
      if (result.isSuccess) {
        // 成功后导向在线实时估值结果页
      } else {
        setError(result.error);
      }
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  /// 业务提交：正式上传置换申请书
  Future<void> handleSubmitApplication() async {
    if (_isSubmitting) return;
    
    _isSubmitting = true;
    notifyListeners();
    
    try {
      final application = TradeInApplication(
        city: _city,
        phone: _phone,
      );
      
      final result = await _tradeInService.submitTradeInApplication(application);
      
      if (result.isSuccess) {
        // 成功后弹出意向提交成功提示
      } else {
        setError(result.error);
      }
    } catch (e) {
      setError(e);
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}