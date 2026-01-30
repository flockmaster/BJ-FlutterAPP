# 北汽越野 App 开发与设计规范手册 (BAIC App Specifications)

本文档汇总了项目中的技术架构、视觉设计、交互规范及代码标准。旨在为研发团队提供统一的开发准则，确保应用质量一致性。

---

## 1. 架构规范 (Architecture)

本项目基于 **Stacked Framework** (MVVM) 架构进行开发。

### 1.1 核心原则 (Core Principles)
*   **ViewModel 优先**: 业务逻辑必须与 UI 分离。
*   **View 职责**: 仅负责 UI 渲染，不包含任何业务逻辑。
*   **服务层 (Services)**: 复杂业务逻辑（如 API 调用、数据持久化）应封装在 Service 中。
*   **接口先行 (Interface First)**: 所有数据交互必须通过 `ApiClient`，使用 `MockInterceptor` 实现虚拟数据，Service 层严禁包含 Mock 逻辑。

### 1.2 开发铁律 (Mandatory Rules)
1.  **ViewModel 继承**: 所有 ViewModel 必须继承 `BaicBaseViewModel`。
2.  **View 构建**: 必须使用 `ViewModelBuilder<T>.reactive()` 构建页面。
3.  **UI 隔离**: 严禁在 ViewModel 中使用 `BuildContext`、`Navigator`、`Material` 或 `Cupertino` UI 库。
    *   *错误示例*: `showDialog(context: ...)`
    *   *正确示例*: 调用 `DialogService`
4.  **导航控制**:
    *   **禁止**: 使用 `Navigator.of(context).pop()` 或 `context.pop()`。
    *   **必须**: 调用 `viewModel.goBack()` 或 `viewModel.navigateTo()`。

### 1.3 必需与禁止的导入 (Imports)
*   **必须导入**:
    ```dart
    import '../../../core/theme/app_colors.dart';
    import '../../../core/components/baic_ui_kit.dart';
    ```
*   **必须移除**:
    ```dart
    import '../../../core/extensions/context_extensions.dart'; // 因导航逻辑移至 ViewModel，此扩展已废弃
    ```

---

## 2. 开发哲学与策略 (Philosophy & Strategy)

### 2.1 "能抄不写" 原则 (Copy-No-Write Rule)
**优先复用，拒绝重复造轮子。**

*   **内部复用**: 遇到类似功能（如列表卡片、弹窗布局），必须优先搜索项目中已有的实现代码，复制并针对性修改，而不是从零编写。
*   **原型复用**: 严格遵循 `prototypes/` 目录下的设计参考。如果存在高保真原型代码，必须直接将其转化为 Flutter 代码，保持像素级还原。
*   **目的**: 减少低级错误，保持代码风格高度一致，提升效率。

### 2.2 组件提取策略 (Component Extraction Strategy)
不要过早优化，但当满足以下条件时，**必须**进行组件提取：

1.  **复用原则**: 当一段 UI 代码在 **2个或以上** 的地方被使用时，必须提取为独立组件。
2.  **体积原则**: 当 Widget 的 `build` 方法超过 **150行** 时，应将子模块拆分为独立的小组件 (Private Widgets)。
3.  **独立性原则**: 如果某个 UI 模块包含复杂的交互逻辑（如独立的倒计时、复杂的动画状态），应当封装为独立的 `StatefulWidget` 或配套独立的 `ViewModel`。
4.  **位置规范**:
    *   **全局通用**: 放入 `lib/core/components/` 或 `lib/shared/`。
    *   **模块专用**: 放入该 feature 目录下的 `widgets/` 子文件夹。

---

## 3. 视觉设计系统 (Design System)

设计哲学：**Precision (精密)**、**Air (透气)**、**Soft-Tech (柔和科技感)**。

### 3.1 色彩体系 (Color Palette)
**严禁使用硬编码颜色（如 `Color(0xFFFF6B00)`），必须统一使用 `AppColors`。**

#### 品牌色 (Brand)
*   **主色 (Brand Orange)**: `AppColors.brandOrange` (#FF6B00) - 按钮、价格、强引导。
*   **辅助色 (Champagne Gold)**: `AppColors.brandGold` (#D4B08C) - VIP、选中态、高级点缀。
*   **深色 (Deep Space Black)**: `AppColors.brandBlack` (#111827) - 标题、边框聚焦。

#### 功能色 (Functional)
*   **成功 (Success)**: `AppColors.success` (#10B981)
*   **警告 (Warning)**: `AppColors.warning` (#F59E0B)
*   **错误 (Error)**: `AppColors.error` (#EF4444)
*   **信息 (Info)**: `AppColors.info` (#3B82F6)

#### 文本色 (Typography Colors)
*   **标题 (Title)**: `AppColors.textTitle` (#111827)
*   **正文 (Primary)**: `AppColors.textPrimary` (#374151)
*   **辅助 (Secondary)**: `AppColors.textSecondary` (#4B5563)
*   **三级 (Tertiary)**: `AppColors.textTertiary` (#6B7280)
*   **价格专用**: `AppColors.textPrice` (Brand Orange)

#### 背景与层级 (Background Layers)
*   **L0 画布 (Canvas)**: `AppColors.bgCanvas` (#F5F7FA) - 页面默认底色。
*   **L1 容器 (Surface)**: `AppColors.bgSurface` (#FFFFFF) - 卡片、列表底色。
*   **L2 悬浮 (Elevated)**: `AppColors.bgElevated` (#FFFFFF) - 弹窗、悬浮按钮。

### 3.2 投影系统 (Shadows)
*   **Shadow-L1 (常规)**: 用于列表项、静态卡片 (Opacity 4%)。
*   **Shadow-L2 (高悬浮)**: 用于模态弹窗、选中态 (Opacity 12%)。

### 3.3 圆角系统 (Corner Radius)
统一使用 `AppDimensions` 或设计规范定义：
*   **Radius-S (8px)**: 标签、辅助输入框、小图标背景。
*   **Radius-M (16px) [标准]**: 功能卡片、列表项、模态窗口。
*   **Radius-L (24px)**: 页面级大图卡片 (Hero Card)、沉浸式顶部区域。
*   **Radius-Full**: 胶囊按钮、圆形按钮。

### 3.4 字体排印 (Typography)
*   **机械字体**: 数字展示（价格、车速、里程）强制使用 `Oswald` 字体，代码中通过 `AppStyles.mechanicalData` 引用。

### 3.5 图像与媒体 (Images & Media)

#### 核心组件 (Core Widget)
*   **OptimizedImage**: 所有图片加载必须使用 `lib/shared/widgets/optimized_image.dart` 中的 `OptimizedImage` 或其衍生组件。
    *   **特性**: 自动区分 Assets/Network 来源，集成 `CachedNetworkImage` 缓存机制，提供统一的占位图和错误处理。
    *   **禁止**: 严禁直接使用 Flutter 原生的 `Image.network` 或 `CachedNetworkImage`。

#### 性能策略 (Performance Strategy)
*   **列表页与缩略图 (List / Thumbnails)**:
    *   在列表、网格等密集展示图片的场景，**必须**使用 `OptimizedThumbnail` 组件。
    *   **CDN 按需加载**: 所有的列表图片请求，必须在 URL 中包含 CDN 裁剪参数（如 `?x-oss-process=image/resize,w_300`），请求适合当前控件尺寸的图片，**严禁**直接加载原图。
*   **内存缓存优化**: `OptimizedImage` 已默认集成 `memCacheWidth/Height`。在使用大图时，请手动指定 `memCacheWidth` 为显示宽度的 2 倍（Retina 屏），避免解码过大的图片占用内存。

---

## 4. 交互与动效 (Interaction & Motion)

### 4.1 核心交互组件 (Core Interaction Widgets)
*   **BaicBounceButton (点击交互)**:
    *   所有可点击区域（Button, Icon, Card, Text Link）**必须**包裹在 `BaicBounceButton` 中。
    *   **禁止**: 直接使用 `GestureDetector`, `InkWell`, `IconButton`。
    *   **效果**: 统一的 `scale(0.98)` 点击缩放反馈。

*   **EasyRefresh (下拉/上拉)**:
    *   项目统一集成 `easy_refresh` 库处理列表刷新。
    *   **Header/Footer**: 使用统一封装的样式 (BaicHeader/BaicFooter)，确保交互体验一致。

### 4.2 列表加载策略 (List Loading Strategy)
*   **分页策略**: 所有长列表必须支持分页加载。默认 Page Size 建议为 10 或 20。
*   **懒加载 (Lazy Loading)**: 
    *   使用 `EasyRefresh` 的 `onLoad` 回调实现上拉加载更多。
    *   必须处理 **"没有更多数据" (No more data)** 的状态，显示明确的底部提示。
    *   避免一次性加载所有数据，防止内存溢出和 UI 卡顿。

### 4.3 页面布局模式 (Layout Modes)
*   **Mode A (标准导航)**: 设置、个人中心。白色 TopBar，标题居中，内容在 L1 容器。
*   **Mode B (沉浸视觉)**: 首页、详情页。内容穿透状态栏，背景 L0，大圆角卡片。

### 4.4 动效规范 (Motion)
*   **转场**: 从右滑入 (Slide-in Right)，300ms，贝塞尔曲线 `cubic-bezier(0.16, 1, 0.3, 1)`。
*   **加载**: 严禁单纯的 Loading Circle，必须使用 **Skeleton Screen (骨架屏)** 带 Shimmer 扫光效果。

---

## 5. 代码开发规范 (Coding Standards)

### 5.1 基础规范
*   遵循 `analysis_options.yaml` 中的 Flutter Lints 规则。
*   保持代码整洁，及时移除未使用的导入。

### 5.2 重构检查清单 (Refactoring Checklist)
在提交代码前，请确保完成以下自查：
- [ ] 移除所有硬编码颜色 `Color(0xFF...)` → 替换为 `AppColors.xxx`。
- [ ] 移除 `context.pop()` → 替换为 `viewModel.goBack()`。
- [ ] 移除 `GestureDetector`/`InkWell` → 替换为 `BaicBounceButton`。
- [ ] 替换原生 `Image` 组件 → 使用 `OptimizedImage`。
- [ ] 检查是否导入了 `AppColors` 和 `BaicBounceButton`。
- [ ] 运行 `flutter analyze` 确保无报错。

### 5.3 数据模型与序列化 (Data Models & Serialization)
本项目使用 `json_serializable` 处理 JSON 数据。

*   **注解**: 所有模型类必须添加 `@JsonSerializable()` 注解。
*   **构造**: 必须包含 `fromJson` 工厂方法和 `toJson` 方法。
    ```dart
    @JsonSerializable()
    class ExampleModel {
      factory ExampleModel.fromJson(Map<String, dynamic> json) => _$ExampleModelFromJson(json);
      Map<String, dynamic> toJson() => _$ExampleModelToJson(this);
    }
    ```
*   **Part 文件**: 必须包含 `part 'filename.g.dart';` 指令。
*   **代码生成**: 修改模型后必须运行 build_runner：
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

### 5.4 代码备注与注释规范 (Comments & Documentation)
**所有代码必须包含清晰的中文备注，这是项目可读性的硬性要求。**

*   **强制语言**: 除了变量名、类名、函数名使用英文外，**代码内部的所有注释、文档说明必须使用简体中文**。
*   **注释内容**:
    *   **类与服务**: 必须说明该类的核心职责及关联的铁律（如：`// 核心服务：负责 AI 故障识别...`）。
    *   **核心逻辑**: 在复杂的条件判断、数据转换处，必须解释“为什么”这样处理。
    *   **铁律标注**: 在遵循特定铁律（如铁律 7 ApiClient）的代码处，建议显式标注。
*   **示例**:
    ```dart
    /// 故障检测服务类
    /// 遵循铁律 7：所有数据交互必须通过 ApiClient
    class FaultDetectionService extends BaicBaseService {
      // 处理仪表盘图像识别逻辑
      Future<void> detect() async {
        // 调用统一接口 (铁律 7)
        final res = await apiClient.post('/detect');
        // ... 其他逻辑
      }
    }
    ```

### 5.5 数据展示与转换规范 (Data Display & Transformation)
**原则：后端负责存储，前端负责展现 (Backend stores, Frontend presents)。**

*   **时间/日期 (Time & Date)**:
    *   **接口规范**: 接口必须返回 **Timestamp** (Unix 时间戳，毫秒或秒) 或 UTC ISO String。禁止返回 "刚刚"、"1小时前" 这种预格式化的字符串。
    *   **前端处理**: 必须在 UI 层（或 Transformer 层）使用 `TimeUtils` 进行本地化转换。
    *   **展示形式**: 推荐使用**相对时间** (Relative Time)，如 "5分钟前"、"昨天"。
    *   **目的**: 确保能根据用户的系统语言（多语言/i18n）动态展示正确的时间格式。
*   **数字格式化 (Number Formatting)**:
    *   大额数字（如点赞数、销量）需使用 `NumberUtils` 进行缩写（如 "1.2k", "10w+"）。
    *   金额需保留固定小数位并添加千位分隔符。

---

## 6. 项目目录结构 (Directory Structure)

```
lib/
├── app/                  # 应用入口与路由配置 (Router, Locator)
├── core/                 # 核心模块
│   ├── base/             # 基础类 (BaseViewModel, BaseService)
│   ├── components/       # 核心通用组件 (BaicBounceButton, etc.)
│   ├── constants/        # 全局常量
│   ├── di/               # 依赖注入配置 (get_it + injectable)
│   ├── models/           # 数据模型 (实体类 + .g.dart)
│   ├── services/         # 核心业务服务 (API, Auth, User 等)
│   ├── theme/            # 主题系统 (AppColors, AppStyles)
│   └── utils/            # 通用工具类 (TimeUtils, NumberUtils, Formatters)
├── ui/                   # 界面层
│   ├── common/           # UI 通用常量/工具
│   └── views/            # 页面视图 (按业务功能模块划分子目录)
├── shared/               # 共享 UI 组件 (Widget 库)
│   ├── widgets/
│   │   └── optimized_image.dart  # 核心图片组件

└── main.dart             # 应用入口

```

---

## 7. 流程与资源 (Workflow & Resources)

*   **设计原稿**: 位于 `prototypes/` 目录。
*   **开发文档**: 位于 `doc/` 目录。
*   **重构进度**: 查看 `REFACTORING_PROGRESS.md` 了解当前模块状态。

**注意**: 本文档为项目最高规范。任何新的开发需求必须优先遵循本文档中的约定。如需修改规范，需经过架构组评审。
