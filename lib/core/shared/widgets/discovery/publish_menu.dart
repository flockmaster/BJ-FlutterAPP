import 'package:flutter/material.dart';

class PublishMenu extends StatelessWidget {
  final Function(String) onSelect;
  final VoidCallback onClose;

  const PublishMenu({super.key, required this.onSelect, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'name': '动态', 'icon': Icons.camera_alt_outlined},
      {'name': '文章', 'icon': Icons.edit_note},
      {'name': '视频', 'icon': Icons.videocam_outlined},
      {'name': '扫一扫', 'icon': Icons.qr_code_scanner},
    ];

    return Stack(
      children: [
        // Transparent backdrop to close menu
        GestureDetector(
          onTap: onClose,
          behavior: HitTestBehavior.opaque,
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        
        // Menu Dropdown
        Positioned(
          top: MediaQuery.of(context).padding.top + 60, // Align with header height roughly
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Little triangle pointer if possible, skipping for simplicity
                  ...items.map((item) {
                     int idx = items.indexOf(item);
                     return InkWell(
                        onTap: () => onSelect(item['name'] as String),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: idx != items.length - 1 
                                ? const Border(bottom: BorderSide(color: Color(0xFFF5F5F5))) 
                                : null,
                          ),
                          child: Row(
                            children: [
                              Icon(item['icon'] as IconData, size: 20, color: const Color(0xFF1A1A1A)),
                              const SizedBox(width: 12),
                              Text(
                                item['name'] as String,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF333333),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                     );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
