import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFEB4628), // Accent color from prototype
        primary: const Color(0xFFEB4628),
        background: const Color(0xFFF5F5F5),
        surface: Colors.white,
        brightness: Brightness.light,
      ),

      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1A1A1A),
        surfaceTintColor: Colors.transparent, // Disable Material 3 tint
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Color(0xFF1A1A1A), // Active text color
        unselectedItemColor: Color(0xFF999999), // Inactive text color
        backgroundColor: Colors.white,
        elevation: 0, // Flat design as per prototype (usually has a top border instead)
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }
}