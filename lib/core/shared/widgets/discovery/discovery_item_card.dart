import 'package:flutter/material.dart';
import 'package:car_owner_app/core/models/discovery_models.dart';
import 'package:car_owner_app/core/utils/time_utils.dart';
import '../optimized_image.dart';

/// 发现页动态项显示卡片组件
class DiscoveryItemCard extends StatelessWidget {
  final DiscoveryItem item;
  final VoidCallback? onTap;

  const DiscoveryItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: _buildCardContent(context),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    switch (item.type) {
      case DiscoveryItemType.video:
        return _buildVideoCard(context);
      case DiscoveryItemType.post:
        return _buildPostCard(context);
      case DiscoveryItemType.topic:
        return _buildTopicCard(context);
      case DiscoveryItemType.news:
      case DiscoveryItemType.article:
        return _buildArticleCard(context);
      default:
        return _buildDefaultCard(context);
    }
  }

  Widget _buildVideoCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              OptimizedImage(
                imageUrl: item.image,
                fit: BoxFit.cover,
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              if (item.tag != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: _buildTag(),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildEngagementRow(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostCard(BuildContext context) {
    final hasMultipleImages = item.images != null && item.images!.length > 1;
    final images = item.images ?? (item.image.isNotEmpty ? [item.image] : []);
    final imageCount = images.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 8), // mb-2 = 8px
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.grey[50], // active:bg-gray-50
          child: Padding(
            padding: const EdgeInsets.all(16), // p-4 = 16px
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User info
                if (item.user != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFF3F4F6), width: 1), // border-gray-100
                            ),
                            child: OptimizedAvatar(
                              imageUrl: item.user!.avatar ?? '',
                              size: 40,
                              placeholder: item.user!.avatar == null
                                  ? Center(child: Text(item.user!.name[0]))
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12), // gap-3 = 12px
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.user!.name,
                                    style: const TextStyle(
                                      fontSize: 15, // text-[15px]
                                      fontWeight: FontWeight.bold, // font-bold
                                      color: Color(0xFF1A1A1A), // text-[#1A1A1A]
                                      height: 1.2, // leading-tight
                                    ),
                                  ),
                                  // VIP Badge (Mock if needed, React code has logic for it)
                                ],
                              ),
                              const SizedBox(height: 2), // mt-0.5
                              Row(
                                children: [
                                    Text(
                                    TimeUtils.formatRelativeTime(item.createdAt),
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)), // text-gray-400
                                  ),
                                  if (item.user!.carModel != null) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F5F5),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        item.user!.carModel!, // Mock model
                                        style: const TextStyle(fontSize: 10, color: Color(0xFF666666)),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.more_horiz, color: Color(0xFF9CA3AF), size: 20), // text-gray-400
                    ],
                  ),
                  const SizedBox(height: 12), // mb-3
                ],
                
                // Title (if exists)
                if (item.title.isNotEmpty && item.title != item.content)
                   Padding(
                     padding: const EdgeInsets.only(bottom: 4),
                     child: Text(
                       item.title,
                       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.4),
                     ),
                   ),

                // Content
                Text(
                  item.content ?? item.title,
                  maxLines: 4, 
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15, // text-[15px]
                    color: Color(0xFF333333), // text-[#333]
                    height: 1.6, // leading-relaxed
                  ),
                ),
                const SizedBox(height: 12), // mb-3
                
                // Images
                if (images.isNotEmpty) ...[
                 if (imageCount == 1)
                   ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: OptimizedImage(
                        imageUrl: images.first,
                        fit: BoxFit.cover,
                      ),
                    ),
                   )
                 else
                   _buildImageGrid(images),
                   
                 const SizedBox(height: 12),
                ],
                
                // Footer Interactions
                Container(
                  padding: const EdgeInsets.only(top: 12), // pt-3
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFFFAFAFA))), // border-gray-50
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       _buildInteractionBtn(Icons.share_outlined, item.shares, '分享'),
                       _buildInteractionBtn(Icons.chat_bubble_outline, item.comments, '评论'),
                       _buildInteractionBtn(Icons.favorite_border, item.likes, '点赞'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInteractionBtn(IconData icon, int count, String defaultLabel) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF6B7280)), // text-gray-500
        const SizedBox(width: 6), // gap-1.5
        Text(
          count > 0 ? _formatCount(count) : defaultLabel,
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildTopicCard(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
          child: SizedBox(
            width: 120,
            height: 100,
            child: OptimizedThumbnail(
              imageUrl: item.image,
              width: 120,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.tag != null) ...[
                  _buildTag(),
                  const SizedBox(height: 8),
                ],
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${item.comments} 讨论',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArticleCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Header
              if (item.user != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      OptimizedAvatar(
                        imageUrl: item.user!.avatar ?? '',
                        size: 32,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.user!.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '· ${TimeUtils.formatRelativeTime(item.createdAt)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),

              // Cover Image
              if (item.image.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          OptimizedImage(
                            imageUrl: item.image,
                            fit: BoxFit.cover,
                          ),
                          const Positioned(
                            top: 12,
                            right: 12,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              // We can simulate the 'Deep Article' badge if needed, using a container
                              // But for now, just the image is key.
                            ),
                          ),
                          Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "深度长文",
                                  style: TextStyle(fontSize: 10, color: Colors.white),
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ),

              // Title
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),

              // Content / Excerpt
              if (item.content != null)
                Text(
                  item.content!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.5,
                  ),
                ),
              const SizedBox(height: 12),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                     '${item.likes} 阅读',
                     style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                   ),
                   Row(
                     children: [
                       _buildSimpleStat(Icons.favorite_border, item.likes),
                       const SizedBox(width: 16),
                       _buildSimpleStat(Icons.chat_bubble_outline, item.comments),
                     ],
                   )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleStat(IconData icon, int count) {
    return Row(
      children: [
         Icon(icon, size: 16, color: const Color(0xFF9CA3AF)),
         const SizedBox(width: 4),
         Text(
           '$count',
           style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
         ),
      ],
    );
  }

  Widget _buildDefaultCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.image.isNotEmpty)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: OptimizedImage(
              imageUrl: item.image,
              fit: BoxFit.cover,
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildEngagementRow(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTag() {
    final color = _parseColor(item.tagColor) ?? Colors.blue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        item.tag!,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEngagementRow() {
    return Row(
      children: [
        _buildEngagementItem(Icons.favorite_border, item.likes),
        const SizedBox(width: 16),
        _buildEngagementItem(Icons.comment_outlined, item.comments),
        const SizedBox(width: 16),
        _buildEngagementItem(Icons.share_outlined, item.shares),
      ],
    );
  }

  Widget _buildEngagementItem(IconData icon, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          _formatCount(count),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildImageGrid(List<String> images) {
    final displayImages = images.take(4).toList();
    final hasMore = images.length > 4;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: displayImages.length,
      itemBuilder: (context, index) {
        final isLast = index == displayImages.length - 1 && hasMore;
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            fit: StackFit.expand,
            children: [
              OptimizedThumbnail(
                imageUrl: displayImages[index],
                fit: BoxFit.cover,
              ),
              if (isLast)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Text(
                      '+${images.length - 4}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _imageErrorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }

  Color? _parseColor(String? colorString) {
    if (colorString == null) return null;
    try {
      final hex = colorString.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return null;
    }
  }

  String _formatCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}万';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
