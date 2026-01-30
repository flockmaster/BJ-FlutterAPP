import 'package:flutter/material.dart'; // Keeping temporarily for dialog building logic
import 'package:car_owner_app/core/base/baic_base_view_model.dart';
import '../../../app/app.dialogs.dart'; // Import DialogType

/// 预约保养页面 ViewModel
class MaintenanceBookingViewModel extends BaicBaseViewModel {
  // 保养套餐列表
  final List<Map<String, dynamic>> packages = [
    {
      'id': 'A',
      'name': 'A类基础保养',
      'price': 580,
      'items': ['更换机油', '更换机滤', '全车检查'],
      'recommend': true,
    },
    {
      'id': 'B',
      'name': 'B类深度保养',
      'price': 1280,
      'items': ['更换机油机滤', '更换空气滤芯', '更换空调滤芯', '制动液检查'],
      'recommend': false,
    },
  ];

  // 时间段列表
  final List<String> timeSlots = [
    '09:00',
    '10:00',
    '11:00',
    '14:00',
    '15:00',
    '16:00',
  ];

  // 选中的套餐索引
  int _selectedPackageIndex = 0;
  int get selectedPackageIndex => _selectedPackageIndex;

  // 选中的日期索引
  int _selectedDateIndex = 0;
  int get selectedDateIndex => _selectedDateIndex;

  // 选中的时间索引
  int _selectedTimeIndex = 1; // 默认选中 10:00
  int get selectedTimeIndex => _selectedTimeIndex;

  // 获取选中的套餐
  Map<String, dynamic> get selectedPackage => packages[_selectedPackageIndex];

  // 获取选中的日期
  DateTime get selectedDate => DateTime.now().add(Duration(days: _selectedDateIndex + 1));

  // 获取选中的时间
  String get selectedTime => timeSlots[_selectedTimeIndex];

  /// 初始化
  void initialize() {
    // 可以在这里加载数据
  }

  /// 选择套餐
  void selectPackage(int index) {
    _selectedPackageIndex = index;
    notifyListeners();
  }

  /// 选择日期
  void selectDate(int index) {
    _selectedDateIndex = index;
    notifyListeners();
  }

  /// 选择时间
  void selectTime(int index) {
    _selectedTimeIndex = index;
    notifyListeners();
  }

  /// 确认预约
  void confirmBooking() {
    // 获取选中的套餐信息
    final package = selectedPackage;
    final packageName = package['name'] as String;
    final packagePrice = package['price'] as int;
    final storeName = '北京汽车越野4S店（朝阳）';
    final date = selectedDate;
    final time = selectedTime;

    // 显示确认对话框 - 使用 Custom Dialog
    dialogService.showCustomDialog(
      variant: DialogType.bookingSuccess,
      customData: {
        'packageName': packageName,
        'storeName': storeName,
        'timeStr': '${_formatDate(date)} $time',
        'price': packagePrice,
      },
    ).then((_) {
       goBack(); // 确认后返回上一页
       goBack(); // 可能需要退两层
    });
  }

  String _formatDate(DateTime date) {
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final weekday = weekdays[date.weekday - 1];
    return '${date.month}月${date.day}日 $weekday';
  }
}
