import '../../../app/app.locator.dart';
import '../../../core/base/baic_base_view_model.dart';
import '../../../core/services/discovery_service.dart';

class UpdateNicknameViewModel extends BaicBaseViewModel {
  // 1. DI Services
  final _discoveryService = locator<IDiscoveryService>();

  // 2. State
  String _nickname = '';
  String get nickname => _nickname;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 3. Computed Properties
  bool get isValid => _nickname.isNotEmpty && _nickname.length <= 16;
  
  String get hintText => '1-16个字，支持中英文、数字';
  
  String get pageTitle => '我的昵称';
  
  String get saveButtonText => '完成';
  
  String get nicknameLabel => '昵称';
  
  String get wechatImportText => '微信导入';
  
  String get disclaimerText => '* 设置昵称后才能发布、评论社区内容。';

  // 4. Logic
  void updateNickname(String value) {
    _nickname = value;
    notifyListeners();
  }

  Future<void> saveNickname() async {
    if (!isValid || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final success = await _discoveryService.updateUserNickname(_nickname);
      if (success) {
        goBack(result: _nickname);
      }
    } catch (e) {
      // Handle error - could show dialog or snackbar
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void importFromWechat() {
    // TODO: 实现微信导入功能
  }

  void changeAvatar() {
    // TODO: 实现头像更换功能
  }
}