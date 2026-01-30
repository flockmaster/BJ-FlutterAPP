import 'package:flutter/material.dart';
import 'skeleton_loader.dart';

/// 购车页面骨架屏 - 像素级还原原型设计
class CarBuyingSkeleton extends StatelessWidget {
  const CarBuyingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header title
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 68, 20, 8),
            child: SkeletonBox(width: 128, height: 32),
          ),
          // Model tabs
          SizedBox(
            height: 45,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: List.generate(
                4,
                (i) => Container(
                  width: 80,
                  height: 36,
                  margin: const EdgeInsets.only(right: 12),
                  child: const SkeletonBox(
                    width: 80,
                    height: 36,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Hero car card
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SkeletonBox(
              width: double.infinity,
              height: 480,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          const SizedBox(height: 16),
          // Promo card
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SkeletonBox(
              width: double.infinity,
              height: 80,
            ),
          ),
          const SizedBox(height: 24),
          // Section title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SkeletonBox(width: 96, height: 24),
          ),
          const SizedBox(height: 16),
          // Highlight image
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SkeletonBox(
              width: double.infinity,
              height: 220,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }
}
