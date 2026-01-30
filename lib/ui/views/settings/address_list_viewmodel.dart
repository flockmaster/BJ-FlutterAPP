import '../../../core/base/baic_base_view_model.dart';

class AddressListViewModel extends BaicBaseViewModel {

  List<Map<String, dynamic>> _addresses = [];
  List<Map<String, dynamic>> get addresses => _addresses;

  Future<void> init() async {
    setBusy(true);
    await _loadAddresses();
    setBusy(false);
  }

  Future<void> _loadAddresses() async {
    // TODO: Load from API
    await Future.delayed(const Duration(milliseconds: 500));
    _addresses = [
      {
        'id': '1',
        'name': '张越野',
        'phone': '138****8888',
        'address': '北京市朝阳区东三环北路38号安联大厦1层',
        'isDefault': true,
      },
      {
        'id': '2',
        'name': '张越野',
        'phone': '138****8888',
        'address': '北京市海淀区中关村大街1号',
        'isDefault': false,
      },
    ];
    notifyListeners();
  }

  Future<void> addAddress() async {
    // TODO: Navigate to add address page
    await dialogService.showDialog(
      title: '添加地址',
      description: '此功能正在开发中',
    );
  }

  Future<void> editAddress(Map<String, dynamic> address) async {
    // TODO: Navigate to edit address page
    await dialogService.showDialog(
      title: '编辑地址',
      description: '此功能正在开发中',
    );
  }

  Future<void> deleteAddress(String id) async {
    final result = await dialogService.showConfirmationDialog(
      title: '删除地址',
      description: '确认删除此地址？',
      confirmationTitle: '删除',
      cancelTitle: '取消',
    );

    if (result?.confirmed == true) {
      _addresses.removeWhere((addr) => addr['id'] == id);
      notifyListeners();
    }
  }
}
