import 'package:injectable/injectable.dart';
import '../models/car_model.dart';
import '../repositories/car_repository.dart';
import 'mock_data/mock_car_data.dart';
import '../base/base_state.dart' as base;

/// [ICarService] - 车型与车辆信息服务接口
/// 
/// 负责获取品牌下的各种车型数据，支持预览模式区分。
abstract class ICarService {
  /// 获取车型列表
  /// [isPreview]：可选参数。true 表示仅获取内测/预览车型；false 表示仅获取已发布车型；null 表示获取全部。
  Future<base.Result<List<CarModel>>> getCarModels({bool? isPreview});
  
  /// 根据 ID 获取特定车型的详细资料
  Future<base.Result<CarModel>> getCarById(String id);
}

/// [CarService] - 车型服务真实实现
/// 
/// 目前桥接自 [CarRepository]，未来核心业务逻辑可在此层进一步封装。
class CarService implements ICarService {
  // 持有 Repository 引用进行底层数据操作
  final CarRepository _repository = CarRepository(); 

  @override
  Future<base.Result<List<CarModel>>> getCarModels({bool? isPreview}) async {
    // 根据预览标识位分发不同的仓库请求方法
    if (isPreview == null) {
      return await _repository.getCarModels();
    } else if (isPreview) {
      return await _repository.getPreviewModels();
    } else {
      return await _repository.getAvailableModels();
    }
  }

  @override
  Future<base.Result<CarModel>> getCarById(String id) async {
    return await _repository.getCarModelById(id);
  }
}

/// [MockCarService] - 模拟车型服务实现
/// 
/// 用于开发阶段、单元测试或在网络受限环境下提供稳定的模拟数据。
/// 遵循铁律 7：虽然此处定义了 Mock 类，但其应通过 MockInterceptor 或 DI 动态注入，而不是在业务代码中硬编码 if(mock)。
@LazySingleton(as: ICarService)
class MockCarService implements ICarService {
  @override
  Future<base.Result<List<CarModel>>> getCarModels({bool? isPreview}) async {
    await Future.delayed(const Duration(milliseconds: 1000)); // 模拟网络延迟
    
    final all = MockCarData.getCarModels();
    final filtered = isPreview == null 
        ? all 
        : all.where((c) => c.isPreview == isPreview).toList();
        
    return base.Result.success(filtered);
  }

  @override
  Future<base.Result<CarModel>> getCarById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final all = MockCarData.getCarModels();
    try {
      final car = all.firstWhere((c) => c.id == id);
      return base.Result.success(car);
    } catch (_) {
      return base.Result.failure('车型信息不存在');
    }
  }
}
