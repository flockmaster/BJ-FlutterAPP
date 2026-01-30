import 'package:stacked/stacked.dart';
import '../../app/app.locator.dart';
import 'widget_service.dart';

/// Simulates car control state (mock)
class CarControlService with ListenableServiceMixin {
  final _widgetService = locator<WidgetService>();

  bool _isLocked = true;
  bool get isLocked => _isLocked;

  bool _isClimateOn = false;
  bool get isClimateOn => _isClimateOn;

  double _temperature = 22.0;
  double get temperature => _temperature;
  
  // Percent
  final int _fuelLevel = 75; 
  int get fuelLevel => _fuelLevel;

  // Km
  final int _range = 450;
  int get range => _range;

  CarControlService() {
    listenToReactiveValues([_isLocked, _isClimateOn, _temperature, _fuelLevel, _range]);
  }

  Future<void> toggleLock() async {
    _isLocked = !_isLocked;
    notifyListeners();
    await _updateWidget();
  }

  Future<void> toggleClimate() async {
    _isClimateOn = !_isClimateOn;
    notifyListeners();
    await _updateWidget();
  }

  Future<void> setTemperature(double temp) async {
    _temperature = temp;
    notifyListeners();
    await _updateWidget();
  }

  Future<void> _updateWidget() async {
    await _widgetService.updateWidgetData({
      'is_locked': _isLocked,
      'is_climate_on': _isClimateOn,
      'temperature': _temperature, // C
      'fuel_level': _fuelLevel,
      'range': _range,
      'car_model': 'BJ60', // Mock model name
      'license_plate': '京A·88888',
      'last_updated': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
