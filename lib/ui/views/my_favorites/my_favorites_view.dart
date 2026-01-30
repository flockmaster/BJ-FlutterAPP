import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' hide SkeletonLoader;
import 'package:lucide_icons/lucide_icons.dart';
import 'my_favorites_viewmodel.dart';
import 'package:car_owner_app/core/shared/widgets/optimized_image.dart';
import '../../../core/models/discovery_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/components/baic_ui_kit.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/skeleton_loader.dart';

/// 我的收藏页面
/// 展示用户收藏的内容和商品
/// [MyFavoritesView] - 我的收藏空间
/// 
/// 视觉特性：双 Tab 结构切换社区与商城收藏，支持滑动列表中的一键删减。
class MyFavoritesView extends StackedView<MyFavoritesViewModel> {
  const MyFavoritesView({super.key});

  @override
  Widget builder(BuildContext context, MyFavoritesViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Column(
        children: [
          _buildHeader(context, viewModel),
          _buildTabBar(viewModel),
          Expanded(
            child: viewModel.isBusy
                ? _buildLoadingState()
                : _buildTabContent(viewModel),
          ),
        ],
      ),
    );
  }

  @override
  MyFavoritesViewModel viewModelBuilder(BuildContext context) => MyFavoritesViewModel();

  @override
  void onViewModelReady(MyFavoritesViewModel viewModel) => viewModel.init();

  /// 顶部导航栏
  Widget _buildHeader(BuildContext context, MyFavoritesViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.only(top: 54, left: 20, right: 20, bottom: 16),
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BaicBounceButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.centerLeft,
              child: const Icon(
                LucideIcons.arrowLeft,
                size: 24,
                color: AppColors.brandBlack,
              ),
            ),
          ),
          const Text(
            '我的收藏',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.brandBlack,
            ),
          ),
          BaicBounceButton(
            onPressed: viewModel.handleSearch,
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.centerRight,
              child: const Icon(
                LucideIcons.search,
                size: 22,
                color: AppColors.brandBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 标签栏
  Widget _buildTabBar(MyFavoritesViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
      ),
      child: Row(
        children: [
          _buildTab('内容', FavoriteType.content, viewModel),
          const SizedBox(width: 32),
          _buildTab('商品', FavoriteType.product, viewModel),
        ],
      ),
    );
  }

  /// 单个标签
  Widget _buildTab(String label, FavoriteType type, MyFavoritesViewModel viewModel) {
    final isActive = viewModel.activeTab == type;
    
    return BaicBounceButton(
      onPressed: () => viewModel.switchTab(type),
      child: Container(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? AppColors.brandBlack : AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 8),
            if (isActive)
              Container(
                width: 16,
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.brandBlack,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 加载状态
  Widget _buildLoadingState() {
    return const _SkeletonView();
  }

  /// 标签内容
  Widget _buildTabContent(MyFavoritesViewModel viewModel) {
    if (viewModel.activeTab == FavoriteType.content) {
      return _buildContentList(viewModel);
    } else {
      return _buildProductList(viewModel);
    }
  }

  /// 内容列表
  Widget _buildContentList(MyFavoritesViewModel viewModel) {
    if (viewModel.favoriteContents.isEmpty) {
      return _buildEmptyState('暂无收藏内容');
    }

    return ExcludeSemantics(
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: viewModel.favoriteContents.length,
        itemBuilder: (context, index) {
          final content = viewModel.favoriteContents[index];
          return _buildContentCard(content, viewModel);
        },
      ),
    );
  }

  /// 内容卡片
  Widget _buildContentCard(DiscoveryItem content, MyFavoritesViewModel viewModel) {
    return BaicBounceButton(
      onPressed: () => viewModel.handleContentTap(content),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppStyles.shadowCard,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: OptimizedImage(
                imageUrl: content.image,
                width: 100,
                height: 75,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // 内容信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.brandBlack,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  if (content.user != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                content.user!.avatar ?? '',
                                width: 16,
                                height: 16,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 16,
                                    height: 16,
                                    color: AppColors.bgFill,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              content.user!.name,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textTertiary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Text(
                          '${content.likes} 赞',
                          style: AppStyles.mechanicalData.copyWith(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 商品列表
  Widget _buildProductList(MyFavoritesViewModel viewModel) {
    if (viewModel.favoriteProducts.isEmpty) {
      return _buildEmptyState('暂无收藏商品');
    }

    return ExcludeSemantics(
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: viewModel.favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = viewModel.favoriteProducts[index];
          return _buildProductCard(product, viewModel);
        },
      ),
    );
  }

  /// 商品卡片
  Widget _buildProductCard(Map<String, dynamic> product, MyFavoritesViewModel viewModel) {
    return BaicBounceButton(
      onPressed: () => viewModel.handleProductTap(product),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppStyles.shadowCard,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品图片
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: OptimizedImage(
                imageUrl: product['image'] ?? '',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // 商品信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.brandBlack,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (product['discount'] != null && product['discount'] > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.bgFill,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '已降价 ¥${product['discount']}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12), // 替换 Spacer，防止在 unbounded height 下崩溃
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '¥${product['price']}',
                        style: AppStyles.price(16),
                      ),
                      BaicBounceButton(
                        onPressed: () => viewModel.addToCart(product),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.bgFill,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            LucideIcons.shoppingCart,
                            size: 14,
                            color: AppColors.brandBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 空状态
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            LucideIcons.heart,
            size: 64,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonView extends StatelessWidget {
  const _SkeletonView();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SkeletonLoader(
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(
                      width: 100, 
                      height: 75, 
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonLine(width: double.infinity, height: 16),
                          SizedBox(height: 8),
                          SkeletonLine(width: 150, height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
