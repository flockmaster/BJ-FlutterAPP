import 'package:flutter/material.dart'; // Keep for Color
import 'package:car_owner_app/core/base/baic_base_view_model.dart';
// Note: BaseViewModel from stacked is transitively exported or we can import it, but BaicBaseViewModel is preferred.

/// [VRExperienceViewModel] - 3D 虚拟展厅（虚拟看车）业务逻辑类
///
/// 核心职责：
/// 1. 控制 3D 车辆模型的渲染状态：包含自动旋转开关、三维坐标视角重置。
/// 2. 管理实时换色交互：提供多种品牌车漆配色方案，并驱动渲染层实现材质即时切换。
/// 3. 辅助展示车型卖点与参数配置。
class VRExperienceViewModel extends BaicBaseViewModel {
  final String carName;
  final String? modelPath;

  VRExperienceViewModel({
    required this.carName,
    this.modelPath,
  });

  /// 状态：是否开启模型 360 度自动匀速旋转
  bool _isAutoRotate = true;
  bool get isAutoRotate => _isAutoRotate;

  /// 当前选定的车漆配色索引
  int _selectedColorIndex = 0;
  int get selectedColorIndex => _selectedColorIndex;

  /// 定义品牌核心配色方案（名称 + 视觉色彩值）
  final List<Map<String, dynamic>> carColors = [
    {'name': '熔岩橙', 'hex': const Color(0xFFFF6B00)},
    {'name': '极夜黑', 'hex': const Color(0xFF1A1A1A)},
    {'name': '雪域白', 'hex': Colors.white},
    {'name': '太空银', 'hex': const Color(0xFFA5A5A5)},
  ];

  /// 生命周期：根据车型加载指定的 GLB/GLTF 3D 素材
  void init() {
    if (modelPath == null) {
      notifyListeners();
    }
  }

  /// 交互：开启或禁用自动环绕展示
  void toggleAutoRotate() {
    _isAutoRotate = !_isAutoRotate;
    notifyListeners();
  }

  /// 交互：切换模型材质颜色
  void selectColor(int index) {
    _selectedColorIndex = index;
    notifyListeners();
    
    // TODO: 调用 GL渲染器对应接口应用材质偏移或纹理色值
  }
}
