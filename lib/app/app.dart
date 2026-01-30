import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../ui/views/discovery/discovery_view.dart';
import '../ui/views/discovery/discovery_detail_view.dart';
import '../ui/views/store/store_view.dart';
import '../ui/views/store/product_detail_view.dart';
import '../ui/views/car_buying/car_buying_view.dart';
import '../ui/views/car_detail/car_detail_view.dart';
import '../ui/views/service/service_view.dart';
import '../ui/views/profile/profile_view.dart';
import '../ui/views/profile_detail/profile_detail_view.dart';
import '../ui/views/follow/follow_list_view.dart';
import '../ui/views/check_in/check_in_view.dart';
import '../ui/views/points/points_history_view.dart';
import '../ui/views/message_center/message_center_view.dart';
import '../ui/views/help_center/help_center_view.dart';
import '../ui/views/consultant_chat/consultant_chat_view.dart';
import '../ui/views/trade_in/trade_in_view.dart';
import '../ui/views/scanner/scanner_view.dart';
import '../ui/views/my_qrcode/my_qrcode_view.dart';
import '../ui/views/my_vehicles/my_vehicles_view.dart';
import '../ui/views/my_vehicles/bind_vehicle_view.dart';
import '../ui/views/store/order/order_list_view.dart';
import '../ui/views/coupons/my_coupons_view.dart';
import '../ui/views/task_center/task_center_view.dart';
import '../ui/views/invite_friends/invite_friends_view.dart';
import '../ui/views/customer_service/customer_service_view.dart';
import '../ui/views/settings/settings_view.dart';
import '../ui/views/settings/address_list_view.dart';
import '../ui/views/settings/invoice_list_view.dart';
import '../ui/views/settings/notification_settings_view.dart';
import '../ui/views/settings/privacy_settings_view.dart';
import '../ui/views/settings/feedback_view.dart';
import '../ui/views/settings/account_binding_view.dart';
import '../ui/views/store/cart/store_cart_view.dart';
import '../ui/views/store/checkout/store_checkout_view.dart';
import '../ui/views/store/order/order_detail_view.dart';
import '../ui/views/address/address_selection_view.dart';
import '../ui/views/my_posts/my_posts_view.dart';
import '../ui/views/my_favorites/my_favorites_view.dart';
import '../ui/views/car_buying/test_drive/test_drive_view.dart';
import '../ui/views/car_buying/car_compare/car_compare_view.dart';
import '../ui/views/car_buying/car_order/car_order_view.dart';
import '../ui/views/login/login_view.dart';
import '../core/shared/widgets/main_navigation.dart';
import '../core/services/car_service.dart';
import '../core/services/store_service.dart';
import '../core/services/cart_service.dart';
import '../core/services/discovery_service.dart';
import '../core/services/trade_in_service.dart';
import '../core/services/service_service.dart';
import '../core/services/profile_service.dart';
import '../core/services/chat_service.dart';
import '../core/services/address_service.dart';
import '../core/services/follow_service.dart';
import '../core/services/check_in_service.dart';
import '../core/services/message_service.dart';
import '../core/services/profile_detail_service.dart';
import '../core/services/help_center_service.dart';
import '../core/services/user_content_service.dart';
import '../core/services/points_service.dart';
import '../core/services/coupon_service.dart';
import '../core/services/task_service.dart';
import '../core/services/invite_service.dart';
import '../core/services/customer_service_service.dart';
import '../core/services/json_product_service.dart';
import 'package:car_owner_app/core/network/api_client.dart';
import '../core/services/cache_service.dart';
import '../core/services/fault_detection_service.dart';
import '../core/services/widget_service.dart';
import '../core/services/car_control_service.dart';

import '../ui/dialogs/booking_success_dialog.dart';
import '../ui/bottom_sheets/map_selection_sheet.dart';
import '../ui/bottom_sheets/payment_method_sheet.dart';

@StackedApp(
  routes: [
    // Main Navigation (底部导航栏容器)
    MaterialRoute(page: MainNavigation, initial: true),
    
    // Main Tabs
    MaterialRoute(page: DiscoveryView),
    MaterialRoute(page: StoreView),
    MaterialRoute(page: CarBuyingView),
    MaterialRoute(page: ServiceView),
    MaterialRoute(page: ProfileView),
    
    // Discovery
    MaterialRoute(page: DiscoveryDetailView),
    
    // Store
    MaterialRoute(page: ProductDetailView),
    MaterialRoute(page: StoreCartView),
    MaterialRoute(page: StoreCheckoutView),
    MaterialRoute(page: OrderDetailView),
    MaterialRoute(page: OrderListView),
    MaterialRoute(page: AddressSelectionView),
    
    // Car
    MaterialRoute(page: CarDetailView),
    MaterialRoute(page: TradeInView),
    MaterialRoute(page: ConsultantChatPage),
    MaterialRoute(page: TestDriveView),
    MaterialRoute(page: CarCompareView),
    MaterialRoute(page: CarOrderView),
    
    // Profile
    MaterialRoute(page: ProfileDetailView),
    MaterialRoute(page: FollowListView),
    MaterialRoute(page: MyPostsView),
    MaterialRoute(page: MyFavoritesView),
    MaterialRoute(page: CheckInView),
    MaterialRoute(page: PointsHistoryView),
    MaterialRoute(page: MessageCenterView),
    MaterialRoute(page: ScannerView),
    MaterialRoute(page: MyQRCodeView),
    MaterialRoute(page: MyVehiclesView),
    MaterialRoute(page: BindVehicleView),
    MaterialRoute(page: MyCouponsView),
    MaterialRoute(page: TaskCenterView),
    MaterialRoute(page: InviteFriendsView),
    MaterialRoute(page: CustomerServiceView),
    MaterialRoute(page: HelpCenterView),
    
    // Settings
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: AddressListView),
    MaterialRoute(page: InvoiceListView),
    MaterialRoute(page: NotificationSettingsView),
    MaterialRoute(page: PrivacySettingsView),
    MaterialRoute(page: FeedbackView),
    MaterialRoute(page: AccountBindingView),
    MaterialRoute(page: LoginView),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: ApiClient),


    // Feature Services
    LazySingleton(classType: MockCarService, asType: ICarService),
    LazySingleton(classType: StoreService, asType: IStoreService),
    LazySingleton(classType: CartService, asType: ICartService),
    LazySingleton(classType: DiscoveryService, asType: IDiscoveryService),
    LazySingleton(classType: TradeInService, asType: ITradeInService),
    LazySingleton(classType: ServiceService, asType: IServiceService),
    LazySingleton(classType: ProfileService, asType: IProfileService),
    LazySingleton(classType: ChatService, asType: IChatService),
    LazySingleton(classType: AddressService, asType: IAddressService),
    LazySingleton(classType: FollowService, asType: IFollowService),
    LazySingleton(classType: CheckInService, asType: ICheckInService),
    LazySingleton(classType: MessageService, asType: IMessageService),
    LazySingleton(classType: ProfileDetailService, asType: IProfileDetailService),
    LazySingleton(classType: HelpCenterService, asType: IHelpCenterService),
    LazySingleton(classType: UserContentService, asType: IUserContentService),
    LazySingleton(classType: PointsService, asType: IPointsService),
    LazySingleton(classType: CouponService, asType: ICouponService),
    LazySingleton(classType: TaskService, asType: ITaskService),
    LazySingleton(classType: InviteService, asType: IInviteService),
    LazySingleton(classType: CustomerServiceService, asType: ICustomerServiceService),
    LazySingleton(classType: JsonProductService),
    LazySingleton(classType: CacheService, asType: ICacheService),
    LazySingleton(classType: FaultDetectionService),
    LazySingleton(classType: WidgetService),
    LazySingleton(classType: CarControlService),
  ],
  dialogs: [
    StackedDialog(classType: BookingSuccessDialog),
  ],
  bottomsheets: [
    StackedBottomsheet(classType: MapSelectionSheet),
    StackedBottomsheet(classType: PaymentMethodSheet),
  ],
)
class App {}