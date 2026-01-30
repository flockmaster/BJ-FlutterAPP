
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_owner_app/core/models/store_models.dart';
import '../product_detail_viewmodel.dart';
import '../../../../core/theme/app_typography.dart';

/// 商品规格选择模态框 - 简化版（按照最新原型）
/// 只包含：规格选择 + 数量调整
class ProductSpecModal extends ViewModelWidget<ProductDetailViewModel> {
  const ProductSpecModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ProductDetailViewModel viewModel) {
    if (!viewModel.showSkuModal) return const SizedBox.shrink();

    return Stack(
      children: [
        // Backdrop
        GestureDetector(
          onTap: viewModel.closeSkuModal,
          child: Container(
            color: Colors.black.withValues(alpha: 0.6),
          ),
        ),
        
        // Modal Sheet
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
             height: MediaQuery.of(context).size.height * 0.65,
             decoration: const BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.only(
                 topLeft: Radius.circular(32),
                 topRight: Radius.circular(32),
               ),
             ),
             child: Column(
               children: [
                 _buildHeader(context, viewModel),
                 Expanded(
                   child: _buildSelectionForm(context, viewModel),
                 ),
                 _buildFooter(context, viewModel),
               ],
             ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, ProductDetailViewModel viewModel) {
    final product = viewModel.product!;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Floating Image
              Transform.translate(
                offset: const Offset(0, -40),
                child: Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('¥', style: AppTypography.priceCurrency),
                        const SizedBox(width: 2),
                        Text(
                          viewModel.specPrice.toStringAsFixed(0),
                          style: AppTypography.priceMain,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '已选: ${viewModel.selectionText}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Close Button
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: viewModel.closeSkuModal,
              child: const Icon(LucideIcons.x, color: Colors.grey, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionForm(BuildContext context, ProductDetailViewModel viewModel) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      children: [
        // Specs
        if (viewModel.product?.specifications != null)
          ...viewModel.product!.specifications!.map((spec) => _buildSpecSection(viewModel, spec)),

        // Quantity
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('购买数量', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111111))),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                   _CircleBtn(icon: LucideIcons.minus, onTap: () => viewModel.updateQuantity(-1), enabled: viewModel.quantity > 1),
                   SizedBox(
                     width: 32, 
                     child: Text(
                       '${viewModel.quantity}', 
                       textAlign: TextAlign.center,
                       style: AppTypography.dataDisplayXS.copyWith(fontWeight: FontWeight.bold),
                     ),
                   ),
                   _CircleBtn(icon: LucideIcons.plus, onTap: () => viewModel.updateQuantity(1), enabled: true),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSpecSection(ProductDetailViewModel viewModel, ProductSpec spec) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(spec.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111111))),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: spec.options.map((opt) {
            final isSelected = viewModel.selections[spec.id]?.value == opt.value;
            return GestureDetector(
              onTap: () => viewModel.selectOption(spec.id, opt),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: isSelected ? const Color(0xFF1A1A1A) : const Color(0xFFF3F4F6)),
                  boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset:const Offset(0, 2))] : null,
                ),
                child: Text(
                  opt.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF666666),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, ProductDetailViewModel viewModel) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: MediaQuery.of(context).padding.bottom + 12),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFF3F4F6)))),
      child: GestureDetector(
        onTap: viewModel.confirmAction,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          alignment: Alignment.center,
          child: Text(
            viewModel.buyNowMode ? '立即购买' : '确认加入',
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  const _CircleBtn({required this.icon, required this.onTap, required this.enabled});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 28, height: 28,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, size: 14, color: enabled ? const Color(0xFF333333) : Colors.grey[300]),
      ),
    );
  }
}
