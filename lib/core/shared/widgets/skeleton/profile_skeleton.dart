import 'package:flutter/material.dart';
import 'skeleton_loader.dart';

/// 个人中心页面骨架屏 - 像素级还原原型设计
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header icons
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 54, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SkeletonCircle(size: 40),
                SizedBox(width: 16),
                SkeletonCircle(size: 40),
              ],
            ),
          ),
          // User profile section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              children: [
                // Avatar and name
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SkeletonCircle(size: 72),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonBox(width: 96, height: 24),
                            SizedBox(height: 8),
                            SkeletonBox(width: 64, height: 16),
                          ],
                        ),
                      ],
                    ),
                    SkeletonBox(
                      width: 96,
                      height: 32,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    4,
                    (i) => const Column(
                      children: [
                        SkeletonBox(width: 32, height: 24),
                        SizedBox(height: 8),
                        SkeletonBox(width: 40, height: 12),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Message card
                const SkeletonBox(
                  width: double.infinity,
                  height: 48,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                const SizedBox(height: 16),
                // Feature grid
                const SkeletonBox(
                  width: double.infinity,
                  height: 120,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                const SizedBox(height: 16),
                // Orders card
                const SkeletonBox(
                  width: double.infinity,
                  height: 100,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
