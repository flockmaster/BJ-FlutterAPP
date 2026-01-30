import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'address_selection_viewmodel.dart';
import '../../../../core/models/user_address.dart';

class AddressSelectionView extends StackedView<AddressSelectionViewModel> {
  final int? selectedId;

  const AddressSelectionView({Key? key, this.selectedId}) : super(key: key);

  @override
  void onViewModelReady(AddressSelectionViewModel viewModel) {
    viewModel.init();
  }

  @override
  Widget builder(
    BuildContext context,
    AddressSelectionViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('选择收货地址', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.addresses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final address = viewModel.addresses[index];
                final isSelected = address.id == selectedId;
                return GestureDetector(
                  onTap: () => viewModel.selectAddress(address),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected ? Border.all(color: const Color(0xFFC18E58), width: 1) : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (address.tag != null) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFC18E58).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        address.tag!,
                                        style: const TextStyle(fontSize: 10, color: Color(0xFFC18E58)),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Text(
                                    '${address.province}${address.city}${address.district}',
                                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                address.detailAddress ?? '',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    address.contactName ?? '',
                                    style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    address.contactPhone ?? '',
                                    style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(LucideIcons.checkCircle, color: Color(0xFFC18E58), size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: viewModel.addNewAddress,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A1A1A),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 44),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('新增收货地址', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  AddressSelectionViewModel viewModelBuilder(BuildContext context) => AddressSelectionViewModel();
}
