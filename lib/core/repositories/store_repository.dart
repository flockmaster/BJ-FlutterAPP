import '../base/base_state.dart';
import '../di/service_locator.dart';
import 'package:car_owner_app/core/shared/services/api_service.dart';
import '../models/store_models.dart';

/// 商城数据操作的仓储类
class StoreRepository {
  final ApiService _apiService = sl.get<ApiService>();

  /// 获取所有商品
  Future<Result<List<StoreProduct>>> getProducts({
    int? categoryId,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (categoryId != null) queryParams['categoryId'] = categoryId;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await _apiService.get(
        '/store/products',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
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
        
        final products = items
            .map((json) => StoreProduct.fromJson(json))
            .toList();
        
        return Result.success(products);
      }
      
      return Result.failure('加载商品失败');
    } catch (e) {
      return Result.failure('网络错误: ${e.toString()}');
    }
  }

  /// 根据ID获取商品
  Future<Result<StoreProduct>> getProductById(String id) async {
    try {
      final response = await _apiService.get('/store/products/$id');
      
      if (response.statusCode == 200) {
        final data = response.data;
        Map<String, dynamic> productData;
        
        if (data is Map && data['data'] != null) {
          productData = data['data'] as Map<String, dynamic>;
        } else if (data is Map) {
          productData = data as Map<String, dynamic>;
        } else {
          return Result.failure('无效的响应格式');
        }
        
        return Result.success(StoreProduct.fromJson(productData));
      }
      
      return Result.failure('未找到商品');
    } catch (e) {
      return Result.failure('网络错误: ${e.toString()}');
    }
  }

  /// 获取商品分类
  Future<Result<List<ProductCategory>>> getCategories() async {
    try {
      final response = await _apiService.get('/store/categories');
      
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
        
        final categories = items
            .map((json) => ProductCategory.fromJson(json))
            .toList();
        
        return Result.success(categories);
      }
      
      return Result.failure('加载分类失败');
    } catch (e) {
      return Result.failure('网络错误: ${e.toString()}');
    }
  }

  /// 搜索商品
  Future<Result<List<StoreProduct>>> searchProducts(String query) async {
    return getProducts(search: query);
  }
}
