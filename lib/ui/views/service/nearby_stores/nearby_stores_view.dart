import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:stacked/stacked.dart';
import 'dart:ui';
import 'nearby_stores_viewmodel.dart';
import '../../../../core/models/service_models.dart';
import 'package:car_owner_app/core/shared/widgets/optimized_image.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/components/baic_ui_kit.dart';

/// 附近门店地图页面
class NearbyStoresView extends StatelessWidget {
  const NearbyStoresView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NearbyStoresViewModel>.reactive(
      viewModelBuilder: () => NearbyStoresViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // 地图区域
            if (viewModel.viewMode == 'map') _buildMap(context, viewModel),
            
            // 列表区域
            if (viewModel.viewMode == 'list') _buildListView(context, viewModel),

            // 顶部导航栏
            _buildHeader(context, viewModel),
            
            // 底部门店详情卡片 (Map模式下)
            if (viewModel.viewMode == 'map' && viewModel.selectedStore != null)
              _buildStoreCard(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(BuildContext context, NearbyStoresViewModel viewModel) {
    return FlutterMap(
      mapController: viewModel.mapController,
      options: MapOptions(
        initialCenter: viewModel.currentPosition,
        initialZoom: 13.0,
        minZoom: 10.0,
        maxZoom: 18.0,
        onTap: (_, __) => viewModel.clearSelection(),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.beijingauto.car_owner_app',
          tileBuilder: (context, widget, tile) {
            return ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.grey.withOpacity(0.3),
                BlendMode.saturation,
              ),
              child: widget,
            );
          },
        ),
        MarkerLayer(
          markers: viewModel.stores.map((store) {
            // 这里简化处理，给每个门店一个伪造的坐标偏差
            final isSelected = viewModel.selectedStore?.id == store.id;
            return Marker(
              point: viewModel.currentPosition, // 实际上应该有各自的坐标
              width: 80,
              height: 60,
              child: GestureDetector(
                onTap: () => viewModel.selectStore(store),
                child: _buildMarker(store, isSelected),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMarker(NearbyStore store, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF111111) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            isSelected ? LucideIcons.car : LucideIcons.mapPin,
            size: 18,
            color: isSelected ? Colors.white : const Color(0xFF111111),
          ),
        ),
      ],
    );
  }

  Widget _buildListView(BuildContext context, NearbyStoresViewModel viewModel) {
    return Container(
      color: const Color(0xFFF5F7FA),
      padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                const Text(
                  '全部门店',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${viewModel.stores.length})',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: viewModel.stores.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final store = viewModel.stores[index];
                return BaicBounceButton(
                  onPressed: () {
                    viewModel.selectStore(store);
                    viewModel.toggleViewMode();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 14,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                store.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111111),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF7ED),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.navigation, size: 10, color: Color(0xFFFF6B00)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${store.distance} km',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF6B00),
                                      fontFamily: 'Oswald',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          store.address,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                _buildTag('官方认证'),
                                const SizedBox(width: 8),
                                _buildTag('维修保养'),
                              ],
                            ),
                            const Row(
                              children: [
                                Text('详情', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                Icon(Icons.chevron_right, size: 14, color: Colors.grey),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF), fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, NearbyStoresViewModel viewModel) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 54, 20, 12),
        child: Row(
          children: [
            BaicBounceButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(LucideIcons.arrowLeft, size: 22, color: Color(0xFF111111)),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                BaicBounceButton(
                  onPressed: () => viewModel.toggleViewMode(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      viewModel.viewMode == 'map' ? LucideIcons.list : LucideIcons.compass,
                      size: 20,
                      color: const Color(0xFF111111),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                BaicBounceButton(
                  onPressed: () {},
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(LucideIcons.search, size: 20, color: Color(0xFF111111)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreCard(BuildContext context, NearbyStoresViewModel viewModel) {
    final store = viewModel.selectedStore!;
    
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 40,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 6,
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                store.name,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111111),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(LucideIcons.clock, size: 12, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  const Text('09:00 - 18:00', style: TextStyle(fontSize: 13, color: Colors.grey)),
                                  const SizedBox(width: 8),
                                  const Text('|', style: TextStyle(color: Color(0xFFE5E7EB))),
                                  const SizedBox(width: 8),
                                  const Icon(LucideIcons.star, size: 12, color: Color(0xFFFFB800)),
                                  const SizedBox(width: 4),
                                  Text('${store.rating}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${store.distance}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Oswald',
                                height: 1.0,
                              ),
                            ),
                            const Text(
                              'KM',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF9CA3AF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildTag('官方认证'),
                        const SizedBox(width: 8),
                        _buildTag('维修保养'),
                        const SizedBox(width: 8),
                        _buildTag('新车销售'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF3F4F6)),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.mapPin, size: 16, color: Color(0xFF9CA3AF)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              store.address,
                              style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563), fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: BaicBounceButton(
                            onPressed: () => viewModel.handleCall(store),
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFE5E7EB)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.phone, size: 18, color: Color(0xFF111111)),
                                  SizedBox(width: 8),
                                  Text('致电', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: BaicBounceButton(
                            onPressed: () => viewModel.handleNavigate(store),
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFF111827),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.navigation, size: 18, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('导航前往', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                ],
                              ),
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
      ),
    );
  }
}
