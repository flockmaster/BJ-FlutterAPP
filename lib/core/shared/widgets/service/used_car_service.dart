import 'package:flutter/material.dart';

/// 二手车评估服务组件
class UsedCarService extends StatelessWidget {
  final VoidCallback? onTap;

  const UsedCarService({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // 使用 margin 确保与上下组件对齐，左右 20，底部 32
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        height: 140, // 稍微增高一点以适应新的背景图
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 背景图片
            Positioned.fill(
              child: Image.network(
                'https://youke3.picui.cn/s1/2026/01/07/695e21468733f.jpg',
                fit: BoxFit.cover,
              ),
            ),
            
            // 渐变遮罩，确保左侧文字清晰
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.0, 0.5, 1.0],
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            
            // 内容区域 (参考充电服务卡片的对齐方式：左上对齐)
            Padding(
              padding: const EdgeInsets.all(20), // 与 ChargingService 标题位置一致
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start, // 顶部对齐
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '二手车评估',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20, // 与充电服务标题一致
                          fontWeight: FontWeight.w900, // 使用更重的字重匹配品牌风格
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD21E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '官方认证',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10, // 减小标签字号
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '极速报价 · 高价回收 · 置换补贴',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13, // 相应减小副标题字号
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
