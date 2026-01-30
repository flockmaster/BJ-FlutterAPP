import '../../../core/base/baic_base_view_model.dart';

class PrivacySettingsViewModel extends BaicBaseViewModel {

  bool _showBlockList = false;
  List<Map<String, dynamic>> _blockedUsers = [];

  bool get showBlockList => _showBlockList;
  List<Map<String, dynamic>> get blockedUsers => _blockedUsers;

  Future<void> init() async {
    setBusy(true);
    await _loadSettings();
    setBusy(false);
  }

  Future<void> _loadSettings() async {
    // TODO: Load from API
    await Future.delayed(const Duration(milliseconds: 300));
    _blockedUsers = [
      {
        'id': 1,
        'name': '广告推销号001',
        'time': '2023-12-01',
      },
      {
        'id': 2,
        'name': '不文明用户',
        'time': '2023-11-15',
      },
    ];
  }

  void showBlockListPage() {
    _showBlockList = true;
    notifyListeners();
  }

  void hideBlockListPage() {
    _showBlockList = false;
    notifyListeners();
  }

  Future<void> unblockUser(int id) async {
    _blockedUsers.removeWhere((user) => user['id'] == id);
    notifyListeners();
    // TODO: Update API
  }

  Future<void> navigateToVisibilitySettings() async {
    await dialogService.showDialog(
      title: '动态可见性',
      description: '此功能正在开发中',
    );
  }

  Future<void> navigateToSystemPermissions() async {
    await dialogService.showDialog(
      title: '系统权限管理',
      description: '此功能正在开发中',
    );
  }

  Future<void> navigateToThirdPartyInfo() async {
    await dialogService.showDialog(
      title: '第三方共享信息',
      description: '此功能正在开发中',
    );
  }

  Future<void> navigateToDataCollection() async {
    await dialogService.showDialog(
      title: '个人信息收集清单',
      description: '此功能正在开发中',
    );
  }

  Future<void> viewPrivacyPolicy() async {
    await dialogService.showDialog(
      title: '隐私政策条款',
      description: '此功能正在开发中',
    );
  }
}
