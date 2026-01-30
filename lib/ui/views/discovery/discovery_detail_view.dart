import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' hide SkeletonLoader;
import 'discovery_detail_viewmodel.dart';
import '../../../core/models/discovery_models.dart';
import '../../../core/utils/image_utils.dart';
import 'package:car_owner_app/core/shared/widgets/full_screen_image_viewer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/components/baic_ui_kit.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/skeleton_loader.dart';
import '../../../core/utils/time_utils.dart';

/// 发现详情页面 - 严格遵循 BAIC 架构规范
/// 架构规范: .rules (Stacked MVVM + AppColors + BaicBounceButton)
/// [DiscoveryDetailView] - 发现页动态/资讯详情展示视图
/// 
/// 核心职责：
/// 1. 根据 itemId 同步拉取完整的资讯详情（含富文本块及评论列表）。
/// 2. 渲染高度沉浸式的图文资讯页面或普通短动态。
/// 3. 处理用户互动（点赞、收藏、发表评论）。
class DiscoveryDetailView extends StackedView<DiscoveryDetailViewModel> {
  final String itemId; // 目标资讯/动态的唯一标识 ID

  const DiscoveryDetailView({super.key, required this.itemId});

  @override
  Widget builder(
    BuildContext context,
    DiscoveryDetailViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.isBusy) {
      return const Scaffold(
        backgroundColor: AppColors.bgSurface,
        body: _DiscoveryDetailSkeleton(),
      );
    }

    if (viewModel.hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('详情')),
        body: Center(child: Text('加载失败: ${viewModel.modelError}')),
      );
    }

    final item = viewModel.item;
    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('详情')),
        body: const Center(child: Text('内容不存在')),
      );
    }

    return _DiscoveryDetailContent(item: item, viewModel: viewModel);
  }

  @override
  DiscoveryDetailViewModel viewModelBuilder(BuildContext context) => DiscoveryDetailViewModel();

  @override
  void onViewModelReady(DiscoveryDetailViewModel viewModel) {
    viewModel.init(itemId);
  }
}

class _DiscoveryDetailContent extends StatefulWidget {
  final DiscoveryItem item;
  final DiscoveryDetailViewModel viewModel;

  const _DiscoveryDetailContent({required this.item, required this.viewModel});

  @override
  State<_DiscoveryDetailContent> createState() => _DiscoveryDetailContentState();
}

class _DiscoveryDetailContentState extends State<_DiscoveryDetailContent> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      backgroundColor: AppColors.bgSurface,
      appBar: _buildAppBar(context, item),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          if (item.title.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  height: 1.3,
                                ),
                              ),
                            ),

                          // Content Rendering
                          if (item.type == DiscoveryItemType.article && item.contentBlocks != null)
                            _buildArticleContent(item.contentBlocks!)
                          else
                            _buildStandardPostContent(item),

                          const SizedBox(height: 32),
                          
                          // Meta Info
                          Text(
                            '发布于 ${TimeUtils.formatRelativeTime(item.user?.createdAt)} · 著作权归作者所有',
                            style: const TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    Container(height: 8, color: AppColors.bgCanvas, width: double.infinity),
                    const SizedBox(height: 24),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Comments Header
                          Text(
                            '全部评论 (${item.comments})',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Comments List
                          _buildCommentsList(item),
                          const SizedBox(height: 80), // Bottom padding for footer
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildFooter(item),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, DiscoveryItem item) {
    return AppBar(
      backgroundColor: AppColors.bgSurface,
      elevation: 0,
      centerTitle: false,
      leading: BaicBounceButton(
        onPressed: () => widget.viewModel.goBack(),
        child: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
      ),
      titleSpacing: 0,
      title: item.user != null ? Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.bgFill,
            backgroundImage: item.user!.avatar != null ? NetworkImage(item.user!.avatar!) : null,
          ),
          const SizedBox(width: 8),
          Text(
            item.user!.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ) : null,
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.error, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              '关注',
              style: TextStyle(
                color: AppColors.error,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        BaicBounceButton(
          onPressed: () {},
          child: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.bgCanvas, height: 1),
      ),
    );
  }

  /// 构建文章专用富文本内容渲染引擎。
  /// 支持 header (二级标题)、image (大图查看) 以及 text (正文文本) 等多种 Block 类型。
  Widget _buildArticleContent(List<DiscoveryContentBlock> blocks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks.map((block) {
        if (block.type == 'image' && block.imageUrl != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: BaicBounceButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FullScreenImageViewer(
                      images: [block.imageUrl!], // View single image for article
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image(
                  image: ImageUtils.getImageProvider(block.imageUrl!),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(height: 200, color: AppColors.bgFill),
                ),
              ),
            ),
          );
        } else if (block.type == 'header' && block.text != null) {
          return Container(
            margin: const EdgeInsets.only(top: 24, bottom: 12),
            padding: const EdgeInsets.only(left: 12),
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: AppColors.error, width: 4)),
            ),
            child: Text(
              block.text!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          );
        } else if (block.text != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              block.text!,
              style: const TextStyle(
                fontSize: 16,
                height: 1.8,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.justify,
            ),
          );
        }
        return const SizedBox.shrink();
      }).toList(),
    );
  }

  /// 构建标准短动态内容架构（文字 + 多图列表）。
  Widget _buildStandardPostContent(DiscoveryItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.content != null)
          Text(
            item.content!,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
        const SizedBox(height: 16),
        if (item.images != null && item.images!.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: item.images!.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return BaicBounceButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageViewer(
                        images: item.images!,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image(
                    image: ImageUtils.getImageProvider(item.images![index]),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                       return Container(
                          height: 200,
                          color: AppColors.bgFill,
                          child: const Icon(Icons.image, color: AppColors.textTertiary),
                       );
                    },
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  /// 构建底部互动评论列表。
  Widget _buildCommentsList(DiscoveryItem item) {
    final comments = item.commentsList ?? [];
    
    if (comments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            '暂无评论，快来抢沙发吧',
            style: TextStyle(color: AppColors.textTertiary, fontSize: 14),
          ),
        ),
      );
    }

    return Column(
      children: comments.map((comment) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.bgFill,
              backgroundImage: comment.user.avatar != null ? NetworkImage(comment.user.avatar!) : null,
              child: comment.user.avatar == null ? const Icon(Icons.person, size: 20, color: AppColors.textTertiary) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(
                         comment.user.name, 
                         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)
                       ),
                       Row(
                         children: [
                           const Icon(Icons.favorite_border, size: 14, color: AppColors.textTertiary),
                           const SizedBox(width: 4),
                           Text('${comment.likes}', style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                         ],
                       )
                     ],
                   ),
                   const SizedBox(height: 4),
                   Text(
                     comment.content,
                     style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.4),
                   ),
                   const SizedBox(height: 8),
                   Row(
                     children: [
                        Text(
                          TimeUtils.formatRelativeTime(comment.createdAt), 
                          style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)
                        ),
                        const SizedBox(width: 16),
                        const Text('回复', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                     ],
                   ),
                ],
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  /// 构建底部固定的互动工具栏（评论输入、点赞、收藏）。
  Widget _buildFooter(DiscoveryItem item) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(top: BorderSide(color: AppColors.bgCanvas)),
      ),
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8 + MediaQuery.of(context).padding.bottom),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.bgCanvas,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: '说点什么...',
                        hintStyle: TextStyle(fontSize: 14, color: AppColors.textTertiary),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          _buildActionIcon(Icons.favorite_border, '${item.likes}'),
          const SizedBox(width: 16),
          _buildActionIcon(Icons.star_border, '收藏'),
          const SizedBox(width: 16),
          _buildActionIcon(Icons.chat_bubble_outline, '${item.comments}'),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: AppColors.textSecondary),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

/// [ _DiscoveryDetailSkeleton] - 发现详情页私有骨架屏
/// 模仿资讯详情页结构，用于提升加载时的感知体验。
class _DiscoveryDetailSkeleton extends StatelessWidget {
  const _DiscoveryDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Column(
        children: [
          // AppBar Skeleton
          Container(
            height: 100,
            padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
            ),
            child: const Row(
              children: [
                SkeletonCircle(size: 32),
                SizedBox(width: 12),
                SkeletonBox(width: 80, height: 16),
                Spacer(),
                SkeletonBox(width: 60, height: 28, borderRadius: BorderRadius.all(Radius.circular(14))),
                SizedBox(width: 12),
                SkeletonBox(width: 24, height: 24),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title skeleton
                  const SkeletonBox(width: double.infinity, height: 28),
                  const SizedBox(height: 12),
                  const SkeletonBox(width: 200, height: 28),
                  const SizedBox(height: 32),
                  
                  // Content blocks
                  const SkeletonBox(width: double.infinity, height: 16),
                  const SizedBox(height: 12),
                  const SkeletonBox(width: double.infinity, height: 16),
                  const SizedBox(height: 12),
                  const SkeletonBox(width: double.infinity, height: 16),
                  const SizedBox(height: 12),
                  const SkeletonBox(width: 150, height: 16),
                  
                  const SizedBox(height: 24),
                  // Image placeholder
                  const SkeletonBox(width: double.infinity, height: 200, borderRadius: BorderRadius.all(Radius.circular(12))),
                  
                  const SizedBox(height: 32),
                  // Text blocks again
                  const SkeletonBox(width: double.infinity, height: 16),
                  const SizedBox(height: 12),
                  const SkeletonBox(width: 180, height: 16),
                  
                  const SizedBox(height: 40),
                  // Comments area
                  const SkeletonBox(width: 120, height: 24),
                  const SizedBox(height: 24),
                  
                  // Mock comments
                  ...List.generate(2, (index) => const Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonCircle(size: 32),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonBox(width: 60, height: 14),
                              SizedBox(height: 8),
                              SkeletonBox(width: double.infinity, height: 14),
                              SizedBox(height: 4),
                              SkeletonBox(width: 120, height: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
          
          // Footer Skeleton
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: SkeletonBox(height: 36, borderRadius: BorderRadius.all(Radius.circular(18))),
                ),
                SizedBox(width: 16),
                SkeletonBox(width: 32, height: 32),
                SizedBox(width: 16),
                SkeletonBox(width: 32, height: 32),
                SizedBox(width: 16),
                SkeletonBox(width: 32, height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}