import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'publish_viewmodel.dart';

/// [PublishView] - 社区动态发布编辑器
/// 
/// 核心特性：多行弹性文本域、Grid 网格媒体选择器、以及置底防抖发布 Bar。
class PublishView extends StackedView<PublishViewModel> {
  final Map<String, dynamic> userProfile;

  const PublishView({super.key, required this.userProfile});

  @override
  Widget builder(BuildContext context, PublishViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
      children: [
        // Custom Header with Dynamic Island Spacing
        Container(
          padding: EdgeInsets.only(
            top: (MediaQuery.of(context).padding.top > 20 ? MediaQuery.of(context).padding.top : 44) + 24,
            bottom: 10,
            left: 16,
            right: 16
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5), width: 0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('取消', style: TextStyle(color: Color(0xFF1A1A1A), fontSize: 16)),
              ),
              const Text('发布动态', style: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold, fontSize: 17)),
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: viewModel.canPublish ? () => _handlePublish(context, viewModel) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB4628),
                    disabledBackgroundColor: const Color(0xFFEB4628).withOpacity(0.5),
                    elevation: viewModel.canPublish ? 2 : 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: viewModel.isPublishing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('发布', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: userProfile['avatar'] != null 
                          ? NetworkImage(userProfile['avatar'] as String)
                          : const NetworkImage('https://api.dicebear.com/7.x/avataaars/svg?seed=CarOwner'),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      viewModel.userProfile?['nickname'] ?? '未设置昵称',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
    
                // Title
                TextField(
                  controller: viewModel.titleController,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                  decoration: const InputDecoration(
                    hintText: '填写标题会有更多赞哦~',
                    hintStyle: TextStyle(color: Color(0xFFCCCCCC), fontWeight: FontWeight.normal),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const Divider(color: Color(0xFFF5F5F5), thickness: 1),
                
                // Content
                TextField(
                  controller: viewModel.contentController,
                  maxLines: 8,
                  style: const TextStyle(fontSize: 16, height: 1.5, color: Color(0xFF1A1A1A)),
                  decoration: const InputDecoration(
                    hintText: '分享你的用车生活...',
                    hintStyle: TextStyle(color: Color(0xFFCCCCCC)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
    
                // Images
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: viewModel.images.length + 1,
                  itemBuilder: (context, index) {
                    if (index == viewModel.images.length) {
                      return GestureDetector(
                        onTap: viewModel.pickImages,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFEEEEEE), style: BorderStyle.none), // Dashed border needs CustomPaint or package, simple for now
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, color: Colors.grey, size: 28),
                              SizedBox(height: 4),
                              Text('添加图片', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    }
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(viewModel.images[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => viewModel.removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                              child: const Icon(Icons.close, color: Colors.white, size: 14),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
    
                const SizedBox(height: 32),
                
                // Options
                _buildOptionItem(Icons.location_on_outlined, '添加地点'),
                _buildOptionItem(Icons.tag, '添加话题'),
                _buildOptionItem(Icons.alternate_email, '提醒谁看'),
                
                // Extra bottom padding
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
      ),
    );
  }

  @override
  PublishViewModel viewModelBuilder(BuildContext context) => PublishViewModel();

  @override
  void onViewModelReady(PublishViewModel viewModel) {
    viewModel.init(userProfile);
  }

  Future<void> _handlePublish(BuildContext context, PublishViewModel viewModel) async {
    final success = await viewModel.handlePublish();
    if (success && context.mounted) {
      Navigator.pop(context, {
        'title': viewModel.titleController.text.trim(),
        'content': viewModel.contentController.text.trim(),
        'images': viewModel.images.map((e) => e.path).toList(),
        'user': viewModel.userProfile,
      });
    }
  }

  Widget _buildOptionItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1A1A1A)),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A1A))),
          const Spacer(),
          const Icon(Icons.chevron_right, size: 20, color: Color(0xFFCCCCCC)),
        ],
      ),
    );
  }
}