import 'package:flutter/material.dart';
import '../../../app/app.locator.dart';
import '../../../core/base/baic_base_view_model.dart';
import '../../../core/services/profile_service.dart';

class MyQRCodeViewModel extends BaicBaseViewModel {
  final _profileService = locator<IProfileService>();

  String _userName = '张越野';
  final String _userInfo = 'BJ40 城市猎人版 · 北京';
  String _avatarUrl = 'https://randomuser.me/api/portraits/men/75.jpg';
  String _userId = 'user_12345';

  String get userName => _userName;
  String get userInfo => _userInfo;
  String get avatarUrl => _avatarUrl;
  
  // 生成二维码数据
  String get qrData => 'baic://user/$_userId';

  Future<void> init() async {
    setBusy(true);
    await _loadUserInfo();
    setBusy(false);
  }

  Future<void> _loadUserInfo() async {
    try {
      final result = await _profileService.getUserProfile();
      
      result.when(
        success: (profile) {
          _userName = profile.displayName ?? '张越野';
          _avatarUrl = profile.avatar ?? _avatarUrl;
          _userId = profile.id ?? _userId;
          notifyListeners();
        },
        failure: (error) {
          // 使用默认值
          debugPrint('Failed to load user info: $error');
        },
      );
    } catch (e) {
      debugPrint('Error loading user info: $e');
    }
  }

  Future<void> saveToGallery() async {
    // TODO: 实现保存二维码到相册功能
    // 1. 将二维码渲染为图片
    // 2. 请求存储权限
    // 3. 保存到相册
    debugPrint('Save QR code to gallery');
    
    // 显示成功提示
    // 可以使用 SnackbarService 或 DialogService
  }

  Future<void> shareQRCode() async {
    // TODO: 实现分享二维��功能
    // 1. 将二维码渲染为图片
    // 2. 使用 share_plus 包分享
    debugPrint('Share QR code');
  }

  void showMoreOptions() {
    // TODO: 显示更多选项（如刷新二维码、设置等）
    debugPrint('Show more options');
  }
}
