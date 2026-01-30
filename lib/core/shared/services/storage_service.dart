import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:car_owner_app/core/constants/app_constants.dart';

/// 使用SharedPreferences的本地存储服务
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;
  bool _initialized = false;

  bool get isInitialized => _initialized;

  /// 初始化存储服务
  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  /// 保存字符串值
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  /// 获取字符串值
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// 保存整数值
  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  /// 获取整数值
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// 保存布尔值
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  /// 获取布尔值
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// 保存JSON对象
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    return await _prefs.setString(key, jsonEncode(value));
  }

  /// 获取JSON对象
  Map<String, dynamic>? getJson(String key) {
    final value = _prefs.getString(key);
    if (value == null) return null;
    try {
      return jsonDecode(value) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// 保存JSON对象列表
  Future<bool> setJsonList(String key, List<Map<String, dynamic>> value) async {
    return await _prefs.setString(key, jsonEncode(value));
  }

  /// 获取JSON对象列表
  List<Map<String, dynamic>>? getJsonList(String key) {
    final value = _prefs.getString(key);
    if (value == null) return null;
    try {
      final list = jsonDecode(value) as List;
      return list.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      return null;
    }
  }

  /// 删除一个值
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  /// 清除所有存储值
  Future<bool> clear() async {
    return await _prefs.clear();
  }

  /// 检查键是否存在
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // 常用操作的便捷方法

  /// 保存用户令牌
  Future<bool> saveUserToken(String token) async {
    return await setString(AppConstants.userTokenKey, token);
  }

  /// 获取用户令牌
  String? getUserToken() {
    return getString(AppConstants.userTokenKey);
  }

  /// 删除用户令牌
  Future<bool> removeUserToken() async {
    return await remove(AppConstants.userTokenKey);
  }

  /// 保存用户数据
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    return await setJson(AppConstants.userDataKey, userData);
  }

  /// 获取用户数据
  Map<String, dynamic>? getUserData() {
    return getJson(AppConstants.userDataKey);
  }

  /// 删除用户数据
  Future<bool> removeUserData() async {
    return await remove(AppConstants.userDataKey);
  }

  /// 清除用户会话（令牌 + 数据）
  Future<void> clearUserSession() async {
    await removeUserToken();
    await removeUserData();
  }
}
