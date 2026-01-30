import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:car_owner_app/ui/views/car_buying/test_drive/test_drive_view.dart';
import 'package:car_owner_app/core/models/car_model.dart';
import 'package:car_owner_app/core/components/baic_ui_kit.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:car_owner_app/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

void main() {
  setUpAll(() async {
    if (locator.isRegistered<NavigationService>()) {
      await locator.reset();
    }
    locator.registerLazySingleton(() => NavigationService());
    locator.registerLazySingleton(() => DialogService());
  });

  final mockCar = CarModel(
    id: 'BJ40',
    modelKey: 'bj40',
    name: '北京越野 BJ40',
    fullName: '北京越野 BJ40 都市猎人版',
    subtitle: '硬核越野 纯正血统',
    price: 15.98,
    priceUnit: '万',
    backgroundImage: 'https://example.com/bj40.png',
  );

  group('TestDriveView Widget Tests', () {
    testWidgets('应当正确渲染主界面元素', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TestDriveView(car: mockCar),
      ));

      // 验证标题
      expect(find.text('预约试驾'), findsOneWidget);

      // 验证车辆信息
      expect(find.text('北京越野 BJ40'), findsOneWidget);
      expect(find.text('预约有好礼'), findsOneWidget);

      // 验证表单文案
      expect(find.text('姓名'), findsOneWidget);
      expect(find.text('手机号'), findsOneWidget);
      expect(find.text('城市'), findsOneWidget);
      expect(find.text('时间'), findsOneWidget);

      // 验证底部按钮
      expect(find.text('立即预约'), findsOneWidget);
    });

    testWidgets('应当能显示隐私协议', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TestDriveView(car: mockCar),
      ));

      // 对于 RichText，使用 textContaining 寻找其包含的文字
      expect(find.textContaining('我已阅读并同意'), findsOneWidget);
    });
  });
}
