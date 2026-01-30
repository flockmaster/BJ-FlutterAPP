import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../app/app.locator.dart';

/// Context 扩展 - 提供导航方法（兼容旧代码）
/// 
/// 注意：这是为了兼容旧代码，新代码应该使用 ViewModel + NavigationService
extension ContextExtensions on BuildContext {
  /// 导航到指定路由（兼容 GoRouter 的 push 方法）
  Future<T?> push<T>(String routeName, {Object? extra}) async {
    final navigationService = locator<NavigationService>();
    return await navigationService.navigateTo<T>(
      routeName,
      arguments: extra,
    );
  }

  /// 返回上一页（兼容 GoRouter 的 pop 方法）
  void pop<T>([T? result]) {
    final navigationService = locator<NavigationService>();
    navigationService.back(result: result);
  }

  /// 替换当前路由（兼容 GoRouter 的 go 方法）
  void go(String routeName, {Object? extra}) {
    final navigationService = locator<NavigationService>();
    navigationService.replaceWith(
      routeName,
      arguments: extra,
    );
  }
}
