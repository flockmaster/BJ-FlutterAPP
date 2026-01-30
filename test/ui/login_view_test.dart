import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:car_owner_app/ui/views/login/login_view.dart';
import 'package:car_owner_app/app/app.locator.dart';
import 'package:car_owner_app/core/services/profile_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([IProfileService, NavigationService, DialogService])
void main() {
  setUpAll(() async {
    // 注册 Mock 服务
    // 注意：实际项目中可能需要更完善的 setup_test_helpers.dart
    locator.registerLazySingleton<IProfileService>(() => MockIProfileService());
    locator.registerLazySingleton<NavigationService>(() => MockNavigationService());
    locator.registerLazySingleton<DialogService>(() => MockDialogService());
  });

  tearDownAll(() {
    locator.reset();
  });

  testWidgets('LoginView renders main view correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginView()));

    // 验证核心文案存在
    expect(find.text('悦享越野\n探索无界'), findsOneWidget);
    expect(find.text('本机号码一键登录'), findsOneWidget);
    expect(find.text('其他手机号登录'), findsOneWidget);
    
    // 验证协议勾选框存在
    expect(find.byIcon(Icons.check), findsNothing); // 默认不勾选
  });

  testWidgets('Navigate to form view', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginView()));

    // 点击“其他手机号登录”
    await tester.tap(find.text('其他手机号登录'));
    await tester.pumpAndSettle();

    // 验证进入了表单模式
    expect(find.text('验证码登录'), findsOneWidget);
    expect(find.text('请输入手机号'), findsOneWidget);
  });
}

// Mock 类定义 (如果 mockito 生成还没跑，这里先简单定义)
class MockIProfileService extends Mock implements IProfileService {}
class MockNavigationService extends Mock implements NavigationService {}
class MockDialogService extends Mock implements DialogService {}
