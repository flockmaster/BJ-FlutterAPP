import 'package:car_owner_app/core/base/baic_base_view_model.dart';
import '../../../../app/app.locator.dart';
import '../../../../core/models/user_address.dart';
import '../../../../core/services/address_service.dart';

/// [AddressSelectionViewModel] - 地址选择器业务逻辑类
///
/// 核心职责：
/// 1. 展示用户的收货地址列表，支持下单时的快速选择回传。
/// 2. 处理地址的增删改查交互映射。
class AddressSelectionViewModel extends BaicBaseViewModel {
  final _addressService = locator<IAddressService>();

  /// 用户存储的地址列表
  List<UserAddress> _addresses = [];
  List<UserAddress> get addresses => _addresses;

  /// 生命周期：拉取当前账号下的全量收货地址
  Future<void> init() async {
    setBusy(true);
    _addresses = await _addressService.getUserAddresses();
    setBusy(false);
  }

  /// 交互：选中特定地址并携带结果返回上一页（如结算页）
  void selectAddress(UserAddress address) {
    goBack(result: address);
  }

  /// 交互：跳转至新增地址表单（当前模拟直接添加 Mock 数据）
  Future<void> addNewAddress() async {
    await _addressService.addAddress(UserAddress(
      id: DateTime.now().millisecondsSinceEpoch,
      userId: 1001,
      contactName: '新增用户',
      contactPhone: '13800000000',
      province: '北京市',
      city: '北京市',
      district: '朝阳区',
      detailAddress: '新增地址测试',
      isDefault: false,
      tag: '家',
    ));
    await init(); // 刷新列表展示最新项
  }
}
