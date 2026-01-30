import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'invoice_list_viewmodel.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/components/baic_ui_kit.dart';

/// 发票抬头管理页面
class InvoiceListView extends StackedView<InvoiceListViewModel> {
  const InvoiceListView({super.key});

  @override
  Widget builder(BuildContext context, InvoiceListViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Column(
        children: [
          _buildHeader(viewModel),
          Expanded(
            child: viewModel.isBusy
                ? const Center(child: CircularProgressIndicator(color: AppColors.brandOrange))
                : viewModel.invoices.isEmpty
                    ? _buildEmptyState(viewModel)
                    : _buildInvoiceList(viewModel),
          ),
          _buildFooter(viewModel),
        ],
      ),
    );
  }

  Widget _buildHeader(InvoiceListViewModel viewModel) {
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
                '发票抬头',
                style: AppTypography.headingS.copyWith(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceList(InvoiceListViewModel viewModel) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: viewModel.invoices.length,
      itemBuilder: (context, index) {
        final invoice = viewModel.invoices[index];
        final isCompany = invoice['type'] == 'company';
        final isDefault = invoice['isDefault'] == true;
        
        return BaicBounceButton(
          onPressed: () => viewModel.setDefaultInvoice(invoice['id']),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDefault ? AppColors.brandOrange.withOpacity(0.08) : AppColors.shadowLight,
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
              border: isDefault ? Border.all(color: AppColors.brandOrange, width: 1.5) : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isCompany ? AppColors.brandOrange.withOpacity(0.1) : AppColors.bgFill,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCompany ? LucideIcons.briefcase : LucideIcons.user,
                        size: 12,
                        color: isCompany ? AppColors.brandOrange : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isCompany ? '企业' : '个人',
                      style: AppTypography.captionPrimary.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.brandOrange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '默认',
                          style: AppTypography.captionSecondary.copyWith(color: AppColors.textInverse, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (!isDefault)
                      BaicBounceButton(
                        onPressed: () => viewModel.deleteInvoice(invoice['id']),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(LucideIcons.trash2, size: 16, color: AppColors.textDisabled),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  invoice['title'] ?? '',
                  style: AppTypography.bodyPrimary.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isCompany && invoice['taxNumber'] != null && invoice['taxNumber'].toString().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    '税号: ${invoice['taxNumber']}',
                    style: AppTypography.captionSecondary.copyWith(
                      color: AppColors.textTertiary,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(InvoiceListViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.receipt, size: 64, color: AppColors.bgFill),
          const SizedBox(height: 16),
          Text(
            '暂无发票抬头',
            style: AppTypography.bodySecondary.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(InvoiceListViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppColors.bgCanvas,
      child: SafeArea(
        top: false,
        child: BaicBounceButton(
          onPressed: () => viewModel.addInvoice(),
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
                  '添加新抬头',
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
  InvoiceListViewModel viewModelBuilder(BuildContext context) => InvoiceListViewModel();

  @override
  void onViewModelReady(InvoiceListViewModel viewModel) => viewModel.init();
}
