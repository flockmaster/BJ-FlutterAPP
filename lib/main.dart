import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.locator.dart';
import 'app/car_owner_app.dart';
import 'core/di/service_locator.dart';
import 'core/services/local_asset_server.dart';
import 'app/app.dialogs.dart';
import 'app/app.bottomsheets.dart';
import 'core/services/widget_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize Stacked Locator (New Architecture)
  await setupLocator();

  // Initialize UI Builders
  setupDialogUi();
  setupBottomSheetUi();


  // Initialize Legacy Service Locator (Old Architecture)
  await sl.init();
  
  // Start local asset server for GLB models
  try {
    await LocalAssetServer.start();
    print('✅ Local asset server started successfully');

    // Initialize Widget Service (AppGroup setup)
    try {
      await locator<WidgetService>().init();
      print('✅ WidgetService initialized');
    } catch (e) {
      print('⚠️ Failed to initialize WidgetService: $e');
    }
  } catch (e) {
    print('⚠️ Failed to start local asset server: $e');
  }
  
  runApp(const CarOwnerApp());
}