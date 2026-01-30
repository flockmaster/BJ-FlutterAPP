import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../core/services/map_navigation_service.dart';

class MapSelectionSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const MapSelectionSheet({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget build(BuildContext context) {
    // request.customData expect: {'maps': List<MapApp>}
    final maps = request.customData is List<MapApp> ? (request.customData as List<MapApp>) : <MapApp>[];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicator
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                '选择导航应用',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ),
            
            // Map List
            if (maps.isEmpty)
              const Padding(
                 padding: EdgeInsets.all(20),
                 child: Text('未检测到可用的地图应用'),
              )
            else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: maps.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final map = maps[index];
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      map.icon,
                      color: const Color(0xFF111111),
                      size: 24,
                    ),
                  ),
                  title: Text(
                    map.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF111111),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFCCCCCC),
                  ),
                  onTap: () {
                    completer(SheetResponse(confirmed: true, data: map));
                  },
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Cancel Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: GestureDetector(
                onTap: () => completer(SheetResponse(confirmed: false)),
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      '取消',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
