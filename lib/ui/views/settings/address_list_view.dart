import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' hide SkeletonLoader;
import 'package:lucide_icons/lucide_icons.dart';
import 'address_list_viewmodel.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/components/baic_ui_kit.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/skeleton_loader.dart';

/// 地址管理页面
class AddressListView extends StackedView<AddressListViewModel> {
  final bool isSelectionMode;
  final int? selectedAddressId;
  final Function(Map<String, dynamic>)? onAddressSelected;

  const AddressListView({
    super.key,
    this.isSelectionMode = false,
    this.selectedAddressId,
    this.onAddressSelected,
  });

  @override
  Widget builder(BuildContext context, AddressListViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Column(
        children: [
          _buildHeader(viewModel),
          Expanded(
            child: viewModel.isBusy
                ? const _SkeletonView()
                : viewModel.addresses.isEmpty
                    ? _buildEmptyState(viewModel)
                    : _buildAddressList(viewModel),
          ),
          _buildFooter(viewModel),
        ],
      ),
    );
  }

  Widget _buildHeader(AddressListViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              BaicBounceButton(
                onPressed: () => viewModel.goBack(),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    LucideIcons.arrowLeft,
                    size: 24,
                    color: AppColors.brandBlack,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isSelectionMode ? '选择收货地址' : '地址管理',
                style: AppTypography.headingS.copyWith(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressList(AddressListViewModel viewModel) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: viewModel.addresses.length,
      itemBuilder: (context, index) {
        final address = viewModel.addresses[index];
        final isSelected = isSelectionMode && selectedAddressId == address['id'];
        
        return BaicBounceButton(
          onPressed: () {
            if (isSelectionMode && onAddressSelected != null) {
              onAddressSelected!(address);
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isSelected ? AppColors.brandOrange.withOpacity(0.08) : AppColors.shadowLight,
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
              border: isSelected ? Border.all(color: AppColors.brandOrange, width: 1.5) : null,
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          address['name'] ?? '',
                          style: AppTypography.bodyPrimary.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          address['phone'] ?? '',
                          style: AppTypography.bodySecondary,
                        ),
                        const SizedBox(width: 8),
                        if (address['isDefault'] == true)
                          _buildTag('默认', AppColors.brandOrange, AppColors.textInverse),
                        if (address['tag'] != null && address['tag'].toString().isNotEmpty)
                          _buildTag(address['tag'].toString(), AppColors.bgFill, AppColors.textSecondary),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      address['address'] ?? '',
                      style: AppTypography.bodySecondary.copyWith(height: 1.5),
                    ),
                  ],
                ),
                if (!isSelectionMode)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: BaicBounceButton(
                      onPressed: () => viewModel.editAddress(address),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(LucideIcons.edit2, size: 16, color: AppColors.textTertiary),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: AppTypography.captionSecondary.copyWith(color: textColor, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEmptyState(AddressListViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.mapPin, size: 64, color: AppColors.bgFill),
          const SizedBox(height: 16),
          Text(
            '暂无收货地址',
            style: AppTypography.bodySecondary.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(AddressListViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppColors.bgCanvas,
      child: SafeArea(
        top: false,
        child: BaicBounceButton(
          onPressed: () => viewModel.addAddress(),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.brandBlack,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandBlack.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(LucideIcons.plus, size: 20, color: AppColors.textInverse),
                const SizedBox(width: 8),
                Text(
                  '新建收货地址',
                  style: AppTypography.button.copyWith(color: AppColors.textInverse),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  AddressListViewModel viewModelBuilder(BuildContext context) => AddressListViewModel();

  @override
  void onViewModelReady(AddressListViewModel viewModel) => viewModel.init();
}

class _SkeletonView extends StatelessWidget {
  const _SkeletonView();

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    SkeletonBox(width: 60, height: 20),
                    SizedBox(width: 12),
                    SkeletonBox(width: 100, height: 16),
                    SizedBox(width: 12),
                    SkeletonBox(width: 40, height: 16),
                  ],
                ),
                SizedBox(height: 12),
                SkeletonBox(width: double.infinity, height: 16),
                SizedBox(height: 8),
                SkeletonBox(width: 200, height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
