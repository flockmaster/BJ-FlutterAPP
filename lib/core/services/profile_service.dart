import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import '../base/base_state.dart';
import '../models/profile_models.dart';

/// [IProfileService] - 用户个人中心服务接口
/// 
/// 负责处理：登录、注销、个人资料获取/更新、车辆绑定等核心用户信息操作。
/// 混入 [ListenableServiceMixin] 以支持对用户信息状态的响应式监听。
abstract class IProfileService with ListenableServiceMixin {
  /// 获取当前登录用户信息
  UserProfile? get currentUser;
  
  /// 判断当前是否已登录
  bool get isLoggedIn;
  
  /// 账号密码/验证码登录
  /// [phone]：手机号
  /// [codeOrPass]：验证码或密码
  Future<Result<UserProfile>> login(String phone, String codeOrPass);
  
  /// 微信一键登录
  /// [wechatData]：包含微信 OpenID、Token 等信息的 Map
  Future<Result<UserProfile>> loginWithWechat(Map<String, dynamic> wechatData);
  
  /// 注销登录：清除本地 Token 与用户信息缓存
  Future<void> logout();
  
  /// 从后端同步最新的用户信息
  Future<Result<UserProfile>> getUserProfile();
  
  /// 获取当前用户名下绑定的车辆列表
  Future<Result<List<UserVehicle>>> getUserVehicles();
  
  /// 更新个人资料（如昵称、头像等）
  Future<Result<UserProfile>> updateProfile(Map<String, dynamic> data);
  
  /// 绑定新车辆
  /// [vin]：车架号
  /// [plateNumber]：车牌号
  Future<Result<UserVehicle>> bindVehicle(String vin, String? plateNumber);
  
  /// 解绑车辆
  Future<Result<void>> unbindVehicle(String vehicleId);
  
  /// 获取当前佩戴的勋章 ID
  int? get wornMedalId;
  
  /// 设置当前佩戴的勋章
  void setWornMedalId(int? id);
}

/// [ProfileService] - 用户个人中心服务具体实现
/// 
/// 核心特性：
/// 1. 使用 [ReactiveValue] 管理 [currentUser]，任何对此值的修改都会自动通知订阅该服务的 ViewModel。
/// 2. 遵循 [IProfileService] 定义的异步操作契约，并返回 [Result] 包装类。
@LazySingleton(as: IProfileService)
class ProfileService with ListenableServiceMixin implements IProfileService {
  ProfileService() {
    // 监听响应式变量的变化，确保 UI 能够实时响应用户状态变更
    listenToReactiveValues([_currentUser]);
  }

  // 响应式存储：当前用户信息
  final ReactiveValue<UserProfile?> _currentUser = ReactiveValue<UserProfile?>(null);

  @override
  UserProfile? get currentUser => _currentUser.value;

  @override
  bool get isLoggedIn => _currentUser.value != null;

  // 模拟持久化的勋章状态
  int? _wornMedalId = 1; 

  @override
  int? get wornMedalId => _wornMedalId;

  @override
  void setWornMedalId(int? id) {
    _wornMedalId = id;
    notifyListeners(); // 手动通知，因其不是 ReactiveValue
  }

  @override
  Future<Result<UserProfile>> login(String phone, String codeOrPass) async {
    // 模拟网络请求过程
    await Future.delayed(const Duration(milliseconds: 1500)); 
    
    // 模拟后端返回的用户数据模型
    final profile = UserProfile(
      id: '88293011',
      username: phone,
      nickname: '张越野',
      avatar: 'https://randomuser.me/api/portraits/men/75.jpg',
      phone: phone,
      vipLevel: 5,
      hasVehicle: true, 
      createdAt: DateTime.now(),
    );
    
    // 更新响应式状态，触发 UI 刷新
    _currentUser.value = profile;
    return Result.success(profile);
  }

  @override
  Future<Result<UserProfile>> loginWithWechat(Map<String, dynamic> wechatData) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    final profile = UserProfile(
      id: wechatData['id'] ?? 'wx_123456',
      username: 'wechat_user',
      nickname: wechatData['name'] ?? '微信用户',
      avatar: wechatData['avatar'] ?? 'https://randomuser.me/api/portraits/men/86.jpg',
      vipLevel: 1,
      hasVehicle: false, 
      createdAt: DateTime.now(),
    );
    
    _currentUser.value = profile;
    return Result.success(profile);
  }

  @override
  Future<Result<UserProfile>> getUserProfile() async {
    if (!isLoggedIn) return Result.failure('未登录');
    return Result.success(_currentUser.value!);
  }

  @override
  Future<Result<List<UserVehicle>>> getUserVehicles() async {
    if (!isLoggedIn) return Result.failure('未登录');
    
    await Future.delayed(const Duration(milliseconds: 300));
    
    // 模拟根据当前用户状态返回绑定的车辆列表
    if (_currentUser.value?.hasVehicle == true) {
      return Result.success([
        const UserVehicle(
          id: 'v1',
          name: '北京 BJ40 环塔冠军版',
          imageUrl: 'https://www.helloimg.com/i/2025/12/23/694a28886a3df.jpg',
          plateNumber: '京A·88888',
          vin: 'VIN1234567890',
          isPrimary: true,
          status: 'active',
        )
      ]);
    }
    
    return Result.success([]);
  }

  @override
  Future<Result<UserProfile>> updateProfile(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    UserProfile? updatedProfile;
    
    // 逻辑：如果当前已登录，则进行局部更新覆盖；否则基于 JSON 构建
    if (_currentUser.value == null) {
      try {
        updatedProfile = UserProfile.fromJson(data);
      } catch (e) {
        return Result.failure('初始化用户信息失败: $e');
      }
    } else {
      updatedProfile = _currentUser.value!.copyWith(
        id: data['id'] as String?,
        username: data['username'] as String?,
        phone: data['phone'] as String?,
        avatar: data['avatar'] as String?,
        nickname: data['nickname'] as String?,
        vipLevel: data['vipLevel'] as int?,
        hasVehicle: data['hasVehicle'] as bool?,
        phoneVerified: data['phoneVerified'] as bool?,
        isUpdated: data['isUpdated'] as bool?,
      );
    }
    
    _currentUser.value = updatedProfile;
    return Result.success(updatedProfile);
  }

  @override
  Future<Result<UserVehicle>> bindVehicle(String vin, String? plateNumber) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    // 模拟绑定成功流程：不仅返回车辆结果，同时更新当前用户的"已有车辆"状态
    if (isLoggedIn) {
      _currentUser.value = _currentUser.value!.copyWith(hasVehicle: true);
    }
    return Result.success(UserVehicle(id: 'v2', name: '新绑定车辆', vin: vin, plateNumber: plateNumber));
  }

  @override
  Future<Result<void>> unbindVehicle(String vehicleId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return Result.success(null);
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // 清空登录态，此操作将触发引用该服务的所有响应式 UI 退回到未登录模式
    _currentUser.value = null;
    notifyListeners();
  }
}
