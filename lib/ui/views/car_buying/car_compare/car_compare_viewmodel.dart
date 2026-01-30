import '../../../../core/base/baic_base_view_model.dart';
import '../../../../core/models/car_model.dart';

/// 车型对比 ViewModel
/// 遵循 BAIC 架构规范：继承 BaicBaseViewModel，使用 NavigationService
class CarCompareViewModel extends BaicBaseViewModel {
  // 所有可用车型列表
  List<CarModel> _availableModels = [];
  List<CarModel> get availableModels => _availableModels;

  // 当前选中的车型（最多2个）
  List<CarModel> _selectedModels = [];
  List<CarModel> get selectedModels => _selectedModels;

  // 是否隐藏相同参数
  bool _hideSame = false;
  bool get hideSame => _hideSame;

  // 是否显示添加车型弹窗
  bool _showAddModal = false;
  bool get showAddModal => _showAddModal;

  /// 车型参数数据（来自原型 SPEC_DATA）
  /// 遵循原型驱动开发：原封不动复刻原型中的模拟数据
  static const Map<String, Map<String, String>> specData = {
    'BJ30': {
      'price': '10.99-12.99万',
      'engine': '1.5T 188马力 L4',
      'transmission': '7挡湿式双离合',
      'structure': '承载式 SUV',
      'size': '4730*1910*1790',
      'wheelbase': '2820',
      'ground_clearance': '215mm',
      'drive_mode': '前置前驱/四驱',
      'angles': '25° / 30°',
      'diff_lock': '-',
      'screen': '10.25+14.6英寸',
      'seat': '仿皮',
      'adas': 'L2级辅助驾驶',
      'speaker': '8扬声器',
    },
    'BJ40': {
      'price': '15.98-26.99万',
      'engine': '2.0T 245马力 L4',
      'transmission': '8挡手自一体',
      'structure': '非承载式 SUV',
      'size': '4790*1940*1929',
      'wheelbase': '2745',
      'ground_clearance': '220mm',
      'drive_mode': '分时四驱',
      'angles': '37° / 31°',
      'diff_lock': '前/后桥差速锁',
      'screen': '10.25+12.8英寸',
      'seat': '真皮/仿皮',
      'adas': 'L2级辅助驾驶',
      'speaker': '12扬声器(燕飞利仕)',
    },
    'BJ60': {
      'price': '23.98-28.58万',
      'engine': '2.0T 267马力 L4 + 48V',
      'transmission': '8挡手自一体',
      'structure': '非承载式 SUV',
      'size': '5040*1955*1925',
      'wheelbase': '2820',
      'ground_clearance': '215mm',
      'drive_mode': '分时四驱',
      'angles': '30° / 24°',
      'diff_lock': '前/后桥差速锁',
      'screen': '10.25+12.8英寸',
      'seat': '真皮',
      'adas': 'L2.5级辅助驾驶',
      'speaker': '12扬声器(哈曼卡顿)',
    },
    'BJ80': {
      'price': '29.80-39.80万',
      'engine': '3.0T 280马力 V6',
      'transmission': '8挡手自一体',
      'structure': '非承载式 SUV',
      'size': '4765*1955*1985',
      'wheelbase': '2800',
      'ground_clearance': '215mm',
      'drive_mode': '分时四驱',
      'angles': '39° / 33°',
      'diff_lock': '后桥差速锁',
      'screen': '10.25英寸',
      'seat': 'Nappa真皮',
      'adas': '-',
      'speaker': '8扬声器',
    },
    'WARRIOR': {
      'price': '暂无报价',
      'engine': '3.0T V6 / 2.4T 柴油',
      'transmission': '9挡手自一体',
      'structure': '非承载式 皮卡',
      'size': '5400*1990*1960',
      'wheelbase': '3200',
      'ground_clearance': '235mm',
      'drive_mode': '全时四驱',
      'angles': '35° / 28°',
      'diff_lock': '前/中/后三把锁',
      'screen': '12.8+15.6英寸',
      'seat': '真皮/翻毛皮',
      'adas': 'L2+级辅助驾驶',
      'speaker': '18扬声器',
    },
  };

  /// 获取车型参数值
  String getSpecValue(String modelKey, String specKey) {
    return specData[modelKey]?[specKey] ?? '-';
  }

  /// 初始化 - 传入初始车型和所有可用车型
  void init(CarModel initialModel, List<CarModel> allModels) {
    _availableModels = allModels;
    _selectedModels = [initialModel];
    notifyListeners();
  }

  /// 切换隐藏相同参数
  void toggleHideSame() {
    _hideSame = !_hideSame;
    notifyListeners();
  }

  /// 显示/隐藏添加车型弹窗
  void setShowAddModal(bool show) {
    _showAddModal = show;
    notifyListeners();
  }

  /// 添加车型进行对比
  void addModel(CarModel model) {
    // 如果已经选中，不重复添加
    if (_selectedModels.any((m) => m.id == model.id)) {
      return;
    }

    if (_selectedModels.length >= 2) {
      // 如果已经有2个，替换第二个
      _selectedModels[1] = model;
    } else {
      // 否则直接添加
      _selectedModels.add(model);
    }

    _showAddModal = false;
    notifyListeners();
  }

  /// 移除车型
  void removeModel(CarModel model) {
    // 至少保留一个车型
    if (_selectedModels.length <= 1) {
      return;
    }

    _selectedModels.removeWhere((m) => m.id == model.id);
    notifyListeners();
  }

  /// 检查某个参数在两个车型中是否不同
  bool isDifferent(String specKey) {
    if (_selectedModels.length < 2) {
      return true;
    }

    final val1 = getSpecValue(_selectedModels[0].modelKey, specKey);
    final val2 = getSpecValue(_selectedModels[1].modelKey, specKey);
    return val1 != val2;
  }

  /// 返回上一页
  void navigateBack() {
    goBack();
  }
}
