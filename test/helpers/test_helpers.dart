/// 测试辅助工具
/// 提供统一的 Mock 服务注册和清理

import 'package:car_owner_app/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mockito/mockito.dart';

/// 注册测试所需的 Mock 服务
void registerServices() {
  // 如果已经注册过，先清理
  if (locator.isRegistered<NavigationService>()) {
    locator.unregister<NavigationService>();
  }
  if (locator.isRegistered<DialogService>()) {
    locator.unregister<DialogService>();
  }
  
  // 注册 Mock 服务
  locator.registerLazySingleton<NavigationService>(() => MockNavigationService());
  locator.registerLazySingleton<DialogService>(() => MockDialogService());
}

/// 清理所有注册的服务
void unregisterServices() {
  locator.reset();
}

// Mock 类定义
class MockNavigationService extends Mock implements NavigationService {}
class MockDialogService extends Mock implements DialogService {}
