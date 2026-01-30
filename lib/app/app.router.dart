// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:car_owner_app/core/models/car_model.dart' as _i46;
import 'package:car_owner_app/core/shared/widgets/main_navigation.dart' as _i2;
import 'package:car_owner_app/ui/views/address/address_selection_view.dart'
    as _i14;
import 'package:car_owner_app/ui/views/car_buying/car_buying_view.dart' as _i5;
import 'package:car_owner_app/ui/views/car_buying/car_compare/car_compare_view.dart'
    as _i19;
import 'package:car_owner_app/ui/views/car_buying/car_order/car_order_view.dart'
    as _i20;
import 'package:car_owner_app/ui/views/car_buying/test_drive/test_drive_view.dart'
    as _i18;
import 'package:car_owner_app/ui/views/car_detail/car_detail_view.dart' as _i15;
import 'package:car_owner_app/ui/views/check_in/check_in_view.dart' as _i25;
import 'package:car_owner_app/ui/views/consultant_chat/consultant_chat_view.dart'
    as _i17;
import 'package:car_owner_app/ui/views/coupons/my_coupons_view.dart' as _i32;
import 'package:car_owner_app/ui/views/customer_service/customer_service_view.dart'
    as _i35;
import 'package:car_owner_app/ui/views/discovery/discovery_detail_view.dart'
    as _i8;
import 'package:car_owner_app/ui/views/discovery/discovery_view.dart' as _i3;
import 'package:car_owner_app/ui/views/follow/follow_list_view.dart' as _i22;
import 'package:car_owner_app/ui/views/help_center/help_center_view.dart'
    as _i36;
import 'package:car_owner_app/ui/views/invite_friends/invite_friends_view.dart'
    as _i34;
import 'package:car_owner_app/ui/views/login/login_view.dart' as _i44;
import 'package:car_owner_app/ui/views/message_center/message_center_view.dart'
    as _i27;
import 'package:car_owner_app/ui/views/my_favorites/my_favorites_view.dart'
    as _i24;
import 'package:car_owner_app/ui/views/my_posts/my_posts_view.dart' as _i23;
import 'package:car_owner_app/ui/views/my_qrcode/my_qrcode_view.dart' as _i29;
import 'package:car_owner_app/ui/views/my_vehicles/bind_vehicle_view.dart'
    as _i31;
import 'package:car_owner_app/ui/views/my_vehicles/my_vehicles_view.dart'
    as _i30;
import 'package:car_owner_app/ui/views/points/points_history_view.dart' as _i26;
import 'package:car_owner_app/ui/views/profile/profile_view.dart' as _i7;
import 'package:car_owner_app/ui/views/profile_detail/profile_detail_view.dart'
    as _i21;
import 'package:car_owner_app/ui/views/scanner/scanner_view.dart' as _i28;
import 'package:car_owner_app/ui/views/service/service_view.dart' as _i6;
import 'package:car_owner_app/ui/views/settings/account_binding_view.dart'
    as _i43;
import 'package:car_owner_app/ui/views/settings/address_list_view.dart' as _i38;
import 'package:car_owner_app/ui/views/settings/feedback_view.dart' as _i42;
import 'package:car_owner_app/ui/views/settings/invoice_list_view.dart' as _i39;
import 'package:car_owner_app/ui/views/settings/notification_settings_view.dart'
    as _i40;
import 'package:car_owner_app/ui/views/settings/privacy_settings_view.dart'
    as _i41;
import 'package:car_owner_app/ui/views/settings/settings_view.dart' as _i37;
import 'package:car_owner_app/ui/views/store/cart/store_cart_view.dart' as _i10;
import 'package:car_owner_app/ui/views/store/checkout/store_checkout_view.dart'
    as _i11;
import 'package:car_owner_app/ui/views/store/order/order_detail_view.dart'
    as _i12;
import 'package:car_owner_app/ui/views/store/order/order_list_view.dart'
    as _i13;
import 'package:car_owner_app/ui/views/store/product_detail_view.dart' as _i9;
import 'package:car_owner_app/ui/views/store/store_view.dart' as _i4;
import 'package:car_owner_app/ui/views/task_center/task_center_view.dart'
    as _i33;
import 'package:car_owner_app/ui/views/trade_in/trade_in_view.dart' as _i16;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as _i45;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i47;

class Routes {
  static const mainNavigation = '/';

  static const discoveryView = '/discovery-view';

  static const storeView = '/store-view';

  static const carBuyingView = '/car-buying-view';

  static const serviceView = '/service-view';

  static const profileView = '/profile-view';

  static const discoveryDetailView = '/discovery-detail-view';

  static const productDetailView = '/product-detail-view';

  static const storeCartView = '/store-cart-view';

  static const storeCheckoutView = '/store-checkout-view';

  static const orderDetailView = '/order-detail-view';

  static const orderListView = '/order-list-view';

  static const addressSelectionView = '/address-selection-view';

  static const carDetailView = '/car-detail-view';

  static const tradeInView = '/trade-in-view';

  static const consultantChatPage = '/consultant-chat-page';

  static const testDriveView = '/test-drive-view';

  static const carCompareView = '/car-compare-view';

  static const carOrderView = '/car-order-view';

  static const profileDetailView = '/profile-detail-view';

  static const followListView = '/follow-list-view';

  static const myPostsView = '/my-posts-view';

  static const myFavoritesView = '/my-favorites-view';

  static const checkInView = '/check-in-view';

  static const pointsHistoryView = '/points-history-view';

  static const messageCenterView = '/message-center-view';

  static const scannerView = '/scanner-view';

  static const myQRCodeView = '/my-qr-code-view';

  static const myVehiclesView = '/my-vehicles-view';

  static const bindVehicleView = '/bind-vehicle-view';

  static const myCouponsView = '/my-coupons-view';

  static const taskCenterView = '/task-center-view';

  static const inviteFriendsView = '/invite-friends-view';

  static const customerServiceView = '/customer-service-view';

  static const helpCenterView = '/help-center-view';

  static const settingsView = '/settings-view';

  static const addressListView = '/address-list-view';

  static const invoiceListView = '/invoice-list-view';

  static const notificationSettingsView = '/notification-settings-view';

  static const privacySettingsView = '/privacy-settings-view';

  static const feedbackView = '/feedback-view';

  static const accountBindingView = '/account-binding-view';

  static const loginView = '/login-view';

  static const all = <String>{
    mainNavigation,
    discoveryView,
    storeView,
    carBuyingView,
    serviceView,
    profileView,
    discoveryDetailView,
    productDetailView,
    storeCartView,
    storeCheckoutView,
    orderDetailView,
    orderListView,
    addressSelectionView,
    carDetailView,
    tradeInView,
    consultantChatPage,
    testDriveView,
    carCompareView,
    carOrderView,
    profileDetailView,
    followListView,
    myPostsView,
    myFavoritesView,
    checkInView,
    pointsHistoryView,
    messageCenterView,
    scannerView,
    myQRCodeView,
    myVehiclesView,
    bindVehicleView,
    myCouponsView,
    taskCenterView,
    inviteFriendsView,
    customerServiceView,
    helpCenterView,
    settingsView,
    addressListView,
    invoiceListView,
    notificationSettingsView,
    privacySettingsView,
    feedbackView,
    accountBindingView,
    loginView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.mainNavigation,
      page: _i2.MainNavigation,
    ),
    _i1.RouteDef(
      Routes.discoveryView,
      page: _i3.DiscoveryView,
    ),
    _i1.RouteDef(
      Routes.storeView,
      page: _i4.StoreView,
    ),
    _i1.RouteDef(
      Routes.carBuyingView,
      page: _i5.CarBuyingView,
    ),
    _i1.RouteDef(
      Routes.serviceView,
      page: _i6.ServiceView,
    ),
    _i1.RouteDef(
      Routes.profileView,
      page: _i7.ProfileView,
    ),
    _i1.RouteDef(
      Routes.discoveryDetailView,
      page: _i8.DiscoveryDetailView,
    ),
    _i1.RouteDef(
      Routes.productDetailView,
      page: _i9.ProductDetailView,
    ),
    _i1.RouteDef(
      Routes.storeCartView,
      page: _i10.StoreCartView,
    ),
    _i1.RouteDef(
      Routes.storeCheckoutView,
      page: _i11.StoreCheckoutView,
    ),
    _i1.RouteDef(
      Routes.orderDetailView,
      page: _i12.OrderDetailView,
    ),
    _i1.RouteDef(
      Routes.orderListView,
      page: _i13.OrderListView,
    ),
    _i1.RouteDef(
      Routes.addressSelectionView,
      page: _i14.AddressSelectionView,
    ),
    _i1.RouteDef(
      Routes.carDetailView,
      page: _i15.CarDetailView,
    ),
    _i1.RouteDef(
      Routes.tradeInView,
      page: _i16.TradeInView,
    ),
    _i1.RouteDef(
      Routes.consultantChatPage,
      page: _i17.ConsultantChatPage,
    ),
    _i1.RouteDef(
      Routes.testDriveView,
      page: _i18.TestDriveView,
    ),
    _i1.RouteDef(
      Routes.carCompareView,
      page: _i19.CarCompareView,
    ),
    _i1.RouteDef(
      Routes.carOrderView,
      page: _i20.CarOrderView,
    ),
    _i1.RouteDef(
      Routes.profileDetailView,
      page: _i21.ProfileDetailView,
    ),
    _i1.RouteDef(
      Routes.followListView,
      page: _i22.FollowListView,
    ),
    _i1.RouteDef(
      Routes.myPostsView,
      page: _i23.MyPostsView,
    ),
    _i1.RouteDef(
      Routes.myFavoritesView,
      page: _i24.MyFavoritesView,
    ),
    _i1.RouteDef(
      Routes.checkInView,
      page: _i25.CheckInView,
    ),
    _i1.RouteDef(
      Routes.pointsHistoryView,
      page: _i26.PointsHistoryView,
    ),
    _i1.RouteDef(
      Routes.messageCenterView,
      page: _i27.MessageCenterView,
    ),
    _i1.RouteDef(
      Routes.scannerView,
      page: _i28.ScannerView,
    ),
    _i1.RouteDef(
      Routes.myQRCodeView,
      page: _i29.MyQRCodeView,
    ),
    _i1.RouteDef(
      Routes.myVehiclesView,
      page: _i30.MyVehiclesView,
    ),
    _i1.RouteDef(
      Routes.bindVehicleView,
      page: _i31.BindVehicleView,
    ),
    _i1.RouteDef(
      Routes.myCouponsView,
      page: _i32.MyCouponsView,
    ),
    _i1.RouteDef(
      Routes.taskCenterView,
      page: _i33.TaskCenterView,
    ),
    _i1.RouteDef(
      Routes.inviteFriendsView,
      page: _i34.InviteFriendsView,
    ),
    _i1.RouteDef(
      Routes.customerServiceView,
      page: _i35.CustomerServiceView,
    ),
    _i1.RouteDef(
      Routes.helpCenterView,
      page: _i36.HelpCenterView,
    ),
    _i1.RouteDef(
      Routes.settingsView,
      page: _i37.SettingsView,
    ),
    _i1.RouteDef(
      Routes.addressListView,
      page: _i38.AddressListView,
    ),
    _i1.RouteDef(
      Routes.invoiceListView,
      page: _i39.InvoiceListView,
    ),
    _i1.RouteDef(
      Routes.notificationSettingsView,
      page: _i40.NotificationSettingsView,
    ),
    _i1.RouteDef(
      Routes.privacySettingsView,
      page: _i41.PrivacySettingsView,
    ),
    _i1.RouteDef(
      Routes.feedbackView,
      page: _i42.FeedbackView,
    ),
    _i1.RouteDef(
      Routes.accountBindingView,
      page: _i43.AccountBindingView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i44.LoginView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.MainNavigation: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.MainNavigation(),
        settings: data,
      );
    },
    _i3.DiscoveryView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.DiscoveryView(),
        settings: data,
      );
    },
    _i4.StoreView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.StoreView(),
        settings: data,
      );
    },
    _i5.CarBuyingView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.CarBuyingView(),
        settings: data,
      );
    },
    _i6.ServiceView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.ServiceView(),
        settings: data,
      );
    },
    _i7.ProfileView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i7.ProfileView(),
        settings: data,
      );
    },
    _i8.DiscoveryDetailView: (data) {
      final args = data.getArgs<DiscoveryDetailViewArguments>(nullOk: false);
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i8.DiscoveryDetailView(key: args.key, itemId: args.itemId),
        settings: data,
      );
    },
    _i9.ProductDetailView: (data) {
      final args = data.getArgs<ProductDetailViewArguments>(nullOk: false);
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i9.ProductDetailView(key: args.key, productId: args.productId),
        settings: data,
      );
    },
    _i10.StoreCartView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i10.StoreCartView(),
        settings: data,
      );
    },
    _i11.StoreCheckoutView: (data) {
      final args = data.getArgs<StoreCheckoutViewArguments>(nullOk: false);
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i11.StoreCheckoutView(key: args.key, items: args.items),
        settings: data,
      );
    },
    _i12.OrderDetailView: (data) {
      final args = data.getArgs<OrderDetailViewArguments>(nullOk: false);
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => _i12.OrderDetailView(
            key: args.key,
            orderId: args.orderId,
            orderType: args.orderType,
            items: args.items,
            totalAmount: args.totalAmount,
            paymentMethod: args.paymentMethod,
            appointmentDate: args.appointmentDate,
            productTotal: args.productTotal,
            shippingFee: args.shippingFee,
            couponDiscount: args.couponDiscount,
            pointsDiscount: args.pointsDiscount,
            rewardPoints: args.rewardPoints,
            selectedCoupon: args.selectedCoupon,
            pointsUsed: args.pointsUsed,
            invoiceMode: args.invoiceMode,
            invoiceTitle: args.invoiceTitle,
            taxNumber: args.taxNumber,
            remark: args.remark,
            orderTime: args.orderTime,
            paymentTime: args.paymentTime),
        settings: data,
      );
    },
    _i13.OrderListView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i13.OrderListView(),
        settings: data,
      );
    },
    _i14.AddressSelectionView: (data) {
      final args = data.getArgs<AddressSelectionViewArguments>(
        orElse: () => const AddressSelectionViewArguments(),
      );
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => _i14.AddressSelectionView(
            key: args.key, selectedId: args.selectedId),
        settings: data,
      );
    },
    _i15.CarDetailView: (data) {
      final args = data.getArgs<CarDetailViewArguments>(nullOk: false);
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => _i15.CarDetailView(key: args.key, car: args.car),
        settings: data,
      );
    },
    _i16.TradeInView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i16.TradeInView(),
        settings: data,
      );
    },
    _i17.ConsultantChatPage: (data) {
      final args = data.getArgs<ConsultantChatPageArguments>(nullOk: false);
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i17.ConsultantChatPage(key: args.key, carInfo: args.carInfo),
        settings: data,
      );
    },
    _i18.TestDriveView: (data) {
      final args = data.getArgs<TestDriveViewArguments>(nullOk: false);
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => _i18.TestDriveView(key: args.key, car: args.car),
        settings: data,
      );
    },
    _i19.CarCompareView: (data) {
      final args = data.getArgs<CarCompareViewArguments>(nullOk: false);
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => _i19.CarCompareView(
            key: args.key,
            initialModel: args.initialModel,
            allModels: args.allModels),
        settings: data,
      );
    },
    _i20.CarOrderView: (data) {
      final args = data.getArgs<CarOrderViewArguments>(nullOk: false);
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => _i20.CarOrderView(
            key: args.key,
            car: args.car,
            initialVersionId: args.initialVersionId),
        settings: data,
      );
    },
    _i21.ProfileDetailView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i21.ProfileDetailView(),
        settings: data,
      );
    },
    _i22.FollowListView: (data) {
      final args = data.getArgs<FollowListViewArguments>(
        orElse: () => const FollowListViewArguments(),
      );
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i22.FollowListView(key: args.key, type: args.type),
        settings: data,
      );
    },
    _i23.MyPostsView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i23.MyPostsView(),
        settings: data,
      );
    },
    _i24.MyFavoritesView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i24.MyFavoritesView(),
        settings: data,
      );
    },
    _i25.CheckInView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i25.CheckInView(),
        settings: data,
      );
    },
    _i26.PointsHistoryView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i26.PointsHistoryView(),
        settings: data,
      );
    },
    _i27.MessageCenterView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i27.MessageCenterView(),
        settings: data,
      );
    },
    _i28.ScannerView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i28.ScannerView(),
        settings: data,
      );
    },
    _i29.MyQRCodeView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i29.MyQRCodeView(),
        settings: data,
      );
    },
    _i30.MyVehiclesView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i30.MyVehiclesView(),
        settings: data,
      );
    },
    _i31.BindVehicleView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i31.BindVehicleView(),
        settings: data,
      );
    },
    _i32.MyCouponsView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i32.MyCouponsView(),
        settings: data,
      );
    },
    _i33.TaskCenterView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i33.TaskCenterView(),
        settings: data,
      );
    },
    _i34.InviteFriendsView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i34.InviteFriendsView(),
        settings: data,
      );
    },
    _i35.CustomerServiceView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i35.CustomerServiceView(),
        settings: data,
      );
    },
    _i36.HelpCenterView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i36.HelpCenterView(),
        settings: data,
      );
    },
    _i37.SettingsView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i37.SettingsView(),
        settings: data,
      );
    },
    _i38.AddressListView: (data) {
      final args = data.getArgs<AddressListViewArguments>(
        orElse: () => const AddressListViewArguments(),
      );
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => _i38.AddressListView(
            key: args.key,
            isSelectionMode: args.isSelectionMode,
            selectedAddressId: args.selectedAddressId,
            onAddressSelected: args.onAddressSelected),
        settings: data,
      );
    },
    _i39.InvoiceListView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i39.InvoiceListView(),
        settings: data,
      );
    },
    _i40.NotificationSettingsView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i40.NotificationSettingsView(),
        settings: data,
      );
    },
    _i41.PrivacySettingsView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i41.PrivacySettingsView(),
        settings: data,
      );
    },
    _i42.FeedbackView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i42.FeedbackView(),
        settings: data,
      );
    },
    _i43.AccountBindingView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i43.AccountBindingView(),
        settings: data,
      );
    },
    _i44.LoginView: (data) {
      return _i45.MaterialPageRoute<dynamic>(
        builder: (context) => const _i44.LoginView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class DiscoveryDetailViewArguments {
  const DiscoveryDetailViewArguments({
    this.key,
    required this.itemId,
  });

  final _i45.Key? key;

  final String itemId;

  @override
  String toString() {
    return '{"key": "$key", "itemId": "$itemId"}';
  }

  @override
  bool operator ==(covariant DiscoveryDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.itemId == itemId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ itemId.hashCode;
  }
}

class ProductDetailViewArguments {
  const ProductDetailViewArguments({
    this.key,
    required this.productId,
  });

  final _i45.Key? key;

  final int productId;

  @override
  String toString() {
    return '{"key": "$key", "productId": "$productId"}';
  }

  @override
  bool operator ==(covariant ProductDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.productId == productId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ productId.hashCode;
  }
}

class StoreCheckoutViewArguments {
  const StoreCheckoutViewArguments({
    this.key,
    required this.items,
  });

  final _i45.Key? key;

  final List<Map<String, dynamic>> items;

  @override
  String toString() {
    return '{"key": "$key", "items": "$items"}';
  }

  @override
  bool operator ==(covariant StoreCheckoutViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.items == items;
  }

  @override
  int get hashCode {
    return key.hashCode ^ items.hashCode;
  }
}

class OrderDetailViewArguments {
  const OrderDetailViewArguments({
    this.key,
    required this.orderId,
    required this.orderType,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    this.appointmentDate,
    this.productTotal = 0.0,
    this.shippingFee = 0.0,
    this.couponDiscount = 0.0,
    this.pointsDiscount = 0.0,
    this.rewardPoints = 0,
    this.selectedCoupon,
    this.pointsUsed = 0,
    this.invoiceMode = 'none',
    this.invoiceTitle,
    this.taxNumber,
    this.remark,
    this.orderTime,
    this.paymentTime,
  });

  final _i45.Key? key;

  final String orderId;

  final String orderType;

  final List<Map<String, dynamic>> items;

  final double totalAmount;

  final String paymentMethod;

  final String? appointmentDate;

  final double productTotal;

  final double shippingFee;

  final double couponDiscount;

  final double pointsDiscount;

  final int rewardPoints;

  final Map<String, dynamic>? selectedCoupon;

  final int pointsUsed;

  final String invoiceMode;

  final String? invoiceTitle;

  final String? taxNumber;

  final String? remark;

  final DateTime? orderTime;

  final DateTime? paymentTime;

  @override
  String toString() {
    return '{"key": "$key", "orderId": "$orderId", "orderType": "$orderType", "items": "$items", "totalAmount": "$totalAmount", "paymentMethod": "$paymentMethod", "appointmentDate": "$appointmentDate", "productTotal": "$productTotal", "shippingFee": "$shippingFee", "couponDiscount": "$couponDiscount", "pointsDiscount": "$pointsDiscount", "rewardPoints": "$rewardPoints", "selectedCoupon": "$selectedCoupon", "pointsUsed": "$pointsUsed", "invoiceMode": "$invoiceMode", "invoiceTitle": "$invoiceTitle", "taxNumber": "$taxNumber", "remark": "$remark", "orderTime": "$orderTime", "paymentTime": "$paymentTime"}';
  }

  @override
  bool operator ==(covariant OrderDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.orderId == orderId &&
        other.orderType == orderType &&
        other.items == items &&
        other.totalAmount == totalAmount &&
        other.paymentMethod == paymentMethod &&
        other.appointmentDate == appointmentDate &&
        other.productTotal == productTotal &&
        other.shippingFee == shippingFee &&
        other.couponDiscount == couponDiscount &&
        other.pointsDiscount == pointsDiscount &&
        other.rewardPoints == rewardPoints &&
        other.selectedCoupon == selectedCoupon &&
        other.pointsUsed == pointsUsed &&
        other.invoiceMode == invoiceMode &&
        other.invoiceTitle == invoiceTitle &&
        other.taxNumber == taxNumber &&
        other.remark == remark &&
        other.orderTime == orderTime &&
        other.paymentTime == paymentTime;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        orderId.hashCode ^
        orderType.hashCode ^
        items.hashCode ^
        totalAmount.hashCode ^
        paymentMethod.hashCode ^
        appointmentDate.hashCode ^
        productTotal.hashCode ^
        shippingFee.hashCode ^
        couponDiscount.hashCode ^
        pointsDiscount.hashCode ^
        rewardPoints.hashCode ^
        selectedCoupon.hashCode ^
        pointsUsed.hashCode ^
        invoiceMode.hashCode ^
        invoiceTitle.hashCode ^
        taxNumber.hashCode ^
        remark.hashCode ^
        orderTime.hashCode ^
        paymentTime.hashCode;
  }
}

class AddressSelectionViewArguments {
  const AddressSelectionViewArguments({
    this.key,
    this.selectedId,
  });

  final _i45.Key? key;

  final int? selectedId;

  @override
  String toString() {
    return '{"key": "$key", "selectedId": "$selectedId"}';
  }

  @override
  bool operator ==(covariant AddressSelectionViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.selectedId == selectedId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ selectedId.hashCode;
  }
}

class CarDetailViewArguments {
  const CarDetailViewArguments({
    this.key,
    required this.car,
  });

  final _i45.Key? key;

  final _i46.CarModel car;

  @override
  String toString() {
    return '{"key": "$key", "car": "$car"}';
  }

  @override
  bool operator ==(covariant CarDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.car == car;
  }

  @override
  int get hashCode {
    return key.hashCode ^ car.hashCode;
  }
}

class ConsultantChatPageArguments {
  const ConsultantChatPageArguments({
    this.key,
    required this.carInfo,
  });

  final _i45.Key? key;

  final Map<String, dynamic> carInfo;

  @override
  String toString() {
    return '{"key": "$key", "carInfo": "$carInfo"}';
  }

  @override
  bool operator ==(covariant ConsultantChatPageArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.carInfo == carInfo;
  }

  @override
  int get hashCode {
    return key.hashCode ^ carInfo.hashCode;
  }
}

class TestDriveViewArguments {
  const TestDriveViewArguments({
    this.key,
    required this.car,
  });

  final _i45.Key? key;

  final _i46.CarModel car;

  @override
  String toString() {
    return '{"key": "$key", "car": "$car"}';
  }

  @override
  bool operator ==(covariant TestDriveViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.car == car;
  }

  @override
  int get hashCode {
    return key.hashCode ^ car.hashCode;
  }
}

class CarCompareViewArguments {
  const CarCompareViewArguments({
    this.key,
    required this.initialModel,
    required this.allModels,
  });

  final _i45.Key? key;

  final _i46.CarModel initialModel;

  final List<_i46.CarModel> allModels;

  @override
  String toString() {
    return '{"key": "$key", "initialModel": "$initialModel", "allModels": "$allModels"}';
  }

  @override
  bool operator ==(covariant CarCompareViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.initialModel == initialModel &&
        other.allModels == allModels;
  }

  @override
  int get hashCode {
    return key.hashCode ^ initialModel.hashCode ^ allModels.hashCode;
  }
}

class CarOrderViewArguments {
  const CarOrderViewArguments({
    this.key,
    required this.car,
    this.initialVersionId,
  });

  final _i45.Key? key;

  final _i46.CarModel car;

  final String? initialVersionId;

  @override
  String toString() {
    return '{"key": "$key", "car": "$car", "initialVersionId": "$initialVersionId"}';
  }

  @override
  bool operator ==(covariant CarOrderViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.car == car &&
        other.initialVersionId == initialVersionId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ car.hashCode ^ initialVersionId.hashCode;
  }
}

class FollowListViewArguments {
  const FollowListViewArguments({
    this.key,
    this.type = 'following',
  });

  final _i45.Key? key;

  final String type;

  @override
  String toString() {
    return '{"key": "$key", "type": "$type"}';
  }

  @override
  bool operator ==(covariant FollowListViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.type == type;
  }

  @override
  int get hashCode {
    return key.hashCode ^ type.hashCode;
  }
}

class AddressListViewArguments {
  const AddressListViewArguments({
    this.key,
    this.isSelectionMode = false,
    this.selectedAddressId,
    this.onAddressSelected,
  });

  final _i45.Key? key;

  final bool isSelectionMode;

  final int? selectedAddressId;

  final dynamic Function(Map<String, dynamic>)? onAddressSelected;

  @override
  String toString() {
    return '{"key": "$key", "isSelectionMode": "$isSelectionMode", "selectedAddressId": "$selectedAddressId", "onAddressSelected": "$onAddressSelected"}';
  }

  @override
  bool operator ==(covariant AddressListViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.isSelectionMode == isSelectionMode &&
        other.selectedAddressId == selectedAddressId &&
        other.onAddressSelected == onAddressSelected;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        isSelectionMode.hashCode ^
        selectedAddressId.hashCode ^
        onAddressSelected.hashCode;
  }
}

extension NavigatorStateExtension on _i47.NavigationService {
  Future<dynamic> navigateToMainNavigation([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.mainNavigation,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToDiscoveryView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.discoveryView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStoreView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.storeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCarBuyingView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.carBuyingView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToServiceView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.serviceView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToDiscoveryDetailView({
    _i45.Key? key,
    required String itemId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.discoveryDetailView,
        arguments: DiscoveryDetailViewArguments(key: key, itemId: itemId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProductDetailView({
    _i45.Key? key,
    required int productId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.productDetailView,
        arguments: ProductDetailViewArguments(key: key, productId: productId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStoreCartView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.storeCartView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStoreCheckoutView({
    _i45.Key? key,
    required List<Map<String, dynamic>> items,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.storeCheckoutView,
        arguments: StoreCheckoutViewArguments(key: key, items: items),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOrderDetailView({
    _i45.Key? key,
    required String orderId,
    required String orderType,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String paymentMethod,
    String? appointmentDate,
    double productTotal = 0.0,
    double shippingFee = 0.0,
    double couponDiscount = 0.0,
    double pointsDiscount = 0.0,
    int rewardPoints = 0,
    Map<String, dynamic>? selectedCoupon,
    int pointsUsed = 0,
    String invoiceMode = 'none',
    String? invoiceTitle,
    String? taxNumber,
    String? remark,
    DateTime? orderTime,
    DateTime? paymentTime,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.orderDetailView,
        arguments: OrderDetailViewArguments(
            key: key,
            orderId: orderId,
            orderType: orderType,
            items: items,
            totalAmount: totalAmount,
            paymentMethod: paymentMethod,
            appointmentDate: appointmentDate,
            productTotal: productTotal,
            shippingFee: shippingFee,
            couponDiscount: couponDiscount,
            pointsDiscount: pointsDiscount,
            rewardPoints: rewardPoints,
            selectedCoupon: selectedCoupon,
            pointsUsed: pointsUsed,
            invoiceMode: invoiceMode,
            invoiceTitle: invoiceTitle,
            taxNumber: taxNumber,
            remark: remark,
            orderTime: orderTime,
            paymentTime: paymentTime),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOrderListView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.orderListView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddressSelectionView({
    _i45.Key? key,
    int? selectedId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.addressSelectionView,
        arguments:
            AddressSelectionViewArguments(key: key, selectedId: selectedId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCarDetailView({
    _i45.Key? key,
    required _i46.CarModel car,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.carDetailView,
        arguments: CarDetailViewArguments(key: key, car: car),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTradeInView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.tradeInView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToConsultantChatPage({
    _i45.Key? key,
    required Map<String, dynamic> carInfo,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.consultantChatPage,
        arguments: ConsultantChatPageArguments(key: key, carInfo: carInfo),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTestDriveView({
    _i45.Key? key,
    required _i46.CarModel car,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.testDriveView,
        arguments: TestDriveViewArguments(key: key, car: car),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCarCompareView({
    _i45.Key? key,
    required _i46.CarModel initialModel,
    required List<_i46.CarModel> allModels,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.carCompareView,
        arguments: CarCompareViewArguments(
            key: key, initialModel: initialModel, allModels: allModels),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCarOrderView({
    _i45.Key? key,
    required _i46.CarModel car,
    String? initialVersionId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.carOrderView,
        arguments: CarOrderViewArguments(
            key: key, car: car, initialVersionId: initialVersionId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProfileDetailView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.profileDetailView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToFollowListView({
    _i45.Key? key,
    String type = 'following',
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.followListView,
        arguments: FollowListViewArguments(key: key, type: type),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMyPostsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.myPostsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMyFavoritesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.myFavoritesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCheckInView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.checkInView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPointsHistoryView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.pointsHistoryView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMessageCenterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.messageCenterView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToScannerView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.scannerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMyQRCodeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.myQRCodeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMyVehiclesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.myVehiclesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToBindVehicleView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.bindVehicleView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMyCouponsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.myCouponsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTaskCenterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.taskCenterView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToInviteFriendsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.inviteFriendsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCustomerServiceView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.customerServiceView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHelpCenterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.helpCenterView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddressListView({
    _i45.Key? key,
    bool isSelectionMode = false,
    int? selectedAddressId,
    dynamic Function(Map<String, dynamic>)? onAddressSelected,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.addressListView,
        arguments: AddressListViewArguments(
            key: key,
            isSelectionMode: isSelectionMode,
            selectedAddressId: selectedAddressId,
            onAddressSelected: onAddressSelected),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToInvoiceListView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.invoiceListView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNotificationSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.notificationSettingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPrivacySettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.privacySettingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToFeedbackView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.feedbackView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAccountBindingView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.accountBindingView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMainNavigation([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.mainNavigation,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithDiscoveryView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.discoveryView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStoreView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.storeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCarBuyingView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.carBuyingView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithServiceView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.serviceView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithDiscoveryDetailView({
    _i45.Key? key,
    required String itemId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.discoveryDetailView,
        arguments: DiscoveryDetailViewArguments(key: key, itemId: itemId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProductDetailView({
    _i45.Key? key,
    required int productId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.productDetailView,
        arguments: ProductDetailViewArguments(key: key, productId: productId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStoreCartView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.storeCartView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStoreCheckoutView({
    _i45.Key? key,
    required List<Map<String, dynamic>> items,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.storeCheckoutView,
        arguments: StoreCheckoutViewArguments(key: key, items: items),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOrderDetailView({
    _i45.Key? key,
    required String orderId,
    required String orderType,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String paymentMethod,
    String? appointmentDate,
    double productTotal = 0.0,
    double shippingFee = 0.0,
    double couponDiscount = 0.0,
    double pointsDiscount = 0.0,
    int rewardPoints = 0,
    Map<String, dynamic>? selectedCoupon,
    int pointsUsed = 0,
    String invoiceMode = 'none',
    String? invoiceTitle,
    String? taxNumber,
    String? remark,
    DateTime? orderTime,
    DateTime? paymentTime,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.orderDetailView,
        arguments: OrderDetailViewArguments(
            key: key,
            orderId: orderId,
            orderType: orderType,
            items: items,
            totalAmount: totalAmount,
            paymentMethod: paymentMethod,
            appointmentDate: appointmentDate,
            productTotal: productTotal,
            shippingFee: shippingFee,
            couponDiscount: couponDiscount,
            pointsDiscount: pointsDiscount,
            rewardPoints: rewardPoints,
            selectedCoupon: selectedCoupon,
            pointsUsed: pointsUsed,
            invoiceMode: invoiceMode,
            invoiceTitle: invoiceTitle,
            taxNumber: taxNumber,
            remark: remark,
            orderTime: orderTime,
            paymentTime: paymentTime),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOrderListView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.orderListView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddressSelectionView({
    _i45.Key? key,
    int? selectedId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.addressSelectionView,
        arguments:
            AddressSelectionViewArguments(key: key, selectedId: selectedId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCarDetailView({
    _i45.Key? key,
    required _i46.CarModel car,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.carDetailView,
        arguments: CarDetailViewArguments(key: key, car: car),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTradeInView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.tradeInView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithConsultantChatPage({
    _i45.Key? key,
    required Map<String, dynamic> carInfo,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.consultantChatPage,
        arguments: ConsultantChatPageArguments(key: key, carInfo: carInfo),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTestDriveView({
    _i45.Key? key,
    required _i46.CarModel car,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.testDriveView,
        arguments: TestDriveViewArguments(key: key, car: car),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCarCompareView({
    _i45.Key? key,
    required _i46.CarModel initialModel,
    required List<_i46.CarModel> allModels,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.carCompareView,
        arguments: CarCompareViewArguments(
            key: key, initialModel: initialModel, allModels: allModels),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCarOrderView({
    _i45.Key? key,
    required _i46.CarModel car,
    String? initialVersionId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.carOrderView,
        arguments: CarOrderViewArguments(
            key: key, car: car, initialVersionId: initialVersionId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProfileDetailView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.profileDetailView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithFollowListView({
    _i45.Key? key,
    String type = 'following',
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.followListView,
        arguments: FollowListViewArguments(key: key, type: type),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMyPostsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.myPostsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMyFavoritesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.myFavoritesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCheckInView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.checkInView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPointsHistoryView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.pointsHistoryView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMessageCenterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.messageCenterView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithScannerView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.scannerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMyQRCodeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.myQRCodeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMyVehiclesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.myVehiclesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithBindVehicleView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.bindVehicleView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMyCouponsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.myCouponsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTaskCenterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.taskCenterView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithInviteFriendsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.inviteFriendsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCustomerServiceView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.customerServiceView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHelpCenterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.helpCenterView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddressListView({
    _i45.Key? key,
    bool isSelectionMode = false,
    int? selectedAddressId,
    dynamic Function(Map<String, dynamic>)? onAddressSelected,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.addressListView,
        arguments: AddressListViewArguments(
            key: key,
            isSelectionMode: isSelectionMode,
            selectedAddressId: selectedAddressId,
            onAddressSelected: onAddressSelected),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithInvoiceListView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.invoiceListView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNotificationSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.notificationSettingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPrivacySettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.privacySettingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithFeedbackView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.feedbackView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAccountBindingView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.accountBindingView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
