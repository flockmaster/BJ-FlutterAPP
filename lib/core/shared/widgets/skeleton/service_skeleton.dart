import 'package:flutter/material.dart';
import 'skeleton_loader.dart';

/// 服务页面骨架屏 - 像素级还原原型设计
class ServiceSkeleton extends StatelessWidget {
  const ServiceSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SkeletonLoader(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 54, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonBox(width: 64, height: 32),
                SkeletonCircle(size: 32),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: SkeletonBox(
                    height: 280,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
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
          Padding(
            padding: EdgeInsets.all(20),
            child: SkeletonBox(
              width: double.infinity,
              height: 180,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          Padding(
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
