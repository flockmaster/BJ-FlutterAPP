import '../../../core/base/baic_base_view_model.dart';

class InvoiceListViewModel extends BaicBaseViewModel {

  List<Map<String, dynamic>> _invoices = [];
  List<Map<String, dynamic>> get invoices => _invoices;

  Future<void> init() async {
    setBusy(true);
    await _loadInvoices();
    setBusy(false);
  }

  Future<void> _loadInvoices() async {
    // TODO: Load from API
    await Future.delayed(const Duration(milliseconds: 500));
    _invoices = [
      {
        'id': '1',
        'type': 'personal',
        'title': '张越野',
        'taxNumber': '',
        'isDefault': true,
      },
      {
        'id': '2',
        'type': 'company',
        'title': '北京汽车集团有限公司',
        'taxNumber': '911100001011234567',
        'isDefault': false,
      },
      {
        'id': '3',
        'type': 'company',
        'title': '某某科技发展(北京)有限公司',
        'taxNumber': '91110105MA01234567',
        'isDefault': false,
      },
    ];
    notifyListeners();
  }

  Future<void> addInvoice() async {
    // TODO: Navigate to add invoice page
    await dialogService.showDialog(
      title: '添加发票抬头',
      description: '此功能正在开发中',
    );
  }

  Future<void> editInvoice(Map<String, dynamic> invoice) async {
    // TODO: Navigate to edit invoice page
    await dialogService.showDialog(
      title: '编辑发票抬头',
      description: '此功能正在开发中',
    );
  }

  Future<void> deleteInvoice(String id) async {
    final result = await dialogService.showConfirmationDialog(
      title: '删除发票抬头',
      description: '确认删除此发票抬头？',
      confirmationTitle: '删除',
      cancelTitle: '取消',
    );

    if (result?.confirmed == true) {
      _invoices.removeWhere((inv) => inv['id'] == id);
      notifyListeners();
    }
  }

  Future<void> setDefaultInvoice(String id) async {
    // 将所有发票的 isDefault 设为 false，然后将选中的设为 true
    for (var invoice in _invoices) {
      invoice['isDefault'] = invoice['id'] == id;
    }
    notifyListeners();
    // TODO: Update API
  }
}
