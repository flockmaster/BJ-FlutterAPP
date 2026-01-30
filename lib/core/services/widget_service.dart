import 'package:home_widget/home_widget.dart';
import 'package:stacked/stacked.dart';

class WidgetService with ListenableServiceMixin {
  static const String appGroupId = 'group.com.example.car_owner_app'; // Need to be configured in Xcode
  static const String iOSWidgetName = 'CarControlWidget';

  Future<void> updateWidgetData(Map<String, dynamic> data) async {
    try {
      // Set App Group ID
      await HomeWidget.setAppGroupId(appGroupId);

      // Save data
      for (var entry in data.entries) {
        await HomeWidget.saveWidgetData(entry.key, entry.value);
      }

      // Update Widget
      await HomeWidget.updateWidget(
        iOSName: iOSWidgetName,
      );
    } catch (e) {
      print('Error updating widget: $e');
    }
  }

  /// Initialize HomeWidget (if needed)
  Future<void> init() async {
    await HomeWidget.setAppGroupId(appGroupId);
  }
}
