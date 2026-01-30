import 'package:car_owner_app/core/base/baic_base_view_model.dart';
import 'package:car_owner_app/core/models/car_model.dart';

class TestDriveViewModel extends BaicBaseViewModel {
  final CarModel car;

  TestDriveViewModel({required this.car});

  bool _isSubmitted = false;
  bool get isSubmitted => _isSubmitted;

  // 表单数据
  String name = '张越野';
  String phone = '138****8888';
  String city = '北京市';
  String dealer = '北京汽车北京朝阳4S店';
  String date = '2025-01-15';

  bool _isAgreed = true;
  bool get isAgreed => _isAgreed;

  void setAgreed(bool value) {
    _isAgreed = value;
    notifyListeners();
  }

  void updateName(String value) {
    name = value;
  }

  void updatePhone(String value) {
    phone = value;
  }

  Future<void> sendVerificationCode() async {
    // 模拟发送验证码逻辑
    setBusy(true);
    await Future.delayed(const Duration(milliseconds: 500));
    setBusy(false);
    // 可以在这里添加 Toast 提示
  }

  Future<void> submit() async {
    if (!_isAgreed) {
      // 提示同意协议
      return;
    }

    setBusy(true);
    // 模拟提交逻辑
    await Future.delayed(const Duration(milliseconds: 800));
    _isSubmitted = true;
    setBusy(false);
    notifyListeners();
  }


  void viewMyOrders() {
    // 导航到我的预约页面
  }
}
