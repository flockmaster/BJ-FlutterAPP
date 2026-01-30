import 'package:flutter/foundation.dart'; // for @protected
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../app/app.locator.dart';
export 'package:car_owner_app/app/app.router.dart';

/// [BaicBaseViewModel] - 全局视图模型基类
/// 
/// 遵循铁律 1 (架构约束)：所有业务 ViewModel 必须继承此类。
/// 核心职责：
/// 1. 强制注入全局核心服务（Navigation, Dialog 等），实现逻辑解耦。
/// 2. 屏蔽 BuildContext，确保 ViewModel 纯净，严禁 UI 代码渗入。
/// 3. 集成 ReactiveViewModel，支持响应式数据流。
abstract class BaicBaseViewModel extends ReactiveViewModel {
  
  /// 自动监听服务列表
  /// 子类通过重写此 getter 并放入 [ListenableServiceMixin] 实现类即可实现全局状态自动刷新
  @override
  List<ListenableServiceMixin> get listenableServices => [];

  // 获取全局服务实例 (由 Stacked Locator 管理)
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  // 为子类暴露受保护的服务实例
  @protected
  NavigationService get navigationService => _navigationService;
  
  @protected
  DialogService get dialogService => _dialogService;

  /// 页面跳转方法：遵循铁律 1 - 导航控制
  /// 
  /// [强制要求]：所有页面跳转逻辑必须调用此方法或 navigateTo，严禁直接使用 Navigator。
  /// [routeName]：目标路由名称（由 app.router.dart 生成）
  /// [arguments]：路由传参
  Future MapsTo(String routeName, {dynamic arguments}) async {
    return await _navigationService.navigateTo(routeName, arguments: arguments);
  }

  /// 封装返回逻辑
  /// [result]：返回给上一页的数据
  void goBack({dynamic result}) {
    _navigationService.back(result: result);
  }

  /// 显示统一外观的信息弹窗
  /// [title]：弹窗标题
  /// [description]：弹窗内容正文
  Future showInfo(String title, String description) async {
    return await _dialogService.showDialog(
      title: title,
      description: description,
    );
  }
}
