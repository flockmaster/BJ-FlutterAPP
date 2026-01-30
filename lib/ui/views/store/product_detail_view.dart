import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' hide SkeletonLoader;
import 'package:car_owner_app/core/shared/widgets/skeleton/skeleton_loader.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'product_detail_viewmodel.dart';
import 'widgets/product_sku_modal.dart';
import '../../../core/theme/app_dimensions.dart';

/// [ProductDetailView] - 商品详情页（全功能电商页）
/// 
/// 核心特性：
/// 1. 深度聚合：涵盖画廊、动态定价核心信息、信任体系（正品/顺丰）、评价系统及富文本图文详情。
/// 2. 高级交互：顶部导航栏随滚动在高斯模糊与全透明间自动切换。
/// 3. SKU 深度集成：支持基于规格选择的实时汇总提示。
class ProductDetailView extends StackedView<ProductDetailViewModel> {
  final int productId;

  const ProductDetailView({super.key, required this.productId});

  @override
  ProductDetailViewModel viewModelBuilder(BuildContext context) => 
      ProductDetailViewModel(productId: productId);

  @override
  void onViewModelReady(ProductDetailViewModel viewModel) {
    viewModel.init();
  }

  @override
  Widget builder(BuildContext context, ProductDetailViewModel viewModel, Widget? child) {
    if (viewModel.isBusy) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: _ProductDetailSkeleton(),
      );
    }

    final product = viewModel.product;
    if (product == null) {
      return const Scaffold(
        body: Center(child: Text('商品不存在')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          _buildScrollContent(context, viewModel, product),
          _buildHeader(context, viewModel),
          _buildBottomBar(context, viewModel),
          if (viewModel.showSkuModal) 
            ProductSkuModal(
              viewModel: viewModel,
              onClose: viewModel.closeSkuModal,
            ),
        ],
      ),
    );
  }

  Widget _buildScrollContent(BuildContext context, ProductDetailViewModel viewModel, product) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification && notification.depth == 0) {
          viewModel.onScroll(notification.metrics.pixels);
        }
        return false;
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          children: [
            _buildGallery(viewModel),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                children: [
                  _buildMainInfoCard(product, viewModel),
                  const SizedBox(height: 12),
                  _buildSpecTrigger(viewModel),
                  const SizedBox(height: 12),
                  _buildReviewsCard(),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            _buildDetailSection(viewModel),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// 构建商品顶部画廊 (集成 Oswald 字体数字指示器)
  Widget _buildGallery(ProductDetailViewModel viewModel) {
    return SizedBox(
      height: 440,
      child: Stack(
        children: [
          PageView.builder(
            controller: viewModel.galleryController,
            onPageChanged: viewModel.onGalleryPageChanged,
            itemCount: viewModel.galleryImages.length,
            itemBuilder: (context, index) {
              return Container(
                color: const Color(0xFFF5F5F5),
                child: CachedNetworkImage(
                  imageUrl: viewModel.galleryImages[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Text(
                '${viewModel.currentGalleryIndex} / ${viewModel.galleryImages.length}',
                style: const TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建商品核心信息卡片 (价格、标题、官方保障标识)
  Widget _buildMainInfoCard(product, ProductDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B00),
                ),
              ),
              Text(
                viewModel.basePrice.toStringAsFixed(0),
                style: const TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B00),
                  height: 1.0,
                ),
              ),
              if (product.originalPrice != null) ...[
                const SizedBox(width: 12),
                Text(
                  '¥${product.originalPrice!.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9CA3AF),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            product.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111111),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      _TrustBadge(icon: LucideIcons.checkCircle2, text: '官方正品'),
                      _TruckBadge(icon: LucideIcons.truck, text: '顺丰直发'),
                      _TrustBadge(icon: LucideIcons.shield, text: '品质保障'),
                    ],
                  ),
                ),
                Icon(LucideIcons.chevronRight, size: 14, color: Color(0xFFD1D5DB)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecTrigger(ProductDetailViewModel viewModel) {
    return GestureDetector(
      onTap: () => viewModel.openSkuModal(mode: SkuModalMode.both),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  '已选',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  viewModel.selectionText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                ),
              ],
            ),
            const Icon(LucideIcons.chevronRight, size: 18, color: Color(0xFFD1D5DB)),
          ],
        ),
      ),
    );
  }

  /// 构建用户评价预览区 (含好评率统计与单条置顶评价展示)
  Widget _buildReviewsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '用户评价',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '(128+)',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '99% 好评率',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B00),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(LucideIcons.chevronRight, size: 14, color: Color(0xFFFF6B00)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF0F0F0).withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.network(
                              'https://randomuser.me/api/portraits/men/32.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '越野老炮***',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111111),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(
                          LucideIcons.star,
                          size: 10,
                          color: Color(0xFFFF6B00),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '东西做工扎实，严丝合缝。北京汽车官方出的精品确实不一样，安装很简单，无损替换原车位。',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4B5563),
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Text(
                      '极夜黑 · BJ40专用',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      '2024-01-12',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建图文详情部分 (由多张高分辨率详情切图垂直衔接组成)
  Widget _buildDetailSection(ProductDetailViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        // 标题部分：有 padding
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '图文详情',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // 图片列表：使用标准的 CachedNetworkImage（注意：超过 8192px 高度的图片会被 GPU 限制压缩）
        ...viewModel.detailImages.map((img) {
          return CachedNetworkImage(
            imageUrl: img,
            width: double.infinity,
            fit: BoxFit.fitWidth,
            placeholder: (context, url) => Container(
              height: 200,
              color: const Color(0xFFF9FAFB),
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD1D5DB)),
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => const SizedBox.shrink(),
          );
        }),
        const SizedBox(height: 64),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, ProductDetailViewModel viewModel) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 12,
          left: 20,
          right: 20,
          bottom: 12,
        ),
        decoration: BoxDecoration(
          color: viewModel.isScrolled 
              ? Colors.white.withValues(alpha: 0.95) 
              : Colors.transparent,
          border: viewModel.isScrolled 
              ? const Border(bottom: BorderSide(color: Color(0xFFF0F0F0))) 
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: viewModel.goBack,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: viewModel.isScrolled 
                      ? const Color(0xFFF5F5F5) 
                      : Colors.black.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.arrowLeft,
                  size: 22,
                  color: viewModel.isScrolled 
                      ? const Color(0xFF111111) 
                      : Colors.white,
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: viewModel.isScrolled ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: const Text(
                '商品详情',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: viewModel.toggleFavorite,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: viewModel.isScrolled 
                          ? const Color(0xFFF5F5F5) 
                          : Colors.black.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.heart,
                      size: 20,
                      color: viewModel.isFavorited 
                          ? const Color(0xFFFF4D4F) 
                          : (viewModel.isScrolled 
                              ? const Color(0xFF111111) 
                              : Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: viewModel.isScrolled 
                          ? const Color(0xFFF5F5F5) 
                          : Colors.black.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.share2,
                      size: 20,
                      color: viewModel.isScrolled 
                          ? const Color(0xFF111111) 
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建底部固定动作条 (店铺/购物车快捷入口 + 加车/购买双主按钮)
  Widget _buildBottomBar(BuildContext context, ProductDetailViewModel viewModel) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: Color(0xFFF0F0F0))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 30,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Row(
          children: [
            const _IconBtn(icon: LucideIcons.store, label: '店铺'),
            const SizedBox(width: 24),
            GestureDetector(
              onTap: viewModel.goToCart,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const _IconBtn(icon: LucideIcons.shoppingCart, label: '购物车'),
                  if (viewModel.cartCount > 0)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6B00),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${viewModel.cartCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => viewModel.openSkuModal(mode: SkuModalMode.addToCart),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: AppDimensions.borderRadiusFull,
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 2,
                          ),
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => viewModel.openSkuModal(mode: SkuModalMode.buyNow),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: AppDimensions.borderRadiusFull,
                          color: const Color(0xFF111111),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
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
            ),
          ],
        ),
      ),
    );
  }
}

// 辅助组件
class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TrustBadge({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: const Color(0xFF111111)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

class _TruckBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TruckBadge({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: const Color(0xFFFF6B00)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF6B00),
          ),
        ),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconBtn({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF111111)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111111),
          ),
        ),
      ],
    );
  }
}

/// 商品详情页私有骨架屏
class _ProductDetailSkeleton extends StatelessWidget {
  const _ProductDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gallery Area
                const SkeletonBox(width: double.infinity, height: 440, borderRadius: BorderRadius.zero),
                
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Main info card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonBox(width: 120, height: 40),
                            SizedBox(height: 12),
                            SkeletonBox(width: double.infinity, height: 24),
                            SizedBox(height: 8),
                            SkeletonBox(width: 200, height: 24),
                            SizedBox(height: 24),
                            SkeletonBox(width: double.infinity, height: 50, borderRadius: BorderRadius.all(Radius.circular(16))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Specification trigger
                      const SkeletonBox(width: double.infinity, height: 64, borderRadius: BorderRadius.all(Radius.circular(12))),
                      const SizedBox(height: 12),
                      
                      // Reviews card
                      const SkeletonBox(width: double.infinity, height: 180, borderRadius: BorderRadius.all(Radius.circular(12))),
                    ],
                  ),
                ),
                
                // Detail images
                const Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 24),
                  child: Row(
                    children: [
                      SkeletonBox(width: 6, height: 20, borderRadius: BorderRadius.all(Radius.circular(3))),
                      SizedBox(width: 12),
                      SkeletonBox(width: 100, height: 24),
                    ],
                  ),
                ),
                ...List.generate(3, (index) => const Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: SkeletonBox(width: double.infinity, height: 400, borderRadius: BorderRadius.zero),
                )),
              ],
            ),
          ),
          
          // AppBar Skeleton
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 20,
                right: 20,
                bottom: 12,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SkeletonCircle(size: 36),
                  Row(
                    children: [
                      SkeletonCircle(size: 36),
                      SizedBox(width: 8),
                      SkeletonCircle(size: 36),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Bar Skeleton
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 12,
              ),
              color: Colors.white,
              child: const Row(
                children: [
                  SkeletonBox(width: 40, height: 40),
                  SizedBox(width: 24),
                  SkeletonBox(width: 40, height: 40),
                  SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: SkeletonBox(height: 48, borderRadius: BorderRadius.all(Radius.circular(16)))),
                        SizedBox(width: 10),
                        Expanded(child: SkeletonBox(height: 48, borderRadius: BorderRadius.all(Radius.circular(16)))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
