import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'store_cart_viewmodel.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/components/baic_ui_kit.dart';
import '../../../../core/theme/app_typography.dart';

/// 购物车页面 - 像素级还原原型
class StoreCartView extends StackedView<StoreCartViewModel> {
  const StoreCartView({super.key});

  @override
  StoreCartViewModel viewModelBuilder(BuildContext context) => StoreCartViewModel();

  @override
  void onViewModelReady(StoreCartViewModel viewModel) {
    viewModel.init();
  }

  @override
  Widget builder(BuildContext context, StoreCartViewModel viewModel, Widget? child) {
    // 加载中状态
    if (viewModel.isBusy) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF111111),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(context, viewModel),
          Expanded(
            child: viewModel.items.isEmpty
                ? _buildEmptyCart(viewModel)
                : _buildCartList(viewModel),
          ),
          if (viewModel.items.isNotEmpty) _buildBottomBar(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, StoreCartViewModel viewModel) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BaicBounceButton(
            onPressed: viewModel.goBack,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.arrowLeft,
                size: 24,
                color: Color(0xFF111111),
              ),
            ),
          ),
          Text(
            '购物车 (${viewModel.items.length})',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111111),
            ),
          ),
          BaicBounceButton(
            onPressed: viewModel.toggleEditMode,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                viewModel.isEditMode ? '完成' : '编辑',
                key: ValueKey('cart_edit_text_${viewModel.isEditMode}'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 空购物车
  Widget _buildEmptyCart(StoreCartViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: const Color(0xFFF9FAFB)),
            ),
            child: Icon(
              LucideIcons.shoppingBag,
              size: 40,
              color: Colors.grey[200],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '您的购物车还是空的',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: viewModel.goBack,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: AppDimensions.borderRadiusFull,
                border: Border.all(color: const Color(0xFF111111), width: 2),
              ),
              child: const Text(
                '去挑选心仪商品',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 购物车列表
  Widget _buildCartList(StoreCartViewModel viewModel) {
    return ListView.builder(
      key: const ValueKey('store_cart_list'),
      padding: const EdgeInsets.all(20),
      itemCount: viewModel.items.length,
      itemBuilder: (context, index) {
        final item = viewModel.items[index];
        return Container(
          key: ValueKey('cart_item_${item.cartId}'),
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // 选择框
              BaicBounceButton(
                onPressed: () => viewModel.toggleSelect(item.cartId),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.selected
                        ? const Color(0xFF111111)
                        : Colors.white,
                    border: Border.all(
                      color: item.selected
                          ? const Color(0xFF111111)
                          : const Color(0xFFE5E7EB),
                      width: 2,
                    ),
                    boxShadow: item.selected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                  child: item.selected
                      ? const Icon(
                          LucideIcons.check,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 16),

              // 商品图片
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 85,
                  height: 85,
                  color: const Color(0xFFF9FAFB),
                  child: CachedNetworkImage(
                    imageUrl: item.product.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // 商品信息
              Expanded(
                child: SizedBox(
                  height: 85,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111111),
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.selectedSpec,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF9CA3AF),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      // 价格和数量
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('¥', style: AppTypography.priceCurrency.copyWith(fontSize: 12)),
                              Text(
                                item.product.price.toStringAsFixed(0),
                                style: AppTypography.priceMain.copyWith(fontSize: 17),
                              ),
                            ],
                          ),

                          // 数量控制
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFF0F0F0)),
                            ),
                            child: Row(
                              children: [
                                BaicBounceButton(
                                  onPressed: () => viewModel.updateQuantity(
                                    item.cartId,
                                    -1,
                                  ),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      LucideIcons.minus,
                                      size: 12,
                                      color: item.quantity <= 1
                                          ? const Color(0xFFD1D5DB)
                                          : const Color(0xFF111111),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Oswald',
                                    ),
                                  ),
                                ),
                                BaicBounceButton(
                                  onPressed: () => viewModel.updateQuantity(
                                    item.cartId,
                                    1,
                                  ),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      LucideIcons.plus,
                                      size: 12,
                                      color: Color(0xFF111111),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, StoreCartViewModel viewModel) {
    return Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          border: const Border(top: BorderSide(color: Color(0xFFF0F0F0))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 全选
            BaicBounceButton(
              onPressed: viewModel.toggleSelectAll,
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: viewModel.isAllSelected
                          ? const Color(0xFF111111)
                          : Colors.white,
                      border: Border.all(
                        color: viewModel.isAllSelected
                            ? const Color(0xFF111111)
                            : const Color(0xFFE5E7EB),
                        width: 2,
                      ),
                    ),
                    child: viewModel.isAllSelected
                        ? const Icon(
                            LucideIcons.check,
                            size: 14,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    '全选',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                ],
              ),
            ),

            // 操作按钮
            if (viewModel.isEditMode)
              BaicBounceButton(
                onPressed: viewModel.selectedItems.isEmpty
                    ? null
                    : viewModel.deleteSelected,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: AppDimensions.borderRadiusFull,
                    border: Border.all(
                      color: viewModel.selectedItems.isEmpty
                          ? const Color(0xFFF0F0F0)
                          : const Color(0xFFEF4444),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    '删除所选 (${viewModel.totalCount})',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: viewModel.selectedItems.isEmpty
                          ? const Color(0xFFD1D5DB)
                          : const Color(0xFFEF4444),
                    ),
                  ),
                ),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'SUBTOTAL',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '¥',
                            style: AppTypography.priceCurrency.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            viewModel.totalPrice.toStringAsFixed(0),
                            style: AppTypography.priceMain.copyWith(
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  BaicBounceButton(
                    onPressed: viewModel.selectedItems.isEmpty
                        ? null
                        : () => viewModel.checkoutWithContext(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: AppDimensions.borderRadiusFull,
                        color: viewModel.selectedItems.isEmpty
                            ? const Color(0xFFF0F0F0)
                            : const Color(0xFF111111),
                        boxShadow: viewModel.selectedItems.isEmpty
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Text(
                        '结算 (${viewModel.totalCount})',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: viewModel.selectedItems.isEmpty
                              ? const Color(0xFF9CA3AF)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
  }
}
