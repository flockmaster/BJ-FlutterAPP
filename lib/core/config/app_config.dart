class AppConfig {
  static const bool isDebug = true;
  static const bool enableLogging = true;
  
  // Environment specific configurations
  static const String environment = 'development';
  
  // Feature flags
  static const bool enableAnalytics = false;
  static const bool enableCrashReporting = false;
}