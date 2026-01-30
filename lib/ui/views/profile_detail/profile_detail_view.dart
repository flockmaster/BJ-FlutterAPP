import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'profile_detail_viewmodel.dart';
import 'medal_detail_view.dart';
import 'medal_widget.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/components/baic_ui_kit.dart';
import 'package:car_owner_app/core/shared/widgets/optimized_image.dart';
import '../my_posts/my_posts_view.dart';
import '../my_favorites/my_favorites_view.dart';

/// 个人中心详情页 - BAIC V4.0 全新重构修复版
class ProfileDetailView extends StackedView<ProfileDetailViewModel> {
  const ProfileDetailView({super.key});

  @override
  Widget builder(BuildContext context, ProfileDetailViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: _ProfileDetailBody(viewModel: viewModel),
    );
  }

  @override
  ProfileDetailViewModel viewModelBuilder(BuildContext context) => ProfileDetailViewModel();

  @override
  void onViewModelReady(ProfileDetailViewModel viewModel) => viewModel.init();
}

class _ProfileDetailBody extends StatefulWidget {
  final ProfileDetailViewModel viewModel;
  const _ProfileDetailBody({required this.viewModel});

  @override
  State<_ProfileDetailBody> createState() => _ProfileDetailBodyState();
}

class _ProfileDetailBodyState extends State<_ProfileDetailBody> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? _selectedMedal;
  final ScrollController _scrollController = ScrollController();
  double _headerOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
    setState(() {
      _headerOpacity = (offset / 150).clamp(0.0, 1.0);
    });
  }

  void _showMedalDetail(Map<String, dynamic> medal) {
    setState(() => _selectedMedal = medal);
  }

  void _hideMedalDetail() {
    setState(() => _selectedMedal = null);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Stack(
        children: [
          // 垂直布局：固定头 + 内容区
          Column(
            children: [
              _buildHeaderSection(),      // 固定：封面 + 用户卡片
              _buildTabBar(),             // 固定：选项卡
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPostsGrid(widget.viewModel.posts),
                    _buildPostsGrid(widget.viewModel.posts, isLiked: true),
                    _buildMedalsTab(),
                  ],
                ),
              ),
            ],
          ),
          
          // 顶部常驻操作按钮 (返回/分享等)
          _buildFixedTopBar(),

          if (_selectedMedal != null)
            Positioned.fill(
              child: MedalDetailView(
                medal: _selectedMedal!,
                isWorn: widget.viewModel.wornMedalId == _selectedMedal!['id'],
                onBack: _hideMedalDetail,
                onWear: (id) => widget.viewModel.updateWornMedal(id),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1. 封面背景 (底层)
        Container(
          height: 240, // 略微减小高度，更紧凑
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              OptimizedImage(
                imageUrl: widget.viewModel.coverImage,
                fit: BoxFit.cover,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                      Colors.black.withOpacity(0.35),
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // 2. 用户信息卡片 (顶层，向上偏移)
        Padding(
          padding: const EdgeInsets.only(top: 200), // 卡片向上提
          child: _buildUserInfoSection(),
        ),
      ],
    );
  }

  Widget _buildFixedTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                const SizedBox(width: 20),
                _buildCircularButton(
                  icon: LucideIcons.arrowLeft,
                  onPressed: () => widget.viewModel.goBack(),
                ),
                const Spacer(),
                _buildCircularButton(
                  icon: LucideIcons.share2,
                  onPressed: widget.viewModel.handleShare,
                ),
                const SizedBox(width: 12),
                _buildCircularButton(
                  icon: LucideIcons.moreHorizontal,
                  onPressed: widget.viewModel.handleMore,
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton({required IconData icon, required VoidCallback onPressed}) {
    return BaicBounceButton(
      onPressed: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCanvas,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)), // 略微调小圆角
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 卡片内容容器
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 0), // 减小顶部留白 (头像变小了)
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // 紧凑
              children: [
                // 姓名与 ID
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.viewModel.displayName,
                      style: AppTypography.headingL.copyWith(
                        color: AppColors.textTitle,
                        fontSize: 24, // 略微减小字号以适应更紧凑布局
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        'ID: ${widget.viewModel.userId}',
                        style: AppTypography.captionPrimary.copyWith(
                          color: AppColors.textTertiary,
                          fontFamily: 'Oswald',
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // 地址与签名
                Row(
                  children: [
                    Icon(LucideIcons.mapPin, size: 12, color: AppColors.textDisabled),
                    const SizedBox(width: 4),
                    Text(
                      widget.viewModel.location,
                      style: AppTypography.captionPrimary.copyWith(color: AppColors.textTertiary, fontSize: 12),
                    ),
                    const SizedBox(width: 10),
                    Container(width: 1, height: 10, color: AppColors.divider),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '“ 热爱越野，热爱生活。”',
                        style: AppTypography.bodySecondary.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // 统计数据
                _buildStatsRow(),
                const SizedBox(height: 16), // 底部间距
              ],
            ),
          ),
          
          // 绝对定位：头像 (尺寸减小至 88)
          Positioned(
            top: -44,
            left: 24,
            child: _buildAvatar(),
          ),
          
          // 绝对定位：编辑资料按钮
          Positioned(
            top: 10,
            right: 24,
            child: _buildEditButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 88, // 尺寸减小
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipOval(
            child: OptimizedImage(
              imageUrl: widget.viewModel.avatarUrl,
              width: 88,
              height: 88,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: -2,
          right: -4,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: MedalWidget(
              id: widget.viewModel.wornMedalId ?? 1,
              size: 22, // 对应减小徽章尺寸
            ),
          ),
        ),
        Positioned(
          bottom: -6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.checkCircle2, color: AppColors.brandGold, size: 8),
                const SizedBox(width: 2),
                Text(
                  'BJ40车主',
                  style: TextStyle(
                    color: AppColors.brandGold,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    return BaicBounceButton(
      onPressed: widget.viewModel.handleEditProfile,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '编辑资料',
          style: AppTypography.button.copyWith(
            fontWeight: FontWeight.w900, 
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildStatItem(widget.viewModel.followingCount, '关注'),
        const SizedBox(width: 48),
        _buildStatItem(widget.viewModel.followersCount, '粉丝'),
        const SizedBox(width: 48),
        _buildStatItem(widget.viewModel.likesCount, '获赞'),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value,
          style: AppTypography.dataDisplayM.copyWith(
            color: AppColors.textTitle,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            fontFamily: 'Oswald',
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.captionSecondary.copyWith(
            color: AppColors.textTertiary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }



  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 52, // 减小高度更紧凑
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.brandBlack,
              unselectedLabelColor: AppColors.textTertiary,
              labelStyle: AppTypography.bodyPrimary.copyWith(fontWeight: FontWeight.w900, fontSize: 15),
              unselectedLabelStyle: AppTypography.bodyPrimary.copyWith(fontSize: 15),
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.transparent,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(color: AppColors.brandBlack, width: 4),
                insets: EdgeInsets.only(bottom: 8),
              ),
              tabs: const [
                Tab(child: Text('发布')),
                Tab(child: Text('点赞')),
                Tab(child: Text('勋章')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsGrid(List<Map<String, dynamic>> posts, {bool isLiked = false}) {
    if (posts.isEmpty) {
      return _buildEmptyState('此处尚无内容', LucideIcons.ghost);
    }
    return Container(
      color: Colors.white,
      child: MasonryGridView.count(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          // 模拟原型中的非对称布局：第一项显示得更“重要”一点
          // 在瀑布流中，我们简单地让第一项更高，或者维持 MasonryGridView 的自然流向
          return _buildPostCard(posts[index], isLiked: isLiked, isLarge: index == 0);
        },
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post, {bool isLiked = false, bool isLarge = false}) {
    final hasImage = post['image'] != null && post['image'].toString().isNotEmpty;
    
    return BaicBounceButton(
      onPressed: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider.withOpacity(0.3), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImage)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: isLarge ? 0.8 : 1.2,
                  child: OptimizedImage(
                    imageUrl: post['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['content'] ?? '',
                    style: AppTypography.bodyPrimary.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.textTitle,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ClipOval(
                        child: OptimizedImage(
                          imageUrl: post['user']?['avatar'] ?? '',
                          width: 18,
                          height: 18,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          post['user']?['name'] ?? '',
                          style: AppTypography.captionPrimary.copyWith(
                            fontSize: 10,
                            color: AppColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        LucideIcons.heart,
                        size: 10,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post['likes'] ?? 0}',
                        style: AppTypography.captionPrimary.copyWith(
                          fontSize: 10,
                          color: AppColors.textTertiary,
                          fontFamily: 'Oswald',
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
    );
  }

  Widget _buildMedalsTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), // 增加垂直内边距
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '已点亮荣誉',
              style: AppTypography.headingS.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '3 枚',
              style: AppTypography.dataDisplayS.copyWith(
                color: AppColors.textTertiary,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12), // 增加标题到内容的间距
        _buildMedalGrid(unlocked: true),
        const SizedBox(height: 24), // 增加两个版块之间的间距
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '待解锁荣誉',
              style: AppTypography.headingS.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textTitle.withOpacity(0.5),
              ),
            ),
            Text(
              '3 枚',
              style: AppTypography.dataDisplayS.copyWith(
                color: AppColors.textTertiary,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12), // 增加标题到内容的间距
        _buildMedalGrid(unlocked: false),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMedalGrid({required bool unlocked}) {
    final medals = unlocked
        ? [
            {'id': 1, 'name': '持之以恒', 'date': '2025.03.01', 'desc': '累计登录北京汽车 App 1天'},
            {'id': 2, 'name': '越野新秀', 'date': '2023.06.20', 'desc': '完成首台北京汽车车辆绑定'},
            {'id': 3, 'name': '活跃达人', 'date': '2023.11.02', 'desc': '发布超过10条精选动态'},
          ]
        : [
            {'id': 4, 'name': '进藏英雄', 'task': '单次行驶里程超过3000公里', 'progress': '1200/3000'},
            {'id': 5, 'name': '阿拉善之星', 'task': '参与1次英雄会沙漠挑战', 'progress': '0/1'},
            {'id': 6, 'name': '金牌改装', 'task': '发布3条精华改装动态', 'progress': '1/3'},
          ];

    // 使用 Wrap 代替 GridView，让每个 item 根据内容自适应高度
    final itemWidth = (MediaQuery.of(context).size.width - 40 - 16) / 3; // 减去左右 padding 和间距
    
    return Wrap(
      spacing: 8,  // 水平间距
      runSpacing: 16, // 增加垂直行间距
      children: medals.map((medal) => SizedBox(
        width: itemWidth,
        child: _buildMedalItem(medal, unlocked: unlocked),
      )).toList(),
    );
  }

  Widget _buildMedalItem(Map<String, dynamic> medal, {required bool unlocked}) {
    final isWorn = unlocked && medal['id'] == widget.viewModel.wornMedalId;
    
    return BaicBounceButton(
      onPressed: () => _showMedalDetail(medal),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 紧凑布局
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              MedalWidget(
                id: medal['id'], 
                grayscale: !unlocked, 
                size: 64, // 恢复到较舒适的尺寸
              ),
              if (isWorn)
                Positioned(
                  bottom: -10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.brandBlack,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '佩戴中',
                      style: AppTypography.captionSecondary.copyWith(
                        color: AppColors.brandGold,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10), // 增加图标到名称的间距
          Text(
            medal['name'],
            textAlign: TextAlign.center,
            style: AppTypography.bodySecondary.copyWith(
              fontWeight: FontWeight.bold,
              color: unlocked ? AppColors.textTitle : AppColors.textDisabled,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4), // 增加名称到日期/进度的间距
          if (unlocked)
            Text(
              medal['date'],
              style: AppTypography.captionSecondary.copyWith(
                fontSize: 10,
                fontFamily: 'Oswald',
                color: AppColors.textTertiary,
              ),
            )
          else
            _buildProgressMini(medal['progress']),
        ],
      ),
    );
  }

  Widget _buildProgressMini(String? progress) {
    if (progress == null) return const SizedBox.shrink();
    final parts = progress.split('/');
    final val = (double.tryParse(parts[0]) ?? 0) / (double.tryParse(parts[1]) ?? 1);
    return Container(
      width: 36, // 略微缩小宽度
      height: 2.5, // 略微缩小高度
      margin: EdgeInsets.zero, // 移除上边距
      decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(1.5)),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: val.clamp(0.0, 1.0),
        child: Container(decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(1.5))),
      ),
    );
  }

  Widget _buildEmptyState(String msg, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: AppColors.divider),
          const SizedBox(height: 12),
          Text(msg, style: AppTypography.bodySecondary.copyWith(color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}
