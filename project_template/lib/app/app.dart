import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import '../core/network/api_client.dart';

// TODO: Import your views here
// import '../ui/views/home/home_view.dart';

@StackedApp(
  routes: [
    // MaterialRoute(page: HomeView, initial: true),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: ApiClient),
  ],
)
class App {}