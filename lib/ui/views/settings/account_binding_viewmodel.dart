import '../../../core/base/baic_base_view_model.dart';

class AccountBindingViewModel extends BaicBaseViewModel {

  final String _phoneNumber = '138****8888';
  final String _email = '';
  final String _wechatName = '';
  final bool _isPhoneBound = true;
  final bool _isEmailBound = false;
  final bool _isWechatBound = false;

  String get phoneNumber => _phoneNumber;
  String get email => _email;
  String get wechatName => _wechatName;
  bool get isPhoneBound => _isPhoneBound;
  bool get isEmailBound => _isEmailBound;
  bool get isWechatBound => _isWechatBound;

  Future<void> init() async {
    setBusy(true);
    await _loadBindings();
    setBusy(false);
  }

  Future<void> _loadBindings() async {
    // TODO: Load from API
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> handlePhoneBinding() async {
    await dialogService.showDialog(
      title: '更换手机号',
      description: '此功能正在开发中',
    );
  }

  Future<void> handleEmailBinding() async {
    await dialogService.showDialog(
      title: '绑定邮箱',
      description: '此功能正在开发中',
    );
  }

  Future<void> handleWechatBinding() async {
    await dialogService.showDialog(
      title: '绑定微信',
      description: '此功能正在开发中',
    );
  }

  Future<void> handleDeleteAccount() async {
    // TODO: Implement account deletion API call
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
