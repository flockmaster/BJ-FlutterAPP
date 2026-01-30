import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'discovery_viewmodel.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'package:car_owner_app/core/shared/widgets/discovery/discovery_header.dart';
import 'package:car_owner_app/core/shared/widgets/discovery/community_view.dart';
import 'package:car_owner_app/core/shared/widgets/discovery/official_view.dart';
import 'package:car_owner_app/core/shared/widgets/discovery/go_wild_view.dart';
import 'package:car_owner_app/core/shared/widgets/discovery/qa_view.dart';
import 'package:car_owner_app/core/shared/widgets/discovery/discovery_search_view.dart';
import 'package:car_owner_app/core/shared/widgets/discovery/publish_menu.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/discovery_skeleton.dart';
import '../update_nickname/update_nickname_view.dart';
import '../publish/publish_view.dart';
import '../../../app/app.router.dart';

/// [DiscoveryView] - 发现页主视图容器
/// 
/// 采用了二级 Tab 架构：主 Tab (社区/官方/去野等) + 社区内部子 Tab (推荐/模型等)。
class DiscoveryView extends StackedView<DiscoveryViewModel> {
  const DiscoveryView({super.key});

  @override
  Widget builder(
    BuildContext context,
    DiscoveryViewModel viewModel,
    Widget? child,
  ) {
    return _DiscoveryViewContent(viewModel: viewModel);
  }

  @override
  DiscoveryViewModel viewModelBuilder(BuildContext context) => DiscoveryViewModel();

  @override
  void onViewModelReady(DiscoveryViewModel viewModel) {
    viewModel.init();
  }
}

/// 发现页的具体布局实现
class _DiscoveryViewContent extends StatefulWidget {
  final DiscoveryViewModel viewModel;
  const _DiscoveryViewContent({required this.viewModel});

  @override
  State<_DiscoveryViewContent> createState() => _DiscoveryViewContentState();
}

class _DiscoveryViewContentState extends State<_DiscoveryViewContent> with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _communityTabController;
  
  final List<String> _mainTabs = ['社区', '官方', '改装', '去野', '问答'];
  final List<String> _communityTabs = ['关注', '推荐', 'BJ30', 'BJ40', 'BJ60', 'BJ80'];
  
  // Mock User State
  Map<String, dynamic> _userProfile = {
    'nickname': '',
    'avatar': '',
    'isSet': false,
  };

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: _mainTabs.length, vsync: this);
    _communityTabController = TabController(length: _communityTabs.length, vsync: this, initialIndex: 1);
    
    _mainTabController.addListener(() {
      if (!_mainTabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _communityTabController.dispose();
    super.dispose();
  }

  /// 弹出全局搜索对话框
  void _onSearchTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true, 
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 1.0,
        minChildSize: 1.0,
        maxChildSize: 1.0,
        builder: (context, scrollController) => DiscoverySearchView(
          onSearch: (term) {
             Navigator.pop(context);
          },
        ),
      ),
    );
  }

  /// 弹出动态/视频发布快捷菜单
  void _onPublishTap() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.transparent, 
      pageBuilder: (context, anim1, anim2) {
        return PublishMenu(
          onClose: () => Navigator.pop(context),
          onSelect: (action) {
            Navigator.pop(context);
            _handlePublishAction(action);
          },
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );
  }

  void _handlePublishAction(String action) {
    if (action == '扫一扫') {
      return;
    }

    if (_userProfile['isSet'] == false) {
      _showUpdateNicknamePage();
    } else {
      if (action == '动态') {
        _showPublishPage();
      }
    }
  }

  /// 处理设置昵称及发布权限校验逻辑
  void _showUpdateNicknamePage() async {
    final nickname = await Navigator.of(context, rootNavigator: true).push<String>(
      MaterialPageRoute(
        builder: (context) => const UpdateNicknameView(),
      ),
    );

    if (nickname != null && nickname.isNotEmpty) {
      if (!mounted) return;
      setState(() {
        _userProfile = {
          'nickname': nickname,
          'avatar': 'https://api.dicebear.com/7.x/avataaars/svg?seed=$nickname',
          'isSet': true,
        };
      });
      
      // 昵称设置成功后，延迟一小会儿调起发布页，确保 UI 状态已同步
      Future.microtask(() {
        if (mounted) {
          _showPublishPage();
        }
      });
    }
  }

  /// 跳转至动态编写发布页面
  void _showPublishPage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 1.0,
        minChildSize: 1.0,
        maxChildSize: 1.0,
        builder: (context, scrollController) => PublishView(userProfile: _userProfile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    if (viewModel.isBusy) {
      return const Scaffold(
        backgroundColor: AppColors.bgCanvas,
        body: DiscoverySkeleton(),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Column(
        children: [
          DiscoveryHeader(
            tabController: _mainTabController,
            tabs: _mainTabs,
            onSearchTap: _onSearchTap,
            onPublishTap: _onPublishTap,
          ),
          
          Expanded(
            child: TabBarView(
              controller: _mainTabController,
              children: [
                CommunityView(
                  tabController: _communityTabController,
                  tabs: _communityTabs,
                  viewModel: viewModel,
                ),
                  OfficialView(
                    data: viewModel.officialData,
                    onRefresh: viewModel.onRefresh,
                    onItemTap: (item) {
                      Navigator.of(context, rootNavigator: true).pushNamed(
                        Routes.discoveryDetailView,
                        arguments: DiscoveryDetailViewArguments(itemId: item.id),
                      );
                    },
                  ),
                  _buildModificationPlaceholder(),
                  GoWildView(
                    data: viewModel.goWildData,
                    onRefresh: viewModel.onRefresh,
                    onItemTap: (item) {
                      Navigator.of(context, rootNavigator: true).pushNamed(
                        Routes.discoveryDetailView,
                        arguments: DiscoveryDetailViewArguments(itemId: item.id),
                      );
                    },
                  ),
                  const QAView(),
                ],
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildModificationPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              color: AppColors.bgFill,
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.hammer, size: 40, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 24),
          Text(
            '改装板块建设中', 
            style: AppTypography.headingM.copyWith(color: AppColors.textTitle),
          ),
          const SizedBox(height: 8),
          Text(
            '更多硬核改装方案即将上线，敬请期待', 
            style: AppTypography.bodySecondary.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
