import 'package:injectable/injectable.dart';
import 'package:car_owner_app/app/app.locator.dart';
import 'package:car_owner_app/core/network/api_client.dart';
import '../models/store_models.dart';

/// [IStoreService] - 商城核心业务服务接口
/// 
/// 负责处理：商城分类加载与商品详情查询。
abstract class IStoreService {
  /// 获取商城所有分类列表（含分类图标与描述）
  Future<List<StoreCategory>> getCategories();
  
  /// 根据商品 ID 获取完整的商品详情对象
  Future<StoreProduct?> getProductById(String id);
}

/// [StoreService] - 商城服务生产实现
/// 
/// 该实现直接通过 [ApiClient] 与后端接口通信。
@LazySingleton(as: IStoreService)
class StoreService implements IStoreService {
  final ApiClient _apiClient = locator<ApiClient>();

  @override
  Future<List<StoreCategory>> getCategories() async {
    try {
      final response = await _apiClient.get<List<dynamic>>('/store/categories');
      if (response.data != null) {
        return response.data!
            .map((e) => StoreCategory.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('获取分类失败: $e');
      return [];
    }
  }

  @override
  Future<StoreProduct?> getProductById(String id) async {
    try {
      // 业务逻辑：优先调取商品详情独立接口
      final response = await _apiClient.get<Map<String, dynamic>>('/store/products/$id');
      if (response.data != null) {
        return StoreProduct.fromJson(response.data!);
      }
      return null;
    } catch (e) {
      // 备注：若接口报错，按照铁律 7 不再做本地降级逻辑
      print('获取商品详情失败 $id: $e');
      return null;
    }
  }
}
