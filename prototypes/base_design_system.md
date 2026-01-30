# BAIC App Unified Design System (融合规范)
# Version: 3.1 (Merged Universal)
# 核心哲学: Precision (精密), Air (透气), Soft-Tech (柔和科技感)

## 1. 核心层级与背景 (Layer & Background)
*   **L0 - Canvas (画布底色)**: `#F5F7FA` (冷调极浅灰)。所有页面的默认基底。
*   **L1 - Surface (容器/卡片)**: `#FFFFFF` (纯白)。用于主要内容模块。
*   **L2 - Elevated (悬浮层)**: `#FFFFFF` + `Shadow-L2`。用于弹窗、置顶操作栏、浮动按钮。

## 2. 投影系统 (Shadow System)
*   **Shadow-L1 (常规)**: `rgba(0,0,0,0.04)`, Blur: `14px`, Offset: `(0, 2)`。用于列表项、静态卡片。
*   **Shadow-L2 (高悬浮)**: `rgba(0,0,0,0.10)`, Blur: `30px`, Offset: `(0, 10)`。用于模态弹窗、选中态。

## 3. 圆角系统 (Corner Radius)
*   **Radius-S (8px)**: 标签、辅助输入框、小图标背景。
*   **Radius-M (16px)**: **标准标准**。功能卡片、列表项、模态窗口。
*   **Radius-L (24px)**: 页面级大图卡片 (Hero Card)、沉浸式顶部区域、底部抽屉顶角。
*   **Radius-Full**: 胶囊按钮、圆形功能按键。

## 4. 色彩体系 (Color Palette)
*   **Brand-Orange**: `#FF6B00` (品牌主色，核心 CTA)
*   **Brand-Gold**: `#E5C07B` (高级感点缀，会员标识)
*   **Neutral-Dark**: `#111827` (标题色)
*   **Text-Primary**: `#1F2937` (正文主色)
*   **Text-Sec**: `#6B7280` (辅助说明)
*   **Status-Success**: `#10B981` / **Status-Danger**: `#EF4444`

## 5. 页面布局模式 (Layout Modes)
### Mode A: 标准导航模式 (Standard)
*   **适用**: 设置、个人中心、服务列表。
*   **规范**: 顶部白色 `AppBar`，标题居中，内容使用 L1 容器承载。

### Mode B: 沉浸视觉模式 (Immersive)
*   **适用**: 首页、购车详情、商城首页。
*   **规范**: 视觉元素穿透状态栏，背景使用 L0，卡片使用 `Radius-L`。

## 6. 字体排印与间距 (Typo & Spacing)
*   **数据展示**: 强制使用 `Oswald` 字体（价格、车速、里程）。
*   **间距基数**: `4px`。
    *   S (8px) / M (16px) / L (24px) / XL (32px)。

## 7. 动效规范 (Motion)
*   **点击反馈**: `scale(0.98)` + 阻尼感回弹。
*   **转场**: 从右滑入 (Slide-in Right)，时长 300ms，曲线 `cubic-bezier(0.16, 1, 0.3, 1)`。
*   **加载**: 严禁纯转圈，必须使用 `Skeleton Screen` (骨架屏) 带 Shimmer 扫光。