import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../app/app.locator.dart';
import '../../../core/services/discovery_service.dart';
import 'package:car_owner_app/core/base/baic_base_view_model.dart';

/// [PublishViewModel] - 内容发布（动态/帖子）业务逻辑类
///
/// 核心职责：
/// 1. 管理内容的表单输入：包含多行文本标题、正文及媒体附件队列。
/// 2. 集成相机与相册：处理多图选择、预览及删除交互。
/// 3. 执行发布流程：上传媒体资源与元数据至 [IDiscoveryService]，并处理发布完成后的路由回退。
class PublishViewModel extends BaicBaseViewModel {
  final _discoveryService = locator<IDiscoveryService>();
  final _picker = ImagePicker();

  /// 标题输入控制器
  final TextEditingController titleController = TextEditingController();
  /// 动态正文输入控制器
  final TextEditingController contentController = TextEditingController();

  /// 待上传的本地图片文件队列
  final List<File> _images = [];
  List<File> get images => _images;

  /// 当前发帖账号的元资料（用于注入帖子元数据）
  Map<String, dynamic>? _userProfile;
  Map<String, dynamic>? get userProfile => _userProfile;

  /// 全局发布状态锁
  bool _isPublishing = false;
  bool get isPublishing => _isPublishing;

  /// 计算：发布按钮是否可用（正文非空且不在发布中）
  bool get canPublish => contentController.text.trim().isNotEmpty && !_isPublishing;

  /// 生命周期：初始化发帖人信息并绑定文本监听以实时驱动按钮状态
  void init(Map<String, dynamic> userProfile) {
    _userProfile = userProfile;
    
    contentController.addListener(() {
      notifyListeners();
    });
  }

  /// 交互：唤起系统图片选择器，支持批量选择
  Future<void> pickImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        _images.addAll(pickedFiles.map((e) => File(e.path)));
        notifyListeners();
      }
    } catch (e) {
      // 这里的静默失败通常源于权限被拒
    }
  }

  /// 交互：从当前待发布队列中移除单张预览图
  void removeImage(int index) {
    if (index >= 0 && index < _images.length) {
      _images.removeAt(index);
      notifyListeners();
    }
  }

  /// 核心业务：发起正式发布。包含内容校验、敏感词检查（Service 侧）及上传闭环。
  Future<bool> handlePublish() async {
    if (!canPublish || _userProfile == null) return false;

    _isPublishing = true;
    notifyListeners();

    try {
      final success = await _discoveryService.publishPost(
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        imagePaths: _images.map((e) => e.path).toList(),
        userProfile: _userProfile!,
      );

      _isPublishing = false;
      notifyListeners();
      
      if (success) {
        // 发布成功后携带结果标志位返回上一页，以便上级页面拉取最新动态
        goBack(result: true);
      }

      return success;
    } catch (e) {
      _isPublishing = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }
}