import 'package:flutter/material.dart';
import '../../../../core/base/baic_base_view_model.dart';

enum RescueStatus { idle, requesting, enRoute }

class RoadsideAssistanceViewModel extends BaicBaseViewModel {
  RescueStatus _status = RescueStatus.idle;
  RescueStatus get status => _status;

  // 模拟倒计时
  int _arrivalTime = 15;
  int get arrivalTime => _arrivalTime;

  Future<void> requestRescue() async {
    _status = RescueStatus.requesting;
    notifyListeners();

    // 模拟网络请求和调度延迟
    await Future.delayed(const Duration(seconds: 2));

    _status = RescueStatus.enRoute;
    notifyListeners();
  }

  void cancelRescue() {
    _status = RescueStatus.idle;
    notifyListeners();
  }

  void contactDriver() {
    // TODO: 实现联系司机逻辑
  }

  void contactSupport() {
    // TODO: 实现联系专员逻辑
  }

  void goBackCustom() {
    goBack();
  }
}
