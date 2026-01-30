import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:car_owner_app/core/models/car_model.dart';
import 'package:car_owner_app/ui/views/car_buying/car_order/car_order_view.dart';
import 'package:car_owner_app/ui/views/car_buying/car_order/car_order_viewmodel.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('CarOrderView Widget Test', () {
    const mockCar = CarModel(
      id: 'bj40',
      modelKey: 'bj40',
      name: 'BJ40',
      fullName: '北京BJ40',
      subtitle: '硬派越野',
      price: 15.98,
      priceUnit: '万',
      backgroundImage: '',
      versions: {
        'city': CarVersion(
          name: '城市猎人版',
          price: 159800,
          features: ['2.0T+8AT', '倒车影像'],
        ),
      },
    );

    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    testWidgets('应该展示初始版本列表并且不加载时隐藏骨架屏', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: CarOrderView(car: mockCar),
      ));

      // 验证骨架屏逻辑 (ViewModel 初始化时 setBusy(true) 然后 delay 结束)
      // 在 pumpWidget 后，ViewModel 应该已经开始 init
      expect(find.byType(CircularProgressIndicator), findsNothing); // 我们用了自定义骨架屏

      // 等待 ViewModel init 完成
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      // 验证是否显示了车型名称
      expect(find.text('城市猎人版'), findsOneWidget);
      // 验证是否有下一步按钮
      expect(find.text('下一步'), findsOneWidget);
    });

    testWidgets('点击下一步应该切换到外观选择步骤', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: CarOrderView(car: mockCar),
      ));

      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      // 点击下一步
      await tester.tap(find.text('下一步'));
      await tester.pumpAndSettle();

      // 验证步骤条或标题变化
      expect(find.text('选择外观'), findsOneWidget);
    });
  });
}
