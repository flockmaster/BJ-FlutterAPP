import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:car_owner_app/core/constants/app_constants.dart';
import 'package:car_owner_app/core/models/discovery_models.dart';
import 'package:car_owner_app/core/theme/app_colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../optimized_image.dart';
import 'package:car_owner_app/core/components/baic_ui_kit.dart';

class GoWildView extends StatelessWidget {
  final GoWildData? data;
  final Future<void> Function()? onRefresh;
  final Function(dynamic)? onItemTap;

  const GoWildView({
    super.key,
    required this.data,
    this.onRefresh,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return EasyRefresh(
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
        key: const PageStorageKey<String>('gowild'),
        slivers: [
          // Header Banner
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                   _buildImage('https://images.unsplash.com/photo-1510312305653-8ed496efae75?q=80&w=800&auto=format&fit=crop'),
                   Container(
                     decoration: const BoxDecoration(
                       gradient: LinearGradient(
                         begin: Alignment.topCenter,
                         end: Alignment.bottomCenter,
                         colors: [Colors.transparent, Color(0xFF1A1A1A)],
                       ),
                     ),
                   ),
                   const Positioned(
                     bottom: 16,
                     left: 16,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           children: [
                             Icon(Icons.wb_sunny_outlined, color: Colors.white70, size: 14),
                             SizedBox(width: 4),
                             Text('北京 -5°C 晴', style: TextStyle(color: Colors.white70, fontSize: 12)),
                           ],
                         ),
                         SizedBox(height: 4),
                         Text('探索未知 奔赴山海', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                         Text('越野 / 露营 / 路线推荐', style: TextStyle(color: Colors.white70, fontSize: 12)),
                       ],
                     ),
                   )
                ],
              ),
            ),
          ),

          // 1. Weekend Routes
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSectionHeader('周末近郊', '轻松抵达的诗和远方'),
                SizedBox(
                  height: 180, // Card height
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: data!.weekendRoutes.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = data!.weekendRoutes[index];
                      return BaicBounceButton(
                        onPressed: () => onItemTap?.call(item),
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    _buildImage(item.image),
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(item.location, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                                      ),
                                    ),
                                  ],
                                )
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.navigation_outlined, size: 12, color: Colors.grey),
                                        const SizedBox(width: 2),
                                        Text(item.distance, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                        const SizedBox(width: 12),
                                        const Icon(Icons.timer_outlined, size: 12, color: Colors.grey),
                                        const SizedBox(width: 2),
                                        Text(item.duration, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                      ],
                                    ),
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
                const SizedBox(height: 24),
              ],
            ),
          ),

          // 2. Hardcore Crossing
          SliverToBoxAdapter(
            child: _buildSectionHeader('硬核穿越', '征服极致地形'),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = data!.crossingChallenges[index];
                  return Container(
                    height: 160,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Opacity(opacity: 0.8, child: _buildImage(item.image)),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: item.tags.map((tag) => Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                                  ),
                                  child: Text(tag, style: const TextStyle(color: Colors.white, fontSize: 10)),
                                )).toList(),
                              ),
                              const SizedBox(height: 8),
                              Text(item.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.landscape, size: 14, color: Colors.white70),
                                  const SizedBox(width: 4),
                                  Text('海拔 ${item.altitude}m', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.shield_outlined, size: 14, color: Colors.white70),
                                  const SizedBox(width: 4),
                                  const Text('难度', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                  const SizedBox(width: 4),
                                  Text(item.difficulty, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: data!.crossingChallenges.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // 3. Camping Lifestyle (Masonry)
          SliverToBoxAdapter(
             child: _buildSectionHeader('露营生活', '以天为幕 以地为席'),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childCount: data!.campingSpots.length,
              itemBuilder: (context, index) {
                final item = data!.campingSpots[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                       BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImage(item.image),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: item.tags.take(2).map((tag) => Container(
                                    margin: const EdgeInsets.only(right: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text('#$tag', style: const TextStyle(color: Color(0xFF666666), fontSize: 9)),
                                  )).toList(),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.favorite_border, size: 10, color: Colors.grey),
                                    const SizedBox(width: 2),
                                    Text('${item.likes}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }

  Widget heightBox(double height, Widget child) {
    return SizedBox(height: height, child: child);
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0).copyWith(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
        ],
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
