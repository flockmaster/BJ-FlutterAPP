import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:car_owner_app/core/models/service_models.dart';
import 'package:car_owner_app/core/theme/app_colors.dart';
import 'package:car_owner_app/core/theme/app_dimensions.dart';
import '../optimized_image.dart';

/// 附近门店组件
class NearbyStores extends StatelessWidget {
  final List<NearbyStore>? stores;
  final VoidCallback? onViewAllTap;
  final Function(NearbyStore)? onStoreTap;
  final Function(NearbyStore)? onNavigateTap;

  const NearbyStores({
    super.key,
    this.stores,
    this.onViewAllTap,
    this.onStoreTap,
    this.onNavigateTap,
  });

  @override
  Widget build(BuildContext context) {
    // 使用默认数据
    final displayStore = (stores?.isNotEmpty == true) 
        ? stores!.first 
        : const NearbyStore(
            id: 'default',
            name: '北京汽车越野4S店（朝阳）',
            address: '朝阳区建国路88号',
            distance: 2.3,
            rating: 4.9,
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题栏
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '附近门店',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.brandDark,
                  ),
                ),
                GestureDetector(
                  onTap: onViewAllTap,
                  child: Row(
                    children: [
                      const Text(
                        '全部',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(LucideIcons.chevronRight, size: 14, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 地图小部件
          GestureDetector(
            onTap: () => onStoreTap?.call(displayStore),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: AppDimensions.borderRadiusL,
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 地图背景
                  const OptimizedImage(
                    imageUrl: 'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=800&auto=format&fit=crop',
                    fit: BoxFit.cover,
                  ),
                  
                  // 中心标记
                  _buildMapPin(),
                  
                  // 门店信息浮窗
                  _buildStoreInfoOverlay(displayStore),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPin() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B00),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(LucideIcons.car, size: 16, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Container(
            width: 8,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreInfoOverlay(NearbyStore store) {
    return Positioned(
      bottom: 12,
      left: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        store.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF111111),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF7ED),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.star, size: 10, color: Color(0xFFF97316)),
                                const SizedBox(width: 4),
                                Text(
                                  store.rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFFF97316),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('|', style: TextStyle(color: Color(0xFFE5E7EB))),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              store.address,
                              style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 1,
                  height: 32,
                  color: const Color(0xFFF3F4F6),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => onNavigateTap?.call(store),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF111111),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.navigation, size: 14, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${store.distance}km',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF111111),
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Oswald',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
