import 'package:flutter/material.dart';
import 'skeleton_loader.dart';

/// 商城页面骨架屏 - 完全按照原型布局
class StoreSkeleton extends StatelessWidget {
  const StoreSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Column(
        children: [
          // 顶部导航区域
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).padding.top + 6,
              20,
              4,
            ),
            child: Column(
              children: [
                // 搜索栏和购物车
                Row(
                  children: [
                    Expanded(
                      child: SkeletonBox(
                        width: double.infinity,
                        height: 40,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const SkeletonBox(
                      width: 40,
                      height: 40,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 分类标签
                Row(
                  children: List.generate(
                    5,
                    (i) => Container(
                      margin: const EdgeInsets.only(right: 32),
                      child: const SkeletonBox(
                        width: 48,
                        height: 20,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 内容区域
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  // Hero 轮播图
                  SkeletonBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.5,
                    borderRadius: BorderRadius.zero,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 特色功能网格
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 220,
                      child: Row(
                        children: [
                          // 左侧大卡片
                          Expanded(
                            child: SkeletonBox(
                              height: 220,
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                            ),
                          ),
                          SizedBox(width: 12),
                          // 右侧小卡片
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: SkeletonBox(
                                    borderRadius: BorderRadius.all(Radius.circular(16)),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Expanded(
                                  child: SkeletonBox(
                                    borderRadius: BorderRadius.all(Radius.circular(16)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 热卖榜单标题
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SkeletonBox(
                          width: 80,
                          height: 20,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        SkeletonBox(
                          width: 100,
                          height: 16,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 热卖商品列表
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        return const SizedBox(
                          width: 140,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonBox(
                                width: 140,
                                height: 140,
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                              ),
                              SizedBox(height: 8),
                              SkeletonBox(
                                width: 100,
                                height: 14,
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              SizedBox(height: 4),
                              SkeletonBox(
                                width: 60,
                                height: 18,
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 主题区域
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Banner
                        const SkeletonBox(
                          width: double.infinity,
                          height: 160,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        const SizedBox(height: 16),
                        // 商品网格
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.72,
                          ),
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return const SkeletonBox(
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                            );
                          },
                        ),
                      ],
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
