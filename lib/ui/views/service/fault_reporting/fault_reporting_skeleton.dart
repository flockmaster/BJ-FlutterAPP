import 'package:flutter/material.dart';
import 'package:car_owner_app/core/shared/widgets/skeleton/skeleton_loader.dart';
import 'package:car_owner_app/core/theme/app_dimensions.dart';
import 'package:car_owner_app/core/theme/app_colors.dart';

class FaultReportingSkeleton extends StatelessWidget {
  const FaultReportingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgCanvas,
      child: Stack(
        children: [
          const Positioned.fill(
            child: Column(
              children: [
                Spacer(flex: 1),
                // 顶部插图区域
                SkeletonLoader(
                  child: SkeletonBox(
                    width: 300,
                    height: 200,
                    borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusL)),
                  ),
                ),
                SizedBox(height: AppDimensions.spaceXL),
                // 标题
                SkeletonLoader(
                  child: SkeletonBox(
                    width: 200,
                    height: 28,
                  ),
                ),
                SizedBox(height: AppDimensions.spaceS),
                // 版本号
                SkeletonLoader(
                  child: SkeletonBox(
                    width: 100,
                    height: 16,
                  ),
                ),
                SizedBox(height: AppDimensions.spaceXL),
                // 功能项
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceXL),
                  child: Row(
                    children: [
                      Expanded(
                        child: SkeletonLoader(
                          child: SkeletonBox(
                            height: 80,
                            borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusL)),
                          ),
                        ),
                      ),
                      SizedBox(width: AppDimensions.spaceM),
                      Expanded(
                        child: SkeletonLoader(
                          child: SkeletonBox(
                            height: 80,
                            borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusL)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 2),
              ],
            ),
          ),
          // 底部按钮
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.borderPrimary, width: 0.5)),
              ),
              child: const SafeArea(
                child: SkeletonLoader(
                  child: SkeletonBox(
                    width: double.infinity,
                    height: 56,
                    borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusL)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
