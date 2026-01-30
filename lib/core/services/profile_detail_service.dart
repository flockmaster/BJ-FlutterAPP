import 'package:injectable/injectable.dart';

/// [IProfileDetailService] - 用户个人主页详情服务接口
/// 
/// 负责处理：获取其他用户或自身的公开资料、动态列表、相册照片以及名下绑定的车辆。
abstract class IProfileDetailService {
  /// 获取主页基础展示数据（昵称、ID、地址、签名及统计数值）
  Future<Map<String, dynamic>> getProfileData();
  
  /// 获取该用户发布过的社区动态列表
  Future<List<Map<String, dynamic>>> getUserPosts();
  
  /// 获取该用户的相册照片墙数据（仅图片 URL）
  Future<List<String>> getUserPhotos();
  
  /// 获取该用名下公开的车辆列表
  Future<List<Map<String, dynamic>>> getUserVehicles();
}

/// [ProfileDetailService] - 个人详情服务具体实现
@LazySingleton(as: IProfileDetailService)
class ProfileDetailService implements IProfileDetailService {
  @override
  Future<Map<String, dynamic>> getProfileData() async {
    // 模拟网络请求延迟
    await Future.delayed(const Duration(milliseconds: 500));
    
    return {
      'displayName': '张越野',
      'userId': '88293011',
      'location': '北京·朝阳',
      'bio': '热爱越野，热爱生活。周末不在山里，就在去山里的路上。🚙🏕️📸',
      'avatar': 'https://randomuser.me/api/portraits/men/75.jpg',
      'coverImage': 'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=1200&auto=format&fit=crop',
      'followingCount': 128,
      'followersCount': 3450,
      'likesCount': 15200,
    };
  }

  @override
  Future<List<Map<String, dynamic>>> getUserPosts() async {
    // 模拟动态列表同步
    await Future.delayed(const Duration(milliseconds: 300));
    
    return [
      {
        'id': '1',
        'content': '终于等到周末了，带着我的BJ40去山里撒野！这光影真的绝了',
        'image': 'https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=400&auto=format&fit=crop',
        'date': '12-20',
        'likes': 128,
      },
      {
        'id': '2',
        'content': '周末越野去！老掌沟的雪景太美了，BJ40表现依然稳健',
        'image': 'https://images.unsplash.com/photo-1519245659620-e859806a8d3b?q=80&w=400&auto=format&fit=crop',
        'date': '12-15',
        'likes': 89,
      },
      {
        'id': '3',
        'content': '分享一下我的露营装备，后备箱刚刚好塞满',
        'image': 'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=400&auto=format&fit=crop',
        'date': '12-10',
        'likes': 256,
      },
      {
        'id': '4',
        'content': '川西自驾第三天，格聂神山真的太震撼了',
        'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=400&auto=format&fit=crop',
        'date': '11-28',
        'likes': 342,
      },
      {
        'id': '5',
        'content': '新装的车顶帐篷，周末露营必备神器',
        'image': 'https://images.unsplash.com/photo-1628172813155-2e650f934575?q=80&w=400&auto=format&fit=crop',
        'date': '11-20',
        'likes': 198,
      },
      {
        'id': '6',
        'content': '夕阳下的剪影，随手一拍都是大片',
        'image': 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=400&auto=format&fit=crop',
        'date': '11-15',
        'likes': 445,
      },
    ];
  }

  @override
  Future<List<String>> getUserPhotos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return [
      'https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?q=80&w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?q=80&w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1519245659620-e859806a8d3b?q=80&w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1628172813155-2e650f934575?q=80&w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?q=80&w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1533558701576-23c65e0272fb?q=80&w=400&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1605218427306-022ba8c26308?q=80&w=400&auto=format&fit=crop',
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getUserVehicles() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return [
      {
        'id': '1',
        'name': '北汽BJ40 PLUS',
        'plate': '京A·12345',
        'image': 'https://pngimg.com/d/jeep_PNG48.png',
        'status': '车况健康',
      },
    ];
  }
}
