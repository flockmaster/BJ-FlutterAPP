import 'package:flutter/material.dart';
import 'skeleton_loader.dart';

/// 服务页面骨架屏 - 像素级还原原型设计
class ServiceSkeleton extends StatelessWidget {
  const ServiceSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 54, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SkeletonBox(width: 64, height: 32),
                SkeletonCircle(size: 32),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                const Expanded(
                  child: SkeletonBox(
                    height: 280,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: const [
                      SkeletonBox(
                        height: 134,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      SizedBox(height: 12),
                      SkeletonBox(
                        height: 134,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: SkeletonBox(
              width: double.infinity,
              height: 180,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SkeletonBox(
              width: double.infinity,
              height: 120,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }
}
