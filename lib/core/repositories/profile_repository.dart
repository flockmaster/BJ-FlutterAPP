import '../base/base_state.dart';
import '../di/service_locator.dart';
import 'package:car_owner_app/core/shared/services/api_service.dart';
import 'package:car_owner_app/core/shared/services/storage_service.dart';
import '../models/profile_models.dart';

/// 个人资料数据操作的仓储类
class ProfileRepository {
  final ApiService _apiService = sl.get<ApiService>();
  final StorageService _storageService = sl.get<StorageService>();

  /// 检查用户是否已登录
  Future<bool> isLoggedIn() async {
    final token = _storageService.getUserToken();
    return token != null && token.isNotEmpty;
  }

  /// 获取用户资料
  Future<Result<UserProfile>> getUserProfile() async {
    try {
      final response = await _apiService.get('/users/profile');
      
      if (response.statusCode == 200) {
        final data = response.data;
        Map<String, dynamic> profileData;
        
        if (data is Map && data['data'] != null) {
          profileData = data['data'] as Map<String, dynamic>;
        } else if (data is Map) {
          profileData = data as Map<String, dynamic>;
        } else {
          return Result.failure('无效的响应格式');
        }
        
        return Result.success(UserProfile.fromJson(profileData));
      }
      
      return Result.failure('加载资料失败');
    } catch (e) {
      return Result.failure('网络错误: ${e.toString()}');
    }
  }

  /// 更新用户资料
  Future<Result<UserProfile>> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put('/users/profile', data: data);
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        Map<String, dynamic> profileData;
        
        if (responseData is Map && responseData['data'] != null) {
          profileData = responseData['data'] as Map<String, dynamic>;
        } else if (responseData is Map) {
          profileData = responseData as Map<String, dynamic>;
        } else {
          return Result.failure('无效的响应格式');
        }
        
        return Result.success(UserProfile.fromJson(profileData));
      }
      
      return Result.failure('更新资料失败');
    } catch (e) {
      return Result.failure('网络错误: ${e.toString()}');
    }
  }

  /// 获取用户车辆
  Future<Result<List<UserVehicle>>> getUserVehicles() async {
    try {
      final response = await _apiService.get('/users/vehicles');
      
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
        
        final vehicles = items
            .map((json) => UserVehicle.fromJson(json))
            .toList();
        
        return Result.success(vehicles);
      }
      
      return Result.failure('加载车辆失败');
    } catch (e) {
      return Result.failure('网络错误: ${e.toString()}');
    }
  }

  /// 绑定新车辆
  Future<Result<UserVehicle>> bindVehicle(String vin, String? plateNumber) async {
    try {
      final response = await _apiService.post(
        '/users/vehicles',
        data: {
          'vin': vin,
          if (plateNumber != null) 'plateNumber': plateNumber,
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        Map<String, dynamic> vehicleData;
        
        if (data is Map && data['data'] != null) {
          vehicleData = data['data'] as Map<String, dynamic>;
        } else if (data is Map) {
          vehicleData = data as Map<String, dynamic>;
        } else {
          return Result.failure('无效的响应格式');
        }
        
        return Result.success(UserVehicle.fromJson(vehicleData));
      }
      
      return Result.failure('绑定车辆失败');
    } catch (e) {
      return Result.failure('网络错误: ${e.toString()}');
    }
  }

  /// 解绑车辆
  Future<Result<void>> unbindVehicle(String vehicleId) async {
    try {
      final response = await _apiService.delete('/users/vehicles/$vehicleId');
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return Result.success(null);
      }
      
      return Result.failure('解绑车辆失败');
    } catch (e) {
      return Result.failure('网络错误: ${e.toString()}');
    }
  }

  /// 退出登录
  Future<void> logout() async {
    await _storageService.clearUserSession();
  }
}
