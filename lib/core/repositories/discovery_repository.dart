import '../base/base_state.dart';
import '../models/discovery_models.dart';
import '../services/mock_data/mock_discovery_data.dart';

/// 发现页数据操作的仓储类
class DiscoveryRepository {
  // final ApiService _apiService = sl.get<ApiService>(); // 为模拟模式注释

  /// 获取所有发现页动态
  Future<Result<List<DiscoveryItem>>> getDiscoveryItems() async {
    try {
      // 模拟延迟
      await Future.delayed(const Duration(milliseconds: 500));
      return Result.success(MockDiscoveryData.discoveryItems);
    } catch (e) {
      return Result.failure('加载模拟数据错误: ${e.toString()}');
    }
  }

  /// 根据ID获取发现页动态
  Future<Result<DiscoveryItem>> getDiscoveryItemById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      final item = MockDiscoveryData.discoveryItems.firstWhere(
        (element) => element.id == id,
        orElse: () => throw Exception('未找到项目'),
      );
      return Result.success(item);
    } catch (e) {
      return Result.failure('未找到项目');
    }
  }

  /// 按类型获取发现页动态
  Future<Result<List<DiscoveryItem>>> getDiscoveryItemsByType(
    DiscoveryItemType type,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final items = MockDiscoveryData.discoveryItems
          .where((element) => element.type == type)
          .toList();
      return Result.success(items);
    } catch (e) {
      return Result.failure('数据筛选错误');
    }
  }
  /// 获取“去野”数据（模拟）
  Future<Result<GoWildData>> getGoWildData() async {
    // 模拟数据
    await Future.delayed(const Duration(milliseconds: 500));
    
    return Result.success(MockDiscoveryData.goWildData);
  }
}
