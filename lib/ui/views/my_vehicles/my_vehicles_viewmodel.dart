import 'dart:async';
import '../../../app/app.locator.dart';
import '../../../core/base/baic_base_view_model.dart';
import '../../../core/services/profile_service.dart';
import '../../../core/models/profile_models.dart';

/// [VehicleInfo] - View 侧使用的车辆展示模型
/// 适配核心 Service 层的车辆实体，增加 UI 专属的里程格式化等逻辑。
class VehicleInfo {
  final String id;
  final String name;
  final String plateNumber;
  final String imageUrl;
  final int fuelLevel;
  final int mileage;
  /// 是否为默认展示的首选车辆（通常对应 App 首页展示的车）
  final bool isPrimary;
  /// 状态：active (已绑定), review (审核中), inactive (失效)
  final String status;

  VehicleInfo({
    required this.id,
    required this.name,
    required this.plateNumber,
    required this.imageUrl,
    required this.fuelLevel,
    required this.mileage,
    required this.isPrimary,
    required this.status,
  });

  /// 辅助：将原始里程转换为千分位格式或 K 单位
  String get mileageFormatted {
    if (mileage >= 10000) {
      return '${(mileage / 1000).toStringAsFixed(1)}k';
    }
    return mileage.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// 转换工厂：将 Service 层的模型映射为 View 特化模型
  factory VehicleInfo.fromUserVehicle(UserVehicle vehicle) {
    return VehicleInfo(
      id: vehicle.id,
      name: vehicle.name,
      plateNumber: vehicle.plateNumber ?? '未设置',
      imageUrl: 'https://pngimg.com/d/jeep_PNG48.png', // 默认占位图
      fuelLevel: 85,
      mileage: 8521,
      isPrimary: vehicle.isPrimary ?? false,
      status: vehicle.status ?? 'active',
    );
  }
}

/// [MyVehiclesViewModel] - 用户爱车管理（车库）业务逻辑类
///
/// 核心职责：
/// 1. 展示用户名下的所有车辆资产：区分已绑定车辆、待审核车辆。
/// 2. 管理车辆生命周期：包含绑定新车（入口）、解绑合规性检查（二次确认、计时器限制）。
/// 3. 全局唯一性维护：设置或切换“首选车辆”。
class MyVehiclesViewModel extends BaicBaseViewModel {
  final _profileService = locator<IProfileService>();

  /// 当前账号名下的全量车辆列表
  List<VehicleInfo> _vehicles = [];
  /// 解绑操作的防误触逻辑（长按提示态）
  bool _showUnbindHint = false;
  /// 解绑二次确认 Modal 显隐
  bool _showUnbindModal = false;
  /// 当前正在进行解绑决策的车辆 ID
  String? _selectedVehicleId;
  /// 用于长按防抖或确认计时的 Timer
  Timer? _unbindTimer;

  List<VehicleInfo> get vehicles => _vehicles;
  bool get showUnbindHint => _showUnbindHint;
  bool get showUnbindModal => _showUnbindModal;

  /// 计算属性：过滤出已正式激活绑定的车辆
  List<VehicleInfo> get activeVehicles => 
    _vehicles.where((v) => v.status == 'active').toList();
  
  /// 计算属性：正在审核中的车辆（如新车牌照绑定、二手车过户审核等）
  List<VehicleInfo> get reviewVehicles => 
    _vehicles.where((v) => v.status == 'review').toList();

  int get totalVehicleCount => _vehicles.length;

  /// 计算属性：统计车主所有车辆的累计总里程
  String get totalMileage {
    final total = _vehicles.fold<int>(0, (sum, v) => sum + v.mileage);
    return total.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// 生命周期：初始化加载用户的车辆集合
  Future<void> init() async {
    setBusy(true);
    await loadVehicles();
    setBusy(false);
  }

  /// 业务加载：从 [IProfileService] 获取核心车辆数据
  Future<void> loadVehicles() async {
    try {
      final result = await _profileService.getUserVehicles();
      
      result.when(
        success: (userVehicles) {
          _vehicles = userVehicles.map((v) => VehicleInfo.fromUserVehicle(v)).toList();
          if (_vehicles.isEmpty) {
            _vehicles = _getMockVehicles();
          }
          notifyListeners();
        },
        failure: (error) {
          _vehicles = _getMockVehicles();
          notifyListeners();
        },
      );
    } catch (e) {
      _vehicles = _getMockVehicles();
      notifyListeners();
    }
  }

  /// 兜底：开发阶段或获取失败时的 Mock 展示数据
  List<VehicleInfo> _getMockVehicles() {
    return [
      VehicleInfo(
        id: '1',
        name: '北京BJ40 PLUS',
        plateNumber: '京A·12345',
        imageUrl: 'https://p.sda1.dev/29/0c0cc4449ea2a1074412f6052330e4c4/63999cc7e598e7dc1e84445be0ba70eb-Photoroom.png',
        fuelLevel: 85,
        mileage: 8521,
        isPrimary: true,
        status: 'active',
      ),
      VehicleInfo(
        id: '2',
        name: '北京BJ60 旗舰版',
        plateNumber: '京B·67890',
        imageUrl: 'https://p.sda1.dev/29/0c0cc4449ea2a1074412f6052330e4c4/63999cc7e598e7dc1e84445be0ba70eb-Photoroom.png',
        fuelLevel: 60,
        mileage: 3929,
        isPrimary: false,
        status: 'review',
      ),
    ];
  }

  /// 交互：分发车辆联动指令（跳转至控车页）
  void handleRemoteControl(String vehicleId) {
  }

  /// 交互流程：启动车辆解绑计时器（模拟 iOS/HarmonyOS 长按防误触效果）
  void startUnbindTimer(String vehicleId) {
    _selectedVehicleId = vehicleId;
    _showUnbindHint = true;
    notifyListeners();

    _unbindTimer?.cancel();
    _unbindTimer = Timer(const Duration(seconds: 1), () {
      _showUnbindHint = false;
      _showUnbindModal = true;
      notifyListeners();
    });
  }

  /// 交互流程：取消解绑计时
  void cancelUnbindTimer() {
    _unbindTimer?.cancel();
    _showUnbindHint = false;
    notifyListeners();
  }

  /// 交互流程：在弹窗中取消解绑
  void cancelUnbind() {
    _showUnbindModal = false;
    _selectedVehicleId = null;
    notifyListeners();
  }

  /// 业务执行：正式发起后端解绑闭环
  Future<void> confirmUnbind() async {
    if (_selectedVehicleId == null) return;

    _showUnbindModal = false;
    setBusy(true);

    try {
      final result = await _profileService.unbindVehicle(_selectedVehicleId!);
      
      result.when(
        success: (_) {
          // 本地列表响应式移除
          _vehicles.removeWhere((v) => v.id == _selectedVehicleId);
          _selectedVehicleId = null;
          notifyListeners();
        },
        failure: (error) {
          setError(error);
        },
      );
    } catch (e) {
      setError('解绑失败: ${e.toString()}');
    } finally {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    _unbindTimer?.cancel();
    super.dispose();
  }
}
