import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' hide SkeletonLoader;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'my_posts_viewmodel.dart';
import 'package:car_owner_app/core/shared/widgets/optimized_image.dart';
import '../../../core/models/discovery_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/components/baic_ui_kit.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/skeleton_loader.dart';

/// 我的发布页面
/// 展示用户发布的所有动态内容
class MyPostsView extends StackedView<MyPostsViewModel> {
  const MyPostsView({super.key});

  @override
  Widget builder(BuildContext context, MyPostsViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Column(
        children: [
          _buildHeader(context, viewModel),
          Expanded(
            child: viewModel.isBusy
                ? _buildLoadingState()
                : viewModel.posts.isEmpty
                    ? _buildEmptyState()
                    : _buildPostsGrid(viewModel),
          ),
        ],
      ),
    );
  }

  @override
  MyPostsViewModel viewModelBuilder(BuildContext context) => MyPostsViewModel();

  @override
  void onViewModelReady(MyPostsViewModel viewModel) => viewModel.init();

  /// 顶部导航栏
  Widget _buildHeader(BuildContext context, MyPostsViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.only(top: 54, left: 20, right: 20, bottom: 12),
      decoration: BoxDecoration(
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
              child: Icon(
                LucideIcons.arrowLeft,
                size: 24,
                color: AppColors.brandBlack,
              ),
            ),
          ),
          Text(
            '我的发布',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.brandBlack,
            ),
          ),
          BaicBounceButton(
            onPressed: viewModel.handleMore,
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.centerRight,
              child: Icon(
                LucideIcons.moreHorizontal,
                size: 22,
                color: AppColors.brandBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 加载状态
  Widget _buildLoadingState() {
    return const _SkeletonView();
  }

  /// 空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.fileText,
            size: 64,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无发布',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  /// 发布内容网格
  Widget _buildPostsGrid(MyPostsViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemCount: viewModel.posts.length,
        itemBuilder: (context, index) {
          final post = viewModel.posts[index];
          return _buildPostCard(post, viewModel);
        },
      ),
    );
  }

  /// 单个发布卡片
  Widget _buildPostCard(DiscoveryItem post, MyPostsViewModel viewModel) {
    return BaicBounceButton(
      onPressed: () => viewModel.handlePostTap(post),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Stack(
          children: [
            // 图片
            AspectRatio(
              aspectRatio: 4 / 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: OptimizedImage(
                  imageUrl: post.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            
            // 视频标识
            if (post.isVideo)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  LucideIcons.video,
                  size: 16,
                  color: AppColors.textInverse,
                  shadows: [
                    Shadow(
                      color: AppColors.bgOverlay,
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            
            // 底部信息
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.shadowBase.withValues(alpha: 0.6),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.shadowBase.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.heart,
                            size: 10,
                            color: AppColors.textInverse,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${post.likes}',
                            style: AppStyles.mechanicalData.copyWith(
                              fontSize: 10,
                              color: AppColors.textInverse,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonView extends StatelessWidget {
  const _SkeletonView();

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Container(
        padding: const EdgeInsets.all(4),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 4 / 5,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return SkeletonBox(
              borderRadius: BorderRadius.circular(2),
            );
          },
        ),
      ),
    );
  }
}
