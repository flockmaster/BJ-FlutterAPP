import 'package:flutter/material.dart';
import '../../../core/base/baic_base_view_model.dart';

/// 投诉建议 ViewModel
class FeedbackViewModel extends BaicBaseViewModel {

  final TextEditingController contentController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  
  // 反馈类型：功能异常、产品建议、服务表扬
  String _selectedType = '功能异常';
  final List<String> _feedbackTypes = ['功能异常', '产品建议', '服务表扬'];
  List<String> _selectedImages = [];

  String get selectedType => _selectedType;
  List<String> get feedbackTypes => _feedbackTypes;
  List<String> get selectedImages => _selectedImages;
  
  bool get canSubmit => contentController.text.trim().isNotEmpty;

  @override
  void dispose() {
    contentController.dispose();
    contactController.dispose();
    super.dispose();
  }

  void selectType(String type) {
    _selectedType = type;
    notifyListeners();
  }

  Future<void> pickImages() async {
    // TODO: Implement image picker
    // 使用 image_picker 包选择图片
    await dialogService.showDialog(
      title: '选择图片',
      description: '此功能正在开发中',
    );
    
    // 模拟添加图片
    // _selectedImages.add('https://example.com/image.jpg');
    // notifyListeners();
  }

  void removeImage(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      _selectedImages.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> submitFeedback(BuildContext context) async {
    if (!canSubmit) {
      await dialogService.showDialog(
        title: '提示',
        description: '请填写反馈内容',
      );
      return;
    }

    setBusy(true);
    
    try {
      // TODO: Submit to API
      // 构建提交数据
      final feedbackData = {
        'type': _selectedType,
        'content': contentController.text.trim(),
        'contact': contactController.text.trim(),
        'images': _selectedImages,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      // 模拟网络请求
      await Future.delayed(const Duration(milliseconds: 1500));
      
      setBusy(false);

      await dialogService.showDialog(
        title: '提交成功',
        description: '我们会尽快处理您的反馈。',
      );

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setBusy(false);
      await dialogService.showDialog(
        title: '提交失败',
        description: '请检查网络连接后重试',
      );
    }
  }
}
