import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:car_owner_app/core/constants/app_constants.dart';
import 'package:car_owner_app/core/models/discovery_models.dart';
import 'package:car_owner_app/core/theme/app_colors.dart';
import '../optimized_image.dart';

class OfficialView extends StatelessWidget {
  final OfficialData? data;
  final Function(OfficialItem)? onItemTap;
  final Future<void> Function()? onRefresh;

  const OfficialView({
    super.key,
    required this.data,
    this.onItemTap,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      color: Colors.white,
      child: EasyRefresh(
        onRefresh: onRefresh ?? () async {},
        header: const ClassicHeader(
          dragText: '下拉刷新',
          armedText: '释放刷新',
          readyText: '正在刷新...',
          processingText: '正在刷新...',
          processedText: '刷新完成',
          noMoreText: '没有更多',
          failedText: '刷新失败',
          messageText: '上次更新于 %T',
          textStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        child: CustomScrollView(
          key: const PageStorageKey<String>('official'),
          slivers: [
            // Banner
            if (data!.slides.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          PageView.builder(
                            itemCount: data!.slides.length,
                            itemBuilder: (context, index) {
                              final item = data!.slides[index];
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  _buildImage(item.image),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.6)
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 16,
                                    left: 16,
                                    right: 16,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (item.subtitle != null)
                                          Text(
                                            item.subtitle!,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // Sections
            SliverToBoxAdapter(
              child: Column(
                children: data!.sections.map((section) {
                  final isActivity = section.id == 'activities';
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              section.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const Row(
                              children: [
                                Text('更多', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: isActivity ? 140 : 160, 
                        child: ListView.separated(
                          key: PageStorageKey('official_section_${section.id}'),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: section.items.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, itemIndex) {
                            final item = section.items[itemIndex];
                            return GestureDetector(
                              onTap: () => onItemTap?.call(item),
                              child: SizedBox(
                                width: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (isActivity)
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              _buildImage(item.image),
                                              Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.black.withOpacity(0.0),
                                                      Colors.black.withOpacity(0.6),
                                                    ],
                                                    stops: const [0.5, 1.0],
                                                  ),
                                                ),
                                              ),
                                              if (item.points != null)
                                                Positioned(
                                                  top: 8,
                                                  left: 8,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFFFF6B6B),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Icon(Icons.emoji_events, size: 10, color: Colors.white),
                                                        const SizedBox(width: 2),
                                                        Text(
                                                          '+${item.points}积分',
                                                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              if (item.tag != null)
                                                 Positioned(
                                                  top: 8,
                                                  right: 8,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black.withOpacity(0.4),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Text(
                                                      item.tag!,
                                                      style: const TextStyle(color: Colors.white, fontSize: 9),
                                                    ),
                                                  ),
                                                ),
                                              Positioned(
                                                bottom: 8,
                                                left: 8,
                                                right: 8,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      item.title,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        height: 1.2,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        if (item.date != null)
                                                          Text(
                                                            item.date!,
                                                            style: const TextStyle(color: Colors.white70, fontSize: 10),
                                                          ),
                                                        if (item.views != null)
                                                          Row(
                                                            children: [
                                                              const Icon(Icons.remove_red_eye, size: 10, color: Colors.white70),
                                                              const SizedBox(width: 2),
                                                              Text('${item.views}', style: const TextStyle(fontSize: 10, color: Colors.white70)),
                                                            ],
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    else
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 100,
                                            width: double.infinity,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: _buildImage(item.image),
                                              ),
                                            ),
                                          ],
                                        ),
                                    
                                    if (!isActivity) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        item.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF1A1A1A),
                                          height: 1.2,
                                        ),
                                      ),
                                      if (item.date != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                item.date!,
                                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                                              ),
                                              if (item.views != null)
                                                Row(
                                                  children: [
                                                    const Icon(Icons.remove_red_eye, size: 10, color: Colors.grey),
                                                    const SizedBox(width: 2),
                                                    Text('${item.views}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    return OptimizedImage(
      imageUrl: imagePath,
      fit: BoxFit.cover,
    );
  }
}
