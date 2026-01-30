import '../models/discovery_models.dart';

/// [IUserContentService] - 用户内容生产与收藏管理服务接口
/// 
/// 负责处理：用户个人作品（动态/视频）的获取与删除、收藏夹管理（内容/商品）以及购物车中转逻辑。
abstract class IUserContentService {
  /// 获取指定用户发布的所有内容列表
  Future<List<DiscoveryItem>> getUserPosts(String userId);
  
  /// 获取用户收藏的社区内容（帖子、文章、视频）
  Future<List<DiscoveryItem>> getFavoriteContents(String userId);
  
  /// 获取用户收藏的商城商品列表
  Future<List<Map<String, dynamic>>> getFavoriteProducts(String userId);
  
  /// 下架/删除用户发布的指定作品
  Future<bool> deletePost(String postId);
  
  /// 将内容或商品添加至收藏夹
  /// [type]：'post', 'video', 'product' 等
  Future<bool> addFavorite(String itemId, String type);
  
  /// 从收藏夹移除指定项目
  Future<bool> removeFavorite(String itemId, String type);
  
  /// 收藏页快捷操作：将商品添加至购物车
  Future<bool> addToCart(String productId, int quantity);
}

/// [UserContentService] - 用户内容服务本地 Mock 实现
class UserContentService implements IUserContentService {
  @override
  Future<List<DiscoveryItem>> getUserPosts(String userId) async {
    // 模拟网络请求延迟
    await Future.delayed(const Duration(milliseconds: 500));
    
    // 逻辑：返回模拟该用户发布过的历史动态
    return [
      DiscoveryItem(
        id: 'post1',
        type: DiscoveryItemType.post,
        title: '周末穿越无人区',
        content: '这次穿越真的太刺激了，BJ40表现完美！',
        image: 'https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=400&auto=format&fit=crop',
        likes: 156,
        comments: 23,
        shares: 8,
        user: UserInfo(
          id: 'user1',
          name: '张越野',
          avatar: 'https://randomuser.me/api/portraits/men/75.jpg',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      DiscoveryItem(
        id: 'post2',
        type: DiscoveryItemType.video,
        title: '阿拉善英雄会现场',
        content: '今年的英雄会太精彩了！',
        image: 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?q=80&w=400&auto=format&fit=crop',
        isVideo: true,
        likes: 289,
        comments: 45,
        shares: 12,
        user: UserInfo(
          id: 'user1',
          name: '张越野',
          avatar: 'https://randomuser.me/api/portraits/men/75.jpg',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      DiscoveryItem(
        id: 'post3',
        type: DiscoveryItemType.post,
        title: '改装完成',
        content: '新装的绞盘和车顶架，准备下次长途穿越',
        image: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?q=80&w=400&auto=format&fit=crop',
        likes: 234,
        comments: 56,
        shares: 15,
        user: UserInfo(
          id: 'user1',
          name: '张越野',
          avatar: 'https://randomuser.me/api/portraits/men/75.jpg',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      DiscoveryItem(
        id: 'post4',
        type: DiscoveryItemType.post,
        title: '草原自驾',
        content: '内蒙古大草原，风景太美了',
        image: 'https://images.unsplash.com/photo-1519245659620-e859806a8d3b?q=80&w=400&auto=format&fit=crop',
        likes: 178,
        comments: 34,
        shares: 9,
        user: UserInfo(
          id: 'user1',
          name: '张越野',
          avatar: 'https://randomuser.me/api/portraits/men/75.jpg',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  @override
  Future<List<DiscoveryItem>> getFavoriteContents(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // 逻辑：返回用户收藏过的他人的高质量动态或视频
    return [
      DiscoveryItem(
        id: 'fav1',
        type: DiscoveryItemType.post,
        title: '越野技巧分享',
        content: '新手必看的越野驾驶技巧',
        image: 'https://images.unsplash.com/photo-1533558701576-23c65e0272fb?q=80&w=400&auto=format&fit=crop',
        likes: 456,
        comments: 78,
        user: const UserInfo(
          id: 'user2',
          name: '越野教练',
          avatar: 'https://randomuser.me/api/portraits/men/32.jpg',
        ),
      ),
      DiscoveryItem(
        id: 'fav2',
        type: DiscoveryItemType.article,
        title: 'BJ40改装指南',
        content: '详细的改装方案 and 注意事项',
        image: 'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?q=80&w=400&auto=format&fit=crop',
        likes: 892,
        comments: 156,
        user: const UserInfo(
          id: 'user3',
          name: '改装达人',
          avatar: 'https://randomuser.me/api/portraits/men/45.jpg',
        ),
      ),
      DiscoveryItem(
        id: 'fav3',
        type: DiscoveryItemType.video,
        title: '川藏线穿越记录',
        content: '15天川藏线全程记录',
        image: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=400&auto=format&fit=crop',
        isVideo: true,
        likes: 1234,
        comments: 234,
        user: const UserInfo(
          id: 'user4',
          name: '旅行者',
          avatar: 'https://randomuser.me/api/portraits/men/67.jpg',
        ),
      ),
      DiscoveryItem(
        id: 'fav4',
        type: DiscoveryItemType.post,
        title: '露营装备推荐',
        content: '越野露营必备装备清单',
        image: 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=400&auto=format&fit=crop',
        likes: 567,
        comments: 89,
        user: const UserInfo(
          id: 'user5',
          name: '露营爱好者',
          avatar: 'https://randomuser.me/api/portraits/men/23.jpg',
        ),
      ),
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getFavoriteProducts(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // 逻辑：返回用户收藏过的商城商品（通常包括价格、库存等实时状态）
    return [
      {
        'id': 'prod1',
        'title': 'BJ40专用越野轮胎 AT全地形轮胎',
        'image': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?q=80&w=400&auto=format&fit=crop',
        'price': 1299,
        'originalPrice': 1499,
        'discount': 200,
        'stock': 50,
      },
      {
        'id': 'prod2',
        'title': '车载冰箱 30L大容量 车家两用',
        'image': 'https://images.unsplash.com/photo-1585909695284-32d2985ac9c0?q=80&w=400&auto=format&fit=crop',
        'price': 899,
        'originalPrice': 1099,
        'discount': 200,
        'stock': 30,
      },
      {
        'id': 'prod3',
        'title': '越野绞盘 12000磅 电动绞盘',
        'image': 'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?q=80&w=400&auto=format&fit=crop',
        'price': 2599,
        'originalPrice': 2799,
        'discount': 200,
        'stock': 15,
      },
      {
        'id': 'prod4',
        'title': '车顶帐篷 硬壳自动帐篷',
        'image': 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=400&auto=format&fit=crop',
        'price': 5999,
        'originalPrice': 6999,
        'discount': 1000,
        'stock': 8,
      },
    ];
  }

  @override
  Future<bool> deletePost(String postId) async {
    // 模拟物理删除或逻辑删除耗时
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  @override
  Future<bool> addFavorite(String itemId, String type) async {
    // 模拟服务端写库关联
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  @override
  Future<bool> removeFavorite(String itemId, String type) async {
    // 模拟服务端取消关联
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  @override
  Future<bool> addToCart(String productId, int quantity) async {
    // 模拟将收藏的商品推送至购物车微服务
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
