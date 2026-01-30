// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_services/src/bottom_sheet/bottom_sheet_service.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_services/src/snackbar/snackbar_service.dart';
import 'package:stacked_shared/stacked_shared.dart';

import '../core/network/api_client.dart';
import '../core/services/address_service.dart';
import '../core/services/cache_service.dart';
import '../core/services/car_control_service.dart';
import '../core/services/car_service.dart';
import '../core/services/cart_service.dart';
import '../core/services/chat_service.dart';
import '../core/services/check_in_service.dart';
import '../core/services/coupon_service.dart';
import '../core/services/customer_service_service.dart';
import '../core/services/discovery_service.dart';
import '../core/services/fault_detection_service.dart';
import '../core/services/follow_service.dart';
import '../core/services/help_center_service.dart';
import '../core/services/invite_service.dart';
import '../core/services/json_product_service.dart';
import '../core/services/message_service.dart';
import '../core/services/points_service.dart';
import '../core/services/profile_detail_service.dart';
import '../core/services/profile_service.dart';
import '../core/services/service_service.dart';
import '../core/services/store_service.dart';
import '../core/services/task_service.dart';
import '../core/services/trade_in_service.dart';
import '../core/services/user_content_service.dart';
import '../core/services/widget_service.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => ApiClient());
  locator.registerLazySingleton<ICarService>(() => MockCarService());
  locator.registerLazySingleton<IStoreService>(() => StoreService());
  locator.registerLazySingleton<ICartService>(() => CartService());
  locator.registerLazySingleton<IDiscoveryService>(() => DiscoveryService());
  locator.registerLazySingleton<ITradeInService>(() => TradeInService());
  locator.registerLazySingleton<IServiceService>(() => ServiceService());
  locator.registerLazySingleton<IProfileService>(() => ProfileService());
  locator.registerLazySingleton<IChatService>(() => ChatService());
  locator.registerLazySingleton<IAddressService>(() => AddressService());
  locator.registerLazySingleton<IFollowService>(() => FollowService());
  locator.registerLazySingleton<ICheckInService>(() => CheckInService());
  locator.registerLazySingleton<IMessageService>(() => MessageService());
  locator.registerLazySingleton<IProfileDetailService>(
      () => ProfileDetailService());
  locator.registerLazySingleton<IHelpCenterService>(() => HelpCenterService());
  locator
      .registerLazySingleton<IUserContentService>(() => UserContentService());
  locator.registerLazySingleton<IPointsService>(() => PointsService());
  locator.registerLazySingleton<ICouponService>(() => CouponService());
  locator.registerLazySingleton<ITaskService>(() => TaskService());
  locator.registerLazySingleton<IInviteService>(() => InviteService());
  locator.registerLazySingleton<ICustomerServiceService>(
      () => CustomerServiceService());
  locator.registerLazySingleton(() => JsonProductService());
  locator.registerLazySingleton<ICacheService>(() => CacheService());
  locator.registerLazySingleton(() => FaultDetectionService());
  locator.registerLazySingleton(() => WidgetService());
  locator.registerLazySingleton(() => CarControlService());
}
