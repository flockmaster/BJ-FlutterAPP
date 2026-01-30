import 'package:flutter/material.dart';
import '../../../app/app.locator.dart';
import '../../../core/base/baic_base_view_model.dart';
import '../../../core/services/profile_service.dart';

class BindVehicleViewModel extends BaicBaseViewModel {
  final _profileService = locator<IProfileService>();

  // Controllers
  final TextEditingController vinController = TextEditingController();
  final TextEditingController plateController = TextEditingController();

  // State
  String? _vinError;
  
  // Getters
  String? get vinError => _vinError;
  
  bool get isFormValid {
    return vinController.text.length == 17 && _vinError == null;
  }

  // Initialization
  void init() {
    vinController.addListener(_validateVIN);
  }

  // VIN Validation
  void _validateVIN() {
    final vin = vinController.text.toUpperCase();
    
    if (vin.isEmpty) {
      _vinError = null;
    } else if (vin.length < 17) {
      _vinError = '车架号必须为17位';
    } else if (!RegExp(r'^[A-HJ-NPR-Z0-9]{17}$').hasMatch(vin)) {
      _vinError = '车架号格式不正确';
    } else {
      _vinError = null;
    }
    
    notifyListeners();
  }

  // Input handlers
  void onVINChanged(String value) {
    notifyListeners();
  }

  void onPlateChanged(String value) {
    notifyListeners();
  }

  void clearVIN() {
    vinController.clear();
    _vinError = null;
    notifyListeners();
  }

  void clearPlate() {
    plateController.clear();
    notifyListeners();
  }

  // Submit binding
  Future<void> submitBinding(BuildContext context) async {
    if (!isFormValid || !context.mounted) return;

    setBusy(true);

    try {
      final vin = vinController.text.toUpperCase();
      final plate = plateController.text.isNotEmpty 
        ? plateController.text.toUpperCase() 
        : null;

      final result = await _profileService.bindVehicle(vin, plate);
      
      if (!context.mounted) {
        setBusy(false);
        return;
      }
      
      result.when(
        success: (vehicle) {
          // Show success dialog
          _showSuccessDialog(context);
        },
        failure: (error) {
          // Show error dialog
          _showErrorDialog(context, error);
        },
      );
    } catch (e) {
      if (context.mounted) {
        _showErrorDialog(context, '绑定失败: ${e.toString()}');
      }
    } finally {
      setBusy(false);
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6FFFA),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 32,
                  color: Color(0xFF00B894),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '提交成功',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '您的车辆绑定申请已提交，预计1-2个工作日内完成审核。',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // Close dialog
                  goBack(); // Go back to my vehicles
                },
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      '知道了',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F5),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 32,
                  color: Color(0xFFFF4D4F),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '绑定失败',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      '知道了',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    vinController.dispose();
    plateController.dispose();
    super.dispose();
  }
}
