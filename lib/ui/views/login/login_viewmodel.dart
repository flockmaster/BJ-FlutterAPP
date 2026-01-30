import 'package:car_owner_app/core/base/baic_base_view_model.dart';
import 'package:car_owner_app/core/services/profile_service.dart';
import 'package:car_owner_app/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:car_owner_app/core/models/profile_models.dart';
import 'dart:async';

/// [LoginViewModel] - 登录与授权中心业务逻辑类
///
/// 核心职责：
/// 1. 管理多模式登录流程：一键登录、短信验证码、账号密码及微信第三方登录。
/// 2. 处理高频 UI 交互状态：协议勾选、验证码倒计时、密码显隐及协议未勾选时的“抖动”提醒。
/// 3. 与 [IProfileService] 集成，完成用户资料持久化及应用状态更新。
class LoginViewModel extends BaicBaseViewModel {
  final _profileService = locator<IProfileService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  /// 协议抖动同步 ID
  /// 每当用户未勾选协议尝试登录时，递增此 ID 以触发 UI 层的 Shake 动画
  int _shakeSyncId = 0;
  int get shakeSyncId => _shakeSyncId;

  /// 协议错误状态 (控制 UI 元素变红)
  bool _isAgreementError = false;
  bool get isAgreementError => _isAgreementError;

  /// 触发协议缺失时的抖动反馈逻辑
  void triggerAgreementShake() {
    _shakeSyncId++;
    _isAgreementError = true;
    notifyListeners();
    
    // 500ms 后自动清除红色警告状态，但保持 shakeSyncId，以便下次仍可触发动画
    Future.delayed(const Duration(milliseconds: 500), () {
      _isAgreementError = false;
      notifyListeners();
    });
  }

  /// 当前视图模式：
  /// 'main' (星空背景一键登录), 
  /// 'form' (表单输入态), 
  /// 'wechat-bind' (微信授权后的手机绑定), 
  /// 'forgot-pass' (找回密码)
  String _viewMode = 'main';
  String get viewMode => _viewMode;

  /// 具体表单登录方式：'sms' (短信), 'password' (密码)
  String _loginMethod = 'sms';
  String get loginMethod => _loginMethod;

  String phone = '';
  String code = '';
  String password = '';
  bool showPassword = false;
  bool agreed = false;

  /// 验证码发送倒计时 (秒)
  int countdown = 0;
  Timer? _timer;

  /// 存储微信授权拿到的临时用户信息
  Map<String, dynamic>? wechatProfile;

  /// 切换视图模式
  void setViewMode(String mode) {
    _viewMode = mode;
    notifyListeners();
  }

  /// 切换登录方式（短信/密码）
  void setLoginMethod(String method) {
    _loginMethod = method;
    notifyListeners();
  }

  /// 切换密码可见性
  void toggleShowPassword() {
    showPassword = !showPassword;
    notifyListeners();
  }

  /// 切换协议勾选状态
  void toggleAgreed() {
    agreed = !agreed;
    // 若手动勾选，则立即清除之前的错误高亮
    if (agreed && _isAgreementError) {
      _isAgreementError = false;
    }
    notifyListeners();
  }

  /// 调用接口发送验证码并启动本地倒计时
  Future<void> sendCode() async {
    if (phone.isEmpty) {
      _snackbarService.showSnackbar(message: '请输入手机号');
      return;
    }
    if (phone.length != 11) {
      _snackbarService.showSnackbar(message: '手机号格式不正确');
      return;
    }

    countdown = 60;
    notifyListeners();
    _startTimer();
    _snackbarService.showSnackbar(
      message: '验证码已发送',
      duration: const Duration(seconds: 1),
    );
  }

  /// 内部倒计时计数器
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        countdown--;
        notifyListeners();
      } else {
        _timer?.cancel();
      }
    });
  }

  /// 执行登录主逻辑
  /// [type] 可选参数，区分不同登录触发场景
  Future<void> login(String type) async {
    // 核心前置拦截：必须同意隐私协议
    if (!agreed) {
      triggerAgreementShake();
      return;
    }

    // 针对表单录入进行合法性校验
    if (_viewMode == 'form') {
      if (phone.length != 11) {
        _snackbarService.showSnackbar(message: '请输入正确的手机号');
        return;
      }
      if (_loginMethod == 'sms' && code.length < 4) {
        _snackbarService.showSnackbar(message: '请输入有效的验证码');
        return;
      }
      if (_loginMethod == 'password' && password.length < 6) {
        _snackbarService.showSnackbar(message: '密码长度至少6位');
        return;
      }
    }

    setBusy(true);
    
    // 模拟网络请求及鉴权延迟
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // 构造 Mock 用户资料（生产环境将替换为真实接口返回）
    final mockProfile = UserProfile(
      id: '88293011',
      username: 'zhangyueye',
      nickname: '张越野',
      avatar: 'https://randomuser.me/api/portraits/men/75.jpg',
      phone: phone.isNotEmpty ? phone : '138****8888',
      vipLevel: 5,
      hasVehicle: true, // 一键登录场景演示：默认返回已绑车状态
      phoneVerified: true,
      isUpdated: true,
    );
    
    // 更新全局用户状态
    await _profileService.updateProfile(mockProfile.toJson());
    
    setBusy(false);
    
    // 完成登录，关闭登录页
    _navigationService.back();
  }

  /// 微信授权登录逻辑流程
  Future<void> loginWithWechat() async {
    if (!agreed) {
      triggerAgreementShake();
      return;
    }

    setBusy(true);
    // TODO: 调用第三方 SDK 进行原生授权
    await Future.delayed(const Duration(seconds: 1));
    setBusy(false);

    wechatProfile = {
      'name': 'WeChat_User',
      'avatar': 'https://randomuser.me/api/portraits/men/86.jpg',
      'id': 'wx_123456',
    };
    // 授权成功后跳转至手机号绑定环节（符合监管要求）
    setViewMode('wechat-bind');
  }

  /// 针对微信/第三方账号新关联手机号
  Future<void> bindPhone() async {
    if (phone.isEmpty || code.isEmpty) {
      _snackbarService.showSnackbar(message: '请填写完整信息');
      return;
    }

    setBusy(true);
    await Future.delayed(const Duration(milliseconds: 1200));
    
    // 针对新用户进行注册关联
    final mockProfile = UserProfile(
      id: wechatProfile?['id'] ?? 'wx_123456',
      username: 'wechat_user',
      nickname: wechatProfile?['name'] ?? 'WeChat_User',
      avatar: wechatProfile?['avatar'] ?? 'https://randomuser.me/api/portraits/men/86.jpg',
      phone: phone,
      vipLevel: 1,
      hasVehicle: false, // 社交账号新注册用户默认为未绑车状态
      phoneVerified: true,
      isUpdated: true,
    );
    
    await _profileService.updateProfile(mockProfile.toJson());
    setBusy(false);

    _navigationService.back();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
