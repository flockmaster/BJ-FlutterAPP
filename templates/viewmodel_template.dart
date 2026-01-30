import 'package:car_owner_app/core/base/baic_base_view_model.dart';
import 'package:car_owner_app/app/app.locator.dart';

class TemplateViewModel extends BaicBaseViewModel {
  // Dependency Injection (如果需要监听服务，请解开下方注释)
  // final _exampleService = locator<ExampleService>();

  // @override
  // List<ListenableServiceMixin> get listenableServices => [_exampleService];
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