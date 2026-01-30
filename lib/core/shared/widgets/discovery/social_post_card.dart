
import 'package:flutter/material.dart';
import 'package:car_owner_app/core/models/discovery_models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:car_owner_app/core/utils/time_utils.dart';

class SocialPostCard extends StatelessWidget {
  final DiscoveryItem item;
  final VoidCallback onTap;

  const SocialPostCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (item.type == DiscoveryItemType.ad) {
      return _buildAdCard(context);
    } else if (item.type == DiscoveryItemType.article) {
      return _buildArticleCard(context);
    }
    return _buildStandardCard(context);
  }

  Widget _buildDiscoveryImage(String url, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (url.startsWith('http') || url.startsWith('https')) {
      return CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        memCacheWidth: 400,
        maxWidthDiskCache: 400,
        placeholder: (context, url) => Container(color: Colors.grey[200]),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    } else if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    } else {
      return Image.file(
        File(url),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    }
  }

  // --- AD Layout ---
  Widget _buildAdCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEB4628), // Brand Color
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'AD',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '广告',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (item.content != null && item.content!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  item.content!,
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF333333), height: 1.5),
                ),
              ),
            // Image with Button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildDiscoveryImage(
                    item.image,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(
                      item.tag ?? '查看详情',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _parseColor(item.tagColor) ?? const Color(0xFFEB4628),
                      ),
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

  Color? _parseColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) return null;
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.tryParse(hexColor, radix: 16) ?? 0xFFEB4628);
  }

  // --- Article Layout ---
  Widget _buildArticleCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            if (item.user != null) ...[
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        item.user!.avatar ?? ''),
                    radius: 14,
                    backgroundColor: Colors.grey[100],
                    child: CachedNetworkImage(
                      imageUrl: item.user!.avatar ?? '',
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      memCacheWidth: 200,
                      maxWidthDiskCache: 200,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.person, color: Colors.grey),
                    ),
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
                  const SizedBox(width: 6),
                  Text(
                    '· ${TimeUtils.formatRelativeTime(item.user?.createdAt)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            // Cover Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _buildDiscoveryImage(item.image),
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
                      '深度长文',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Title
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
                height: 1.3,
              ),
            ),
            if (item.content != null) ...[
              const SizedBox(height: 6),
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
            ],
            const SizedBox(height: 12),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item.likes} 阅读',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Row(
                  children: [
                    Text('${item.likes} 赞',
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(width: 16),
                    Text('${item.comments} 评论',
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Standard Layout ---
  Widget _buildStandardCard(BuildContext context) {
    final images = item.images ?? (item.image.isNotEmpty ? [item.image] : []);
    final imageCount = images.length;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header
            if (item.user != null) _buildUserHeader(context),
            const SizedBox(height: 10),

            // Content
            if (item.title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
            if (item.content != null && item.content!.isNotEmpty)
              Text(
                item.content!,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF333333),
                  height: 1.5,
                ),
              ),
            const SizedBox(height: 10),

            // Media
            if (item.isVideo)
              _buildVideoCover(context, images.isNotEmpty ? images.first : '')
            else if (images.isNotEmpty)
              _buildImageGrid(context, images),
            
            const SizedBox(height: 12),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInteractionBtn(Icons.share_outlined, '${item.shares == 0 ? "分享" : item.shares}'),
                _buildInteractionBtn(Icons.chat_bubble_outline, '${item.comments == 0 ? "评论" : item.comments}'),
                _buildInteractionBtn(
                  item.likes > 100 ? Icons.favorite : Icons.favorite_border, 
                  '${item.likes == 0 ? "点赞" : item.likes}',
                  color: item.likes > 100 ? Colors.red : null
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(item.user!.avatar ?? ''),
              radius: 16,
              backgroundColor: Colors.grey[100],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.user!.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    // VIP Badge?? omitted for simplicity unless requested
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      TimeUtils.formatRelativeTime(item.user?.createdAt),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (item.user!.carModel != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.user!.carModel!,
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
        const Icon(Icons.more_horiz, color: Colors.grey),
      ],
    );
  }

  Widget _buildVideoCover(BuildContext context, String imageUrl) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: _buildDiscoveryImage(imageUrl),
          ),
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text('03:45', style: TextStyle(color: Colors.white, fontSize: 10)),
          ),
        ),
      ],
    );
  }

  Widget _buildImageGrid(BuildContext context, List<String> images) {
    final count = images.length;
    
    if (count == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 240),
          child: AspectRatio(
            aspectRatio: 16/9,
            child: _buildDiscoveryImage(images.first),
          ),
        ),
      );
    }



    // Grid Logic - Manual implementation to avoid GridView scrolling issues
    int crossAxisCount = 3;
    if (count == 2 || count == 4) {
      crossAxisCount = 2;
    }
    
    // Calculate rows
    int rowCount = (count / crossAxisCount).ceil();
    
    return Column(
      children: List.generate(rowCount, (rowIndex) {
        return Padding(
          padding: EdgeInsets.only(bottom: rowIndex < rowCount - 1 ? 4.0 : 0),
          child: Row(
            children: List.generate(crossAxisCount, (colIndex) {
              int index = rowIndex * crossAxisCount + colIndex;
              if (index >= count) return const Expanded(child: SizedBox()); // Spacer for incomplete rows
              
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: colIndex < crossAxisCount - 1 ? 4.0 : 0),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: _buildDiscoveryImage(images[index]),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildInteractionBtn(IconData icon, String label, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color ?? Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: color ?? Colors.grey[500]),
        ),
      ],
    );
  }
}
