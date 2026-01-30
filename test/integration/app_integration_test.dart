import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:car_owner_app/main.dart' as app;
import 'package:car_owner_app/core/shared/services/api_service.dart';
import 'package:car_owner_app/core/shared/services/storage_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Car Owner App Integration Tests', () {
    late ApiService apiService;
    late StorageService storageService;

    setUpAll(() async {
      // Initialize services
      apiService = ApiService();
      storageService = StorageService();
      await storageService.init();
      
      // Set test API base URL
      apiService.setBaseUrl('http://localhost:3000/api');
    });

    tearDownAll(() async {
      // Clean up
      await storageService.clear();
    });

    testWidgets('Complete User Registration and Login Flow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Test user registration
      await tester.tap(find.text('注册'));
      await tester.pumpAndSettle();

      // Fill registration form
      await tester.enterText(find.byKey(const Key('username_field')), 'testuser_mobile');
      await tester.enterText(find.byKey(const Key('email_field')), 'mobile@test.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'Test123!');
      await tester.enterText(find.byKey(const Key('phone_field')), '13800138001');

      // Submit registration
      await tester.tap(find.byKey(const Key('register_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify registration success
      expect(find.text('注册成功'), findsOneWidget);

      // Test login
      await tester.tap(find.text('登录'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('login_username_field')), 'testuser_mobile');
      await tester.enterText(find.byKey(const Key('login_password_field')), 'Test123!');

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify login success - should navigate to main screen
      expect(find.byKey(const Key('main_navigation')), findsOneWidget);
    });

    testWidgets('Discovery Content Browsing Flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Assume user is already logged in from previous test
      // Navigate to discovery tab
      await tester.tap(find.byKey(const Key('discovery_tab')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify discovery content loads
      expect(find.byKey(const Key('discovery_list')), findsOneWidget);

      // Test pull to refresh
      await tester.fling(find.byKey(const Key('discovery_list')), const Offset(0, 300), 1000);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tap on first discovery item
      final firstItem = find.byKey(const Key('discovery_item_0')).first;
      if (tester.any(firstItem)) {
        await tester.tap(firstItem);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verify detail page loads
        expect(find.byKey(const Key('discovery_detail')), findsOneWidget);

        // Go back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Store Product Search and Browse Flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to store tab
      await tester.tap(find.byKey(const Key('store_tab')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify store content loads
      expect(find.byKey(const Key('store_content')), findsOneWidget);

      // Test search functionality
      await tester.tap(find.byKey(const Key('search_field')));
      await tester.enterText(find.byKey(const Key('search_field')), '测试');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify search results
      expect(find.byKey(const Key('product_list')), findsOneWidget);

      // Tap on first product if available
      final firstProduct = find.byKey(const Key('product_item_0')).first;
      if (tester.any(firstProduct)) {
        await tester.tap(firstProduct);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verify product detail page
        expect(find.byKey(const Key('product_detail')), findsOneWidget);

        // Test add to cart
        final addToCartButton = find.byKey(const Key('add_to_cart_button'));
        if (tester.any(addToCartButton)) {
          await tester.tap(addToCartButton);
          await tester.pumpAndSettle();

          // Verify success message
          expect(find.text('已添加到购物车'), findsOneWidget);
        }

        // Go back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Car Browsing and Test Drive Booking Flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to car buying tab
      await tester.tap(find.byKey(const Key('car_buying_tab')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify car list loads
      expect(find.byKey(const Key('car_list')), findsOneWidget);

      // Tap on first car if available
      final firstCar = find.byKey(const Key('car_item_0')).first;
      if (tester.any(firstCar)) {
        await tester.tap(firstCar);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verify car detail page
        expect(find.byKey(const Key('car_detail')), findsOneWidget);

        // Test book test drive
        final bookButton = find.byKey(const Key('book_test_drive_button'));
        if (tester.any(bookButton)) {
          await tester.tap(bookButton);
          await tester.pumpAndSettle();

          // Fill booking form
          await tester.enterText(find.byKey(const Key('preferred_date_field')), '2024-12-20');
          await tester.enterText(find.byKey(const Key('preferred_time_field')), '14:00');
          await tester.enterText(find.byKey(const Key('contact_phone_field')), '13800138001');

          // Submit booking
          await tester.tap(find.byKey(const Key('submit_booking_button')));
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Verify booking success
          expect(find.text('预约成功'), findsOneWidget);
        }

        // Go back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Profile Management and Vehicle Binding Flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to profile tab
      await tester.tap(find.byKey(const Key('profile_tab')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify profile page loads
      expect(find.byKey(const Key('profile_content')), findsOneWidget);

      // Test profile editing
      await tester.tap(find.byKey(const Key('edit_profile_button')));
      await tester.pumpAndSettle();

      // Update profile information
      await tester.enterText(find.byKey(const Key('real_name_field')), '测试用户');
      await tester.enterText(find.byKey(const Key('address_field')), '测试地址123号');

      // Save profile
      await tester.tap(find.byKey(const Key('save_profile_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify save success
      expect(find.text('保存成功'), findsOneWidget);

      // Test vehicle binding
      await tester.tap(find.byKey(const Key('my_vehicles_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('add_vehicle_button')));
      await tester.pumpAndSettle();

      // Fill vehicle information
      await tester.enterText(find.byKey(const Key('vin_field')), 'TEST123456789VIN02');
      await tester.enterText(find.byKey(const Key('license_plate_field')), '京B12345');
      await tester.enterText(find.byKey(const Key('brand_field')), '测试品牌');
      await tester.enterText(find.byKey(const Key('model_field')), '测试车型');

      // Submit vehicle binding
      await tester.tap(find.byKey(const Key('bind_vehicle_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify binding success
      expect(find.text('绑定成功'), findsOneWidget);
    });

    testWidgets('Service Record Management Flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to profile and then service records
      await tester.tap(find.byKey(const Key('profile_tab')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('service_records_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify service records page
      expect(find.byKey(const Key('service_records_list')), findsOneWidget);

      // Add new service record
      await tester.tap(find.byKey(const Key('add_service_record_button')));
      await tester.pumpAndSettle();

      // Fill service record form
      await tester.tap(find.byKey(const Key('vehicle_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('测试车型').first);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('service_date_field')), '2024-12-15');
      await tester.enterText(find.byKey(const Key('mileage_field')), '10000');
      await tester.enterText(find.byKey(const Key('cost_field')), '500');
      await tester.enterText(find.byKey(const Key('description_field')), '常规保养');
      await tester.enterText(find.byKey(const Key('service_provider_field')), '测试服务商');

      // Submit service record
      await tester.tap(find.byKey(const Key('save_service_record_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify save success
      expect(find.text('保存成功'), findsOneWidget);
    });

    testWidgets('Network Error Handling', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Simulate network error by setting invalid API URL
      apiService.setBaseUrl('http://invalid-url:9999/api');

      // Try to refresh discovery content
      await tester.tap(find.byKey(const Key('discovery_tab')));
      await tester.pumpAndSettle();

      await tester.fling(find.byKey(const Key('discovery_list')), const Offset(0, 300), 1000);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify error message is shown
      expect(find.text('网络连接失败'), findsOneWidget);

      // Verify retry button is available
      expect(find.byKey(const Key('retry_button')), findsOneWidget);

      // Restore valid API URL
      apiService.setBaseUrl('http://localhost:3000/api');
    });

    testWidgets('Offline Mode Handling', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Load some data first
      await tester.tap(find.byKey(const Key('discovery_tab')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Simulate offline mode
      apiService.setOfflineMode(true);

      // Try to refresh - should show cached data
      await tester.fling(find.byKey(const Key('discovery_list')), const Offset(0, 300), 1000);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify offline indicator
      expect(find.byKey(const Key('offline_indicator')), findsOneWidget);

      // Restore online mode
      apiService.setOfflineMode(false);
    });

    testWidgets('Data Persistence Across App Restarts', (WidgetTester tester) async {
      // First app session - login and save some data
      app.main();
      await tester.pumpAndSettle();

      // Login (assuming login flow works)
      // ... login code ...

      // Save some user preferences
      await tester.tap(find.byKey(const Key('profile_tab')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('settings_button')));
      await tester.pumpAndSettle();

      // Toggle some settings
      await tester.tap(find.byKey(const Key('notifications_toggle')));
      await tester.tap(find.byKey(const Key('dark_mode_toggle')));
      await tester.pumpAndSettle();

      // Restart app (simulate app restart)
      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/platform',
        null,
        (data) {},
      );

      // Start app again
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify user is still logged in
      expect(find.byKey(const Key('main_navigation')), findsOneWidget);

      // Verify settings are preserved
      await tester.tap(find.byKey(const Key('profile_tab')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('settings_button')));
      await tester.pumpAndSettle();

      // Check if settings are still toggled
      final notificationsToggle = tester.widget<Switch>(find.byKey(const Key('notifications_toggle')));
      final darkModeToggle = tester.widget<Switch>(find.byKey(const Key('dark_mode_toggle')));

      expect(notificationsToggle.value, isTrue);
      expect(darkModeToggle.value, isTrue);
    });
  });
}