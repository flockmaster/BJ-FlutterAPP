import 'package:flutter/foundation.dart';
import 'package:car_owner_app/core/models/car_model.dart';
import '../../../app/app.locator.dart';
import '../../../core/base/baic_base_view_model.dart';
import '../../../core/services/help_center_service.dart';

/// [HelpCenterViewModel] - 帮助中心（车友使用指南）业务逻辑类
///
/// 核心职责：
/// 1. 分车型提供全生命周期的用车指导：覆盖选车、用车、售后、权益等各阶段。
/// 2. 管理 FAQ 库的层级筛选：支持基于车型的动态搜索建议。
/// 3. 作为二级分流页，引导用户进入在线客服或详细文档页。
class HelpCenterViewModel extends BaicBaseViewModel {
  final _helpCenterService = locator<IHelpCenterService>();

  /// 当前过滤的车型（如：BJ40, BJ60 等）
  String _selectedModel = 'BJ40';
  String get selectedModel => _selectedModel;

  /// 当前选中的用车生命周期阶段（如：购车阶段、用车阶段）
  String _activeStage = 'use';
  String get activeStage => _activeStage;

  /// 品牌下所有的可选车型元数据
  List<CarModel> _carModels = [];
  List<CarModel> get carModels => _carModels;

  /// 生命周期定义的阶段列表
  List<LifecycleStage> _lifecycleStages = [];
  List<LifecycleStage> get lifecycleStages => _lifecycleStages;

  /// 全量 FAQ 数据集（以阶段 ID 为 Key 分组）
  Map<String, List<String>> _faqs = {};
  Map<String, List<String>> get faqs => _faqs;

  /// 计算属性：获取当前选定阶段下的问题子集
  List<String> get currentFAQs => _faqs[_activeStage] ?? [];

  /// 辅助：获取带车型特色的搜索占位符
  String get searchPlaceholder {
    final model = _carModels.firstWhere(
      (m) => m.id == _selectedModel,
      orElse: () => const CarModel(
        id: '',
        modelKey: '',
        name: '',
        fullName: '',
        subtitle: '',
        price: 0,
        backgroundImage: '',
      ),
    );
    return '搜索 ${model.name} 的问题';
  }

  /// 辅助：获取当前阶段的友好文案
  String get currentStageLabel {
    final stage = _lifecycleStages.firstWhere(
      (s) => s.id == _activeStage,
      orElse: () => LifecycleStage(id: '', label: ''),
    );
    return stage.label;
  }

  /// 生命周期：初始化加载支持文档元资料
  Future<void> init() async {
    await loadData();
  }

  /// 业务加载：从 [IHelpCenterService] 同步车型、阶段及 FAQ 库
  Future<void> loadData() async {
    setBusy(true);
    
    try {
      _lifecycleStages = _helpCenterService.getLifecycleStages();
      _carModels = await _helpCenterService.getCarModels();
      _faqs = await _helpCenterService.getFAQs();
      
      notifyListeners();
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  /// 交互：切换车型以更新相关的指南内容
  void selectModel(String modelId) {
    if (_selectedModel != modelId) {
      _selectedModel = modelId;
      notifyListeners();
    }
  }

  /// 交互：切换生命周期阶段（如从“选车”切换到“养车”）
  void selectStage(String stageId) {
    if (_activeStage != stageId) {
      _activeStage = stageId;
      notifyListeners();
    }
  }

  /// 交互：点击 FAQ 跳转至图文/视频说明详情页
  void handleFAQTap(String question) {
    debugPrint('查看 FAQ 详情: $question');
  }

  /// 交互：引导至人工客服
  void handleContactService() {
    debugPrint('一键直达客服模块');
  }
}
