import 'package:car_owner_app/app/routes.dart';
import 'package:car_owner_app/core/models/car_model.dart';
import 'package:car_owner_app/core/base/baic_base_view_model.dart';

/// [CarDetailViewModel] - 车型详情页业务逻辑与状态管理类
class CarDetailViewModel extends BaicBaseViewModel {
  CarModel? _car;
  /// 获取当前显示的车型数据
  CarModel? get car => _car;

  double _scrollProgress = 0.0;
  /// 顶部横轴滚动进度 (0.0 - 1.0)
  double get scrollProgress => _scrollProgress;

  double _scrollOffset = 0.0;
  /// 页面当前滚动偏移量
  double get scrollOffset => _scrollOffset;

  int _activeFeatureIndex = 0;
  /// 座舱/内饰轮播图当前选中的索引
  int get activeFeatureIndex => _activeFeatureIndex;

  bool _isVideoPlaying = false;
  /// 沉浸式预览视频是否正在播放
  bool get isVideoPlaying => _isVideoPlaying;

  /// 初始化页面数据
  void init(CarModel car) {
    _car = car;
    notifyListeners();
  }

  /// 更新页面滚动状态
  /// [progress]: 归一化的滚动进度 [0, 1]
  /// [offset]: 原始像素偏移量
  void updateScrollProgress(double progress, double offset) {
    bool changed = false;
    if (_scrollProgress != progress) {
      _scrollProgress = progress;
      changed = true;
    }
    if (_scrollOffset != offset) {
      _scrollOffset = offset;
      changed = true;
    }
    if (changed) {
      notifyListeners(); // 仅在状态变化时通知 UI 重绘
    }
  }

  /// 设置座舱特色功能当前选中的 ID
  void setActiveFeatureIndex(int index) {
    if (_activeFeatureIndex != index) {
      _activeFeatureIndex = index;
      notifyListeners();
    }
  }

  /// 切换视频播放/暂停状态
  void toggleVideoPlay() {
    _isVideoPlaying = !_isVideoPlaying;
    notifyListeners();
  }

  /// 返回上一页
  void navigateBack() {
    goBack();
  }

  /// 跳转至购车订单页面
  void navigateToOrder() {
    if (_car != null) {
      MapsTo(AppRoutes.carOrder, arguments: _car);
    }
  }

  /// 跳转至预约试驾页面
  void navigateToTestDrive() {
    if (_car != null) {
      MapsTo(AppRoutes.testDrive, arguments: _car);
    }
  }

  /// 处理分享操作
  void share() {
    // TODO: 实现社交媒体分享逻辑
    showInfo('提示', '分享功能即将上线');
  }
}