import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/base/baic_base_view_model.dart';

enum ScanMode { general, charging }

/// [ScannerViewModel] - 扫码识别（通用与充电业务）业务逻辑类
///
/// 核心职责：
/// 1. 驱动相机硬件进行实时二维码/条形码扫描，并处理震动反馈及数据流。
/// 2. 区分扫码模式：[ScanMode.general] 用于社交/链接跳转，[ScanMode.charging] 专门用于解析桩机编号。
/// 3. 管理辅助功能：手电筒（闪光灯）开关、系统相册图片读取与识别、以及手动输入补偿逻辑。
class ScannerViewModel extends BaicBaseViewModel {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  
  /// 当前扫码业务模式
  ScanMode _scanMode = ScanMode.general;
  /// 闪光灯开关状态
  bool _flashOn = false;
  /// 防抖：是否正在处理上一次扫描结果
  bool _isProcessing = false;

  ScanMode get scanMode => _scanMode;
  bool get flashOn => _flashOn;

  void init() {
  }

  /// 关键回调：相机控制器初始化完成后绑定数据流监听
  void onQRViewCreated(QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!_isProcessing) {
        _handleScanResult(scanData);
      }
    });
  }

  /// 指令处理：解析并分发扫码结果
  void _handleScanResult(Barcode scanData) {
    _isProcessing = true;
    
    final code = scanData.code;
    if (code != null && code.isNotEmpty) {
      // 成功识别后立即暂停相机，避免重复触发，同时触发触感反馈
      _controller?.pauseCamera();
      
      if (_scanMode == ScanMode.general) {
        _handleGeneralScan(code);
      } else {
        _handleChargingScan(code);
      }
    }
    
    _isProcessing = false;
  }

  /// 逻辑：处理通用扫码（如解析 URI、加好友码等）
  void _handleGeneralScan(String code) {
    debugPrint('通用扫码结果: $code');
  }

  /// 逻辑：处理充电专场扫码（解析桩机唯一 ID 并导向充电流程）
  void _handleChargingScan(String code) {
    debugPrint('充电桩扫码结果: $code');
  }

  /// 切换扫码意图（动态调整 UI 覆盖层提示）
  void setScanMode(ScanMode mode) {
    _scanMode = mode;
    notifyListeners();
  }

  /// 硬件交互：开关闪光灯
  Future<void> toggleFlash() async {
    if (_controller != null) {
      await _controller!.toggleFlash();
      _flashOn = !_flashOn;
      notifyListeners();
    }
  }

  /// 交互：从系统相册选取图片进行离线 QR 识别
  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      // TODO: 集成解码库识别离线图片中的二维码
      debugPrint('已选择图片进行识别: ${image.path}');
    }
  }

  /// 交互：唤起手动输入面板（针对扫码失败的补救方案）
  void showManualInput() {
    debugPrint('唤起充电桩编号手动输入框');
  }

  /// 权限映射：响应相机权限授予状态并引导用户跳转设置
  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('需要相机权限才能扫描二维码'),
          action: SnackBarAction(
            label: '去设置',
            onPressed: openAppSettings,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
