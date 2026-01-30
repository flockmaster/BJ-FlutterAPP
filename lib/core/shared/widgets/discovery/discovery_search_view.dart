import 'package:flutter/material.dart';

class DiscoverySearchView extends StatefulWidget {
  final Function(String) onSearch;

  const DiscoverySearchView({super.key, required this.onSearch});

  @override
  State<DiscoverySearchView> createState() => _DiscoverySearchViewState();
}

class _DiscoverySearchViewState extends State<DiscoverySearchView> {
  final TextEditingController _controller = TextEditingController();
  List<String> history = ['露营最佳地点', '坦克300改装', '318川藏线']; // Mock History

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Simple and crude spacing as requested to avoid Dynamic Island
          // Using a conditional check to ensure we have enough space even if padding.top is 0
          SizedBox(height: (MediaQuery.of(context).padding.top > 20 ? MediaQuery.of(context).padding.top : 44) + 20),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (val) {
                        if (val.isNotEmpty) widget.onSearch(val);
                      },
                      decoration: const InputDecoration(
                        hintText: '搜索感兴趣的内容',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消', style: TextStyle(color: Color(0xFF1A1A1A))),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // History
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('历史搜索', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                      onPressed: () => setState(() => history.clear()),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: history.map((item) {
                    return GestureDetector(
                      onTap: () => widget.onSearch(item),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(item, style: const TextStyle(fontSize: 14, color: Color(0xFF333333))),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
