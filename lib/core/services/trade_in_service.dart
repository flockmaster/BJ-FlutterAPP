import 'package:injectable/injectable.dart';
import '../base/base_state.dart' as base;

/// 置换申请数据模型
class TradeInApplication {
  final String city;
  final String phone;

  TradeInApplication({
    required this.city,
    required this.phone,
  });
}

/// [ITradeInService] - 车辆置换业务服务接口
/// 
/// 负责处理：获取当前城市、获取联系电话以及提交二手车置换申请与在线评估请求。
abstract class ITradeInService {
  /// 获取当前定位或用户选择的城市
  Future<base.Result<String>> getCurrentCity();
  
  /// 获取用户绑定的联系电话
  Future<base.Result<String>> getUserPhone();
  
  /// 提交置换申请表单
  Future<base.Result<void>> submitTradeInApplication(TradeInApplication application);
  
  /// 发起在线车辆残值评估流程
  Future<base.Result<void>> startVehicleEvaluation();
}

/// [TradeInService] - 置换服务具体实现
@LazySingleton(as: ITradeInService)
class TradeInService implements ITradeInService {
  @override
  Future<base.Result<String>> getCurrentCity() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return base.Result.success('北京');
  }

  @override
  Future<base.Result<String>> getUserPhone() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return base.Result.success('138****8888');
  }

  @override
  Future<base.Result<void>> submitTradeInApplication(TradeInApplication application) async {
    // 模拟服务端表单验证与保存
    await Future.delayed(const Duration(milliseconds: 1500));
    return base.Result.success(null);
  }

  @override
  Future<base.Result<void>> startVehicleEvaluation() async {
    // 模拟启动第三方评估算法
    await Future.delayed(const Duration(milliseconds: 1000));
    return base.Result.success(null);
  }
}