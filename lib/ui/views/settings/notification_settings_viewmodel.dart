import '../../../core/base/baic_base_view_model.dart';

/// 消息推送设置 ViewModel
class NotificationSettingsViewModel extends BaicBaseViewModel {
  // 推送类别
  bool _systemNotification = true;
  bool _activityNotification = true;
  bool _logisticsNotification = true;
  bool _interactionNotification = false;

  // 提醒方式
  bool _soundEnabled = true;
  bool _vibrationEnabled = false;

  bool get systemNotification => _systemNotification;
  bool get activityNotification => _activityNotification;
  bool get logisticsNotification => _logisticsNotification;
  bool get interactionNotification => _interactionNotification;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  Future<void> init() async {
    setBusy(true);
    // TODO: Load settings from storage
    await Future.delayed(const Duration(milliseconds: 300));
    setBusy(false);
  }

  void toggleSystemNotification(bool value) {
    _systemNotification = value;
    notifyListeners();
    _saveSettings();
  }

  void toggleActivityNotification(bool value) {
    _activityNotification = value;
    notifyListeners();
    _saveSettings();
  }

  void toggleLogisticsNotification(bool value) {
    _logisticsNotification = value;
    notifyListeners();
    _saveSettings();
  }

  void toggleInteractionNotification(bool value) {
    _interactionNotification = value;
    notifyListeners();
    _saveSettings();
  }

  void toggleSound(bool value) {
    _soundEnabled = value;
    notifyListeners();
    _saveSettings();
  }

  void toggleVibration(bool value) {
    _vibrationEnabled = value;
    notifyListeners();
    _saveSettings();
  }

  Future<void> _saveSettings() async {
    // TODO: Save to storage
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
