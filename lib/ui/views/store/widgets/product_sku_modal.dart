import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../product_detail_viewmodel.dart';
import '../../../../core/theme/app_dimensions.dart';

/// SKU选择模态框 - 像素级还原原型设计
class ProductSkuModal extends StatelessWidget {
  final ProductDetailViewModel viewModel;
  final VoidCallback onClose;

  const ProductSkuModal({
    Key? key,
    required this.viewModel,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onClose,
        child: Container(
          color: Colors.black.withValues(alpha: 0.6),
          child: GestureDetector(
            onTap: () {},
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.65,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (viewModel.product!.specifications != null)
                              ...viewModel.product!.specifications!.map((spec) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  child: _buildSpecSection(spec),
                                );
                              }),
                            _buildQuantitySelector(),
                          ],
                        ),
                      ),
                    ),
                    _buildFooter(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF9FAFB))),
      ),
      child: Row(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: viewModel.galleryImages.first,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text(
                      '¥',
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6B00),
                      ),
                    ),
                    Text(
                      viewModel.specPrice.toStringAsFixed(0),
                      style: const TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6B00),
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '官方直营 · 预计 3 日内送达',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9CA3AF),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                LucideIcons.x,
                size: 18,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecSection(spec) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              spec.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111111),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: spec.options.map<Widget>((opt) {
            final isSelected = viewModel.selections[spec.id]?.value == opt.value;
            return GestureDetector(
              onTap: () => viewModel.selectOption(spec.id, opt),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF111111) : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF111111) : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Text(
                  opt.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0).withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '购买数量',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111111),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => viewModel.updateQuantity(-1),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      LucideIcons.minus,
                      size: 14,
                      color: viewModel.quantity <= 1 
                          ? const Color(0xFFE5E7EB) 
                          : const Color(0xFF111111),
                    ),
                  ),
                ),
                SizedBox(
                  width: 32,
                  child: Text(
                    '${viewModel.quantity}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => viewModel.updateQuantity(1),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      LucideIcons.plus,
                      size: 14,
                      color: Color(0xFF111111),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    bool showAddToCart = viewModel.skuModalMode == SkuModalMode.both || 
                        viewModel.skuModalMode == SkuModalMode.addToCart;
    bool showBuyNow = viewModel.skuModalMode == SkuModalMode.both || 
                     viewModel.skuModalMode == SkuModalMode.buyNow;

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          if (showAddToCart)
            Expanded(
              child: GestureDetector(
                onTap: () => viewModel.handleSkuAction(buyNow: false),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: AppDimensions.borderRadiusFull,
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '加入购物车',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                ),
              ),
            ),
          if (viewModel.skuModalMode == SkuModalMode.both)
            const SizedBox(width: 12),
          if (showBuyNow)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  print('🔘 立即购买按钮被点击');
                  print('📋 当前模式: ${viewModel.skuModalMode}');
                  viewModel.handleSkuAction(buyNow: true);
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: AppDimensions.borderRadiusFull,
                    color: const Color(0xFF111111),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '立即购买',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
