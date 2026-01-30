class AppConstants {
  // API Configuration
  // 使用 localhost 用于模拟器，使用局域网 IP 用于真机测试
  // 真机测试时请修改为你 Mac 的局域网 IP，如: http://192.168.3.225:3000/api/v1
  static const String baseUrl = 'http://43.143.187.117:3002/api/v1';
  static const String imageBaseUrl = 'http://43.143.187.117:3002';
  static const Duration requestTimeout = Duration(seconds: 30);
  
  /// 将相对图片路径转换为完整URL
  static String getImageUrl(String relativePath) {
    if (relativePath.startsWith('http')) {
      // 已经是完整URL，直接返回
      return relativePath;
    } else if (relativePath.startsWith('/')) {
      // 相对路径，添加base URL
      return '$imageBaseUrl$relativePath';
    } else if (relativePath.startsWith('assets/')) {
      // 本地assets路径，保持不变
      return relativePath;
    } else {
      // 其他情况，假设是相对路径
      return '$imageBaseUrl/$relativePath';
    }
  }
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  
  // App Configuration
  static const String appName = '车主APP';
  static const String appVersion = '1.0.0';
  
  // Database
  static const String databaseName = 'car_owner_app.db';
  static const int databaseVersion = 1;
}