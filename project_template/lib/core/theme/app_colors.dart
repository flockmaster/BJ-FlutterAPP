import 'package:flutter/material.dart';

/// 应用颜色系统 (V4.0 Merged Version)
/// 结合了完整的架构定义与"北汽越野"专属的硬派/尊贵调色板
class AppColors {
  AppColors._();

  // ==================== 1. 品牌色 (Brand) ====================
  
  /// 品牌主色 - 越野橙 (活力/操作/价格)
  /// 用于：主按钮、价格数字、强引导
  static const Color brandOrange = Color(0xFFFF6B00);
  
  /// 品牌辅助色 - 香槟金 (尊贵/VIP/选中态)
  /// [优化]：调整为更具金属质感的香槟金，原 E5C07B 略显焦黄
  static const Color brandGold = Color(0xFFD4B08C); 
  
  /// 品牌深色 - 深空黑 (标题/重视觉)
  static const Color brandBlack = Color(0xFF111827); // 比纯黑 111111 多了一点蓝灰倾向，更有质感
  
  /// 品牌深色别名 (用于标题等)
  static const Color brandDark = brandBlack;

  // ==================== 2. 状态交互色 (Interaction) [新增关键部分] ====================
  
  /// 选中态背景 - 极浅金色 (用于地址卡片、SKU选中的背景)
  static const Color bgSelected = Color(0xFFFAF5EF); 
  
  /// 选中态边框 - 金色 (用于地址卡片、SKU选中的边框)
  static const Color borderSelected = brandGold;

  // ==================== 3. 功能色 (Functional) ====================
  
  /// 成功色 - 翡翠绿
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  
  /// 警告色 - 琥珀黄
  static const Color warning = Color(0xFFF59E0B); // 调整为更稳重的琥珀色
  static const Color warningLight = Color(0xFFFEF3C7);
  
  /// 错误色 - 警示红
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  
  /// 信息色 - 科技蓝
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // ==================== 4. 中性色 (Neutral / Text) ====================
  
  /// 文本色 - 标题 (几乎纯黑)
  static const Color textTitle = Color(0xFF111827);
  
  /// 文本色 - 主要正文
  static const Color textPrimary = Color(0xFF374151); // 稍微柔和一点的深灰
  
  /// 文本色 - 次要/辅助说明
  static const Color textSecondary = Color(0xFF4B5563); // 提升色深：6B7280 -> 4B5563
  
  /// 文本色 - 三级文本
  static const Color textTertiary = Color(0xFF6B7280); // 提升色深：9CA3AF -> 6B7280
  
  /// 文本色 - 占位符/失效
  static const Color textDisabled = Color(0xFFD1D5DB);
  
  /// 文本色 - 反色 (深色背景下的白字)
  static const Color textInverse = Color(0xFFFFFFFF);
  
  /// 文本色 - 价格专用 (强制橙色)
  static const Color textPrice = brandOrange;
  
  /// 文本色 - 高亮/VIP (强制金色)
  static const Color textHighlight = brandGold;

  // ==================== 5. 背景色 (Background) ====================
  
  /// 背景色 - L0 Canvas 画布底色 (冷灰，提升质感)
  static const Color bgCanvas = Color(0xFFF5F7FA);
  
  /// 背景色 - L1 Surface 容器/卡片 (纯白)
  static const Color bgSurface = Color(0xFFFFFFFF);
  
  /// 背景色 - L2 悬浮层/模态框
  static const Color bgElevated = Color(0xFFFFFFFF);
  
  /// 背景色 - 填色块 (用于搜索框背景、标签背景)
  static const Color bgFill = Color(0xFFF3F4F6);
  
  /// 背景色 - 遮罩 (50% 黑)
  static const Color bgOverlay = Color(0x80000000);

  // ==================== 6. 边框色 (Border) ====================
  
  /// 边框色 - 主要 (浅灰，用于卡片描边)
  static const Color borderPrimary = Color(0xFFE5E7EB);
  
  /// 边框色 - 强 (用于输入框激活)
  static const Color borderFocus = brandBlack;

  // ==================== 7. 分割线 (Divider) ====================
  
  static const Color divider = Color(0xFFEEEEEE); // 极淡

  // ==================== 8. 阴影系统 (Shadows) [优化透明度] ====================
  
  /// 阴影基础色 (用于BoxShadow)
  static const Color shadowBase = Color(0xFF000000);
  
  /// 阴影 - 极轻 (用于卡片默认态) - Opacity 4%
  static Color shadowLight = const Color(0xFF000000).withValues(alpha: 0.04);
  
  /// 阴影 - 浮起 (用于点击反馈) - Opacity 8%
  static Color shadowMedium = const Color(0xFF000000).withValues(alpha: 0.08);
  
  /// 阴影 - 高悬浮 (用于底部弹窗/FAB) - Opacity 12%
  static Color shadowHeavy = const Color(0xFF000000).withValues(alpha: 0.12);

  // ==================== 9. 常用颜色别名 (Aliases) ====================
  
  /// 常用颜色别名 - 方便快速使用
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  /// 背景色别名
  static const Color backgroundGray = bgCanvas;
  static const Color backgroundLight = bgFill;
  
  /// 边框色别名
  static const Color borderLight = borderPrimary;
  static const Color borderMedium = Color(0xFFD1D5DB);
  
  /// 危险色别名
  static const Color danger = error;
  static const Color dangerLight = errorLight;

  // ==================== 10. 第三方与渐变 ====================
  
  static const Color wechat = Color(0xFF07C160);
  static const Color alipay = Color(0xFF1677FF);

  /// 品牌渐变 - 更有质感的黑金渐变 (用于VIP卡片背景)
  static const LinearGradient vipGradient = LinearGradient(
    colors: [Color(0xFF374151), Color(0xFF111827)], // 深灰到黑
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// 按钮渐变 - 橙色活力
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF8800), brandOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// 颜色扩展工具
extension ColorExtension on Color {
  /// 兼容旧版 Opacity 写法，底层调用 withValues
  @override
  Color withOpacity(double opacity) {
    return withValues(alpha: opacity);
  }
  
  /// 获取更亮的颜色
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
  
  /// 获取更暗的颜色
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}
