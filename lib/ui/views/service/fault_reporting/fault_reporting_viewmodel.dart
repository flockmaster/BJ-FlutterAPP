import 'dart:async';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../../app/app.locator.dart';
import '../../../../core/base/baic_base_view_model.dart';
import '../../../../core/services/fault_detection_service.dart';
import '../maintenance_booking_view.dart';
import '../nearby_stores/nearby_stores_view.dart';
import '../roadside_assistance/roadside_assistance_view.dart';
import '../maintenance_booking_view.dart'; // Keep if still needed, or remove if unused

enum FaultReportingStep {
  start,
  camera,
  analyzing,
  result,
}

class FaultReportingViewModel extends BaicBaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FaultDetectionService _faultService = locator<FaultDetectionService>();
  final DialogService _dialogService = locator<DialogService>();
  
  FaultReportingStep _currentStep = FaultReportingStep.start;
  FaultReportingStep get currentStep => _currentStep;

  String? _capturedImagePath;
  String? get capturedImagePath => _capturedImagePath;

  // Real Diagnosis Report
  DiagnosisReport? _report;
  DiagnosisReport? get report => _report;

  // Camera State
  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;
  bool _isCameraInitialized = false;
  bool get isCameraInitialized => _isCameraInitialized;
  
  List<CameraDescription> _cameras = [];

  // Modal State
  bool _showSelfCheckModal = false;
  bool get showSelfCheckModal => _showSelfCheckModal;

  bool _isCriticalMode = false;
  bool get isCriticalMode => _isCriticalMode;

  // Initialize Service and Camera resources
  Future<void> initialize() async {
    await _faultService.initialize();
  }

  Future<void> initializeCamera() async {
    if (_isCameraInitialized) return;
    
    setBusy(true);
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        // Use the first back-facing camera
        final camera = _cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras.first,
        );
        
        _cameraController = CameraController(
          camera,
          ResolutionPreset.veryHigh,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg, // Critical for flutter_vision cross-platform
        );

        await _cameraController!.initialize();
        _isCameraInitialized = true;
        
        // Optimize for scanning
        await _cameraController!.setFlashMode(FlashMode.off);
        await _cameraController!.setFocusMode(FocusMode.auto);
        
        _minAvailableZoom = await _cameraController!.getMinZoomLevel();
        _maxAvailableZoom = await _cameraController!.getMaxZoomLevel();
      } else {
        setError('No cameras available');
      }
    } catch (e) {
      setError('Camera initialization failed: $e');
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  void setStep(FaultReportingStep step) async {
    _currentStep = step;
    
    if (step == FaultReportingStep.camera) {
      await initializeCamera();
    } else if (step != FaultReportingStep.camera) {
      // Releasing camera resource if not needed could be an option, 
      // but keeping it until full exit is usually smoother.
      // We will dispose it in dispose()
    }
    
    notifyListeners();
  }

  Future<void> capture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    if (_cameraController!.value.isTakingPicture) return;

    try {
      // 1. Take Picture
      print('[FaultReportingViewModel] 开始拍照...');
      final XFile imageFile = await _cameraController!.takePicture();
      _capturedImagePath = imageFile.path;
      print('[FaultReportingViewModel] 照片已保存: ${imageFile.path}');
      
      // 2. Change state to Analyzing
      setStep(FaultReportingStep.analyzing);
      
      // 3. Analyze Image
      print('[FaultReportingViewModel] 调用服务进行分析...');
      _report = await _faultService.analyzeImage(imageFile);
      print('[FaultReportingViewModel] 分析完成，结果: ${_report?.summary}');
      
      // Artificial delay for UX (to show the cool animation)
      await Future.delayed(const Duration(seconds: 2));
      
      // 4. Show Result or Handle Self-Check
      setStep(FaultReportingStep.result);
      
      // 自检判断逻辑已移除，直接显示诊断结果

    } catch (e) {
      print('[FaultReportingViewModel] 拍摄或分析过程中出错: $e');
      setError("分析失败: $e");
      // Fallback or detailed error handling
      setStep(FaultReportingStep.camera);
    }
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        _capturedImagePath = image.path;
        setStep(FaultReportingStep.analyzing);
        
        // Use the same analysis flow
        _report = await _faultService.analyzeImage(image);
        
        // Artificial delay for UX
        await Future.delayed(const Duration(seconds: 2));
        
        setStep(FaultReportingStep.result);
        
        // 自检判断逻辑已移除
      }
    } catch (e) {
      setError("从相册选择失败: $e");
    }
  }

  // 自检弹框相关方法已移除
  // void closeSelfCheckModal() ...
  // void confirmDrivingContext() ...

  void navigateBack() {
    if (_currentStep == FaultReportingStep.camera || _currentStep == FaultReportingStep.result) {
       // If in result or camera, maybe confirm before exit if interesting?
       // For now, simple back.
    }
    _navigationService.back();
  }

  void navigateToRescue() {
    _navigationService.navigateToView(const RoadsideAssistanceView());
  }

  void navigateToDealers() {
    _navigationService.navigateToView(const NearbyStoresView());
  }

  // Zoom State
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentZoomLevel = 1.0;
  double get currentZoomLevel => _currentZoomLevel;

  Future<void> setZoomLevel(double zoom) async {
    if (_cameraController == null) return;
    try {
      final z = zoom.clamp(_minAvailableZoom, _maxAvailableZoom);
      await _cameraController!.setZoomLevel(z);
      _currentZoomLevel = z;
      notifyListeners();
    } catch (_) {}
  }

  // Focus State
  Offset? _focusPoint;
  Offset? get focusPoint => _focusPoint;
  Timer? _focusResetTimer;

  Future<void> onFocusTap(Offset relativePoint) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    try {
      _focusPoint = relativePoint;
      notifyListeners();

      // Cancel previous timer
      _focusResetTimer?.cancel();
      _focusResetTimer = Timer(const Duration(seconds: 2), () {
        _focusPoint = null;
        notifyListeners();
      });

      await _cameraController!.setFocusPoint(relativePoint);
      await _cameraController!.setExposurePoint(relativePoint);
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {
      // Ignore focus errors
    }
  }

  @override
  void dispose() {
    _focusResetTimer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }
}
