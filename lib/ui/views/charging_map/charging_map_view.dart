import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:stacked/stacked.dart';
import 'dart:ui';
import 'charging_map_viewmodel.dart';
import '../../../core/models/charging_station.dart';

/// [ChargingMapView] - 集成地图交互的充电站查找页面
/// 
/// 该页面采用了 OpenStreetMap (OSM) 进行基础地图渲染，
/// 并包含：实时定位、站点筛选搜索、选中站点详情卡片等交互模块。
class ChargingMapView extends StatelessWidget {
  const ChargingMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChargingMapViewModel>.reactive(
      viewModelBuilder: () => ChargingMapViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) => Scaffold(
        body: Stack(
          children: [
            // 地图区域
            _buildMap(context, viewModel),
            
            // 顶部搜索栏
            _buildHeader(context, viewModel),
            
            // 底部充电站详情卡片
            if (viewModel.selectedStation != null)
              _buildStationCard(context, viewModel),
          ],
        ),
      ),
    );
  }

  /// 构建地图底层渲染逻辑，包含瓦片层、Marker 标记层以及用户定位层。
  Widget _buildMap(BuildContext context, ChargingMapViewModel viewModel) {
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
        // OpenStreetMap 瓦片层
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.beijingauto.car_owner_app',
          tileBuilder: (context, widget, tile) {
            return ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.grey.withValues(alpha: 0.3),
                BlendMode.saturation,
              ),
              child: widget,
            );
          },
        ),
        
        // 充电站标记层
        MarkerLayer(
          markers: viewModel.stations.map((station) {
            final isSelected = viewModel.selectedStation?.id == station.id;
            return Marker(
              point: station.position,
              width: 80,
              height: 60,
              child: GestureDetector(
                onTap: () => viewModel.selectStation(station),
                child: _buildMarker(station, isSelected),
              ),
            );
          }).toList(),
        ),
        
        // 用户位置标记
        MarkerLayer(
          markers: [
            Marker(
              point: viewModel.currentPosition,
              width: 40,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue,
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 绘制单个充电站在地图上的 Marker 图标。
  /// [isSelected]: 是否为当前选中站点，选中时会有放大与高亮效果。
  Widget _buildMarker(ChargingStation station, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(isSelected ? 1.1 : 1.0, isSelected ? 1.1 : 1.0, 1.0),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF111111) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.white : const Color(0xFFE5E7EB),
              width: isSelected ? 3 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isSelected ? 0.3 : 0.1),
                blurRadius: isSelected ? 12 : 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.zap,
                size: 13,
                color: isSelected ? const Color(0xFFFFD700) : const Color(0xFFFF6B00),
              ),
              const SizedBox(width: 4),
              Text(
                '¥${station.price.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Oswald',
                  color: isSelected ? Colors.white : const Color(0xFF111111),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  /// 构建页面浮动 Header，包含返回键、搜索框以及筛选入口。
  Widget _buildHeader(BuildContext context, ChargingMapViewModel viewModel) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 54, 20, 12),
        child: Row(
          children: [
            // 返回按钮
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.arrowLeft,
                  size: 22,
                  color: Color(0xFF111111),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // 搜索框
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        const Icon(
                          LucideIcons.search,
                          size: 18,
                          color: Color(0xFF9CA3AF),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: viewModel.searchController,
                            decoration: const InputDecoration(
                              hintText: '搜索充电站',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF9CA3AF),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // 筛选按钮
            GestureDetector(
              onTap: () => viewModel.showFilterDialog(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.filter,
                  size: 20,
                  color: Color(0xFF111111),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建底部悬浮的充电站详情信息卡片。
  /// 仅在用户于地图上选中某个 [ChargingStation] 时显示。
  Widget _buildStationCard(BuildContext context, ChargingMapViewModel viewModel) {
    final station = viewModel.selectedStation!;
    
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFFF3F4F6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 50,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 拖动指示器
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 24, bottom: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // 内容区域
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题和价格
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                station.name,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111111),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    '距离 ${station.distance.toStringAsFixed(1)}km',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF6B7280),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 12,
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    color: const Color(0xFFE5E7EB),
                                  ),
                                  if (station.isOfficial)
                                    const Text(
                                      '官方认证 · 对外开放',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFFFF6B00),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              station.price.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Oswald',
                                color: Color(0xFFFF6B00),
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '元 / 度',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9CA3AF),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // 充电桩信息
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFDCFCE7),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '快充',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF166534),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      '${station.fastChargers}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Oswald',
                                        color: Color(0xFF15803D),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      '空闲',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF166534),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFDBEAFE),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '慢充',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E40AF),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      '${station.slowChargers}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Oswald',
                                        color: Color(0xFF1D4ED8),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      '空闲',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E40AF),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // 操作按钮
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => viewModel.lowerLock(station),
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                  width: 1,
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.batteryCharging,
                                    size: 18,
                                    color: Color(0xFF111111),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '降地锁',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF111111),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => viewModel.navigateToStation(station),
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFF111827),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.navigation,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '导航前往',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
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
