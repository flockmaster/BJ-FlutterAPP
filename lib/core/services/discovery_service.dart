
import '../models/discovery_models.dart';
import 'mock_data/mock_discovery_data.dart';

/// [IDiscoveryService] - 社区发现页服务接口
/// 
/// 核心职责：
/// 1. 获取发现页推荐流、关注流及特定车型的内容流。
/// 2. 获取官方动态与“去野”活动数据。
/// 3. 处理用户动态发布与个人资料（如昵称）更新逻辑。
abstract class IDiscoveryService {
  /// 获取发现页推荐的内容列表
  Future<List<DiscoveryItem>> getDiscoveryItems();
  
  /// 获取已关注用户的动态列表
  Future<List<DiscoveryItem>> getFollowItems();
  
  /// 获取特定车型的专题内容流
  /// [model]：车型名称（如：“BJ40”）
  Future<List<DiscoveryItem>> getModelFeed(String model);
  
  /// 获取官方发布的数据（如：官方公告、车主活动等）
  Future<OfficialData> getOfficialData();
  
  /// 获取“去野”模块的数据（越野活动、路线等）
  Future<GoWildData> getGoWildData();
  
  /// 根据 ID 获取单条动态详情
  Future<DiscoveryItem?> getItemById(String id);
  
  /// 更新用户昵称：模拟社区层面的昵称同步
  Future<bool> updateUserNickname(String nickname);
  
  /// 发布社区动态
  /// [title]：动态标题
  /// [content]：文字内容
  /// [imagePaths]：配图的本地路径列表
  /// [userProfile]：发布者的用户信息
  Future<bool> publishPost({
    required String title,
    required String content,
    required List<String> imagePaths,
    required Map<String, dynamic> userProfile,
  });
}

/// [DiscoveryService] - 发现页服务具体实现
/// 
/// 当前版本包含部分 Mock 数据与异步模拟逻辑。
class DiscoveryService implements IDiscoveryService {
  @override
  Future<List<DiscoveryItem>> getDiscoveryItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockDiscoveryData.discoveryItems;
  }

  @override
  Future<List<DiscoveryItem>> getFollowItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      DiscoveryItem(
        id: 'f1',
        type: DiscoveryItemType.post,
        title: '关注的人更新了：我的改装日常',
        image: 'https://images.unsplash.com/photo-1533558701576-23c65e0272fb?q=80&w=400&auto=format&fit=crop',
        user: UserInfo(
          id: 'u1', 
          name: '改装达人', 
          avatar: 'https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=100&auto=format&fit=crop', 
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)), 
          carModel: 'BJ40'
        ),
        likes: 42,
        comments: 5,
      ),
      DiscoveryItem(
        id: 'f2',
        type: DiscoveryItemType.post,
        title: '周末跑山，遇见最美晚霞',
        image: 'https://images.unsplash.com/photo-1519245659620-e859806a8d3b?q=80&w=400&auto=format&fit=crop',
        user: UserInfo(
          id: 'u2', 
          name: '山道之王', 
          avatar: 'https://images.unsplash.com/photo-1519245659620-e859806a8d3b?q=80&w=100&auto=format&fit=crop', 
          createdAt: DateTime.now().subtract(const Duration(hours: 1)), 
          carModel: 'BJ60'
        ),
        likes: 88,
        comments: 12,
      ),
    ];
  }

  @override
  Future<List<DiscoveryItem>> getModelFeed(String model) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockDiscoveryData.discoveryItems.take(3).toList();
  }

  @override
  Future<OfficialData> getOfficialData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockDiscoveryData.officialData;
  }

  @override
  Future<GoWildData> getGoWildData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockDiscoveryData.goWildData;
  }

  @override
  Future<DiscoveryItem?> getItemById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final followItems = await getFollowItems();
    final allItems = [
      ...MockDiscoveryData.discoveryItems,
      ...followItems,
    ];
    try {
      return allItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateUserNickname(String nickname) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return nickname.isNotEmpty && nickname.length <= 16;
  }

  @override
  Future<bool> publishPost({
    required String title,
    required String content,
    required List<String> imagePaths,
    required Map<String, dynamic> userProfile,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return content.trim().isNotEmpty;
  }
}

/// [MockDiscoveryService] - 模拟发现页服务实现
class MockDiscoveryService implements IDiscoveryService {
  @override
  Future<List<DiscoveryItem>> getDiscoveryItems() async {
    return MockDiscoveryData.discoveryItems;
  }

  @override
  Future<List<DiscoveryItem>> getFollowItems() async {
    // 复用 DiscoveryService 中的模拟关注项逻辑
    return DiscoveryService().getFollowItems();
  }

  @override
  Future<List<DiscoveryItem>> getModelFeed(String model) async {
    return MockDiscoveryData.discoveryItems.take(3).toList();
  }

  @override
  Future<OfficialData> getOfficialData() async {
    return MockDiscoveryData.officialData;
  }

  @override
  Future<GoWildData> getGoWildData() async {
    return MockDiscoveryData.goWildData;
  }

  @override
  Future<DiscoveryItem?> getItemById(String id) async {
    final followItems = await getFollowItems();
    final allItems = [
      ...MockDiscoveryData.discoveryItems,
      ...followItems,
    ];
    try {
      return allItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateUserNickname(String nickname) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return nickname.isNotEmpty && nickname.length <= 16;
  }

  @override
  Future<bool> publishPost({
    required String title,
    required String content,
    required List<String> imagePaths,
    required Map<String, dynamic> userProfile,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return content.trim().isNotEmpty;
  }
}
