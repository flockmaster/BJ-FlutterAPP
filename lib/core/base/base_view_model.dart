import 'package:flutter/foundation.dart';

/// [BaseViewModel] - 基础视图模型基类（基于 ChangeNotifier）
/// 
/// 该类提供了最核心的加载状态管理、错误处理以及安全的资源释放逻辑。
/// 虽然项目中优先推荐继承 [BaicBaseViewModel]，但底层逻辑仍遵循此基类的设计哲学。
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false; // 是否正在加载中
  bool _isDisposed = false; // 资源是否已销毁
  String? _error; // 当前持有的错误信息

  // 暴露给 View 层的 Getter
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null; // 用于快速判断是否存在错误
  bool get isDisposed => _isDisposed;

  /// 设置加载状态并通知 UI 刷新
  /// 
  /// 调用此方法后，View 层可通过 [isLoading] 切换显示状态。
  void setLoading(bool loading) {
    if (_isDisposed) return;
    _isLoading = loading;
    notifyListeners();
  }

  /// 设置错误信息并通知 UI 刷新
  /// 
  /// 建议结合 [Result] 类使用，将异常信息转化为用户可读的提示。
  void setError(String? error) {
    if (_isDisposed) return;
    _error = error;
    notifyListeners();
  }

  /// 清除当前的错误状态
  void clearError() {
    if (_isDisposed) return;
    _error = null;
    notifyListeners();
  }

  /// 安全地通知监听器
  /// 
  /// 在进行异步回调更新 UI 前，必须检查 ViewModel 是否已被销毁，防止内存泄露或报错。
  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  /// 销毁 ViewModel 并释放资源
  /// 
  /// 严禁在销毁后继续调用 notifyListeners 或更新状态。
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// 生命周期：初始化入口
  /// 
  /// 子类应重写此方法进行初始数据加载或服务订阅。
  Future<void> init() async {}

  /// 生命周期：刷新数据
  /// 
  /// 用于处理下拉刷新等手动更新数据的场景。
  Future<void> refresh() async {}
}
