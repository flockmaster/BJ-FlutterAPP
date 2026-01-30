import '../base/base_state.dart';
import '../di/service_locator.dart';
import 'package:car_owner_app/core/shared/services/api_service.dart';
import '../models/car_model.dart';

/// 车型数据操作的仓储类
class CarRepository {
  final ApiService _apiService = sl.get<ApiService>();

  /// 获取所有车型
  Future<Result<List<CarModel>>> getCarModels() async {
    try {
      final response = await _apiService.get('/cars/models');
      
      if (response.statusCode == 200) {
        final data = response.data;
        List<dynamic> items;
        
        if (data is Map && data['data'] != null) {
          items = data['data'] as List;
        } else if (data is List) {
          items = data;
        } else {
          return Result.failure('无效的响应格式');
        }
        
        final carModels = items
            .map((json) => CarModel.fromJson(json))
            .toList();
        
        return Result.success(carModels);
      }
      
      return Result.failure('加载车型失败');
    } catch (e) {
      return Result.failure('网络错误: ${e.toString()}');
    }
  }

  /// 根据ID获取车型
  Future<Result<CarModel>> getCarModelById(String id) async {
    try {
      final response = await _apiService.get('/cars/models/$id');
      
      if (response.statusCode == 200) {
        final data = response.data;
        Map<String, dynamic> carData;
        
        if (data is Map && data['data'] != null) {
          carData = data['data'] as Map<String, dynamic>;
        } else if (data is Map) {
          carData = data as Map<String, dynamic>;
        } else {
          return Result.failure('无效的响应格式');
        }
        
        return Result.success(CarModel.fromJson(carData));
      }
      
      return Result.failure('未找到车型');
    } catch (e) {
      return Result.failure('网络错误: ${e.toString()}');
    }
  }

  /// 获取预览（即将上市）车型
  Future<Result<List<CarModel>>> getPreviewModels() async {
    try {
      final response = await _apiService.get(
        '/cars/models',
        queryParameters: {'isPreview': true},
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        List<dynamic> items;
        
        if (data is Map && data['data'] != null) {
          items = data['data'] as List;
        } else if (data is List) {
          items = data;
        } else {
          return Result.failure('无效的响应格式');
        }
        
        final carModels = items
            .map((json) => CarModel.fromJson(json))
            .toList();
        
        return Result.success(carModels);
      }
      
      return Result.failure('加载预览车型失败');
    } catch (e) {
      return Result.failure('网络错误: ${e.toString()}');
    }
  }

  /// 获取在售车型
  Future<Result<List<CarModel>>> getAvailableModels() async {
    try {
      final response = await _apiService.get(
        '/cars/models',
        queryParameters: {'isPreview': false},
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        List<dynamic> items;
        
        if (data is Map && data['data'] != null) {
          items = data['data'] as List;
        } else if (data is List) {
          items = data;
        } else {
          return Result.failure('无效的响应格式');
        }
        
        final carModels = items
            .map((json) => CarModel.fromJson(json))
            .toList();
        
        return Result.success(carModels);
      }
      
      return Result.failure('加载在售车型失败');
    } catch (e) {
      return Result.failure('网络错误: ${e.toString()}');
    }
  }
}
