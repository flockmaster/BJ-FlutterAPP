import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


/// Provides all app-level providers
class AppProviders {
  static List<ChangeNotifierProvider> get providers => [];

  /// Wrap a widget with all providers
  static Widget wrapWithProviders(Widget child) {
    if (providers.isEmpty) {
      return child;
    }
    return MultiProvider(
      providers: providers,
      child: child,
    );
  }
}
