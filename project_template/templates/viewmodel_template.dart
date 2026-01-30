import '../lib/core/base/baic_base_view_model.dart';
// import '../lib/app/app.locator.dart';

class TemplateViewModel extends BaicBaseViewModel {
  // State
  String _title = 'Title';
  String get title => _title;

  // Logic
  Future<void> onAction() async {
    setBusy(true); // 使用基类状态
    await Future.delayed(const Duration(seconds: 1));
    setBusy(false);
    
    // MapsTo(Routes.nextView); // 使用封装方法
  }
}