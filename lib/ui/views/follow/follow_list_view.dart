import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'follow_list_viewmodel.dart';
import '../../../core/models/follow_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/components/baic_ui_kit.dart';

/// 关注/粉丝列表页面 - BAIC V4.0 重构
class FollowListView extends StackedView<FollowListViewModel> {
  final String type;

  const FollowListView({super.key, this.type = 'following'});

  @override
  Widget builder(BuildContext context, FollowListViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Column(
        children: [
          _buildHeader(context, viewModel),
          Expanded(
            child: viewModel.isBusy
                ? _buildSkeletonLoader()
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceL,
                      vertical: AppDimensions.spaceM,
                    ),
                    itemCount: viewModel.users.length + 1,
                    itemBuilder: (context, index) {
                      if (index == viewModel.users.length) {
                        return _buildEndIndicator();
                      }
                      return _buildUserItem(viewModel.users[index], viewModel);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, FollowListViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppDimensions.spaceM,
            AppDimensions.spaceS,
            AppDimensions.spaceM,
            AppDimensions.spaceM,
          ),
          child: Row(
            children: [
              BaicBounceButton(
                onPressed: () => viewModel.goBack(),
                child: Container(
                  width: AppDimensions.topNavHeight,
                  height: AppDimensions.topNavHeight,
                  alignment: Alignment.centerLeft,
                  child: const Icon(
                    LucideIcons.arrowLeft,
                    size: AppDimensions.iconL,
                    color: AppColors.brandBlack,
                  ),
                ),
              ),
              AppDimensions.spaceS.horizontalSpace,
              Text(
                viewModel.title,
                style: AppTypography.headingS.copyWith(
                  color: AppColors.brandBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      padding: AppDimensions.paddingL,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: AppDimensions.spaceM),
          padding: AppDimensions.paddingM,
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: AppDimensions.borderRadiusM,
          ),
          child: Row(
            children: [
              const BaicSkeleton(
                width: AppDimensions.avatarM,
                height: AppDimensions.avatarM,
                radius: AppDimensions.avatarM / 2,
              ),
              AppDimensions.spaceM.horizontalSpace,
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaicSkeleton(width: 100, height: 16),
                    SizedBox(height: 8),
                    BaicSkeleton(width: 160, height: 12),
                  ],
                ),
              ),
              AppDimensions.spaceM.horizontalSpace,
              const BaicSkeleton(
                width: 72,
                height: AppDimensions.buttonHeightS,
                radius: AppDimensions.buttonHeightS / 2,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserItem(FollowUser user, FollowListViewModel viewModel) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: AppDimensions.borderRadiusM,
        boxShadow: AppDimensions.shadowL1,
      ),
      child: BaicBounceButton(
        onPressed: () {
          HapticFeedback.selectionClick();
          // Navigate to user profile
        },
        child: Padding(
          padding: AppDimensions.paddingM,
          child: Row(
            children: [
              Container(
                width: AppDimensions.avatarM + 4,
                height: AppDimensions.avatarM + 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.bgCanvas, width: 2),
                  image: DecorationImage(
                    image: NetworkImage(user.avatar),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              AppDimensions.spaceM.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: AppTypography.bodyPrimary.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textTitle,
                      ),
                    ),
                    AppDimensions.spaceBase.verticalSpace,
                    Text(
                      user.bio,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.captionSecondary.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              AppDimensions.spaceM.horizontalSpace,
              _buildFollowButton(user, viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFollowButton(FollowUser user, FollowListViewModel viewModel) {
    final bool isFollowing = user.isFollowing;
    
    return BaicBounceButton(
      onPressed: () {
        HapticFeedback.selectionClick();
        viewModel.toggleFollow(user.id);
      },
      child: AnimatedContainer(
        duration: AppDimensions.durationNormal,
        curve: Curves.easeInOut,
        height: AppDimensions.buttonHeightS,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isFollowing ? AppColors.bgCanvas : AppColors.brandBlack,
          borderRadius: BorderRadius.circular(AppDimensions.buttonHeightS / 2),
          border: Border.all(
            color: isFollowing ? AppColors.divider : AppColors.brandBlack,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            isFollowing ? '已关注' : '+ 关注',
            style: AppTypography.captionPrimary.copyWith(
              fontWeight: FontWeight.bold,
              color: isFollowing ? AppColors.textSecondary : AppColors.textInverse,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEndIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.spaceXL),
      child: Center(
        child: Column(
          children: [
            Container(width: 40, height: 1, color: AppColors.divider),
            AppDimensions.spaceS.verticalSpace,
            Text(
              'END OF LIST',
              style: AppTypography.dataDisplayXS.copyWith(
                color: AppColors.textDisabled,
                letterSpacing: 3.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  FollowListViewModel viewModelBuilder(BuildContext context) =>
      FollowListViewModel(type: type);

  @override
  void onViewModelReady(FollowListViewModel viewModel) => viewModel.init();
}
