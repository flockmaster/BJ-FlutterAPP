import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' hide SkeletonLoader;
import 'package:lucide_icons/lucide_icons.dart';
import 'task_center_viewmodel.dart';
import '../../../core/services/task_service.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/skeleton_loader.dart';

/// [TaskCenterView] - 任务中心（会员积分与权益仪表盘）
/// 
/// 视觉特性：
/// 1. 沉浸式深色 Header：营造高级会员感，突出积分与礼包奖励。
/// 2. 楼层化展示：清晰划分“每日任务”与“成长任务”两个业务板块。
/// 3. 复用任务组件：状态化的 [TaskItem] 渲染，提供清晰的进度导向。
class TaskCenterView extends StackedView<TaskCenterViewModel> {
  const TaskCenterView({super.key});

  @override
  Widget builder(BuildContext context, TaskCenterViewModel viewModel, Widget? child) {
    if (viewModel.isBusy) {
      return const _SkeletonView();
    }
    
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              // Header Banner
              _buildHeader(context, viewModel),
              
              // Scrollable Content
              Expanded(
                child: _buildContent(viewModel),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建品牌感 Header：采用深色渐变与圆形 Gift 图标营造任务氛围
  Widget _buildHeader(BuildContext context, TaskCenterViewModel viewModel) {
    return Container(
      height: 240,
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A1A1A),
              const Color(0xFF333333).withOpacity(0.9),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Content
            Padding(
              padding: const EdgeInsets.only(top: 54, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: viewModel.goBack,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          LucideIcons.arrowLeft,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Title and Gift Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '任务中心',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '完成任务 赢取丰厚好礼',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFB3B3B3),
                            ),
                          ),
                        ],
                      ),
                      // Animated Gift Icon
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          LucideIcons.gift,
                          color: Color(0xFFFF6B00),
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Rounded Bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(TaskCenterViewModel viewModel) {
    return Container(
      color: const Color(0xFFF5F7FA),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
        child: Column(
          children: [
            // Daily Tasks Section
            _buildTaskSection(
              title: '每日任务',
              accentColor: const Color(0xFFFF6B00),
              tasks: viewModel.dailyTasks,
              onTaskTap: viewModel.handleTaskAction,
            ),
            
            const SizedBox(height: 20),
            
            // Growth Tasks Section
            _buildTaskSection(
              title: '成长任务',
              accentColor: const Color(0xFF111111),
              tasks: viewModel.growthTasks,
              onTaskTap: viewModel.handleTaskAction,
            ),
          ],
        ),
      ),
    );
  }

  /// 通用任务楼层构建器：整合标题标识与任务列表项
  Widget _buildTaskSection({
    required String title,
    required Color accentColor,
    required List<TaskItem> tasks,
    required Function(TaskItem) onTaskTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Tasks List
          ...tasks.asMap().entries.map((entry) {
            final index = entry.key;
            final task = entry.value;
            return Column(
              children: [
                if (index > 0) const SizedBox(height: 24),
                _buildTaskItem(task, onTaskTap),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTaskItem(TaskItem task, Function(TaskItem) onTap) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Task Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                task.description,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Reward and Action
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Reward Points
            Text(
              '+${task.reward} 积分',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6B00),
                fontFamily: 'Oswald',
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Action Button
            GestureDetector(
              onTap: () => onTap(task),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: _getButtonColor(task.status),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: task.status == TaskStatus.todo
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (task.status == TaskStatus.done)
                      const Icon(
                        LucideIcons.checkCircle2,
                        size: 12,
                        color: Color(0xFF999999),
                      ),
                    if (task.status == TaskStatus.done) const SizedBox(width: 4),
                    Text(
                      _getButtonText(task.status),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _getButtonTextColor(task.status),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getButtonColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.done:
        return const Color(0xFFF5F5F5);
      case TaskStatus.locked:
        return const Color(0xFFF9F9F9);
      case TaskStatus.todo:
        return const Color(0xFF111111);
    }
  }

  Color _getButtonTextColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.done:
        return const Color(0xFF999999);
      case TaskStatus.locked:
        return const Color(0xFFCCCCCC);
      case TaskStatus.todo:
        return Colors.white;
    }
  }

  String _getButtonText(TaskStatus status) {
    switch (status) {
      case TaskStatus.done:
        return '已完成';
      case TaskStatus.locked:
        return '未解锁';
      case TaskStatus.todo:
        return '去完成';
    }
  }

  @override
  TaskCenterViewModel viewModelBuilder(BuildContext context) => TaskCenterViewModel();

  @override
  void onViewModelReady(TaskCenterViewModel viewModel) => viewModel.init();
}

class _SkeletonView extends StatelessWidget {
  const _SkeletonView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SkeletonLoader(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Skeleton
              Container(
                height: 240,
                color: const Color(0xFF111111),
                child: Padding(
                  padding: const EdgeInsets.only(top: 54, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SkeletonCircle(size: 36),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SkeletonBox(width: 150, height: 32),
                              SizedBox(height: 8),
                              SkeletonBox(width: 200, height: 16),
                            ],
                          ),
                          const SkeletonCircle(size: 64),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Tasks List Skeleton
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                     // 每日任务
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           // Section Title
                          const SkeletonBox(width: 100, height: 20),
                          const SizedBox(height: 24),
                          
                          // Task Items
                          ...List.generate(2, (index) => Column(
                            children: [
                              if (index > 0) const SizedBox(height: 24),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        SkeletonBox(width: 120, height: 20),
                                        SizedBox(height: 8),
                                        SkeletonBox(width: 180, height: 14),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: const [
                                      SkeletonBox(width: 60, height: 16),
                                      SizedBox(height: 8),
                                      SkeletonBox(width: 70, height: 28, borderRadius: BorderRadius.all(Radius.circular(14))),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // 成长任务
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           // Section Title
                          const SkeletonBox(width: 100, height: 20),
                          const SizedBox(height: 24),
                          
                          // Task Items
                          ...List.generate(3, (index) => Column(
                            children: [
                              if (index > 0) const SizedBox(height: 24),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        SkeletonBox(width: 140, height: 20),
                                        SizedBox(height: 8),
                                        SkeletonBox(width: 200, height: 14),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: const [
                                      SkeletonBox(width: 60, height: 16),
                                      SizedBox(height: 8),
                                      SkeletonBox(width: 70, height: 28, borderRadius: BorderRadius.all(Radius.circular(14))),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )),
                        ],
                      ),
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
