import '../../../core/base/baic_base_view_model.dart';
import '../../../app/app.locator.dart';
import '../../../core/services/cache_service.dart';
import 'package:car_owner_app/core/services/profile_service.dart';

/// 设置页面 ViewModel
/// 管理设置页面的状态和业务逻辑
/// 严格遵循 BAIC 架构规范：禁止使用 BuildContext、Navigator
/// [SettingsViewModel] - 系统设置与账号管理业务逻辑类
///
/// 核心职责：
/// 1. 管理应用基础配置：缓存监控与一键清理、版本在线检测与关于信息。
/// 2. 处理账号全局生命周期：退出登录（清除持久化状态并导航重置）。
/// 3. 分发设置项导航：账号绑定、地址管理、隐私协议、推送通知等二级页面路由。
class SettingsViewModel extends BaicBaseViewModel {
  final ICacheService _cacheService = locator<ICacheService>();
  final IProfileService _profileService = locator<IProfileService>();

  // 页面响应式状态
  bool _showLogoutModal = false; /// 退出确认弹窗显隐
  String _cacheSize = '0 B'; /// 实时缓存磁盘占用大小
  String _appVersion = 'v2.1.0'; /// 当前应用版本号

  // Getters
  bool get showLogoutModal => _showLogoutModal;
  String get cacheSize => _cacheSize;
  String get appVersion => _appVersion;

  /// 生命周期：初始化时载入系统元数据（缓存与版本）
  Future<void> init() async {
    setBusy(true);
    await _loadCacheSize();
    await _loadAppVersion();
    setBusy(false);
  }

  /// 业务加载：统计当前 App 各模块产生的临时文件大小
  Future<void> _loadCacheSize() async {
    _cacheSize = await _cacheService.getCacheSize();
    notifyListeners();
  }

  /// 业务加载：提取当前包定义的展示版本
  Future<void> _loadAppVersion() async {
    _appVersion = 'v2.1.0'; // TODO: 集成 package_info_plus 提取真实包版本
    notifyListeners();
  }

  /// 交互：唤起底部/中心退出登录二次确认弹窗
  void showLogoutConfirmation() {
    _showLogoutModal = true;
    notifyListeners();
  }

  /// 交互：关闭退出弹窗
  void hideLogoutModal() {
    _showLogoutModal = false;
    notifyListeners();
  }

  /// 关键流程：核心退出登录指令
  /// 执行后会通知 [IProfileService] 重置全局登录态，并切断所有敏感业务流
  Future<void> handleLogout() async {
    hideLogoutModal();
    setBusy(true); 

    await _profileService.logout();
    
    setBusy(false);
    
    // 执行完退出后，回退至主个人中心页同步 UI 刷新
    goBack();
  }

  // --- 导航路由分发集 ---

  /// 导向第三方账号（微信、Apple）绑定管理
  void navigateToAccountBinding() {
    MapsTo('/account-binding-view');
  }

  /// 导向电商收货地址簿管理
  void navigateToAddressList() {
    MapsTo('/address-list-view');
  }

  /// 导向常用开票抬头管理
  void navigateToInvoiceList() {
    MapsTo('/invoice-list-view');
  }

  /// 导向隐私权限与账号注销管理
  void navigateToPrivacySettings() {
    MapsTo('/privacy-settings-view');
  }

  /// 导向系统通知开关设置
  void navigateToNotificationSettings() {
    MapsTo('/notification-settings-view');
  }

  /// 导向用户反馈与吐槽建议入口
  void navigateToFeedback() {
    MapsTo('/feedback-view');
  }

  /// 交互：触发修改登录密码流程（需敏感操作提权）
  Future<void> handleChangePassword() async {
    await dialogService.showDialog(
      title: '修改密码',
      description: '此功能正在开发中',
    );
  }

  /// 交互：执行磁盘缓存清除动作
  Future<void> handleClearCache() async {
    final result = await dialogService.showConfirmationDialog(
      title: '清理缓存',
      description: '确认清理所有缓存数据？',
      confirmationTitle: '确认',
      cancelTitle: '取消',
    );

    if (result?.confirmed == true) {
      setBusy(true);
      await _cacheService.clearCache();
      await _loadCacheSize(); // 刷新显示为 0
      setBusy(false);
      
      await dialogService.showDialog(
        title: '清理成功',
        description: '缓存已成功清理',
      );
    }
  }

  /// 交互：展示关于北汽 App 的法律申明与版权信息
  Future<void> handleAboutUs() async {
    await dialogService.showDialog(
      title: '关于我们',
      description: '北京汽车车主APP\n版本: $_appVersion\n\n© 2024 北京汽车集团有限公司',
    );
  }
}
