import 'package:injectable/injectable.dart';
import '../models/user_address.dart';

/// [IAddressService] - 用户收货地址管理服务接口
/// 
/// 负责处理：获取地址列表、新增、修改、删除收货地址等业务。
abstract class IAddressService {
  /// 获取当前用户关联的所有收货地址
  Future<List<UserAddress>> getUserAddresses();
  
  /// 添加新地址
  Future<void> addAddress(UserAddress address);
  
  /// 更新已有地址信息
  Future<void> updateAddress(UserAddress address);
  
  /// 根据 ID 删除地址
  Future<void> deleteAddress(int id);
}

/// [AddressService] - 地址服务具体实现
/// 
/// 当前为全 Mock 实现，用于模拟地址管理的 CRUD 操作。
@LazySingleton(as: IAddressService)
class AddressService implements IAddressService {
  // 内存中维护的模拟数据列表
  final List<UserAddress> _addresses = [
    UserAddress(
      id: 1,
      userId: 1001,
      contactName: '张越野',
      contactPhone: '13812345678',
      province: '北京市',
      city: '北京市',
      district: '朝阳区',
      detailAddress: '建国路88号SOHO现代城A座1202',
      isDefault: true,
      tag: '公司',
    ),
    UserAddress(
      id: 2,
      userId: 1001,
      contactName: '李生活',
      contactPhone: '13987654321',
      province: '北京市',
      city: '北京市',
      district: '海淀区',
      detailAddress: '中关村大街1号海龙大厦',
      isDefault: false,
      tag: '家',
    ),
  ];

  @override
  Future<List<UserAddress>> getUserAddresses() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _addresses;
  }

  @override
  Future<void> addAddress(UserAddress address) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _addresses.add(address);
  }
  
  @override
  Future<void> updateAddress(UserAddress address) async {
     await Future.delayed(const Duration(milliseconds: 300));
     final index = _addresses.indexWhere((a) => a.id == address.id);
     if (index != -1) {
       _addresses[index] = address;
     }
  }
  
  @override
  Future<void> deleteAddress(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _addresses.removeWhere((a) => a.id == id);
  }
}
