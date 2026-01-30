import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';
import '../core/providers/app_providers.dart';
import 'app.locator.dart';
import 'app.router.dart';

class CarOwnerApp extends StatelessWidget {
  const CarOwnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders.wrapWithProviders(
      MaterialApp(
        title: '北京越野',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        navigatorKey: StackedService.navigatorKey,
        onGenerateRoute: StackedRouter().onGenerateRoute,
        initialRoute: Routes.mainNavigation,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}