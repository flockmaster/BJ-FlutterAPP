import 'package:flutter/material.dart';
import 'skeleton_loader.dart';

/// 发现页面骨架屏 - 像素级还原原型设计
class DiscoverySkeleton extends StatelessWidget {
  const DiscoverySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Column(
        children: [
          // Header tabs area
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 8),
            color: const Color(0xFFF5F7FA).withOpacity(0.95),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: List.generate(
                      5,
                      (i) => Container(
                        width: 40,
                        height: 20,
                        margin: const EdgeInsets.only(right: 24),
                        child: const SkeletonBox(width: 40, height: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Large card
                  const SkeletonBox(
                    width: double.infinity,
                    height: 220,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  const SizedBox(height: 20),
                  // Horizontal scroll cards
                  SizedBox(
                    height: 220,
                    child: Row(
                      children: List.generate(
                        3,
                        (i) => Container(
                          width: 280,
                          margin: const EdgeInsets.only(right: 16),
                          child: const SkeletonBox(
                            width: 280,
                            height: 220,
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
