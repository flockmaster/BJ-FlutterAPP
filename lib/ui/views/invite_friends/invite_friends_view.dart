import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'invite_friends_viewmodel.dart';
import '../../../core/models/invite_models.dart';

class InviteFriendsView extends StackedView<InviteFriendsViewModel> {
  const InviteFriendsView({super.key});

  @override
  Widget builder(BuildContext context, InviteFriendsViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Stack(
        children: [
          // Scrollable Content
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                viewModel.updateScrollOffset(notification.metrics.pixels);
              }
              return false;
            },
            child: CustomScrollView(
              slivers: [
                // Header Section
                SliverToBoxAdapter(
                  child: _buildHeader(context, viewModel),
                ),
                
                // Content Section (邀请记录)
                SliverToBoxAdapter(
                  child: _buildContent(viewModel),
                ),
              ],
            ),
          ),
          
          // Fixed Navigation Bar with scroll effect
          _buildFixedNavBar(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, InviteFriendsViewModel viewModel) {
    return Container(
      // Add top padding for the fixed nav bar
      padding: const EdgeInsets.only(top: 88),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFF6B00),
            const Color(0xFFFF8E53),
            const Color(0xFFF5F7FA).withOpacity(0.9),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative Circles
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: -50,
            child: Container(
              width: 192,
              height: 192,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                
                // Promo Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    '🎉 限时活动：奖励翻倍',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Main Title
                const Text(
                  '邀请好友加入\n赢取海量积分',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Subtitle
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(text: '每成功邀请 1 位好友注册，双方各得 '),
                      TextSpan(
                        text: '500',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFD700),
                          fontFamily: 'Oswald',
                        ),
                      ),
                      TextSpan(text: ' 积分'),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Main Action Card
                _buildActionCard(context, viewModel),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedNavBar(BuildContext context, InviteFriendsViewModel viewModel) {
    // Calculate opacity based on scroll offset
    final scrollOffset = viewModel.scrollOffset;
    final opacity = (scrollOffset / 100).clamp(0.0, 1.0);
    
    // Interpolate colors
    final backgroundColor = Color.lerp(
      Colors.transparent,
      Colors.white,
      opacity,
    )!;
    
    final textColor = Color.lerp(
      Colors.white,
      const Color(0xFF111111),
      opacity,
    )!;
    
    final iconColor = Color.lerp(
      Colors.white,
      const Color(0xFF111111),
      opacity,
    )!;
    
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: Colors.black.withOpacity(0.05 * opacity),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: viewModel.goBack,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: opacity > 0.5
                          ? const Color(0xFFF5F5F5)
                          : Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      LucideIcons.arrowLeft,
                      color: iconColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '邀请有礼',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, InviteFriendsViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Gift Icon Badge
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFD700), Color(0xFFFF6B00)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B00).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              LucideIcons.gift,
              color: Colors.white,
              size: 24,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Invite Code Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7E6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFFE4B5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '我的邀请码',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B4513),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      viewModel.inviteCode,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6B00),
                        fontFamily: 'Oswald',
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => viewModel.copyInviteCode(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.copy,
                          size: 12,
                          color: Color(0xFFFF6B00),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '复制',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B00),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Main Invite Button
          GestureDetector(
            onTap: viewModel.handleInvite,
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '立即邀请好友',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Share Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildShareButton(
                icon: LucideIcons.messageCircle,
                label: '微信',
                color: const Color(0xFF10B981),
                onTap: () => viewModel.shareToWeChat(),
              ),
              _buildShareButton(
                icon: LucideIcons.users,
                label: '朋友圈',
                color: const Color(0xFF3B82F6),
                onTap: () => viewModel.shareToMoments(),
              ),
              _buildShareButton(
                icon: LucideIcons.share2,
                label: '更多',
                color: const Color(0xFF6B7280),
                onTap: () => viewModel.shareMore(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(InviteFriendsViewModel viewModel) {
    return Container(
      color: const Color(0xFFF5F7FA),
      padding: const EdgeInsets.all(20),
      child: Container(
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
          mainAxisSize: MainAxisSize.min,
          children: [
            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '邀请记录',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                    children: [
                      const TextSpan(text: '已邀请 '),
                      TextSpan(
                        text: '${viewModel.successfulInvites}',
                        style: const TextStyle(
                          color: Color(0xFFFF6B00),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' 人'),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Invite List
            if (viewModel.inviteList.isEmpty)
              _buildEmptyState()
            else
              ...viewModel.inviteList.asMap().entries.map((entry) {
                final index = entry.key;
                final invite = entry.value;
                return Column(
                  children: [
                    if (index > 0) const SizedBox(height: 24),
                    _buildInviteItem(invite),
                  ],
                );
              }),
            
            const SizedBox(height: 32),
            
            // Rules Section
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
            
            const SizedBox(height: 24),
            
            Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '活动规则',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Rules List
            ..._buildRulesList(),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            LucideIcons.users,
            size: 48,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            '还没有邀请记录',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '快去邀请好友加入吧',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInviteItem(InviteRecord invite) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
            image: invite.avatar != null
                ? DecorationImage(
                    image: NetworkImage(invite.avatar!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: invite.avatar == null
              ? const Icon(
                  LucideIcons.user,
                  size: 20,
                  color: Color(0xFF9CA3AF),
                )
              : null,
        ),
        
        const SizedBox(width: 12),
        
        // User Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                invite.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                invite.date,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
        
        // Status and Reward
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              invite.status == InviteStatus.success
                  ? '+${invite.reward}'
                  : '审核中',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: invite.status == InviteStatus.success
                    ? const Color(0xFFFF6B00)
                    : const Color(0xFFD1D5DB),
                fontFamily: invite.status == InviteStatus.success ? 'Oswald' : null,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              invite.status == InviteStatus.success ? '邀请成功' : '等待注册',
              style: TextStyle(
                fontSize: 10,
                color: invite.status == InviteStatus.success
                    ? const Color(0xFF10B981)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildRulesList() {
    final rules = [
      '被邀请人需从未注册过北京汽车APP。',
      '被邀请人完成车辆认证后，双方可获得额外奖励。',
      '积分将于被邀请人注册成功后 24 小时内到账。',
      '如发现违规刷分行为，平台有权取消奖励资格。',
    ];
    
    return rules.map((rule) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 4,
              margin: const EdgeInsets.only(top: 6, right: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF9CA3AF),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                rule,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  InviteFriendsViewModel viewModelBuilder(BuildContext context) => InviteFriendsViewModel();

  @override
  void onViewModelReady(InviteFriendsViewModel viewModel) => viewModel.init();
}
