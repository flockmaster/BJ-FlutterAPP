import 'package:stacked/stacked.dart';
import '../../../app/app.locator.dart';
import '../../../core/base/baic_base_view_model.dart';
import '../../../core/base/base_state.dart';
import '../../../core/models/profile_models.dart';
import '../../../core/services/profile_service.dart';
import '../../../core/utils/number_utils.dart';
import 'dart:async';

/// [ProfileViewModel] - 个人中心（我的）核心业务逻辑类
///
/// 核心职责：
/// 1. 响应式监听 [IProfileService]，实现登录状态、用户信息（昵称/头像/勋章）的实时更新。
/// 2. 聚合社交统计数据（关注/粉丝/动态/获赞）与资产信息（积分/卡券/订单）。
/// 3. 管理用户名下的车辆列表及其在线状态。
/// 4. 处理极其丰富的页面跳转逻辑，涵盖了应用 70% 的二级功能入口。
class ProfileViewModel extends BaicBaseViewModel {
  // 依赖注入服务
  final _profileService = locator<IProfileService>();

  // 内部状态
  List<UserVehicle> _vehicles = [];
  ViewState _state = ViewState.idle;

  int _currentMessageIndex = 0;
  double _headerOpacity = 0.0;
  bool _isTickerStarted = false; // 控制通知轮询 Ticker 仅启动一次

  @override
  /// 声明响应式服务，当 _profileService 内部状态变化时，此 ViewModel 会自动调用 notifyListeners()
  List<ListenableServiceMixin> get listenableServices => [_profileService];

  // 状态获取器
  UserProfile? get userProfile => _profileService.currentUser;
  bool get isLoggedIn => _profileService.isLoggedIn;
  
  List<UserVehicle> get vehicles => _vehicles;
  ViewState get state => _state;
  int get currentMessageIndex => _currentMessageIndex;
  /// 顶部导航栏透明度（随滚动位置动态计算）
  double get headerOpacity => _headerOpacity;
  
  // UI 展示数据
  String get displayName => userProfile?.nickname ?? '张越野';
  String get userId => '88293011';
  String get location => '北京·朝阳';
  String get bio => '热爱越野，热爱生活。'; 
  String get userLevel => 'Lv.${userProfile?.vipLevel ?? 0} 资深车主';
  String get avatarUrl => userProfile?.avatar ?? 'https://randomuser.me/api/portraits/men/75.jpg';
  int? get wornMedalId => _profileService.wornMedalId;
  
  // 资产与订单统计
  String get pointsBalance => '2,450';
  String get couponsCount => '3';
  String get orderStatus => '进行中';

  // 社交统计数据格式化
  String get followingCount => NumberUtils.formatCount(userProfile?.followingCount);
  String get followersCount => NumberUtils.formatCount(userProfile?.followersCount);
  String get likesCount => NumberUtils.formatCount(userProfile?.likesCount);
  
  /// 通知中心跑马灯消息源
  List<String> get messages => [
    '您的BJ40预约保养已确认，请准时前往',
    '双11特惠活动开启，越野配件由低至5折',
    '恭喜您获得"越野达人"勋章，快去查看'
  ];
  
  String get currentMessage => messages[_currentMessageIndex];
  int get messageCount => 3;
  
  /// 动态/发帖总数
  String get postsCount => NumberUtils.formatCount(userProfile?.postsCount);

  // 车辆快速访问信息
  String get vehicleName => vehicles.isNotEmpty ? vehicles.first.name : '北汽BJ40 PLUS';
  String get vehiclePlate => vehicles.isNotEmpty ? vehicles.first.plateNumber ?? '京A·12345' : '京A·12345';
  String get vehicleImageUrl => 'https://pngimg.com/d/jeep_PNG48.png';
  String get maintenanceInfo => '下次保养：还剩1200公里';

  /// 初始化页面数据
  Future<void> init({bool showLoading = true}) async {
    if (showLoading) setBusy(true);
    
    // 若已登录，则需要补全车辆等额外数据
    if (isLoggedIn) {
      await loadVehicles();
    }
    
    if (showLoading) setBusy(false);
    _startMessageTicker();
  }

  /// 启动消息轮播定时器
  void _startMessageTicker() {
    if (_isTickerStarted) return; 
    _isTickerStarted = true;
    
    Stream.periodic(const Duration(seconds: 4)).listen((_) {
      _currentMessageIndex = (_currentMessageIndex + 1) % messages.length;
      notifyListeners();
    });
  }

  /// 异步加载用户完整资料
  Future<void> loadProfile() async {
    _state = ViewState.loading;
    
    try {
      final result = await _profileService.getUserProfile();
      
      result.when(
        success: (data) {
          _state = ViewState.success;
        },
        failure: (error) {
          setError(error);
          _state = ViewState.error;
        },
      );

      await loadVehicles();
    } catch (e) {
      setError('加载用户信息失败: ${e.toString()}');
      _state = ViewState.error;
    }
  }

  /// 加载当前用户关联的所有车辆
  Future<void> loadVehicles() async {
    if (!isLoggedIn) return;

    try {
      final result = await _profileService.getUserVehicles();
      
      result.when(
        success: (data) {
          _vehicles = data;
        },
        failure: (error) {
          // 车辆信息为非阻塞性数据
        },
      );
      notifyListeners();
    } catch (e) {
      // 捕获异常，防止页面加载中断
    }
  }

  /// 下拉刷新逻辑
  Future<void> refresh() async {
    await init(showLoading: false);
  }

  /// 交互：更新用户资料（如昵称/头像）
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    setBusy(true);

    try {
      final result = await _profileService.updateProfile(data);
      
      return result.when(
        success: (profile) {
          notifyListeners();
          return true;
        },
        failure: (error) {
          setError(error);
          return false;
        },
      );
    } catch (e) {
      setError('更新失败: ${e.toString()}');
      return false;
    } finally {
      setBusy(false);
    }
  }

  /// 交互：绑定车辆 (通过 VIN 码)
  Future<bool> bindVehicle(String vin, String? plateNumber) async {
    if (!isLoggedIn) return false;

    setBusy(true);

    try {
      final result = await _profileService.bindVehicle(vin, plateNumber);
      
      return result.when(
        success: (vehicle) {
          _vehicles.add(vehicle);
          notifyListeners();
          return true;
        },
        failure: (error) {
          setError(error);
          return false;
        },
      );
    } catch (e) {
      setError('绑定车辆失败: ${e.toString()}');
      return false;
    } finally {
      setBusy(false);
    }
  }

  /// 交互：解绑车辆
  Future<bool> unbindVehicle(String vehicleId) async {
    if (!isLoggedIn) return false;

    setBusy(true);

    try {
      final result = await _profileService.unbindVehicle(vehicleId);
      
      return result.when(
        success: (_) {
          _vehicles.removeWhere((v) => v.id == vehicleId);
          notifyListeners();
          return true;
        },
        failure: (error) {
          setError(error);
          return false;
        },
      );
    } catch (e) {
      setError('解绑车辆失败: ${e.toString()}');
      return false;
    } finally {
      setBusy(false);
    }
  }

  /// 业务操作：退出登录
  Future<void> logout() async {
    await _profileService.logout();
    _vehicles = [];
    _state = ViewState.idle;
    notifyListeners();
  }

  // 导航逻辑组
  
  /// 导向登录中心
  void navigateToLogin() {
    MapsTo(Routes.loginView);
  }

  /// 快捷测试：模拟带车账户快速登录
  Future<void> quickLogin() async {
    setBusy(true);
    await _profileService.login('13800138000', '123456');
    await init(showLoading: false);
    setBusy(false);
  }

  void navigateToScanner() => MapsTo(Routes.scannerView);
  void navigateToMyQRCode() => MapsTo(Routes.myQRCodeView);
  
  void navigateToProfileDetail() async {
    if (!isLoggedIn) {
      navigateToLogin();
      return;
    }
    await MapsTo(Routes.profileDetailView);
    notifyListeners();
  }

  void navigateToCheckIn() {
    if (!isLoggedIn) {
      navigateToLogin();
      return;
    }
    MapsTo(Routes.checkInView);
  }
  
  void navigateToFollowList(String type) {
    if (!isLoggedIn) {
      navigateToLogin();
      return;
    }
    MapsTo(Routes.followListView, arguments: FollowListViewArguments(type: type));
  }

  void navigateToMyPosts() {
    if (!isLoggedIn) {
      navigateToLogin();
      return;
    }
    MapsTo(Routes.myPostsView);
  }

  void navigateToMyFavorites() {
    if (!isLoggedIn) {
      navigateToLogin();
      return;
    }
    MapsTo(Routes.myFavoritesView);
  }
  
  void navigateToMessageCenter() {
    if (!isLoggedIn) {
      navigateToLogin();
      return;
    }
    MapsTo(Routes.messageCenterView);
  }

  void navigateToMyVehicles() {
    if (!isLoggedIn) {
      navigateToLogin();
      return;
    }
    MapsTo(Routes.myVehiclesView);
  }
  
  void navigateToOrderList() {
    if (!isLoggedIn) {
      navigateToLogin();
      return;
    }
    MapsTo(Routes.orderListView);
  }

  void navigateToCoupons() {
    if (!isLoggedIn) {
      navigateToLogin();
      return;
    }
    MapsTo(Routes.myCouponsView);
  }

  void navigateToTaskCenter() {
    if (!isLoggedIn) {
      navigateToLogin();
      return;
    }
    MapsTo(Routes.taskCenterView);
  }
  
  void navigateToInviteFriends() => MapsTo(Routes.inviteFriendsView);
  
  void navigateToCustomerService() => MapsTo(Routes.customerServiceView);
  void navigateToHelpCenter() => MapsTo(Routes.helpCenterView);
  void navigateToSettings() => MapsTo(Routes.settingsView);

  // UI 事件分发器 (适配器层，方便 UI 调用)
  void updateHeaderOpacity(double opacity) {
    _headerOpacity = opacity;
    notifyListeners();
  }

  void updateMessageIndex(int index) {
    _currentMessageIndex = index;
    notifyListeners();
  }

  void handleSignInTap() => navigateToCheckIn();
  void handleNotificationTap() => navigateToMessageCenter();
  void handleVehicleTap() => navigateToMyVehicles();

  void handleAssetTap(String assetType) {
    switch (assetType) {
      case 'points':
        navigateToCheckIn();
        break;
      case 'orders':
        navigateToOrderList();
        break;
      case 'coupons':
        navigateToCoupons();
        break;
      case 'tasks':
        navigateToTaskCenter();
        break;
    }
  }

  void handleInviteTap() => navigateToInviteFriends();

  void handleMenuTap(String menuType) {
    switch (menuType) {
      case 'help_center':
        navigateToHelpCenter();
        break;
      case 'customer_service':
        navigateToCustomerService();
        break;
      case 'settings':
        navigateToSettings();
        break;
    }
  }

  void handleFollowingTap() => navigateToFollowList('following');
  void handleFollowersTap() => navigateToFollowList('followers');
  void handlePostsTap() => navigateToMyPosts();
  void handleFavoritesTap() => navigateToMyFavorites();
}