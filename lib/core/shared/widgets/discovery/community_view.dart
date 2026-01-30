
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:car_owner_app/core/theme/app_colors.dart';
import 'package:car_owner_app/core/theme/app_typography.dart';
import 'package:car_owner_app/core/base/base_state.dart';
import 'package:car_owner_app/core/extensions/context_extensions.dart';
import 'package:car_owner_app/ui/views/discovery/discovery_viewmodel.dart';
import 'package:car_owner_app/core/models/discovery_models.dart';
import 'package:car_owner_app/app/routes.dart';
import 'package:car_owner_app/app/app.router.dart';
import 'social_post_card.dart';

class CommunityView extends StatefulWidget {
  final TabController tabController;
  final List<String> tabs;
  final DiscoveryViewModel? viewModel;

  const CommunityView({
    super.key,
    required this.tabController,
    required this.tabs,
    this.viewModel,
  });

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.bgSurface,
          ),
          child: TabBar(
            controller: widget.tabController,
            isScrollable: true,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.textTitle,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: AppTypography.bodyPrimary.copyWith(fontWeight: FontWeight.bold),
            unselectedLabelStyle: AppTypography.bodyPrimary,
            indicator: const BoxDecoration(color: Colors.transparent),
            dividerColor: Colors.transparent,
            labelPadding: const EdgeInsets.symmetric(horizontal: 12),
            tabs: widget.tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: widget.tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: widget.tabs.map((tab) => _buildFeedContent(tab)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedContent(String tabName) {
    final viewModel = widget.viewModel;
    if (viewModel == null) {
      return const Center(child: Text('数据加载中...', style: TextStyle(color: Colors.grey)));
    }

    if (viewModel.state == ViewState.loading && viewModel.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.brandOrange));
    }

    if (viewModel.state == ViewState.error && viewModel.isEmpty) {
      return Center(child: Text('加载失败: ${viewModel.modelError}', style: AppTypography.bodySecondary.copyWith(color: AppColors.error)));
    }

    List<DiscoveryItem> items;
    if (tabName == '推荐') {
      items = viewModel.items;
    } else if (tabName == '关注') {
      items = viewModel.followItems;
    } else {
      items = viewModel.getModelFeed(tabName);
    }

    if (items.isEmpty) {
      return Center(child: Text('暂无内容', style: AppTypography.bodySecondary.copyWith(color: AppColors.textTertiary)));
    }

    return EasyRefresh(
      onRefresh: () => viewModel.refresh(),
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
        key: PageStorageKey<String>(tabName), // Preserve scroll position
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = items[index];
                  return SocialPostCard(
                    item: item,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pushNamed(
                        Routes.discoveryDetailView,
                        arguments: DiscoveryDetailViewArguments(itemId: item.id),
                      );
                    },
                  );
                },
                childCount: items.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}
